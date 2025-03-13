import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  final VoidCallback onFinishGame;

  const GameScreen({super.key, required this.onFinishGame});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Screen'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red, // Red to indicate finishing the game
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () {
            onFinishGame(); // Callback to reset the "Divide Cell" button
            Navigator.pop(context); // Navigate back to the home screen
          },
          child: const Text(
            'FINISH GAME',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}