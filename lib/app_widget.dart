import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'app_strings.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.all(
            Colors.blueGrey,
          ),
        ),
      ),
    );
  }
}
