import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'app_module.dart';
import 'app_widget.dart';

void main() {
  // Crie sua api-key em
  // https://platform.openai.com/account/api-keys
  OpenAI.apiKey = 'sua api-key';
  OpenAI.organization = "sua organização";

  setUrlStrategy(PathUrlStrategy());

  runApp(
    ModularApp(
      module: AppModule(),
      child: const AppWidget(),
    ),
  );
}
