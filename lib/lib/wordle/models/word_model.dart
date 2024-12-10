import 'package:equatable/equatable.dart';
import 'package:wordle/wordle/wordle.dart';

class Word extends Equatable {
  const Word({
    required this.letters,
  });

  factory Word.fromString(String word) =>
    Word(letters: word.split('').map((l) => Letter(val: l)).toList());

  final List<Letter> letters;

  String get wordString => letters.map((l) => l.val).join();

  void addLetter(String val) {
    final currentIndex = letters.indexWhere((l) => l.val.isEmpty);
    if (currentIndex != -1) {
      letters[currentIndex] = Letter(val: val);
    }
  }

  void removeLetter() {
    final recentLetterIndex = letters.lastIndexWhere((l) => l.val.isNotEmpty);
    if (recentLetterIndex != -1) {
      letters[recentLetterIndex] = Letter.empty();
    }
  }

  @override
  List<Object?> get props => [letters];
}