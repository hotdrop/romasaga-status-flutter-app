import 'package:flutter/material.dart';

class RightSlidePageRoute<T> extends PageRouteBuilder<T> {
  RightSlidePageRoute({this.page})
      : super(
          pageBuilder: (
            context,
            anim,
            secondAnim,
          ) =>
              page,
          transitionsBuilder: (
            context,
            animation,
            secondaryAnimation,
            child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );

  final Widget page;
}

class ScalePageRoute<T> extends PageRouteBuilder<T> {
  ScalePageRoute({this.page})
      : super(
          pageBuilder: (
            context,
            animation,
            secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            context,
            animation,
            secondaryAnimation,
            child,
          ) =>
              ScaleTransition(
            scale: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.fastOutSlowIn,
              ),
            ),
            child: child,
          ),
        );

  final Widget page;
}
