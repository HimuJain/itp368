import 'package:flutter/material.dart';
import 'package:wordle/wordle/models/letter_model.dart';

const _keyb = [
  ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
  ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
  ['ENT', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', 'DEL']
];

class Keyboard extends StatelessWidget {
  const Keyboard({
    Key? key, 
    required this.onKeyTapped,
    required this.onDeleteTapped,
    required this.onEnterTapped,
    required this.letters,
    }) : super(key: key);
  final Function(String) onKeyTapped;
  final VoidCallback onDeleteTapped;
  final VoidCallback onEnterTapped;
  final Set<Letter> letters;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: _keyb.map(
        (keybRow) => Row(
          children: keybRow.map(
            (letter) {
              if (letter == 'DEL') {
                return _KeyboardButton.delete(onTap: onDeleteTapped);
              }
              else if (letter == 'ENT') {
                return _KeyboardButton.enter(onTap: onEnterTapped);
              }
                final letterKey = letters.firstWhere(
                  (element) => element.val == letter,
                  orElse: () => Letter.empty(),
                );
                return _KeyboardButton(
                  onTap: () => onKeyTapped(letter),
                  letter: letter,
                  backgroundColor: letterKey != Letter.empty() ? letterKey.backgroundColor : Colors.grey,
                );
            },
          ).toList(),
        ),
      ).toList(),
    );
  }
}

class _KeyboardButton extends StatelessWidget {
  const _KeyboardButton({
    Key? key,
    this.height = 40,
    this.width = 30,
    required this.onTap,
    required this.backgroundColor,
    required this.letter,
  }) : super(key: key);

  factory _KeyboardButton.delete({required VoidCallback onTap}) {
    return _KeyboardButton(
      onTap: onTap,
      letter: 'DEL',
      backgroundColor: Colors.red,
    );
  }

  factory _KeyboardButton.enter({required VoidCallback onTap}) {
    return _KeyboardButton(
      onTap: onTap,
      letter: 'ENT',
      backgroundColor: Colors.green,
    );
  }

  final double height;
  final double width;
  final VoidCallback onTap;
  final String letter;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 4,
      ),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: height,
            width: width,
            alignment: Alignment.center,
            child: Text(
              letter,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
