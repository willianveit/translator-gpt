import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:translator_gpt/translater/presentation/modals/show_modal_g.dart';
import '../../controllers/translater_bloc.dart';
import '../../enums/status.dart';
import '../widgets/divider_g.dart';

class TranslaterPage extends StatefulWidget {
  const TranslaterPage({super.key});

  @override
  State<TranslaterPage> createState() => _TranslaterPageState();
}

class _TranslaterPageState extends State<TranslaterPage> {
  final cubit = Modular.get<TranslaterBloc>();

  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _textEditingControllerLanguages = TextEditingController();
  TextEditingController _textEditingControllerPrompt = TextEditingController();
  bool giveExplanation = true;
  bool giveExamples = true;

  String getComplement() {
    if (giveExplanation && giveExamples) {
      return '\nGive an explanation and give examples.';
    } else if (giveExplanation) {
      return '\nGive an explanation.';
    } else if (giveExamples) {
      return '\nGive examples.';
    } else {
      return '';
    }
  }

  String getPrompt(String text) {
    return _textEditingControllerPrompt.text =
        'Translate "$text" to ${_textEditingControllerLanguages.text}. ${getComplement()}';
  }

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _textEditingControllerLanguages = TextEditingController(text: 'english and spanish');
    _textEditingControllerPrompt = TextEditingController(text: getPrompt(''));

    super.initState();
  }

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
              'Translator GPT',
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                'Any (auto detect)',
                                style: Theme.of(context).primaryTextTheme.titleLarge!.copyWith(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.compare_arrows_rounded,
                          ),
                          Expanded(
                              child: TextFormField(
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.center,
                            controller: _textEditingControllerLanguages,
                            onChanged: (text) => getPrompt(text),
                            style: Theme.of(context).primaryTextTheme.titleLarge!.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 18,
                                ),
                            decoration: const InputDecoration.collapsed(
                              hintText: '',
                            ),
                          )),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const DividerG(),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      controller: _textEditingController,
                      maxLines: 4,
                      maxLength: 500,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Enter the text...',
                      ),
                      onChanged: (text) => getPrompt(text),
                    ),
                  ),
                  const DividerG(),
                  Row(
                    children: [
                      CheckboxMenuButton(
                        value: giveExplanation,
                        onChanged: (value) {
                          setState(() {
                            giveExplanation = value ?? false;
                          });
                          getPrompt(_textEditingController.text);
                        },
                        child: const Text('Explanation'),
                      ),
                      CheckboxMenuButton(
                        value: giveExamples,
                        onChanged: (value) {
                          setState(() {
                            giveExamples = value ?? false;
                          });
                          getPrompt(_textEditingController.text);
                        },
                        child: const Text('Examples'),
                      ),
                    ],
                  ),
                  const DividerG(),
                  Container(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: TextFormField(
                      controller: _textEditingControllerPrompt,
                      expands: false,
                      maxLines: null,
                      maxLength: null,
                      style: const TextStyle(
                        height: 1.8,
                      ),
                      decoration: const InputDecoration.collapsed(
                        hintText: '',
                      ),
                    ),
                  ),
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
                        if (_textEditingController.text.isEmpty) {
                          showModalG(
                            context,
                            child: Center(
                              child: Text(
                                '\nDigite algum texto para traduzir\n\nEnter some text to translate\n\nIntroduce un texto para traducir\n\n',
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                            ),
                          );
                        } else {
                          cubit.translate(
                            text: _textEditingControllerPrompt.text,
                          );
                        }
                      },
                      label: const Text(
                        'Translate',
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
