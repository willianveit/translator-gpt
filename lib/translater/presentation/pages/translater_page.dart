import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../controllers/translater_bloc.dart';
import '../../enums/status.dart';
import '../language_options_panel.dart';
import '../widgets/divider_g.dart';

class TranslaterPage extends StatefulWidget {
  const TranslaterPage({super.key});

  @override
  State<TranslaterPage> createState() => _TranslaterPageState();
}

class _TranslaterPageState extends State<TranslaterPage> {
  final cubit = Modular.get<TranslaterBloc>();

  final _textEditingController = TextEditingController();
  bool giveExplanation = true;
  bool giveExamples = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TranslaterBloc, TranslaterState>(
      listener: (context, state) {},
      bloc: cubit,
      buildWhen: (previous, current) =>
          previous.firstLanguageSelected != current.firstLanguageSelected ||
          previous.secondLanguageSelected != current.secondLanguageSelected,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            centerTitle: true,
            title: const Text(
              'Gringow',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LanguageOptionsPanel(
                    firstLanguageSelected: state.firstLanguageSelected,
                    secondLanguageSelected: state.secondLanguageSelected,
                    onChangedFirstLanguage: cubit.onChangedFirstLanguage,
                    onChangedsecondLanguage: cubit.onChangedsecondLanguage,
                    onTapSwitchLanguage: cubit.onTapSwitchLanguage,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      controller: _textEditingController,
                      maxLines: 4,
                      maxLength: 100,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Digite o texto...',
                      ),
                    ),
                  ),
                  const DividerG(),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 12,
                      bottom: 6,
                      right: 12,
                      left: 12,
                    ),
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      icon: const Icon(
                        Icons.translate,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        cubit.translate(
                          text: _textEditingController.text,
                          firstLanguage: state.firstLanguageSelected,
                          secondLanguage: state.secondLanguageSelected,
                          giveExamples: giveExamples,
                          giveExplanation: giveExplanation,
                        );
                      },
                      label: const Text(
                        'Traduzir',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  BlocBuilder<TranslaterBloc, TranslaterState>(
                    bloc: cubit,
                    builder: (context, state) {
                      if (state.translaterStatus == Status.loading) {
                        return const Padding(
                          padding: EdgeInsets.all(30.0),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (state.response.isEmpty) {
                        return Container();
                      }

                      return Container(
                        padding: const EdgeInsets.only(top: 6),
                        child: Container(
                          color: Theme.of(context).colorScheme.secondary,
                          width: double.infinity,
                          padding: const EdgeInsets.only(
                            top: 12,
                            left: 8,
                            right: 8,
                            bottom: 20,
                          ),
                          child: SingleChildScrollView(
                            child: SelectableText(
                              state.response,
                              style: const TextStyle(
                                color: Colors.white,
                                height: 1.4,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
