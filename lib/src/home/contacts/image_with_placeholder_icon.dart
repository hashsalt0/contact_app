
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class ImageWithPlaceholderIcon extends StatelessWidget {
  const ImageWithPlaceholderIcon({
    Key? key,
    required Uint8List? image,
  })  : _image = image,
        super(key: key);

  final Uint8List? _image;

  @override
  Widget build(BuildContext context) {
    if (_image != null) {
      return ExtendedImage.memory(_image!,
          height: MediaQuery.of(context).size.width * 0.8,
          width: MediaQuery.of(context).size.width * 0.8,
          fit: BoxFit.fill,
          shape: BoxShape.circle,
          borderRadius: const BorderRadius.all(Radius.circular(30.0)));
    } else {
      return const Icon(Icons.add);
    }
  }
}
