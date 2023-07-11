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
  }) async {
    emit(state.copyWith(translaterStatus: Status.loading));
    try {
      OpenAIChatCompletionModel chatCompletion = await OpenAI.instance.chat.create(
        model: "gpt-3.5-turbo-16k",
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            content: text,
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
