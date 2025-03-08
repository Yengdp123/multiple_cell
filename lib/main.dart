import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

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
  final AssetsAudioPlayer _audioPlayer = AssetsAudioPlayer(); // Create an AssetsAudioPlayer instance
  int cellCount = 1; // Start with one cell
  bool isGameCompleted = false; // Tracks game session completion

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    // Define a scaling animation
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Add a listener to update the UI after animation ends
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed && isGameCompleted) {
        setState(() {
          cellCount++; // Increment cell count
          isGameCompleted = false; // Reset game completion status
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _audioPlayer.dispose(); // Dispose the audio player instance
    super.dispose();
  }

  // Function to play the button click sound
  void _playButtonClickSound() {
    _audioPlayer.open(
      Audio("assetss/animations/Tap.mp3"), // Specify the audio file
      autoStart: true, // Start playing automatically
      showNotification: false, // Don't show notification
    );
  }

  // Simulating game session completion
  void completeGameSession() {
    setState(() {
      isGameCompleted = true; // Mark the game session as completed
    });
    _playButtonClickSound(); // Play sound when button is clicked
    _animationController.reset();
    _animationController.forward(); // Trigger the multiplication animation
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
                          scale: (index == cellCount - 1 && isGameCompleted)
                              ? _scaleAnimation.value
                              : 1.0, // Scale only the latest cell during animation
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
                if (cellCount > 1) ...[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    onPressed: () {
                      _playButtonClickSound(); // Play sound when button is clicked
                      // Placeholder for Home functionality
                      print("Home button pressed (not yet connected)");
                    },
                    child: const Text(
                      'HOME',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    onPressed: () {
                      _playButtonClickSound(); // Play sound when button is clicked
                      // Placeholder for Continue Session functionality
                      print("Continue Session button pressed (not yet connected)");
                    },
                    child: const Text(
                      'CONTINUE SESSION',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
                if (cellCount == 1)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    onPressed: () {
                      _playButtonClickSound(); // Play sound when button is clicked
                      completeGameSession();
                    },
                    child: const Text(
                      'COMPLETE SESSION',
                      style: TextStyle(fontSize: 18, color: Colors.black),
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
