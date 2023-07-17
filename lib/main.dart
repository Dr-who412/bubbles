import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: BubbleShooterApp(),
    );
  }
}

class BubbleShooterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bubble Shooter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BubbleShootScreen(),
    );
  }
}
//
// late AnimationController _animationController=AnimationController(
//   vsync: this,
//   duration: Duration(milliseconds: 500),
// );
// late Animation<double> _animation=Tween<double>(begin: 0.0, end: -50.0).animate(_animationController);

////goood gradil
class BubbleShootScreen extends StatefulWidget {
  @override
  _BubbleShootScreenState createState() => _BubbleShootScreenState();
}

class _BubbleShootScreenState extends State<BubbleShootScreen>
    with SingleTickerProviderStateMixin {
  late List<List<Color>> bubbleMatrix;
  late int currentBubbleIndex;
  bool isGameOver = false;
  Color shooterButtonColor = Colors.red;
  late AnimationController _animationController = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 500),
  );
  late Animation<double> _animation =
      Tween<double>(begin: 0.0, end: -50.0).animate(_animationController);

  @override
  void initState() {
    super.initState();
    generateBubbleMatrix();
    generateShooterButtonColor();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation =
        Tween<double>(begin: 0.0, end: -50.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void generateBubbleMatrix() {
    bubbleMatrix = List.generate(
        3, (_) => List.generate(8, (_) => getRandomBubbleColor()));
    currentBubbleIndex = Random().nextInt(bubbleMatrix[0].length);
  }

  void generateShooterButtonColor() {
    shooterButtonColor = getRandomBubbleColor();
  }

  Color getRandomBubbleColor() {
    List<Color> bubbleColors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
    ];
    return bubbleColors[Random().nextInt(bubbleColors.length)];
  }

  void shootBubble() {
    if (!isGameOver) {
      setState(() {
        // Shift all rows down
        for (int i = bubbleMatrix.length - 1; i > 0; i--) {
          bubbleMatrix[i] = List.from(bubbleMatrix[i - 1]);
        }
        // Generate random colors for the new top row
        bubbleMatrix[0] = List.generate(
            bubbleMatrix[0].length, (_) => getRandomBubbleColor());
        // Increment the number of rows
        bubbleMatrix
            .add(List.generate(bubbleMatrix[0].length, (_) => Colors.white));
      });

      checkCollision();
      checkGameOver();
      generateShooterButtonColor();

      _animationController.reset();
      _animationController.forward();
    }
  }

  void checkCollision() {
    int currentRowIndex = 0;
    int currentColIndex = currentBubbleIndex;

    while (currentRowIndex < bubbleMatrix.length - 1) {
      if (bubbleMatrix[currentRowIndex + 1][currentColIndex] != Colors.white) {
        break;
      }
      currentRowIndex++;
    }

    // Handle collision logic here
    // Compare the color of the current bubble with the neighboring bubbles
    // You can add matching logic and bubble removal logic here
  }

  void checkGameOver() {
    // Implement your game over condition here
    // Set isGameOver to true if the game is over
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bubble Shoot'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: bubbleMatrix.length * bubbleMatrix[0].length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: bubbleMatrix[0].length,
              ),
              itemBuilder: (BuildContext context, int index) {
                int row = index ~/ bubbleMatrix[0].length;
                int col = index % bubbleMatrix[0].length;
                Color color = bubbleMatrix[row][col];
                return Container(
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                );
              },
            ),
          ),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _animation.value),
                child: GestureDetector(
                  onTap: shootBubble,
                  child: CustomPaint(
                    size: Size(60, 60),
                    painter: ShooterButtonPainter(shooterButtonColor),
                  ),
                ),
              );
            },
          ),
          ElevatedButton(
            onPressed: shootBubble,
            child: Text('Shoot Bubble'),
          ),
        ],
      ),
    );
  }
}

class ShooterButtonPainter extends CustomPainter {
  final Color bubbleColor;

  ShooterButtonPainter(this.bubbleColor);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..color = bubbleColor;

