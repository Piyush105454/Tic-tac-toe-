import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TicTacToePage(isTwoPlayer: true),
                  ),
                );
              },
              child: const Text('Two Player'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TicTacToePage(isTwoPlayer: false),
                  ),
                );
              },
              child: const Text('Play Against AI'),
            ),
          ],
        ),
      ),
    );
  }
}

class TicTacToePage extends StatefulWidget {
  final bool isTwoPlayer;

  const TicTacToePage({super.key, required this.isTwoPlayer});

  @override
  _TicTacToePageState createState() => _TicTacToePageState();
}

class _TicTacToePageState extends State<TicTacToePage> {
  List<String> board = List.filled(9, '');
  bool isPlayerOneTurn = true;
  String playerOneSymbol = 'X';
  String playerTwoSymbol = 'O';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _onTileTap(index),
                  child: Container(
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                    ),
                    child: Center(
                      child: Text(
                        board[index],
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetGame,
              child: const Text('Restart Game'),
            ),
          ],
        ),
      ),
    );
  }

  void _onTileTap(int index) {
    if (board[index] == '') {
      setState(() {
        board[index] = isPlayerOneTurn ? playerOneSymbol : playerTwoSymbol;
        if (_checkWin(isPlayerOneTurn ? playerOneSymbol : playerTwoSymbol)) {
          _showWinDialog(isPlayerOneTurn ? playerOneSymbol : playerTwoSymbol);
          return;
        }
        isPlayerOneTurn = !isPlayerOneTurn;
        if (!widget.isTwoPlayer && !isPlayerOneTurn) {
          _aiMove();
        }
      });
    }
  }

  void _aiMove() {
    int index = _getBestMove();
    if (index != -1) {
      setState(() {
        board[index] = playerTwoSymbol;
        if (_checkWin(playerTwoSymbol)) {
          _showWinDialog(playerTwoSymbol);
        } else {
          isPlayerOneTurn = true;
        }
      });
    }
  }

  int _getBestMove() {
    List<int> emptyIndices = [];
    for (int i = 0; i < board.length; i++) {
      if (board[i] == '') {
        emptyIndices.add(i);
      }
    }
    if (emptyIndices.isNotEmpty) {
      return emptyIndices[Random().nextInt(emptyIndices.length)];
    }
    return -1;
  }

  bool _checkWin(String symbol) {
    const List<List<int>> winningCombinations = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var combination in winningCombinations) {
      if (board[combination[0]] == symbol &&
          board[combination[1]] == symbol &&
          board[combination[2]] == symbol) {
        return true;
      }
    }
    return false;
  }

  void _showWinDialog(String winner) {
    String message = winner == playerOneSymbol ? 'Player 1 Wins!' : 'AI Wins!';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
              child: const Text('Restart'),
            ),
          ],
        );
      },
    );
  }

  void _resetGame() {
    setState(() {
      board = List.filled(9, '');
      isPlayerOneTurn = true;
    });
  }
}
