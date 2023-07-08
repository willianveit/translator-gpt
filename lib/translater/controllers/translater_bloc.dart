import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../enums/language.dart';
import '../enums/status.dart';

part 'translater_state.dart';

class TranslaterBloc extends Cubit<TranslaterState> {
  TranslaterBloc() : super(const TranslaterState()) {}

  void onChangedFirstLanguage(Language language) {
    emit(state.copyWith(firstLanguageSelected: language));
  }

  void onChangedsecondLanguage(Language language) {
    emit(state.copyWith(secondLanguageSelected: language));
  }

  void translate({
    required String text,
    required Language firstLanguage,
    required Language secondLanguage,
    required bool giveExplanation,
    required bool giveExamples,
  }) async {
    if (state.translaterStatus == Status.loading || text.length < 1) {
      return;
    }
    emit(state.copyWith(translaterStatus: Status.loading));

    String prompt = '';

    if (firstLanguage == Language.Portuguese) {
      if (secondLanguage == Language.English) {
        prompt = 'Traduzir do Português para o Inglês "$text"';
      } else {
        prompt = 'Traduzir do Português para o Espanhol "$text"';
      }
      if (giveExplanation) {
        prompt = prompt + ' e dê uma explicação';
      }
      if (giveExamples) {
        prompt = prompt + ' e dê exemplos de uso';
      }
    } else if (firstLanguage == Language.Spanish) {
      if (secondLanguage == Language.English) {
        prompt = 'Traducir del Español al Inglés "$text"';
      } else {
        prompt = 'Traducir del Español al Portugués (BR) "$text"';
      }
      if (giveExplanation) {
        prompt = prompt + ' y dar una explicación';
      }
      if (giveExamples) {
        prompt = prompt + ' y dar ejemplos de uso';
      }
    } else if (firstLanguage == Language.English) {
      if (secondLanguage == Language.Portuguese) {
        prompt = 'Translate from English to Portuguese "$text"';
      } else {
        prompt = 'Translate from English to Spanish "$text"';
      }
      if (giveExplanation) {
        prompt = prompt + ' and give an explanation';
      }
      if (giveExamples) {
        prompt = prompt + ' and give examples of use';
      }
    }

    try {
      OpenAIChatCompletionModel chatCompletion = await OpenAI.instance.chat.create(
        model: "gpt-3.5-turbo-16k",
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            content: prompt,
            role: OpenAIChatMessageRole.system,
          ),
        ],
      );
      emit(
        state.copyWith(
          translaterStatus: Status.success,
          response: chatCompletion.choices.first.message.content,
        ),
      );
    } catch (e) {
      state.copyWith(
        translaterStatus: Status.error,
        response: e.toString(),
      );
    }
  }

  void onTapSwitchLanguage() {
    Language _firstLanguage = state.firstLanguageSelected;
    Language _secondLanguage = state.secondLanguageSelected;

    emit(
      state.copyWith(
        firstLanguageSelected: _secondLanguage,
        secondLanguageSelected: _firstLanguage,
      ),
    );
  }

  void changeHomeStatus() {
    if (state.translaterStatus == Status.loading) {
      emit(state.copyWith(translaterStatus: Status.success));
    } else {
      emit(state.copyWith(translaterStatus: Status.loading));
    }
  }
}