    canvas.drawCircle(center, size.width / 2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
/////
// class BubbleShootScreen extends StatefulWidget {
//   @override
//   _BubbleShootScreenState createState() => _BubbleShootScreenState();
// }
//
// class _BubbleShootScreenState extends State<BubbleShootScreen>
//     with SingleTickerProviderStateMixin {
//   late List<List<Color>> bubbleMatrix;
//   late int currentBubbleIndex;
//   bool isGameOver = false;
//   Color shooterButtonColor = Colors.red;
//
//   late AnimationController _animationController = AnimationController(
//     vsync: this,
//     duration: Duration(milliseconds: 500),
//   );
//   late Animation<double> _animation =
//       Tween<double>(begin: 0.0, end: -50.0).animate(_animationController);
//
//   @override
//   void initState() {
//     super.initState();
//     generateBubbleMatrix();
//     generateShooterButtonColor();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 500),
//     );
//     _animation =
//         Tween<double>(begin: 0.0, end: -50.0).animate(_animationController);
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   void generateBubbleMatrix() {
//     bubbleMatrix = List.generate(
//         3, (_) => List.generate(8, (_) => getRandomBubbleColor()));
//     currentBubbleIndex = Random().nextInt(bubbleMatrix[0].length);
//   }
//
//   void generateShooterButtonColor() {
//     shooterButtonColor = getRandomBubbleColor();
//   }
//
//   Color getRandomBubbleColor() {
//     List<Color> bubbleColors = [
//       Colors.red,
//       Colors.blue,
//       Colors.green,
//       Colors.yellow,
//       Colors.orange,
//       Colors.purple,
//     ];
//     return bubbleColors[Random().nextInt(bubbleColors.length)];
//   }
//
//   void shootBubble() {
//     if (!isGameOver) {
//       setState(() {
//         // Shift all rows down
//         for (int i = bubbleMatrix.length - 1; i > 0; i--) {
//           bubbleMatrix[i] = List.from(bubbleMatrix[i - 1]);
//         }
//         // Generate random colors for the new top row
//         bubbleMatrix[0] = List.generate(
//             bubbleMatrix[0].length, (_) => getRandomBubbleColor());
//       });
//
//       checkCollision();
//       checkGameOver();
//       generateShooterButtonColor();
//
//       _animationController.reset();
//       _animationController.forward();
//     }
//   }
//
//   void checkCollision() {
//     int currentRowIndex = 0;
//     int currentColIndex = currentBubbleIndex;
//
//     while (currentRowIndex < bubbleMatrix.length - 1) {
//       if (bubbleMatrix[currentRowIndex + 1][currentColIndex] != Colors.white) {
//         break;
//       }
//       currentRowIndex++;
//     }
//
//     // Handle collision logic here
//     // Compare the color of the current bubble with the neighboring bubbles
//     // You can add matching logic and bubble removal logic here
//   }
//
//   void checkGameOver() {
//     // Implement your game over condition here
//     // Set isGameOver to true if the game is over
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Bubble Shoot'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: GridView.builder(
//               padding: EdgeInsets.all(16.0),
//               itemCount: bubbleMatrix.length * bubbleMatrix[0].length,
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: bubbleMatrix[0].length,
//               ),
//               itemBuilder: (BuildContext context, int index) {
//                 int row = index ~/ bubbleMatrix[0].length;
//                 int col = index % bubbleMatrix[0].length;
//                 Color color = bubbleMatrix[row][col];
//                 return Container(
//                   decoration: BoxDecoration(
//                     color: color,
//                     shape: BoxShape.circle,
//                   ),
//                 );
//               },
//             ),
//           ),
//           AnimatedBuilder(
//             animation: _animation,
//             builder: (context, child) {
//               return Transform.translate(
//                 offset: Offset(0, _animation.value),
//                 child: GestureDetector(
//                   onTap: shootBubble,
//                   child: CustomPaint(
//                     size: Size(60, 60),
//                     painter: ShooterButtonPainter(shooterButtonColor),
//                   ),
//                 ),
//               );
//             },
//           ),
//           ElevatedButton(
//             onPressed: shootBubble,
//             child: Text('Shoot Bubble'),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class ShooterButtonPainter extends CustomPainter {
//   final Color bubbleColor;
//
//   ShooterButtonPainter(this.bubbleColor);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = Offset(size.width / 2, size.height / 2);
//     final paint = Paint()..color = bubbleColor;
//
//     canvas.drawCircle(center, size.width / 2, paint);
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }
// class BubbleShootScreen extends StatefulWidget {
//   @override
//   _BubbleShootScreenState createState() => _BubbleShootScreenState();
// }
//
// class _BubbleShootScreenState extends State<BubbleShootScreen>
//     with SingleTickerProviderStateMixin {
//   late List<List<Color>> bubbleMatrix;
//   late int currentBubbleIndex;
//   bool isGameOver = false;
//   Color shooterButtonColor = Colors.red;
//   late AnimationController _animationController;
//   late Animation<double> _animation;
//
//   double shooterButtonYOffset = 0.0;
//
//   @override
//   void initState() {
//     super.initState();
//     generateBubbleMatrix();
//     generateShooterButtonColor();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 500),
//     );
//     _animation =
//         Tween<double>(begin: 0.0, end: -50.0).animate(_animationController);
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   void generateBubbleMatrix() {
//     bubbleMatrix = List.generate(
//         3, (_) => List.generate(8, (_) => getRandomBubbleColor()));
//     currentBubbleIndex = Random().nextInt(bubbleMatrix[0].length);
//   }
//
//   void generateShooterButtonColor() {
//     shooterButtonColor = getRandomBubbleColor();
//   }
//
//   Color getRandomBubbleColor() {
//     List<Color> bubbleColors = [
//       Colors.red,
//       Colors.blue,
//       Colors.green,
//       Colors.yellow,
//       Colors.orange,
//       Colors.purple,
//     ];
//     return bubbleColors[Random().nextInt(bubbleColors.length)];
//   }
//
//   void shootBubble() {
//     if (!isGameOver) {
//       setState(() {
//         // Add a new row to the top of the bubble matrix
//         bubbleMatrix.insert(
//             0, List.filled(bubbleMatrix[0].length, Colors.white));
//         // Shift the existing rows down
//         for (int i = bubbleMatrix.length - 1; i >= 1; i--) {
//           bubbleMatrix[i] = List.from(bubbleMatrix[i - 1]);
//         }
//         // Generate random colors for the new row
//         for (int j = 0; j < bubbleMatrix[0].length; j++) {
//           bubbleMatrix[0][j] = getRandomBubbleColor();
//         }
//       });
//
//       moveBubblesDown();
//       checkCollision();
//       checkGameOver();
//       generateShooterButtonColor();
//
//       _animationController.reset();
//       _animationController.forward();
//     }
//   }
//
//   void moveBubblesDown() {
//     for (int i = bubbleMatrix.length - 2; i >= 0; i--) {
//       for (int j = 0; j < bubbleMatrix[i].length; j++) {
//         bubbleMatrix[i + 1][j] = bubbleMatrix[i][j];
//       }
//     }
//   }
//
//   void checkCollision() {
//     int currentRowIndex = 0;
//     int currentColIndex = currentBubbleIndex;
//
//     while (currentRowIndex < bubbleMatrix.length - 1) {
//       if (bubbleMatrix[currentRowIndex + 1][currentColIndex] != Colors.white) {
//         break;
//       }
//       currentRowIndex++;
//     }
//
//     // Handle collision logic here
//     // Compare the color of the current bubble with the neighboring bubbles
//     // You can add matching logic and bubble removal logic here
//   }
//
//   void checkGameOver() {
//     // Implement your game over condition here
//     // Set isGameOver to true if the game is over
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Bubble Shoot'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: GridView.builder(
//               padding: EdgeInsets.all(16.0),
//               itemCount: bubbleMatrix.length * bubbleMatrix[0].length,
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: bubbleMatrix[0].length,
//               ),
//               itemBuilder: (BuildContext context, int index) {
//                 int row = index ~/ bubbleMatrix[0].length;
//                 int col = index % bubbleMatrix[0].length;
//                 Color color = bubbleMatrix[row][col];
//                 // Apply fixed color to all rows except the first row
//                 if (row > 0) {
//                   color = getRandomBubbleColor();
//                 }
//                 return Container(
//                   decoration: BoxDecoration(
//                     color: color,
//                     shape: BoxShape.circle,
//                   ),
//                 );
//               },
//             ),
//           ),
//           AnimatedBuilder(
//             animation: _animation,
//             builder: (context, child) {
//               return Transform.translate(
//                 offset: Offset(0, _animation.value),
//                 child: GestureDetector(
//                   onTap: shootBubble,
//                   child: CustomPaint(
//                     size: Size(60, 60),
//                     painter: ShooterButtonPainter(shooterButtonColor),
//                   ),
//                 ),
//               );
//             },
//           ),
//           ElevatedButton(
//             onPressed: shootBubble,
//             child: Text('Shoot Bubble'),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class ShooterButtonPainter extends CustomPainter {
//   final Color bubbleColor;
//
//   ShooterButtonPainter(this.bubbleColor);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = Offset(size.width / 2, size.height / 2);
//     final paint = Paint()..color = bubbleColor;
//
//     canvas.drawCircle(center, size.width / 2, paint);
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }
// class BubbleShootScreen extends StatefulWidget {
//   @override
//   _BubbleShootScreenState createState() => _BubbleShootScreenState();
// }
//
// class _BubbleShootScreenState extends State<BubbleShootScreen>
//     with SingleTickerProviderStateMixin {
//   List<List<Color>> bubbleMatrix =
//       List.generate(8, (_) => List.filled(8, Colors.white));
//   late int currentBubbleIndex;
//   bool isGameOver = false;
//   Color shooterButtonColor = Colors.red;
//   late AnimationController _animationController = AnimationController(
//     vsync: this,
//     duration: Duration(milliseconds: 500),
//   );
//   late Animation<double> _animation =
//       Tween<double>(begin: 0.0, end: -50.0).animate(_animationController);
//
//   double shooterButtonYOffset = 0.0;
//
//   @override
//   void initState() {
//     super.initState();
//     generateBubbleMatrix();
//     generateShooterButtonColor();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 500),
//     );
//     _animation =
//         Tween<double>(begin: 0.0, end: -50.0).animate(_animationController);
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   void generateBubbleMatrix() {
//     for (int i = 0; i < bubbleMatrix.length; i++) {
//       for (int j = 0; j < bubbleMatrix[i].length; j++) {
//         bubbleMatrix[i][j] = getRandomBubbleColor();
//       }
//     }
//     currentBubbleIndex = Random().nextInt(bubbleMatrix[0].length);
//   }
//
//   void generateShooterButtonColor() {
//     shooterButtonColor = getRandomBubbleColor();
//   }
//
//   Color getRandomBubbleColor() {
//     List<Color> bubbleColors = [
//       Colors.red,
//       Colors.blue,
//       Colors.green,
//       Colors.yellow,
//       Colors.orange,
//       Colors.purple,
//     ];
//     return bubbleColors[Random().nextInt(bubbleColors.length)];
//   }
//
//   void shootBubble() {
//     if (!isGameOver) {
//       setState(() {
//         // Add a new row to the top of the bubble matrix
//         bubbleMatrix.insert(
//             0, List.filled(bubbleMatrix[0].length, Colors.white));
//         // Shift the existing rows down
//         for (int i = bubbleMatrix.length - 1; i >= 1; i--) {
//           bubbleMatrix[i] = List.from(bubbleMatrix[i - 1]);
//         }
//         // Generate random colors for the new row
//         for (int j = 0; j < bubbleMatrix[0].length; j++) {
//           bubbleMatrix[0][j] = getRandomBubbleColor();
//         }
//       });
//
//       moveBubblesDown();
//       checkCollision();
//       checkGameOver();
//       generateShooterButtonColor();
//
//       _animationController.reset();
//       _animationController.forward();
//     }
//   }
//
//   void moveBubblesDown() {
//     for (int i = bubbleMatrix.length - 2; i >= 0; i--) {
//       for (int j = 0; j < bubbleMatrix[i].length; j++) {
//         bubbleMatrix[i + 1][j] = bubbleMatrix[i][j];
//       }
//     }
//   }
//
//   void checkCollision() {
//     int currentRowIndex = 0;
//     int currentColIndex = currentBubbleIndex;
//
//     while (currentRowIndex < bubbleMatrix.length - 1) {
//       if (bubbleMatrix[currentRowIndex + 1][currentColIndex] != Colors.white) {
//         break;
//       }
//       currentRowIndex++;
//     }
//
//     // Handle collision logic here
//     // Compare the color of the current bubble with the neighboring bubbles
//     // You can add matching logic and bubble removal logic here
//   }
//
//   void checkGameOver() {
//     // Implement your game over condition here
//     // Set isGameOver to true if the game is over
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Fixed color for all rows
//     Color rowColor = Colors.grey;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Bubble Shoot'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: GridView.builder(
//               padding: EdgeInsets.all(16.0),
//               itemCount: bubbleMatrix.length * bubbleMatrix[0].length,
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: bubbleMatrix[0].length,
//               ),
//               itemBuilder: (BuildContext context, int index) {
//                 int row = index ~/ bubbleMatrix[0].length;
//                 int col = index % bubbleMatrix[0].length;
//                 Color color = bubbleMatrix[row][col];
//                 // Apply fixed color to all rows
//                 if (row > 0) {
//                   color = rowColor;
//                 }
//                 return Container(
//                   decoration: BoxDecoration(
//                     color: color,
//                     shape: BoxShape.circle,
//                   ),
//                 );
//               },
//             ),
//           ),
//           AnimatedBuilder(
//             animation: _animation,
//             builder: (context, child) {
//               return Transform.translate(
//                 offset: Offset(0, _animation.value),
//                 child: GestureDetector(
//                   onTap: shootBubble,
//                   child: CustomPaint(
//                     size: Size(60, 60),
//                     painter: ShooterButtonPainter(shooterButtonColor),
//                   ),
//                 ),
//               );
//             },
//           ),
//           ElevatedButton(
//             onPressed: shootBubble,
//             child: Text('Shoot Bubble'),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class ShooterButtonPainter extends CustomPainter {
//   final Color bubbleColor;
//
//   ShooterButtonPainter(this.bubbleColor);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = Offset(size.width / 2, size.height / 2);
//     final paint = Paint()..color = bubbleColor;
//
//     canvas.drawCircle(center, size.width / 2, paint);
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }

// class BubbleShootScreen extends StatefulWidget {
//   @override
//   _BubbleShootScreenState createState() => _BubbleShootScreenState();
// }
//
// class _BubbleShootScreenState extends State<BubbleShootScreen>
//     with SingleTickerProviderStateMixin {
//   List<List<Color>> bubbleMatrix =
//       List.generate(8, (_) => List.filled(8, Colors.white));
//   late int currentBubbleIndex;
//   bool isGameOver = false;
//   Color shooterButtonColor = Colors.red;
//   late AnimationController _animationController = AnimationController(
//     vsync: this,
//     duration: Duration(milliseconds: 500),
//   );
//   late Animation<double> _animation =
//       Tween<double>(begin: 0.0, end: -50.0).animate(_animationController);
//   double shooterButtonYOffset = 0.0;
//
//   @override
//   void initState() {
//     super.initState();
//     generateBubbleMatrix();
//     generateShooterButtonColor();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 500),
//     );
//     _animation =
//         Tween<double>(begin: 0.0, end: -50.0).animate(_animationController);
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   void generateBubbleMatrix() {
//     for (int i = 0; i < bubbleMatrix.length; i++) {
//       for (int j = 0; j < bubbleMatrix[i].length; j++) {
//         bubbleMatrix[i][j] = getRandomBubbleColor();
//       }
//     }
//     currentBubbleIndex = Random().nextInt(bubbleMatrix[0].length);
//   }
//
//   void generateShooterButtonColor() {
//     shooterButtonColor = getRandomBubbleColor();
//   }
//
//   Color getRandomBubbleColor() {
//     List<Color> bubbleColors = [
//       Colors.red,
//       Colors.blue,
//       Colors.green,
//       Colors.yellow,
//       Colors.orange,
//       Colors.purple,
//     ];
//     return bubbleColors[Random().nextInt(bubbleColors.length)];
//   }
//
//   void shootBubble() {
//     if (!isGameOver) {
//       setState(() {
//         for (int i = 0; i < bubbleMatrix[0].length; i++) {
//           bubbleMatrix[bubbleMatrix.length - 1][i] = Colors.white;
//         }
//         currentBubbleIndex = bubbleMatrix[0].length ~/ 2;
//         bubbleMatrix[bubbleMatrix.length - 1][currentBubbleIndex] =
//             shooterButtonColor;
//       });
//
//       moveBubblesDown();
//       checkCollision();
//       checkGameOver();
//       generateShooterButtonColor();
//
//       _animationController.reset();
//       _animationController.forward();
//     }
//   }
//
//   void moveBubblesDown() {
//     for (int i = bubbleMatrix.length - 2; i >= 0; i--) {
//       for (int j = 0; j < bubbleMatrix[i].length; j++) {
//         bubbleMatrix[i + 1][j] = bubbleMatrix[i][j];
//       }
//     }
//   }
//
//   void checkCollision() {
//     int currentRowIndex = 0;
//     int currentColIndex = currentBubbleIndex;
//
//     while (currentRowIndex < bubbleMatrix.length - 1) {
//       if (bubbleMatrix[currentRowIndex + 1][currentColIndex] != Colors.white) {
//         break;
//       }
//       currentRowIndex++;
//     }
//
//     // Handle collision logic here
//     // Compare the color of the current bubble with the neighboring bubbles
//     // You can add matching logic and bubble removal logic here
//   }
//
//   void checkGameOver() {
//     // Implement your game over condition here
//     // Set isGameOver to true if the game is over
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Bubble Shoot'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: GridView.builder(
//               padding: EdgeInsets.all(16.0),
//               itemCount: bubbleMatrix.length * bubbleMatrix[0].length,
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: bubbleMatrix[0].length,
//               ),
//               itemBuilder: (BuildContext context, int index) {
//                 int row = index ~/ bubbleMatrix[0].length;
//                 int col = index % bubbleMatrix[0].length;
//                 Color color = bubbleMatrix[row][col];
//                 return Container(
//                   decoration: BoxDecoration(
//                     color: color,
//                     shape: BoxShape.circle,
//                   ),
//                 );
//               },
//             ),
//           ),
//           AnimatedBuilder(
//             animation: _animation,
//             builder: (context, child) {
//               return Transform.translate(
//                 offset: Offset(0, _animation.value),
//                 child: GestureDetector(
//                   onTap: shootBubble,
//                   child: CustomPaint(
//                     size: Size(60, 60),
//                     painter: ShooterButtonPainter(shooterButtonColor),
//                   ),
//                 ),
//               );
//             },
//           ),
//           ElevatedButton(
//             onPressed: shootBubble,
//             child: Text('Shoot Bubble'),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class ShooterButtonPainter extends CustomPainter {
//   final Color bubbleColor;
//
//   ShooterButtonPainter(this.bubbleColor);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = Offset(size.width / 2, size.height / 2);
//     final paint = Paint()..color = bubbleColor;
//
//     canvas.drawCircle(center, size.width / 2, paint);
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }
// class BubbleShootScreen extends StatefulWidget {
//   @override
//   _BubbleShootScreenState createState() => _BubbleShootScreenState();
// }

// class _BubbleShootScreenState extends State<BubbleShootScreen> {
//   List<List<Color>> bubbleMatrix =
//       List.generate(8, (_) => List.filled(8, Colors.white));
//   late int currentBubbleIndex;
//   bool isGameOver = false;
//   late Color shooterButtonColor = Colors.red;
//
//   @override
//   void initState() {
//     super.initState();
//     generateBubbleMatrix();
//     generateShooterButtonColor();
//   }
//
//   void generateBubbleMatrix() {
//     for (int i = 0; i < bubbleMatrix.length; i++) {
//       for (int j = 0; j < bubbleMatrix[i].length; j++) {
//         bubbleMatrix[i][j] = getRandomBubbleColor();
//       }
//     }
//     currentBubbleIndex = Random().nextInt(bubbleMatrix[0].length);
//   }
//
//   void generateShooterButtonColor() {
//     shooterButtonColor = getRandomBubbleColor();
//   }
//
//   Color getRandomBubbleColor() {
//     List<Color> bubbleColors = [
//       Colors.red,
//       Colors.blue,
//       Colors.green,
//       Colors.yellow,
//       Colors.orange,
//       Colors.purple,
//     ];
//     return bubbleColors[Random().nextInt(bubbleColors.length)];
//   }
//
//   void shootBubble() {
//     if (!isGameOver) {
//       setState(() {
//         bubbleMatrix[0][currentBubbleIndex] = getRandomBubbleColor();
//         currentBubbleIndex = Random().nextInt(bubbleMatrix[0].length);
//       });
//
//       moveBubblesDown();
//       checkCollision();
//       checkGameOver();
//       generateShooterButtonColor();
//     }
//   }
//
//   void moveBubblesDown() {
//     for (int i = bubbleMatrix.length - 2; i >= 0; i--) {
//       for (int j = 0; j < bubbleMatrix[i].length; j++) {
//         bubbleMatrix[i + 1][j] = bubbleMatrix[i][j];
//       }
//     }
//   }
//
//   void checkCollision() {
//     int currentRowIndex = 0;
//     int currentColIndex = currentBubbleIndex;
//
//     while (currentRowIndex < bubbleMatrix.length - 1) {
//       if (bubbleMatrix[currentRowIndex + 1][currentColIndex] != Colors.white) {
//         break;
//       }
//       currentRowIndex++;
//     }
//
//     // Handle collision logic here
//     // Compare the color of the current bubble with the neighboring bubbles
//     // You can add matching logic and bubble removal logic here
//   }
//
//   void checkGameOver() {
//     // Implement your game over condition here
//     // Set isGameOver to true if the game is over
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Bubble Shoot'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: GridView.builder(
//               padding: EdgeInsets.all(16.0),
//               itemCount: bubbleMatrix.length * bubbleMatrix[0].length,
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: bubbleMatrix[0].length,
//               ),
//               itemBuilder: (BuildContext context, int index) {
//                 int row = index ~/ bubbleMatrix[0].length;
//                 int col = index % bubbleMatrix[0].length;
//                 Color color = bubbleMatrix[row][col];
//                 return Container(
//                   decoration: BoxDecoration(
//                     color: color,
//                     shape: BoxShape.circle,
//                   ),
//                 );
//               },
//             ),
//           ),
//           CustomPaint(
//             size: Size(60, 60),
//             painter: ShooterButtonPainter(shooterButtonColor),
//           ),
//           ElevatedButton(
//             onPressed: shootBubble,
//             child: Text('Shoot Bubble'),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class ShooterButtonPainter extends CustomPainter {
//   final Color bubbleColor;
//
//   ShooterButtonPainter(this.bubbleColor);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = Offset(size.width / 2, size.height / 2);
//     final paint = Paint()..color = bubbleColor;
//
//     canvas.drawCircle(center, size.width / 2, paint);
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }
// class BubbleShootScreen extends StatefulWidget {
//   @override
//   _BubbleShootScreenState createState() => _BubbleShootScreenState();
// }
//
// class _BubbleShootScreenState extends State<BubbleShootScreen> {
//   List<List<Color>> bubbleMatrix = List.generate(
//       8, (_) => List.filled(8, Colors.white));
//   late int currentBubbleIndex;
//   bool isGameOver = false;
//
//   @override
//   void initState() {
//     super.initState();
//     generateBubbleMatrix();
//   }
//
//   void generateBubbleMatrix() {
//     for (int i = 0; i < bubbleMatrix.length; i++) {
//       for (int j = 0; j < bubbleMatrix[i].length; j++) {
//         bubbleMatrix[i][j] = getRandomBubbleColor();
//       }
//     }
//     currentBubbleIndex = Random().nextInt(bubbleMatrix[0].length);
//   }
//
//   Color getRandomBubbleColor() {
//     List<Color> bubbleColors = [
//       Colors.red,
//       Colors.blue,
//       Colors.green,
//       Colors.yellow,
//       Colors.orange,
//       Colors.purple,
//     ];
//     return bubbleColors[Random().nextInt(bubbleColors.length)];
//   }
//
//   void shootBubble() {
//     if (!isGameOver) {
//       setState(() {
//         bubbleMatrix[0][currentBubbleIndex] = getRandomBubbleColor();
//         currentBubbleIndex = Random().nextInt(bubbleMatrix[0].length);
//       });
//       // Check for game over or matching bubbles
//       // Add your game logic here
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Bubble Shoot'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: GridView.builder(
//               padding: EdgeInsets.all(16.0),
//               itemCount: bubbleMatrix.length * bubbleMatrix[0].length,
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: bubbleMatrix[0].length,
//               ),
//               itemBuilder: (BuildContext context, int index) {
//                 int row = index ~/ bubbleMatrix[0].length;
//                 int col = index % bubbleMatrix[0].length;
//                 Color color = bubbleMatrix[row][col];
//                 return Container(
//                   decoration: BoxDecoration(
//                     color: color,
//                     shape: BoxShape.circle,
//                   ),
//                 );
//               },
//             ),
//           ),
//           ElevatedButton(
//             onPressed: shootBubble,
//             child: Text('Shoot Bubble'),
//           ),
//         ],
//       ),
//     );
//   }
// }
// class BubbleShooterScreen extends StatefulWidget {
//   @override
//   _BubbleShooterScreenState createState() => _BubbleShooterScreenState();
// }
//
// class _BubbleShooterScreenState extends State<BubbleShooterScreen> {
//   List<List<Color>> gameBoard =
//       []; // Represents the game board with colored bubbles
//   List<Color> bubbleColors = []; // Available colors for bubbles
//   Color? currentBubbleColor; // Color of the bubble being shot
//
//   @override
//   void initState() {
//     super.initState();
//     // Initialize the game board with empty bubbles
//     gameBoard = List.generate(8, (_) => List.filled(8, Colors.transparent));
//
//     // Initialize bubble colors
//     bubbleColors = [Colors.red, Colors.green, Colors.blue, Colors.yellow];
//
//     // Set initial bubble color
//     currentBubbleColor = bubbleColors[Random().nextInt(bubbleColors.length)];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Bubble Shooter'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Display the game board
//             GridView.builder(
//               shrinkWrap: true,
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 8,
//               ),
//               itemCount: 64,
//               itemBuilder: (context, index) {
//                 final row = index ~/ 8;
//                 final col = index % 8;
//                 return Bubble(color: gameBoard[row][col]);
//               },
//             ),
//             SizedBox(height: 16.0),
//             RaisedButton(
//               child: Text('Shoot'),
//               onPressed: () {
//                 // Shoot the bubble
//                 shootBubble();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void shootBubble() {
//     // Check if there is already a bubble being shot
//     if (currentBubbleColor == null) {
//       // Shoot a new bubble
//       setState(() {
//         currentBubbleColor =
//             bubbleColors[Random().nextInt(bubbleColors.length)];
//       });
//     } else {
//       // Bubble already being shot
//       // TODO: Implement logic for bubble collision, placement, and matching
//       // Reset the current bubble color
//       setState(() {
//         currentBubbleColor = null;
//       });
//     }
//   }
// }
//
// class Bubble extends StatelessWidget {
//   final Color color;
//
//   Bubble({required this.color});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.all(4.0),
//       decoration: BoxDecoration(
//         color: color,
//         shape: BoxShape.circle,
//       ),
//     );
//   }
// }
