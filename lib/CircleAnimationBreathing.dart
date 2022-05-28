import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

// import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class CircleAnimation extends StatefulWidget {
  @override
  _CircleAnimationState createState() => _CircleAnimationState();
}

class _CircleAnimationState extends State<CircleAnimation>
    with TickerProviderStateMixin {
  double screenWidth = 200;
  // late ConfettiController _controllerCenter;
  final List<double> sizes = [200, 300, 300, 200, 200];
  final List<double> centerCircleSizes = [90, 140, 140, 90, 90];
  final List<int> duration = [0, 5, 0, 5, 0];
  final List<String> textArray = [
    "",
    "Breathe-in",
    "Hold",
    "Breathe-out",
    "Hold",
  ];

  String text = "";
  int iteration = 0;
  int cycle = 0;
  int sum = 0;
  late Animation<double> animation_rotation;
  late AnimationController controller;

  late double dotRadius = 14.0;

  final interval = const Duration(seconds: 1);
  final int timerMaxSeconds = 90;
  int currentSeconds = 0;
  String get timerText =>
      '${(0).toString().padLeft(2, '0')}: ${((timerMaxSeconds - currentSeconds)).toString().padLeft(2, '0')}';

  // String get timerText =>
  //     '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';

  startTimer([int? milliseconds]) {
    var duration = interval;
    Timer.periodic(duration, (timer) {
      setState(() {
        print(timer.tick);
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds) timer.cancel();
        Future.delayed(Duration(seconds: 89), () {
          setState(() {
            controller.stop();
          });
        });
        // if (timer.tick >= 00 && timer.tick <= 89) {
        //call here controller to stop animatin
        // run();

        // print("run is running");
        // }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    // startTimer();
    for (int i = 0; i < duration.length; i++) {
      sum = sum + duration[i];
    }
    print(sum);

    controller = AnimationController(
        lowerBound: 0.0,
        upperBound: 1.0,
        duration: Duration(seconds: sum),
        vsync: this);

    animation_rotation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 1.0, curve: Curves.linear),
      ),
    );

    // _controllerCenter =
    //     ConfettiController(duration: const Duration(seconds: 20));
  }

  Path drawStar(Size size) {
    double degToRad(double deg) => deg * (math.pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * math.cos(step),
          halfWidth + externalRadius * math.sin(step));
      path.lineTo(
          halfWidth + internalRadius * math.cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * math.sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  Future<void> run() async {
    while (cycle <= 8) {
      for (int i = 0; i < sizes.length; i++) {
        if (iteration + 1 < sizes.length) {
          setState(() {
            iteration += 1;
          });
          await Future.delayed(Duration(seconds: duration[iteration]), () {});
        }
      }
      setState(() {
        cycle += 1;
        iteration = 0;
      });
      // if (cycle == 10) {
      // controller.stop();
      // _controllerCenter.play();
      // }
      print(controller.isAnimating);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Circle Animation'),
        ),
        body: Center(
            child: Container(
          color: Colors.black,
          child: Stack(
            children: [
              /*iteration == 0 && cycle == 4
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ConfettiWidget(
                        confettiController: _controllerCenter,
                        blastDirectionality: BlastDirectionality.explosive,
                        shouldLoop: true,
                        colors: const [
                          Colors.green,
                          Colors.blue,
                          Colors.pink,
                          Colors.orange,
                          Colors.purple
                        ],
                        createParticlePath: drawStar,
                      ),
                    )
                  : Container(),*/
              Center(
                child: AnimatedContainer(
                  duration: Duration(seconds: duration[iteration]),
                  width: sizes[iteration],
                  height: sizes[iteration],
                  child: CustomPaint(
                    painter: QuadrantCirclePainter(
                        text: textArray[iteration],
                        breatheIn: double.parse(duration[1].toString()),
                        breatheOut: double.parse(duration[3].toString()),
                        hold1: double.parse(duration[2].toString()),
                        hold2: double.parse(duration[4].toString())),
                  ),
                ),
              ),
              RotationTransition(
                turns: animation_rotation,
                child: Transform.translate(
                    child: Dot(
                      radius: dotRadius,
                      color: Colors.red,
                    ),
                    offset: Offset(
                      // sizes[iteration] - 100, sizes[iteration] - 100
                      18 * 9 * math.cos(0.0 + 6 * math.pi / 4),
                      18 * 9 * math.sin(0.0 + 6 * math.pi / 4),
                    )),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 150.0,
                          child: ElevatedButton(
                              onPressed: () {
                                startTimer();
                                setState(() {
                                  cycle = 0;
                                  iteration = 0;
                                  controller.reset();
                                  controller.repeat();
                                  run();
                                });
                              },
                              child: Text("Start")),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 150.0,
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  cycle = 4;
                                  iteration = 0;
                                  controller.reset();
                                  controller.stop();
                                });
                              },
                              child: Text("Stop")),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                  top: 10,
                  right: 20,
                  child: Column(
                    children: [
                      Text(
                        timerText,
                        style: TextStyle(
                            color: Colors.amber,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ))
            ],
          ),
        )));
  }
}

