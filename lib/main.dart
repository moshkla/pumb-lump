import 'package:flutter/material.dart';
import 'dart:ui' as ui;

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  const LightEffect(),
    );
  }
}


const lightColor = Color.fromRGBO(200, 173, 112, 1);

class LightEffect extends StatefulWidget {
  const LightEffect({Key? key}) : super(key: key);

  @override
  State<LightEffect> createState() => _LightEffectState();
}

class _LightEffectState extends State<LightEffect> {
  Offset textPosition = Offset.zero;
  bool isLightOn = false;
  Offset initialPosition = const Offset(128, 61);
  Offset containerPosition = const Offset(128, 61);

  @override
  void didChangeDependencies() {
    final size = MediaQuery.of(context).size;
    initialPosition = Offset(size.width / 2, 85.0);
    containerPosition = initialPosition;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Center(
            child: Stack(
              children: [
                Text(
                  text * 50,
                  style: !isLightOn
                      ? const TextStyle(color: Colors.black)
                      : TextStyle(
                    // color: Colors.white,
                    foreground: Paint()
                      ..strokeWidth = 9.0
                      ..shader = ui.Gradient.radial(
                        containerPosition == Offset.zero
                            ? initialPosition
                            : Offset(
                          containerPosition.dx,
                          containerPosition.dy + 60,
                        ),
                        190.0,
                        <Color>[
                          lightColor,
                          Colors.grey.shade900,
                        ],
                      ),
                  ),
                ),
                Wire(
                  toOffset: Offset(
                    containerPosition.dx,
                    containerPosition.dy - 80,
                  ),
                  initialPosition: Offset(
                    initialPosition.dx,
                    initialPosition.dy - 75,
                  ),
                ),
                AnimatedPositioned(
                  left: containerPosition.dx - 50,
                  top: containerPosition.dy - 85,
                  curve: Curves.easeOutCirc,
                  duration: const Duration(milliseconds: 300),
                  child: !isLightOn
                      ? bulbContainer()
                      : Draggable(
                    feedback: Material(
                      child: bulbContainer(),
                      color: Colors.transparent,
                    ),
                    onDragEnd: (x) {
                      setState(() {
                        containerPosition = initialPosition;
                      });
                    },
                    onDragUpdate: (x) {
                      if (isLightOn) {
                        containerPosition = x.localPosition;

                        setState(() {});
                      }
                    },
                    child: bulbContainer(),
                    childWhenDragging: Container(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget bulbContainer({Key? key}) {
    return InkWell(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: () {
        setState(() {
          isLightOn = !isLightOn;
        });
      },
      child: Container(
        height: 100.0,
        color: Colors.transparent,
        child: Image.asset(
          isLightOn ? 'assets/images/lamp_on.png' : 'assets/images/lamp_off.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class Wire extends StatefulWidget {
  final Offset toOffset;
  final Offset initialPosition;

  const Wire({Key? key, required this.toOffset, required this.initialPosition})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _WireState();
}

class _WireState extends State<Wire> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        painter: LinePainter(
          toOffset: widget.toOffset,
          initialPosition: widget.initialPosition,
        ));
  }
}

class LinePainter extends CustomPainter {
  Paint? _paint;
  final Offset initialPosition;
  final Offset toOffset;
  LinePainter({required this.toOffset, required this.initialPosition}) {
    _paint = Paint()
      ..color = lightColor
      ..strokeWidth = 2.0;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(initialPosition, toOffset, _paint!);
  }

  @override
  bool shouldRepaint(LinePainter oldDelegate) {
    return false;
  }
}

const text = '''
As a college student, much of your time will be spent interacting with texts of all types, shapes, sizes, and delivery methods. Sound interesting? Oh, it is. In the following sections, we’ll explore the nature of texts, what they will mean to you, and how to explore and use them effectively.
In academic terms, a text is anything that conveys a set of meanings to the person who examines it. You might have thought that texts were limited to written materials, such as books, magazines, newspapers, and ‘zines (an informal term for magazine that refers especially to fanzines and webzines). Those items are indeed texts—but so are movies, paintings, television shows, songs, political cartoons, online materials, advertisements, maps, works of art, and even rooms full of people. If we can look at something, explore it, find layers of meaning in it, and draw information and conclusions from it, we’re looking at a text.
''';