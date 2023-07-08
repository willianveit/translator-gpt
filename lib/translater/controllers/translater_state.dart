part of 'translater_bloc.dart';

class TranslaterState {
  final Status translaterStatus;
  final String response;
  final Language firstLanguageSelected;
  final Language secondLanguageSelected;

  const TranslaterState({
    this.translaterStatus = Status.initial,
    this.response = '',
    this.firstLanguageSelected = Language.Portuguese,
    this.secondLanguageSelected = Language.English,
  });

  TranslaterState copyWith({
    Status? translaterStatus,
    String? response,
    Language? firstLanguageSelected,
    Language? secondLanguageSelected,
  }) {
    return TranslaterState(
      translaterStatus: translaterStatus ?? this.translaterStatus,
      response: response ?? this.response,
      firstLanguageSelected: firstLanguageSelected ?? this.firstLanguageSelected,
      secondLanguageSelected: secondLanguageSelected ?? this.secondLanguageSelected,
    );
  }
}