class Dot extends StatelessWidget {
  final double? radius;
  final Color? color;

  Dot({this.radius, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: radius,
        height: radius,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}

class QuadrantCirclePainter extends CustomPainter {
  final double breatheIn;
  final double hold1;
  final double breatheOut;
  final double hold2;

  static const Color centerCircleColor = Colors.black;

  final String text;

  QuadrantCirclePainter(
      {required this.text,
      required this.breatheIn,
      required this.breatheOut,
      required this.hold1,
      required this.hold2}); // 1 quadrant = 90 degrees

  void _drawSpeenWheel(Canvas canvas, Paint paint,
      {Offset? center,
      double? radius,
      List<double>? sources,
      List<Color>? colors,
      double? startRadian}) {
    var total = 0.0;
    for (var d in sources!) {
      total += d;
    }
    List<double> radians = [];
    for (var data in sources) {
      radians.add(data * 2 * math.pi / total);
    }
    for (int i = 0; i < radians.length; i++) {
      paint.color = colors![i % colors.length];
      canvas.drawArc(Rect.fromCircle(center: center!, radius: radius!),
          startRadian!, radians[i], true, paint);
      startRadian += radians[i];
    }
  }

  /*drawAxis(double value, Canvas canvas, double radius, Paint paint, Size size) {
    print("hy");
    var firstAxis = getCirclePath(radius, size);
    var pathMetrics = firstAxis.computeMetrics();
    for (PathMetric pathMetric in pathMetrics) {
      Path extractPath = pathMetric.extractPath(
        0.0,
        pathMetric.length * value,
      );
      try {
        var metric = extractPath.computeMetrics().first;
        print(metric);
        final offset = metric.getTangentForOffset(metric.length)!.position;
        print(0 + math.cos((value * 360 * math.pi) / 180) * 100);
        print(0 + math.sin((value * 360 * math.pi) / 180) * 100);
        canvas.drawCircle(offset, 10.0, paint);
      } catch (e) {}
    }
  }*/

  Path getCirclePath(double radius, Size size) => Path()
    ..addOval(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2), radius: radius));

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = new Paint()
      ..isAntiAlias = true
      ..strokeWidth = 2.0
      ..style = PaintingStyle.fill;

    Paint _axisPaint = Paint()
      ..color = const Color(0xFFE6E6E6)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    Offset center = new Offset(size.width / 2, size.height / 2);
    double radius = math.min(size.width / 2, size.height / 2);

    _drawSpeenWheel(
      canvas,
      paint,
      sources: [this.breatheIn, this.hold1, this.breatheOut, this.hold2],
      colors: [
        Color(0xff1065b2),
        Color(0xffcfefff),
        Color(0xff2a9ef5),
        Color(0xffcfefff),
      ],
      center: center,
      radius: radius,
      startRadian: (3 * math.pi / 2),
    );

    canvas.drawCircle(center, radius / 1.12, paint..color = centerCircleColor);
    final textStyle = TextStyle(
        color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold);
    final textSpan = TextSpan(
      text: this.text,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 10,
      maxWidth: size.width,
    );
    final xCenter = (size.width - textPainter.width) / 2;
    final yCenter = (size.height - textPainter.height) / 2;
    final offset = Offset(xCenter, yCenter);
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}


// import 'dart:async';
// import 'dart:math' as math;
// import 'dart:ui';

// // import 'package:confetti/confetti.dart';
// import 'package:flutter/material.dart';

// class CircleAnimation extends StatefulWidget {
//   @override
//   _CircleAnimationState createState() => _CircleAnimationState();
// }

// class _CircleAnimationState extends State<CircleAnimation>
//     with TickerProviderStateMixin {
//   Timer? _myTimer;
//   double _size = 90.0;
//   double screenWidth = 200;
//   // late ConfettiController _controllerCenter;
//   final List<double> sizes = [200, 300, 300, 200, 200];
//   final List<double> centerCircleSizes = [90, 140, 140, 90, 90];
//   final List<int> duration = [0, 4, 2, 4, 2];
//   final List<String> textArray = [
//     "",
//     "Breathe-in",
//     "Hold",
//     "Breathe-out",
//     "Hold",
//   ];

