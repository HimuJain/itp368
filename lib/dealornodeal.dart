import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deal or No Deal',
      home: BlocProvider(
        create: (_) => DealBloc()..add(ResetGameEvent()),
        child: DealGameScreen(),
      ),
    );
  }
}

// Deal or No Deal Game Screen
class DealGameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Deal or No Deal')),
      body: BlocBuilder<DealBloc, DealState>(
        builder: (context, state) {
          if (state is GameInitial) {
            return _buildGameBoard(context, state.remainingSuitcases, state.suitcaseNumbers, state.revealedSuitcases);
          } else if (state is SuitcaseSelected) {
            return _buildDealOrNoDeal(context, state.remainingValues, state.suitcaseNumbers, state.revealedSuitcases);
          } else if (state is DealerOffer) {
            return _buildDealerOffer(context, state.offerAmount, state.remainingValues, state.suitcaseNumbers, state.revealedSuitcases);
          } else if (state is GameOver) {
            return _buildGameOver(context, state.finalWinnings);
          }
          return Center(child: Text('Unexpected state!'));
        },
      ),
    );
  }

  Widget _buildGameBoard(BuildContext context, List<int> remainingValues, List<int> suitcaseNumbers, Map<int, int> revealedSuitcases) {
    return Column(
      children: [
        Text('Remaining Suitcases: ${remainingValues.length}'),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2,
            ),
            itemCount: remainingValues.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  context.read<DealBloc>().add(SelectSuitcaseEvent(index));
                },
                child: Card(
                  child: Center(
                    child: Text('Suitcase ${suitcaseNumbers[index]}'),
                  ),
                ),
              );
            },
          ),
        ),
        _buildValueTable(revealedSuitcases),
      ],
    );
  }

  Widget _buildDealOrNoDeal(BuildContext context, List<int> remainingValues, List<int> suitcaseNumbers, Map<int, int> revealedSuitcases) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => context.read<DealBloc>().add(DealOrNoDealEvent(true)),
              child: Text('DEAL'),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: () => context.read<DealBloc>().add(DealOrNoDealEvent(false)),
              child: Text('NO DEAL'),
            ),
          ],
        ),
        _buildValueTable(revealedSuitcases),
      ],
    );
  }

  Widget _buildDealerOffer(BuildContext context, double offerAmount, List<int> remainingValues, List<int> suitcaseNumbers, Map<int, int> revealedSuitcases) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Dealer\'s offer: \$${offerAmount.toStringAsFixed(2)}'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => context.read<DealBloc>().add(DealOrNoDealEvent(true)),
              child: Text('DEAL'),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: () => context.read<DealBloc>().add(DealOrNoDealEvent(false)),
              child: Text('NO DEAL'),
            ),
          ],
        ),
        _buildValueTable(revealedSuitcases),
      ],
    );
  }

  Widget _buildValueTable(Map<int, int> revealedSuitcases) {
    List<int> values = [1, 2, 5, 10, 20, 50, 100, 200, 500, 1000];
    return Table(
      border: TableBorder.all(),
      children: [
        TableRow(
          children: values.map((value) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('\$$value', textAlign: TextAlign.center),
          )).toList(),
        ),
        TableRow(
          children: values.map((value) {
            int? suitcaseNumber = revealedSuitcases[value];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(suitcaseNumber != null ? 'Suitcase $suitcaseNumber' : '', textAlign: TextAlign.center),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildGameOver(BuildContext context, double winnings) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Game Over! You won \$${winnings.toStringAsFixed(2)}'),
          ElevatedButton(
            onPressed: () => context.read<DealBloc>().add(ResetGameEvent()),
            child: Text('Play Again'),
          ),
        ],
      ),
    );
  }
}

// Event Classes
abstract class DealEvent {}

class ResetGameEvent extends DealEvent {}

class SelectSuitcaseEvent extends DealEvent {
  final int selectedSuitcaseIndex;
  SelectSuitcaseEvent(this.selectedSuitcaseIndex);
}

