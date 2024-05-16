import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yanapa/presentation/home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller!, curve: Curves.easeIn);

    _controller!.forward();

    _loadDataAndNavigate();
  }

  Future<void> _loadDataAndNavigate() async {
    // Aquí puedes cargar tus datos necesarios
    await Future.delayed(Duration(seconds: 5)); // Simula carga de datos

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size sizeScreen = MediaQuery.of(context).size;
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: FadeTransition(
            opacity: _animation!,
            child: Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Center(
                // child: Image.asset(
                //   'assets/images/splash.jpeg',
                //   width: sizeScreen.width / 1.2,
                //   height: sizeScreen.width / 1.2,
                // ),
                child: SvgPicture.asset(
                  'assets/images/AI_fraud_Detection_header.svg',
                  width: sizeScreen.width / 1.2,
                  height: sizeScreen.width / 1.2,
                ),
              ),
            ),
          ),
        ),
        Text('La IA a tu servicio'),
        SizedBox(
          height: 40,
        )
      ],
    ));
  }
}
