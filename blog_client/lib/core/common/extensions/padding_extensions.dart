import 'package:flutter/material.dart';

extension SizeExtensions on BuildContext {
  Padding paddingAll(double percentage, {Widget? child}) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.sizeOf(this).width * percentage),
      child: child,
    );
  }

  Padding paddingSymmetric({
    double horizontal = 0.0,
    double vertical = 0.0,
    Widget? child,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.sizeOf(this).width * horizontal,
        vertical: MediaQuery.sizeOf(this).width * vertical,
      ),
      child: child,
    );
  }

  Padding paddingHorizontal(double percentage, {Widget? child}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.sizeOf(this).width * percentage,
      ),
      child: child,
    );
  }

  Padding paddingVertical(double percentage, {Widget? child}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.sizeOf(this).width * percentage,
      ),
      child: child,
    );
  }

  Padding paddingLeft(double percentage, {Widget? child}) {
    return Padding(
      padding: EdgeInsets.only(
        left: MediaQuery.sizeOf(this).width * percentage,
      ),
      child: child,
    );
  }

  Padding paddingRight(double percentage, {Widget? child}) {
    return Padding(
      padding: EdgeInsets.only(
        right: MediaQuery.sizeOf(this).width * percentage,
      ),
      child: child,
    );
  }

  Padding paddingTop(double percentage, {Widget? child}) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.sizeOf(this).width * percentage),
      child: child,
    );
  }

  Padding paddingBottom(double percentage, {Widget? child}) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.sizeOf(this).width * percentage,
      ),
      child: child,
    );
  }

  Padding paddingOnly({
    double? left,
    double? right,
    double? top,
    double? bottom,
    Widget? child,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: left != null ? MediaQuery.sizeOf(this).width * left : 0,
        right: right != null ? MediaQuery.sizeOf(this).width * right : 0,
        top: top != null ? MediaQuery.sizeOf(this).width * top : 0,
        bottom: bottom != null ? MediaQuery.sizeOf(this).width * bottom : 0,
      ),
      child: child,
    );
  }
}
