
import 'dart:convert';
import 'dart:io';


import 'package:controle_de_gastos_app/ui/data/dtos/user_dto.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share_handler/share_handler.dart';
import 'package:switch_button/switch_button.dart';

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
import '../../../data/service/share/share_service.dart';
import '../../widgets/appbar/app_bar_back.dart';
import '../../widgets/buttons/normal_button/custom_button.dart';
import '../../widgets/buttons/switch_button/custom_switch_button.dart';
import '../../widgets/data/custom_date_picker_field.dart';
import '../../widgets/images/photo_gallery_img.dart';
import '../../widgets/inputs/custom_field.dart';

class AddFaturaPage extends StatefulWidget {
  final Gasto? gasto;
  const AddFaturaPage({super.key, this.gasto});

  @override
  State<AddFaturaPage> createState() => _AddFaturaPageState();
}

class _AddFaturaPageState extends State<AddFaturaPage> {

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

  late DateTime _selectedVencimento;

  @override
  void initState() {
    super.initState();
    _initFocus();
    _loadingUser();
    _loadingGasto();
    // 🔥 ESCUTA mudança da imagem compartilhada
    Utils.imageShareNotifier.addListener(_onImageShared);
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
        gradient: context
            .watch<ThemeProvider>()
            .currentGradient, // vem do provider,
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
                    style: AppTextStyles.textoSentimentoNegritoWhite(
                        20, context),),
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
                        ? DateTime.tryParse(gasto!.vencimento!) ??
                        DateTime.now()
                        : DateTime.now(),
                    onDateSelected: (date) {
                      _selectedVencimento = date;
                      _controllerVencimento.text =
                          DateFormat('dd/MM/yyyy').format(date);
                    },
                  ),
                  Utils.sizedBox(altura: 20.0, largura: 0),

                  /// Pago
                  CustomSwitchButton(
                    value: _isPago,
                    onToggle: (value) {
                      setState(() {
                        print("object" + value.toString());
                        _isPago = value;
                      });
                    },
                    activeColor: Colors.green,
                    inactiveColor: Colors.red,
                  ),

                  /// Foto/Galeria Imagem
                  ValueListenableBuilder<File?>(
                    valueListenable: Utils.imageShareNotifier,
                    builder: (context, file, _) {
                      return PhotoGalleryNetworkImg(
                        tirarFoto: _tirarFoto,
                        getImage: _getImage,
                        // 🔥 prioridade: imagem do share
                        imagem: file ?? _imagem,
                      );
                    },
                  ),
                  Utils.sizedBox(altura: 20.0, largura: 0),

                  /// Salvar
                  CustomButton(
                    radios: 20,
                    height: 55,
                    gradient: context
                        .watch<ThemeProvider>()
                        .currentGradient,
                    // vem do provider
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

  //Save Gasto
  Future<void> _salvarGasto(
      {required NavigatorState navigator, required ScaffoldMessengerState scaffoldMessenger,}) async {
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

    _isPago = gasto?.pago ?? false; // ✅ inicializa aqui
    _selectedVencimento = (gasto!.vencimento != null
        ? DateTime.tryParse(gasto!.vencimento!)
        : DateTime.now())!;
    _controllerDescricao.text = gasto?.descricao ?? "";
    _controllerValor.text =
    gasto?.valor != null ? gasto!.valor!.toStringAsFixed(2) : "";
    if (gasto!.vencimento != null && gasto!.vencimento!.isNotEmpty) {
      try {
        DateTime vencimentoDate = DateTime.tryParse(gasto!.vencimento!) ??
            DateTime.now();
        _controllerVencimento.text =
            DateFormat('dd/MM/yyyy').format(vencimentoDate);
      } catch (e) {
        _controllerVencimento.text = gasto!.vencimento!;
      }
    }
    //_clearControllers();

  }

  // Gerar obj Gasto
  Future<GastoDTO> _generateGasto() async {

    // 🔥 pega a imagem atual
    final currentImage =
        Utils.imageShareNotifier.value ?? _imagem;

    var currentBytes;

    if (currentImage != null) {
      currentBytes = await Utils.compressImageBytes(currentImage);
    }

    GastoDTO g = GastoDTO();

    g.id = null;
    g.descricao = _controllerDescricao.text;
    g.valor = _controllerValor.text.isNotEmpty ? double.parse(_controllerValor.text) : 0;
    g.vencimento = _selectedVencimento.toIso8601String();
    g.createdAt = DateTime.now().toIso8601String();
    g.updatedAt = DateTime.now().toIso8601String();
    g.imagemBase64 = currentBytes != null ? await Utils.base64String(currentBytes) : null;
    g.photoName = "foto_${user?.id}${DateTime.now().millisecondsSinceEpoch}.jpg";
    AgendaDePagamentoDTO agenda = AgendaDePagamentoDTO();
    agenda.id = gasto?.agendaDePagamento?.id;

    UserDTO u = UserDTO();
    u.id = user?.id;
    g.user = u;
    g.agendaDePagamento = agenda;
    g.deletado = gasto?.deletado ?? false;
    g.statusPagamento = _isPago
        ? StatusPagamentoEnum.PAGO
        : Utils.isVencido(gasto?.vencimento)
        ? StatusPagamentoEnum.VENCIDO
        : StatusPagamentoEnum.NAO_PAGO;
    g.pago = _isPago;

    return g;
  }
  // Print Photo
  Future<void> _tirarFoto() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      final XFile? fotoFile = await _picker.pickImage(
          source: ImageSource.camera);
      if (fotoFile != null) {
        final File originalFile = File(fotoFile.path);
        final compressedBytes = await Utils.compressImageBytes(
            originalFile); // Compactar a foto
        if (compressedBytes != null) {
          Utils.imageShareNotifier.value = null;  // 🔥 limpa imagem compartilhada
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
      imageQuality: 50,
    );

    if (galleryFile != null) {
      final File originalFile = File(galleryFile.path);
      final compressedBytes = await Utils.compressImageBytes(originalFile);

      if (compressedBytes != null) {
        Utils.imageShareNotifier.value = null;  // 🔥 limpa imagem compartilhada
        setState(() {
          _imagem = originalFile;
          bytes = compressedBytes; // salva os bytes comprimidos
        });
        print("Imagem da galeria comprimida: ${bytes!.length / 1024} KB");
      } else {
        print("Falha ao comprimir a imagem da galeria");
      }
    } else {
      print('Nenhuma imagem selecionada.');
    }
  }

  // Carregar User
  Future<void> _loadingUser() async {
    final u = await Utils.recuperarUser();
    setState(() {
      user = u!;
    });
  }

  // Inicializar Focus
  void _initFocus() {
    _focusDescricaoNode = FocusNode();
    _focusValorNode = FocusNode();
  }

  // Limpar Controllers
  void _clearControllers() {
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
void _cleanWidgets(){
  Utils.imageShareNotifier.value = null;
}
  //Add Cliente
  Future<bool> _cadastroGasto(GastoDTO g) async {
    _cleanWidgets();
    return await GastoApi().addGasto(g);
  }

  Future<void> _onImageShared() async {

    final file = Utils.imageShareNotifier.value;
    if (file == null) return;
    await Utils.saveImageShare(file);
    final compressedBytes = await Utils.compressImageBytes(file);
    if (compressedBytes != null) {
      setState(() {
        _imagem = file;
        bytes = compressedBytes;
      });
    }
  }
}






