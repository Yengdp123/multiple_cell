import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'game_screen.dart'; // Import the GameScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cytodoro Game',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: ThirdScreen(),
    );
  }
}

class ThirdScreen extends StatefulWidget {
  @override
  _ThirdScreenState createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;
  final AssetsAudioPlayer _audioPlayer = AssetsAudioPlayer();
  int cellCount = 1; // Start with one cell
  bool hasDivideCellButtonBeenUsed = false; // Tracks if the "Divide Cell" button has been used

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          cellCount++; // Increment cell count after the animation
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playButtonClickSound() {
    _audioPlayer.open(
      Audio("assetss/animations/Tap.mp3"),
      autoStart: true,
      showNotification: false,
    );
  }

  void divideCell() {
    if (!hasDivideCellButtonBeenUsed) {
      setState(() {
        hasDivideCellButtonBeenUsed = true; // Mark the button as used
      });
      _playButtonClickSound(); // Play sound effect
      _animationController.reset();
      _animationController.forward(); // Start the scaling animation
    }
  }

  void continueAnotherSession() {
    _playButtonClickSound(); // Play sound effect for "Continue Another Session"
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(
          onFinishGame: () {
            // When "Finish Game" is pressed, reset the "Divide Cell" button
            setState(() {
              hasDivideCellButtonBeenUsed = false;
            });
          },
        ),
      ), // Navigate to GameScreen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HOME SCREEN'),
        backgroundColor: Colors.yellowAccent,
      ),
      body: Stack(
        children: <Widget>[
          Image.asset(
            'assetss/animations/homescreen.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(cellCount, (index) {
                    return AnimatedBuilder(
                      animation: _scaleAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: (index == cellCount - 1) ? _scaleAnimation.value : 1.0,
                          child: Lottie.asset(
                            'assetss/animations/cellwiggle.json',
                            width: 100,
                            height: 100,
                          ),
                        );
                      },
                    );
                  }),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: hasDivideCellButtonBeenUsed
                        ? Colors.grey // Disabled state
                        : Colors.blue, // Active state
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  onPressed:
                  hasDivideCellButtonBeenUsed ? null : divideCell, // Disable button permanently if clicked
                  child: const Text(
                    'DIVIDE CELL', // Button label
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  onPressed: continueAnotherSession, // Action for the "Continue Another Session" button
                  child: const Text(
                    'CONTINUE ANOTHER SESSION', // Button label
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Cell Count: $cellCount',
                style: const TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}