
import 'dart:convert';
import 'dart:io';

import 'package:controle_de_gastos_app/ui/core/styles/app_text_styles.dart';
import 'package:controle_de_gastos_app/ui/features/pages/components/appbar/app_bar_cadastro_gasto.dart';
import 'package:controle_de_gastos_app/ui/features/pages/components/buttons/switch_button/custom_switch_button.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:switch_button/switch_button.dart';

import '../../core/colors/app_colors.dart';
import '../../core/gradients/app_gradients.dart';
import '../../core/utils/utils.dart';
import '../../data/model/gasto.dart';
import '../../data/model/user.dart';
import 'components/data/custom_date_picker_field.dart';
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
        }, gradient: AppGradients.cadastroPet,
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

                  // Descrição
                  CustomField(
                    controller: _controllerDescricao,
                    focusNode: _focusDescricaoNode,
                    hintText: 'Descrição',
                    icon: Icons.money,
                    keyboardType: TextInputType.text,
                  ),
                  Utils.sizedBox(altura: 20.0, largura: 0),

                  // Valor
                  CustomField(
                    controller: _controllerValor,
                    focusNode: _focusValorNode,
                    hintText: "Digite o valor",
                    icon: Icons.monetization_on_outlined,
                    keyboardType: TextInputType.number,
                  ),
                  Utils.sizedBox(altura: 20.0, largura: 0),

                  // Data Vencimento
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

                  CustomSwitchButton(
                    value: gasto?.pago ?? false,
                    onToggle: (value) {
                      setState(() {
                        gasto?.pago = value;
                        print(value);
                      });
                    },

                    activeColor: Colors.green,
                    inactiveColor: Colors.red,

                    //inactiveThumbColor: Colors.red,
                  ),
                  widgetFoto(() => _tirarFoto(setState)),


                ],
              ),
            ),
          )
          ),
    );
  }

  ///****** METHODS ******
  widgetFoto(void Function() tirarFoto) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        GestureDetector(
            onTap: tirarFoto,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius
                      .circular(50)),
              height: 70,
              width: 70,
              child: Stack(
                clipBehavior: Clip.none,
                children: [

                  const Center(child:
                  Icon(
                    Icons.camera_alt_rounded,
                    color: AppColors.black,
                    size: 35,),),

                  Align(
                      alignment: const Alignment(
                          0, 2.0),
                      child:
                      Padding(
                        padding: const EdgeInsets
                            .only(bottom: 20),
                        child: Text("Camera",
                          style: AppTextStyles
                              .bodyBold,),
                      )
                  )
                ],
              ),
            )
        ),
        if (_imagem != null)
          Image.file(
            _imagem!,
            key: ValueKey(_imagem!.path), // força reconstrução
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
      ],
    );
  }

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
  ///Retornar um cliente
  Future<Gasto> _generateGasto() async {

    Gasto g = Gasto();
    g.descricao = _controllerDescricao.text;
    g.valor = _controllerValor.text.isNotEmpty ? double.parse(_controllerValor.text) : 0;
    g.vencimento = _selectedVencimento.toIso8601String();
    g.createdAt = !_isEdit ? DateTime.now().toIso8601String() : gasto?.createdAt;
    g.updatedAt = DateTime.now().toIso8601String();
    g.imagemBase64 = await Utils.base64String(bytes);
    g.photoName =  "foto_${user?.id}${DateTime.now().millisecondsSinceEpoch}.jpg";

    return g;
  }
  Future<void> _tirarFoto(StateSetter dialogSetState) async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      final XFile? foto = await _picker.pickImage(source: ImageSource.camera);
      if (foto != null) {
        dialogSetState(() {
          _imagem = File(foto.path);
          bytes = _imagem?.readAsBytes();
        });
        ///_loadingFieldsByPhoto(foto); TODO
      }
    } else {
      print("Permissão de câmera negada");
    }
  }
  Future<void> _loadingUser() async {
    final u = await Utils.recuperarUser();
    setState(() {
      user = u!;
    });
  }

  void _initFocus(){
    _focusDescricaoNode = FocusNode();
    _focusValorNode = FocusNode();
  }
  void _clearControllers(){
    _controllerDescricao.text = '';
    _controllerValor.text = '';
    _controllerVencimento.text = '';
    _imagem = null;
  }

  Future<void> _loadingFieldsByPhoto(XFile? foto) async{
    final inputImage = InputImage.fromFilePath(foto!.path);
    final textRecognizer = GoogleMlKit.vision.textRecognizer();
    final recognizedText = await textRecognizer.processImage(inputImage);
    await textRecognizer.close();

    final valor = extrairValorTotal(recognizedText);

    setState(() {
    _controllerValor.text = valor ?? "Não identificado";
      //carregando = false;
    });
  }

  /// Função que tenta localizar um valor numérico próximo de "TOTAL" no texto
  String? extrairValorTotal(RecognizedText recognizedText) {
    final regexValor = RegExp(r'(\d{1,3}(?:[.,]\d{3})*[.,]\d{2})');

    for (var block in recognizedText.blocks) {
      for (var line in block.lines) {
        final texto = line.text.toUpperCase();
        print("text"+texto);

        // Pode variar: TOTAL, VALOR A PAGAR, VALOR TOTAL, TOTAL R$, etc.
        if (texto.contains("VALOR TOTAL") || texto.contains("VALOR A PAGAR")) {
          final match = regexValor.firstMatch(texto);
          if (match != null) {
            return match.group(0);
          }
        }
      }
    }

    // fallback: tenta encontrar a última linha com valor
    for (var block in recognizedText.blocks.reversed) {
      for (var line in block.lines.reversed) {
        final match = regexValor.firstMatch(line.text);
        if (match != null) {
          return match.group(0);
        }
      }
    }

    return null;
  }

}
