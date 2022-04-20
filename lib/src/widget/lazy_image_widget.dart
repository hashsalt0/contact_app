import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

/// Widget that lazy loads an image using future builder
class LazyImageWidget extends StatelessWidget {
  static Uint8List showFallbackWidget = Uint8List(0);

  /// [image] is a [Future]
  /// when it is working a CircularProgressBar is show
  /// when it is completed
  /// a. if a Exception is thrown, error is shown inside the widget
  /// b. if the image was successfully read the image is shown.
  /// Note - The future must return some value for the image to be shown
  /// if null is returned loading screen is show, [showFallbackWidget] to
  /// display the fallback widget ie
  /// LazyImageWidget({
  //     ...
  //     image = Future.value(LazyImageWidget.showFallbackWidget),
  //     ...
  //   })
  ///
  const LazyImageWidget(
      {Key? key, required this.image, required this.fallbackWidget})
      : super(key: key);

  final Future<Uint8List>? image;

  final Widget fallbackWidget;

  @override
  Widget build(BuildContext context) => FutureBuilder<Uint8List>(
      future: image,
      builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
        if (snapshot.hasData) {
          Uint8List? avatar = snapshot.data;
          // if the image was empty Uint8List list then show the fallback.
          if (avatar != null && avatar.isNotEmpty) {
            return ExtendedImage.memory(avatar,
                height: MediaQuery.of(context).size.width * 0.8,
                width: MediaQuery.of(context).size.width * 0.8,
                fit: BoxFit.fill,
                shape: BoxShape.circle,
                borderRadius: const BorderRadius.all(Radius.circular(30.0)));
          } else {
            return fallbackWidget;
          }
        } else if (snapshot.hasError) {
          return const Icon(Icons.error_outline);
        } else {
          return const CircularProgressIndicator.adaptive();
        }
      });
}
