import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:productosapp/services/services.dart';
import 'package:provider/provider.dart';

class ImageButton extends StatelessWidget {
  final IconData icon;
  final bool cameraOrGallery;

  const ImageButton(
      {Key? key, required this.icon, required this.cameraOrGallery})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);
    return IconButton(
      icon: Icon(
        icon,
        color: Colors.white,
      ),
      onPressed: () async {
        final picker = new ImagePicker();
        final XFile? xFile;
        if (cameraOrGallery)
          xFile = await picker.pickImage(
              source: ImageSource.camera, imageQuality: 100);
        else
          xFile = await picker.pickImage(
              source: ImageSource.gallery, imageQuality: 100);
        if (xFile == null) {
          return;
        }
        productsService.updateSelectedProductImage(xFile.path);
      },
    );
  }
}
