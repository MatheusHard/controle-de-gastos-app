import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/imgs/img_url.dart';
import '../../../core/utils/utils.dart';

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


  Widget _getImageWidget() {
    if (widget.imagem != null) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.file(
          widget.imagem!,
          width: 250,
          height: 250,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return FutureBuilder<Map<String, String>>(
        future: tokenFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Image.asset(
              ImgUrl.no_image,
              width: 250,
              height: 250,
              fit: BoxFit.cover,
            );
          } else {
            final headers = snapshot.data ?? {};
            return Image(
              image: NetworkImage('${widget.url}?${DateTime.now().millisecondsSinceEpoch}', headers: headers,),
              width: 250,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  ImgUrl.no_image,
                  width: 250,
                  height: 250,
                  fit: BoxFit.cover,
                );
              },
            );
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _getImageWidget(),
        Row(
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
}