import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/app.dart';
import 'package:rsapp/res/env.dart';

void main() {
  RSEnv.dev();
  runApp(const ProviderScope(child: App()));
}