//   String text = "";
//   int iteration = 0;
//   int cycle = 0;
//   int sum = 0;
//   late Animation<double> animation_rotation;
//   late AnimationController controller;

//   late double dotRadius = 14.0;

//   @override
//   void initState() {
//     super.initState();
//     for (int i = 0; i < duration.length; i++) {
//       sum = sum + duration[i];
//     }
//     print(sum);

//     controller = AnimationController(
//         lowerBound: 0.0,
//         upperBound: 1.0,
//         duration: const Duration(seconds: 16),
//         vsync: this);

//     animation_rotation = Tween(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: controller,
//         curve: Interval(0.0, 1.0, curve: Curves.linear),
//       ),
//     );

//     controller.repeat();
//     // _controllerCenter =
//     //     ConfettiController(duration: const Duration(seconds: 20));
//   }

//   Path drawStar(Size size) {
//     double degToRad(double deg) => deg * (math.pi / 180.0);

//     const numberOfPoints = 5;
//     final halfWidth = size.width / 2;
//     final externalRadius = halfWidth;
//     final internalRadius = halfWidth / 2.5;
//     final degreesPerStep = degToRad(360 / numberOfPoints);
//     final halfDegreesPerStep = degreesPerStep / 2;
//     final path = Path();
//     final fullAngle = degToRad(360);
//     path.moveTo(size.width, halfWidth);

//     for (double step = 0; step < fullAngle; step += degreesPerStep) {
//       path.lineTo(halfWidth + externalRadius * math.cos(step),
//           halfWidth + externalRadius * math.sin(step));
//       path.lineTo(
//           halfWidth + internalRadius * math.cos(step + halfDegreesPerStep),
//           halfWidth + internalRadius * math.sin(step + halfDegreesPerStep));
//     }
//     path.close();
//     return path;
//   }

//   Future<void> run() async {
//     while (cycle <= 3) {
//       for (int i = 0; i < sizes.length; i++) {
//         if (iteration + 1 < sizes.length) {
//           setState(() {
//             iteration += 1;
//           });
//           await Future.delayed(Duration(seconds: duration[iteration]), () {});
//         }
//       }
//       setState(() {
//         cycle += 1;
//         iteration = 0;
//       });
//       if (cycle == 4) {
//         print("cycle complted");
//         // _controllerCenter.play();
//       }
//       print(cycle);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           title: const Text('Circle Animation'),
//         ),
//         body: Center(
//             child: Container(
//           color: Colors.black,
//           child: Stack(
//             children: [
//               iteration == 0 && cycle == 4
//                   ? const Padding(
//                       padding: EdgeInsets.all(8.0),
//                       // child: ConfettiWidget(
//                       //   confettiController: _controllerCenter,
//                       //   blastDirectionality: BlastDirectionality.explosive,
//                       //   shouldLoop: true,
//                       //   colors: const [
//                       //     Colors.green,
//                       //     Colors.blue,
//                       //     Colors.pink,
//                       //     Colors.orange,
//                       //     Colors.purple
//                       //   ],
//                       //   createParticlePath: drawStar,
//                       // ),
//                     )
//                   : Container(),
//               Center(
//                 child: AnimatedContainer(
//                   duration: Duration(seconds: duration[iteration]),
//                   width: sizes[iteration],
//                   height: sizes[iteration],
//                   child: CustomPaint(
//                     painter: QuadrantCirclePainter(
//                         text: textArray[iteration],
//                         breatheIn: double.parse(duration[1].toString()),
//                         breatheOut: double.parse(duration[3].toString()),
//                         hold1: double.parse(duration[2].toString()),
//                         hold2: double.parse(duration[4].toString())),
//                   ),
//                 ),
//               ),
//               RotationTransition(
//                 turns: animation_rotation,
//                 child: Transform.translate(
//                     child: Dot(
//                       radius: dotRadius,
//                       // radius: sizes[iteration],
//                       color: Colors.red,
//                     ),
//                     offset: sizes[iteration] == 200
//                         ? Offset(
//                             14 * 9 * math.cos(0.0 + 6 * math.pi / 4),
//                             14 * 9 * math.sin(0.0 + 6 * math.pi / 4),
//                           )
//                         : Offset(
//                             20 * 9 * math.cos(0.0 + 6 * math.pi / 4),
//                             20 * 9 * math.sin(0.0 + 6 * math.pi / 4),
//                           )),
//               ),
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 20.0, bottom: 30.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           width: 150.0,
//                           child: ElevatedButton(
//                               onPressed: () {
//                                 cycle = 0;
//                                 iteration = 0;
//                                 run();
//                                 print(_myTimer?.isActive);
//                               },
//                               child: Text("Start")),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           width: 150.0,
//                           child: ElevatedButton(
//                               onPressed: () {
//                                 _myTimer?.cancel();
//                               },
//                               child: Text("Stop")),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         )));
//   }
// }

