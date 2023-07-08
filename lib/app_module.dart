import 'package:flutter_modular/flutter_modular.dart';
import 'translater/controllers/translater_bloc.dart';
import 'translater/presentation/pages/translater_page.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        Bind((i) => TranslaterBloc()),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          Modular.initialRoute,
          child: (_, __) => TranslaterPage(),
        ),
      ];
}
