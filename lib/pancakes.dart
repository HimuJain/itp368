import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';

// Pancake model for representing each pancake's size
class Pancake {
  final int size;
  Pancake(this.size);
}

// Cubit to manage pancake stack and flipping logic
class PancakeCubit extends Cubit<List<int>> {
  PancakeCubit() : super([]);

  // Initialize pancakes in a randomized stack
  void initializePancakes(int count) {
    List<int> pancakes = List<int>.generate(count, (i) => i + 1);
    pancakes.shuffle();
    emit(pancakes);
  }

  // Flip part of the stack
  void flip(int index) {
    final flippedPart = state.sublist(0, index + 1).reversed.toList();
    final remainingPart = state.sublist(index + 1);
    emit(flippedPart + remainingPart);
  }

  // Check if the stack is sorted in ascending order
  bool isSorted() {
    for (int i = 0; i < state.length - 1; i++) {
      if (state[i] > state[i + 1]) return false;
    }
    return true;
  }
}

// GameBloc for managing flip count and win condition
class GameState {
  final int flipCount;
  final bool isSorted;
  GameState(this.flipCount, this.isSorted);
}

class GameBloc extends Cubit<GameState> {
  GameBloc() : super(GameState(0, false));

  void increaseFlipCount() {
    emit(GameState(state.flipCount + 1, state.isSorted));
  }

  void resetFlips() {
    emit(GameState(0, false));
  }

  void checkIfSorted(bool sorted) {
    emit(GameState(state.flipCount, sorted));
  }
}

// Main PancakeGame widget
class PancakeGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pancake Sorting'),
      ),
      body: Column(
        children: [
          BlocBuilder<PancakeCubit, List<int>>(builder: (context, pancakes) {
            return Expanded(
              child: Column(
                children: pancakes.asMap().entries.map((entry) {
                  int index = entry.key;
                  int size = entry.value;
                  return GestureDetector(
                    onTap: () {
                      context.read<PancakeCubit>().flip(index);
                      context.read<GameBloc>().increaseFlipCount();
                      if (context.read<PancakeCubit>().isSorted()) {
                        context.read<GameBloc>().checkIfSorted(true);
                      }
                    },
                    child: PancakeWidget(size: size),
                  );
                }).toList(),
              ),
            );
          }),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  int currentCount = context.read<PancakeCubit>().state.length;
                  if (currentCount > 2) {
                    context.read<PancakeCubit>().initializePancakes(currentCount - 1);
                    context.read<GameBloc>().resetFlips();
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  int currentCount = context.read<PancakeCubit>().state.length;
                  if (currentCount < 20) {
                    context.read<PancakeCubit>().initializePancakes(currentCount + 1);
                    context.read<GameBloc>().resetFlips();
                  }
                },
              ),
            ],
          ),
          BlocBuilder<GameBloc, GameState>(builder: (context, state) {
            return Text(
              'Flips: ${state.flipCount} ${state.isSorted ? " - You sorted it!" : ""}',
              style: TextStyle(fontSize: 24),
            );
          }),
          ElevatedButton(
            onPressed: () {
              context.read<PancakeCubit>().initializePancakes(
                  context.read<PancakeCubit>().state.length);
              context.read<GameBloc>().resetFlips();
            },
            child: Text('Restart with Same Stack'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<PancakeCubit>().initializePancakes(
                  context.read<PancakeCubit>().state.length);
              context.read<GameBloc>().resetFlips();
            },
            child: Text('New Random Stack'),
          ),
        ],
      ),
    );
  }
}

// Widget for displaying each pancake as a horizontal bar
class PancakeWidget extends StatelessWidget {
  final int size;

  PancakeWidget({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20.0 * size,
      height: 40.0,
      color: Colors.brown,
      margin: EdgeInsets.symmetric(vertical: 4.0),
    );
  }
}

// Main app entry
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pancake Sorting',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => PancakeCubit()..initializePancakes(5)),
          BlocProvider(create: (_) => GameBloc()),
        ],
        child: PancakeGame(),
      ),
    );
  }
}
