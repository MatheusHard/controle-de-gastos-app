import 'dart:io';
import 'package:controle_de_gastos_app/ui/core/imgs/img_url.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoGalleryImg extends StatelessWidget {
  final VoidCallback tirarFoto;
  final Function(ImageSource source) getImage;
  final File? imagem;

  const PhotoGalleryImg({
    Key? key,
    required this.tirarFoto,
    required this.getImage,
    this.imagem,
  }) : super(key: key);

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
              onTap: tirarFoto,
            ),
            _buildButton(
              icon: Icons.image_rounded,
              label: "Galeria",
              onTap: () => getImage(ImageSource.gallery),
            ),
           ],
        ),
      ],
    );
  }

  Widget _getImageWidget() {
    if (imagem != null) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.file(
          imagem!,
          width: 250,
          height: 250,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Image.asset(
        ImgUrl.no_image,
        width: 250,
        height: 250,
        fit: BoxFit.cover,
      );
    }
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
              child: Icon(
                icon,
                color: Colors.black,
                size: 35,
              ),
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