import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/imgs/img_url.dart';
import '../../../core/utils/utils.dart';
import '../appbar/app_bar_header_photo.dart';

class PhotoGalleryNetworkImg extends StatefulWidget {
  final VoidCallback tirarFoto;
  final Function(ImageSource source) getImage;
  final File? imagem;
  final String? url;

  const PhotoGalleryNetworkImg({
    Key? key,
    required this.tirarFoto,
    required this.getImage,
    this.imagem,
    this.url,
  }) : super(key: key);

  @override
  State<PhotoGalleryNetworkImg> createState() => _PhotoGalleryImgState();
}

class _PhotoGalleryImgState extends State<PhotoGalleryNetworkImg> {
  late Future<Map<String, String>> tokenFuture;

  String? photoName;
  String? url;

  @override
  void initState() {
    super.initState();
    tokenFuture = _getToken();
  }

  Future<Map<String, String>> _getToken() async {
    return await Utils.requestToken();
  }


  Widget _getImageWidget({
    double? width,
    double? height,
  }) {
    if (widget.imagem != null) {
      return Image.file(
        widget.imagem!,
        width: width ?? 250,
        height: height ?? 250,
        fit: BoxFit.contain,
      );
    } else {
      return FutureBuilder<Map<String, String>>(
        future: tokenFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Image.asset(
              ImgUrl.no_image,
              width: width ?? 250,
              height: height ?? 250,
              fit: BoxFit.contain,
            );
          }

          final headers = snapshot.data ?? {};

          return Image(
            image: NetworkImage(
              '${widget.url}?${DateTime.now().millisecondsSinceEpoch}',
              headers: headers,
            ),
            width: width ?? 250,
            height: height ?? 250,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              debugPrint("Ocorreu um Erro: $error");

              return Image.asset(
                ImgUrl.no_image,
                width: width ?? 250,
                height: height ?? 250,
                fit: BoxFit.contain,
              );
            },
          );
        },
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _showImageDialog,
          child: _getImageWidget(),
        ),        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildButton(
              icon: Icons.camera_alt_rounded,
              label: "Camera",
              onTap: widget.tirarFoto,
            ),
            _buildButton(
              icon: Icons.image_rounded,
              label: "Galeria",
              onTap: () => widget.getImage(ImageSource.gallery),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.grey.shade200,
        ),
        height: 70,
        width: 70,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Center(
              child: Icon(icon, color: Colors.black, size: 35),
            ),
            Align(
              alignment: const Alignment(0, 2.0),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  void _showImageDialog() {
    if (widget.imagem == null && widget.url == null) {
      return;
    }

    final String nomeImagem = widget.url != null
        ? widget.url!.split('/').last.replaceFirst(
      RegExp(r'\.jpg$', caseSensitive: false),
      '',
      ) : 'Nova imagem';

    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
              maxWidth: MediaQuery.of(context).size.width * 0.95,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppBarHeaderPhoto(
                  titulo: 'Imagem: $nomeImagem',
                  onClose: () => Navigator.pop(context),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: InteractiveViewer(
                      minScale: 0.5,
                      maxScale: 4.0,
                      child: _getImageWidget(
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }}