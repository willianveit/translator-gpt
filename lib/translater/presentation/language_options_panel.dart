import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../enums/language.dart';
import 'modals/show_modal_g.dart';
import 'widgets/divider_g.dart';

class LanguageOptionsPanel extends StatelessWidget {
  LanguageOptionsPanel({
    super.key,
    required this.firstLanguageSelected,
    required this.secondLanguageSelected,
    required this.onChangedFirstLanguage,
    required this.onChangedsecondLanguage,
    required this.onTapSwitchLanguage,
  });

  final Language firstLanguageSelected;
  final Language secondLanguageSelected;
  final Function(Language) onChangedFirstLanguage;
  final Function(Language) onChangedsecondLanguage;
  final VoidCallback onTapSwitchLanguage;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  child: Text(
                    firstLanguageSelected.name,
                  ),
                  onPressed: () => showModalLanguage(
                    context,
                    onChangedLanguage: onChangedFirstLanguage,
                  ),
                ),
              ),
              IconButton(
                onPressed: onTapSwitchLanguage,
                icon: Icon(
                  Icons.compare_arrows_rounded,
                ),
              ),
              Expanded(
                child: TextButton(
                  child: Text(
                    secondLanguageSelected.name,
                  ),
                  onPressed: () => showModalLanguage(
                    context,
                    onChangedLanguage: onChangedsecondLanguage,
                  ),
                ),
              ),
            ],
          ),
          DividerG(),
        ],
      ),
    );
  }
}

void showModalLanguage(
  BuildContext context, {
  required Function(Language) onChangedLanguage,
}) {
  showModalG(
    context,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...languages
            .map(
              (language) => TextButton(
                onPressed: () {
                  onChangedLanguage(language);
                  Modular.to.pop();
                },
                child: Text(
                  language.name,
                ),
              ),
            )
            .toList(),
      ],
    ),
  );
}
