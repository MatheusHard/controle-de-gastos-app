
import 'dart:convert';
import 'dart:io';

import 'package:controle_de_gastos_app/ui/core/enums/status_pagamento_enum.dart';
import 'package:controle_de_gastos_app/ui/core/styles/app_text_styles.dart';
import 'package:controle_de_gastos_app/ui/features/pages/components/appbar/app_bar_cadastro_gasto.dart';
import 'package:controle_de_gastos_app/ui/features/pages/components/buttons/normal_button/custom_button.dart';
import 'package:controle_de_gastos_app/ui/features/pages/components/buttons/switch_button/custom_switch_button.dart';
import 'package:controle_de_gastos_app/ui/service/api/gasto_api.dart';
import 'package:controle_de_gastos_app/ui/service/dtos/agenda_de_pagamento_dto.dart';
import 'package:controle_de_gastos_app/ui/service/dtos/gasto_dto.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:switch_button/switch_button.dart';

import '../../core/colors/app_colors.dart';
import '../../core/gradients/app_gradients.dart';
import '../../core/imgs/img_url.dart';
import '../../core/utils/utils.dart';
import '../../data/model/gasto.dart';
import '../../data/model/user.dart';
import 'components/data/custom_date_picker_field.dart';
import 'components/images/photo_gallery_img.dart';
import 'components/inputs/custom_field.dart';
import 'components/inputs/descricao_field.dart';

class FaturaCadastroPage extends StatefulWidget {
  final Gasto? gasto;
  const FaturaCadastroPage({super.key, this.gasto});

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

  late DateTime _selectedVencimento;

  @override
  void initState() {
    super.initState();
    _initFocus();
    _loadingUser();
    _loadingGasto();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:AppBarCadastroGasto(
        title: '',
        onBack: () {
          // ação personalizada para voltar
        },
        onClose: () {
          // ação personalizada para fechar
        }, gradient: AppGradients.redColor,
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
                    value: gasto?.pago ?? false,
                    onToggle: (value) {
                      setState(() {
                        gasto?.pago = value;
                      });
                    },
                    activeColor: Colors.green,
                    inactiveColor: Colors.red,
                  ),
                  /// Foto/Galeria Imagem
                  PhotoGalleryImg(
                    tirarFoto: _tirarFoto,
                    getImage: _getImage,
                    imagem: _imagem,

                  ),
                  Utils.sizedBox(altura: 20.0, largura: 0),
                  /// Salvar
                  CustomButton(
                    radios: 20,
                    height: 55,
                    gradient: AppGradients.redGradient,
                    icon: Icons.monetization_on,
                    isLoading: _isLoading,
                    onTap: () async {
                      setState(() {
                        _isLoading = true; // ativa o loading
                      });

                      try {
                        await _cadastroGasto(await _generateGasto(), context);
                        final navigator = Navigator.of(context);
                        if (mounted) {
                          navigator.pop();
                        }
                      } catch (e) {
                        // trate erros se necessário
                        print("Erro ao cadastrar gasto: $e");
                      } finally {
                        if (mounted) {
                          setState(() {
                            _isLoading = false; // desativa o loading
                          });
                        }
                      }
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
  void _loadingGasto() {
    gasto = widget.gasto;
    if (gasto != null) {
      _selectedVencimento = (gasto!.vencimento != null  ? DateTime.tryParse(gasto!.vencimento!) : DateTime.now())!;
      _isEdit = true;
      _controllerDescricao.text = gasto?.descricao ?? "";
      _controllerValor.text = gasto?.valor != null ? gasto!.valor!.toStringAsFixed(2) : "";
      //Vencimento
      if (gasto!.vencimento != null && gasto!.vencimento!.isNotEmpty) {
        try {
          DateTime vencimentoDate = DateTime.tryParse(gasto!.vencimento!) ?? DateTime.now();
          _controllerVencimento.text = DateFormat('dd/MM/yyyy').format(vencimentoDate);
        } catch (e) {
          _controllerVencimento.text = gasto!.vencimento!;
        }
      }
    } else {
      _isEdit = false;
      _clearControllers();
    }
  }

  Future<GastoDTO> _generateGasto() async {
    GastoDTO g = GastoDTO();
    g.id =  _isEdit &&  gasto?.id != null ? gasto?.id : null;
    g.descricao = _controllerDescricao.text;
    g.valor = _controllerValor.text.isNotEmpty ? double.parse(_controllerValor.text) : 0;
    g.vencimento = _selectedVencimento.toIso8601String();
    g.createdAt = !_isEdit ? DateTime.now().toIso8601String() : gasto?.createdAt;
    g.updatedAt = DateTime.now().toIso8601String();
    g.imagemBase64 = await Utils.base64String(bytes);
    g.photoName =  "foto_${user?.id}${DateTime.now().millisecondsSinceEpoch}.jpg";
    AgendaDePagamentoDTO agenda = AgendaDePagamentoDTO();
    agenda.id = gasto?.agendaDePagamento?.id;
    g.user = user;
    g.agendaDePagamento = agenda;
    g.deletado = gasto?.deletado ?? false;
    g.statusPagamento = gasto!.pago == true ? StatusPagamentoEnum.PAGO :
                        Utils.isVencido(gasto?.vencimento) ? StatusPagamentoEnum.VENCIDO :
                        StatusPagamentoEnum.NAO_PAGO;
    g.pago = gasto?.pago;

    return g;
  }

  // Print Photo
  Future<void> _tirarFoto() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      final XFile? fotoFile = await _picker.pickImage(source: ImageSource.camera);
      if (fotoFile != null) {
       setState(() {
         _imagem = File(fotoFile.path);
         bytes = _imagem?.readAsBytes();
       });
       // _loadingFieldsByPhoto(fotoFile);
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
        //_loadingFieldsByPhoto(galleryFile);
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

   ///Add Cliente
  Future<bool> _cadastroGasto(GastoDTO g,  BuildContext context) async {
    if(_isEdit) {
      return await GastoApi(context).updateGasto(g, user?.id ?? 0);
    }else{
      return await GastoApi(context).addGasto(g);
    }
  }
}