// class Dot extends StatelessWidget {
//   final double? radius;
//   final Color? color;

//   Dot({this.radius, this.color});

//   @override
//   Widget build(BuildContext context) {
//     return new Center(
//       child: Container(
//         width: radius,
//         height: radius,
//         decoration: BoxDecoration(color: color, shape: BoxShape.circle),
//       ),
//     );
//   }
// }

// class QuadrantCirclePainter extends CustomPainter {
//   final double breatheIn;
//   final double hold1;
//   final double breatheOut;
//   final double hold2;

//   static const Color centerCircleColor = Colors.black;

//   final String text;

//   QuadrantCirclePainter(
//       {required this.text,
//       required this.breatheIn,
//       required this.breatheOut,
//       required this.hold1,
//       required this.hold2}); // 1 quadrant = 90 degrees

//   void _drawSpeenWheel(Canvas canvas, Paint paint,
//       {Offset? center,
//       double? radius,
//       List<double>? sources,
//       List<Color>? colors,
//       double? startRadian}) {
//     var total = 0.0;
//     for (var d in sources!) {
//       total += d;
//     }
//     List<double> radians = [];
//     for (var data in sources) {
//       radians.add(data * 2 * math.pi / total);
//     }
//     for (int i = 0; i < radians.length; i++) {
//       paint.color = colors![i % colors.length];
//       canvas.drawArc(Rect.fromCircle(center: center!, radius: radius!),
//           startRadian!, radians[i], true, paint);
//       startRadian += radians[i];
//     }
//   }

//   /*drawAxis(double value, Canvas canvas, double radius, Paint paint, Size size) {
//     print("hy");
//     var firstAxis = getCirclePath(radius, size);
//     var pathMetrics = firstAxis.computeMetrics();
//     for (PathMetric pathMetric in pathMetrics) {
//       Path extractPath = pathMetric.extractPath(
//         0.0,
//         pathMetric.length * value,
//       );
//       try {
//         var metric = extractPath.computeMetrics().first;
//         print(metric);
//         final offset = metric.getTangentForOffset(metric.length)!.position;
//         print(0 + math.cos((value * 360 * math.pi) / 180) * 100);
//         print(0 + math.sin((value * 360 * math.pi) / 180) * 100);
//         canvas.drawCircle(offset, 10.0, paint);
//       } catch (e) {}
//     }
//   }*/

//   Path getCirclePath(double radius, Size size) => Path()
//     ..addOval(Rect.fromCircle(
//         center: Offset(size.width / 2, size.height / 2), radius: radius));

//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = new Paint()
//       ..isAntiAlias = true
//       ..strokeWidth = 2.0
//       ..style = PaintingStyle.fill;

//     Paint _axisPaint = Paint()
//       ..color = const Color(0xFFE6E6E6)
//       ..strokeWidth = 2.0
//       ..style = PaintingStyle.stroke;

//     Offset center = new Offset(size.width / 2, size.height / 2);
//     double radius = math.min(size.width / 2, size.height / 2);

//     _drawSpeenWheel(
//       canvas,
//       paint,
//       sources: [this.breatheIn, this.hold1, this.breatheOut, this.hold2],
//       colors: [
//         Color(0xff1065b2),
//         Color(0xffcfefff),
//         Color(0xff2a9ef5),
//         Color(0xffcfefff),
//       ],
//       center: center,
//       radius: radius,
//       startRadian: (3 * math.pi / 2),
//     );

//     canvas.drawCircle(center, radius / 1.12, paint..color = centerCircleColor);
//     final textStyle = TextStyle(
//       color: Colors.white,
//       fontSize: 12,
//     );
//     final textSpan = TextSpan(
//       text: this.text,
//       style: textStyle,
//     );
//     final textPainter = TextPainter(
//       text: textSpan,
//       textDirection: TextDirection.ltr,
//     );
//     textPainter.layout(
//       minWidth: 0,
//       maxWidth: size.width,
//     );
//     final xCenter = (size.width - textPainter.width) / 2;
//     final yCenter = (size.height - textPainter.height) / 2;
//     final offset = Offset(xCenter, yCenter);
//     textPainter.paint(canvas, offset);

//     //drawAxis(value, canvas, radius * 1.1, Paint()..color = Colors.red, size);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }
