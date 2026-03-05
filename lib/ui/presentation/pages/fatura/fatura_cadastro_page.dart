
import 'dart:convert';
import 'dart:io';


import 'package:controle_de_gastos_app/ui/core/constants/imgs/img_url.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:switch_button/switch_button.dart';

import '../../../core/configs/dio/configs.dart';
import '../../../core/constants/enums/status_pagamento_enum.dart';
import '../../../core/theme/gradients/app_gradients.dart';
import '../../../core/theme/provider/theme_provider.dart';
import '../../../core/theme/styles/app_text_styles.dart';
import '../../../core/utils/utils.dart';
import '../../../data/dtos/agenda_de_pagamento_dto.dart';
import '../../../data/dtos/gasto_dto.dart';
import '../../../data/model/gasto.dart';
import '../../../data/model/user.dart';
import '../../../data/service/api/gasto_api.dart';
import '../../widgets/appbar/app_bar_back.dart';
import '../../widgets/buttons/normal_button/custom_button.dart';
import '../../widgets/buttons/switch_button/custom_switch_button.dart';
import '../../widgets/data/custom_date_picker_field.dart';
import '../../widgets/images/photo_gallery_img.dart';
import '../../widgets/inputs/custom_field.dart';

class FaturaCadastroPage extends StatefulWidget {
  final Gasto? gasto;
  final bool isEdit;
  const FaturaCadastroPage({super.key, this.gasto, required this.isEdit});

  @override
  State<FaturaCadastroPage> createState() => _FaturaCadastroPageState();
}

class _FaturaCadastroPageState extends State<FaturaCadastroPage> {

  ///Variables
  User? user;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _controllerDescricao = TextEditingController();
  final _controllerValor = TextEditingController();
  final _controllerVencimento = TextEditingController();
  late FocusNode _focusDescricaoNode;
  late FocusNode _focusValorNode;
  Gasto? gasto;
  bool isSwitched = false;
  File? _imagem;
  final ImagePicker _picker = ImagePicker();
  var bytes;
  bool _isEdit = false;
  bool _isLoading = false;
  bool _isPago = false;
  final Configs _customDio = Configs();
  String?  toke ;

  late DateTime _selectedVencimento;

  @override
  void initState() {
    super.initState();
    _loadToken();
    _initFocus();
    _loadingUser();
    _loadingGasto();
  }
  Future<void> _loadToken() async {
    toke = await Utils.recuperarToken();
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBack(
        title: '',
        onBack: () {
          Navigator.pop(context);
        },
        onClose: () {
          Navigator.pop(context);
        },
        gradient: context.watch<ThemeProvider>().currentGradient, // vem do provider,
      ),
      body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Utils.sizedBox(altura: 20.0, largura: 0),
                  Text("Cadastre seu Gasto",
                      style: AppTextStyles.textoSentimentoNegritoWhite( 20, context),),
                  Utils.sizedBox(altura: 20.0, largura: 0),
                  /// Descrição
                  CustomField(
                    controller: _controllerDescricao,
                    focusNode: _focusDescricaoNode,
                    hintText: 'Descrição',
                    icon: Icons.money,
                    keyboardType: TextInputType.text,
                  ),
                  Utils.sizedBox(altura: 20.0, largura: 0),
                  /// Valor
                  CustomField(
                    controller: _controllerValor,
                    focusNode: _focusValorNode,
                    hintText: "Digite o valor",
                    icon: Icons.monetization_on_outlined,
                    keyboardType: TextInputType.number,
                  ),
                  Utils.sizedBox(altura: 20.0, largura: 0),
                  /// Vencimento
                  CustomDatePickerField(
                    label: "Vencimento",
                    initialDate: gasto?.vencimento != null
                        ? DateTime.tryParse(gasto!.vencimento!) ?? DateTime.now()
                        : DateTime.now(),
                    onDateSelected: (date) {
                      _selectedVencimento = date;
                      _controllerVencimento.text = DateFormat('dd/MM/yyyy').format(date);
                      },
                  ),
                  Utils.sizedBox(altura: 20.0, largura: 0),
                  /// Pago
                  CustomSwitchButton(
                    value: _isPago,
                    onToggle: (value) {
                      setState(() {
                        _isPago = value;
                      });
                    },
                    activeColor: Colors.green,
                    inactiveColor: Colors.red,
                  ),
                  /// Foto/Galeria Imagem
                  PhotoGalleryNetworkImg(
                    tirarFoto: _tirarFoto,
                    getImage: _getImage,
                    imagem: _imagem,
                    url: getUrlImg(gasto?.photoName ?? '')
                  ),
               /* CircleAvatar(
                  backgroundImage: gasto?.photoName != null
                      ? NetworkImage(
                    'http://192.168.0.18:8080/uploads/foto_31771340921672.jpg',
                    headers: {
                      "Authorization": "Bearer $toke",
                    },
                  )
                      : AssetImage(ImgUrl.semfoto) as ImageProvider,
                ),*/
                  Utils.sizedBox(altura: 20.0, largura: 0),
                  /// Salvar
                  CustomButton(
                    radios: 20,
                    height: 55,
                    gradient: context.watch<ThemeProvider>().currentGradient, // vem do provider
                    icon: Icons.monetization_on,
                    isLoading: _isLoading,
                    onTap: () async {
                      await _salvarGasto(
                        navigator: Navigator.of(context),
                        scaffoldMessenger: ScaffoldMessenger.of(context),
                      );
                    },
                    label: 'Salvar',
                    textStyle: AppTextStyles.textLogin,
                  ),
                ],
              ),
            ),
          )
        ),
      );
  }

  ///****** METHODS ******
  String getUrlImg(String photoName){
    Configs conf = Configs();
    String BASE_URL = conf.dio.options.baseUrl;
    return "$BASE_URL/${Utils.URL_UPLOAD}$photoName";
  }
  Future<void> _carregarImagemDaNet() async {
    if (gasto?.photoName == null) return;

    try {
      final token = await Utils.recuperarToken();

      final response = await HttpClient()
          .getUrl(Uri.parse(
          'http://192.168.0.10:8080/uploads/${gasto!.photoName}'))
          .then((request) {
        request.headers.set("Authorization", "Bearer $token");
        return request.close();
      });

      if (response.statusCode == 200) {
        final bytes = await consolidateHttpClientResponseBytes(response);

        final tempDir = await Directory.systemTemp.createTemp();
        final file = File('${tempDir.path}/${gasto!.photoName}');
        await file.writeAsBytes(bytes);

        setState(() {
          _imagem = file;
        });
      } else {
        print("Erro ao baixar imagem: ${response.statusCode}");
      }
    } catch (e) {
      print("Erro ao carregar imagem da net: $e");
    }
  }
  //Save Gasto
  Future<void> _salvarGasto({required NavigatorState navigator, required ScaffoldMessengerState scaffoldMessenger,}) async {

    setState(() {
      _isLoading = true;
    });
    try {
      await _cadastroGasto(await _generateGasto());
      if (!mounted) return;
      navigator.pop(true);
    } catch (e) {
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Erro ao cadastrar o gasto: $e')),
      );
      print('Erro ao cadastrar o gasto: $e');

    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  //Carregar Gasto
  void _loadingGasto() {
    gasto = widget.gasto;
    _isEdit = widget.isEdit;

    if (_isEdit) {
      _carregarImagemDaNet();

      _isPago = gasto?.pago ?? false; // ✅ inicializa aqui
      _selectedVencimento = (gasto!.vencimento != null  ? DateTime.tryParse(gasto!.vencimento!) : DateTime.now())!;
      _isEdit = true;
      _controllerDescricao.text = gasto?.descricao ?? "";
      _controllerValor.text = gasto?.valor != null ? gasto!.valor!.toStringAsFixed(2) : "";
      if (gasto!.vencimento != null && gasto!.vencimento!.isNotEmpty) {
        try {
          DateTime vencimentoDate = DateTime.tryParse(gasto!.vencimento!) ?? DateTime.now();
          _controllerVencimento.text = DateFormat('dd/MM/yyyy').format(vencimentoDate);
        } catch (e) {
          _controllerVencimento.text = gasto!.vencimento!;
        }
      }
    } else {
      _clearControllers();
    }
  }
  // Gerar obj Gasto
  Future<GastoDTO> _generateGasto() async {
    GastoDTO g = GastoDTO();
    g.id =  _isEdit &&  gasto?.id != null ? gasto?.id : null;
    g.descricao = _controllerDescricao.text;
    g.valor = _controllerValor.text.isNotEmpty ? double.parse(_controllerValor.text) : 0;
    g.vencimento = _selectedVencimento.toIso8601String();
    g.createdAt = !_isEdit ? DateTime.now().toIso8601String() : gasto?.createdAt;
    g.updatedAt = DateTime.now().toIso8601String();
    g.imagemBase64 = bytes != null ? await Utils.base64String(bytes) : null;
    g.photoName =  !_isEdit ? "foto_${user?.id}${DateTime.now().millisecondsSinceEpoch}.jpg" : gasto?.photoName;
    AgendaDePagamentoDTO agenda = AgendaDePagamentoDTO();
    agenda.id = gasto?.agendaDePagamento?.id;
    g.user = user;
    g.agendaDePagamento = agenda;
    g.deletado = gasto?.deletado ?? false;
    g.statusPagamento = _isPago ? StatusPagamentoEnum.PAGO :
                        Utils.isVencido(gasto?.vencimento) ? StatusPagamentoEnum.VENCIDO :
                        StatusPagamentoEnum.NAO_PAGO;
    g.pago = _isPago;

    return g;
  }
  // Print Photo
  Future<void> _tirarFoto() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      final XFile? fotoFile = await _picker.pickImage(source: ImageSource.camera);
      if (fotoFile != null) {
        final File originalFile = File(fotoFile.path);
        final compressedBytes = await Utils.compressImageBytes(originalFile); // Compactar a foto
        if (compressedBytes != null) {
          setState(() {
            _imagem = originalFile;
            bytes = compressedBytes; // já comprimidos
          });
          print("Foto comprimida: ${bytes!.length / 1024} KB");
        } else {
          print("Falha ao comprimir a imagem");
        }
      }
    } else {
      print("Permissão de câmera negada");
    }
  }
  // Capture Galley
  Future _getImage(ImageSource source) async {
    final galleryFile = await _picker.pickImage(
        source: source,
        maxHeight: 480,
        maxWidth: 640,
        imageQuality: 50);
    setState(() {
      if (galleryFile != null) {
        _imagem = File(galleryFile.path);
        //_loadingFieldsByPhoto(galleryFile); TODO
      } else {
        print('No image selected.');
      }
    });
  }
  // Carregar User
  Future<void> _loadingUser() async {
    final u = await Utils.recuperarUser();
    setState(() {
      user = u!;
    });
  }
  // Inicializar Focus
  void _initFocus(){
    _focusDescricaoNode = FocusNode();
    _focusValorNode = FocusNode();
  }
  // Limpar Controllers
  void _clearControllers(){
    _controllerDescricao.text = '';
    _controllerValor.text = '';
    _controllerVencimento.text = '';
    _imagem = null;
  }
  // Aqui serve para lê da imagem, caso capture as palavras chaves:
  Future<void> _loadingFieldsByPhoto(XFile? foto) async {
    final valor = await Utils.loadingFieldsByPhoto(foto, "valor");
    setState(() {
      _controllerValor.text = valor ?? "Não identificado";
    });
  }
  //Add Cliente
  Future<bool> _cadastroGasto(GastoDTO g) async {
    if(_isEdit) {
      return await GastoApi(context).updateGasto(g, user?.id ?? 0);
    }else{
      return await GastoApi(context).addGasto(g);
    }
  }
}