class DealOrNoDealEvent extends DealEvent {
  final bool dealAccepted;
  DealOrNoDealEvent(this.dealAccepted);
}

// State Classes
abstract class DealState {}

class GameInitial extends DealState {
  final List<int> remainingSuitcases;
  final List<int> suitcaseNumbers;
  final Map<int, int> revealedSuitcases;
  GameInitial(this.remainingSuitcases, this.suitcaseNumbers, this.revealedSuitcases);
}

class SuitcaseSelected extends DealState {
  final List<int> remainingValues;
  final List<int> suitcaseNumbers;
  final Map<int, int> revealedSuitcases;
  SuitcaseSelected(this.remainingValues, this.suitcaseNumbers, this.revealedSuitcases);
}

class DealerOffer extends DealState {
  final double offerAmount;
  final List<int> remainingValues;
  final List<int> suitcaseNumbers;
  final Map<int, int> revealedSuitcases;
  DealerOffer(this.offerAmount, this.remainingValues, this.suitcaseNumbers, this.revealedSuitcases);
}

class GameOver extends DealState {
  final double finalWinnings;
  GameOver(this.finalWinnings);
}

// Bloc Class: DealBloc
class DealBloc extends Bloc<DealEvent, DealState> {
  List<int> _initialSuitcaseValues = [1, 2, 5, 10, 20, 50, 100, 200, 500, 1000]; // Example values
  List<int> _remainingSuitcases = [];
  List<int> _suitcaseNumbers = [];
  int? _playerSuitcaseValue;
  Map<int, int> _revealedSuitcases = {};
  int _selectedSuitcaseIndex = -1;

  DealBloc() : super(GameInitial([], [], {})) {
    on<ResetGameEvent>(_onResetGame);
    on<SelectSuitcaseEvent>(_onSelectSuitcase);
    on<DealOrNoDealEvent>(_onDealOrNoDeal);
  }

  void _onResetGame(ResetGameEvent event, Emitter<DealState> emit) {
    // Initialize the game by shuffling the suitcase values and resetting the player's suitcase
    _remainingSuitcases = List.from(_initialSuitcaseValues)..shuffle();
    _suitcaseNumbers = List.generate(_initialSuitcaseValues.length, (index) => index + 1);
    _playerSuitcaseValue = null;
    _revealedSuitcases = {};
    emit(GameInitial(List.from(_remainingSuitcases), List.from(_suitcaseNumbers), Map.from(_revealedSuitcases)));
  }

  void _onSelectSuitcase(SelectSuitcaseEvent event, Emitter<DealState> emit) {
    // Store the selected suitcase index
    _selectedSuitcaseIndex = event.selectedSuitcaseIndex;
    // Reveal the selected suitcase value
    int revealedValue = _remainingSuitcases[event.selectedSuitcaseIndex];
    double offerAmount = _calculateOffer();
    emit(DealerOffer(offerAmount, List.from(_remainingSuitcases), List.from(_suitcaseNumbers), Map.from(_revealedSuitcases)));
  }

  void _onDealOrNoDeal(DealOrNoDealEvent event, Emitter<DealState> emit) {
    if (event.dealAccepted) {
      // If the deal is accepted, end the game with the dealer's offer as the final winnings
      emit(GameOver(_calculateOffer()));
    } else {
      // If the deal is not accepted, update the revealed suitcases and continue the game
      int revealedValue = _remainingSuitcases.removeAt(_selectedSuitcaseIndex);
      _revealedSuitcases[revealedValue] = _suitcaseNumbers[_selectedSuitcaseIndex];
      _suitcaseNumbers.removeAt(_selectedSuitcaseIndex);
      emit(GameInitial(List.from(_remainingSuitcases), List.from(_suitcaseNumbers), Map.from(_revealedSuitcases)));
    }
  }

  double _calculateOffer() {
    if (_remainingSuitcases.isEmpty) {
      return 0.0;
    }
    double averageValue = _remainingSuitcases.reduce((a, b) => a + b) / _remainingSuitcases.length;
    return 0.9 * averageValue; // Dealer offers 90% of the expected value
  }
}