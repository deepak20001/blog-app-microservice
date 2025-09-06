import 'package:blog_client/core/common/widgets/spinkit_ring.dart';
import 'package:blog_client/core/constants/constants.dart';
import 'package:blog_client/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class Loader extends StatefulWidget {
  const Loader({
    super.key,
    this.color = AppPallete.whiteColor,
    this.size = numD12,
  });
  final Color color;
  final double size;

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final double sizeWidth = MediaQuery.sizeOf(context).width;

    return Center(
      child: SpinKitRing(color: widget.color, size: sizeWidth * widget.size),
    );
  }
}
