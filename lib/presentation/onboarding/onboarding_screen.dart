import 'package:flutter/material.dart';
import 'package:yanapa/presentation/home/home_screen.dart';
import 'package:yanapa/presentation/home/navigation_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with AutomaticKeepAliveClientMixin {
  final PageController _pageController = PageController(initialPage: 0);

  final List<String> imageUrls = [
    'assets/images/Yanapa/1_yanapa.gif',
    'assets/images/Yanapa/2_yanapa.gif',
    'assets/images/Yanapa/3_yanapa.gif',
  ];

  // final List<String> descriptions = [
  //   '''YANAPA
  //   Reconocimiento de texto y análisis lingüístico: La app debe extraer texto de imágenes y analizarlo en busca de señales de fraude.''',
  //   'Algoritmos avanzados de detección de fraudes: Debe usar técnicas de aprendizaje automático para identificar patrones sospechosos en el texto.',
  //   'Actualización continua y adaptabilidad: Se mantiene al día con las últimas tácticas de estafadores y mejorar constantemente su capacidad de detección.',
  // ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 30),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: imageUrls.length,
              onPageChanged: (value) {
                setState(() {});
              },
              itemBuilder: (context, index) {
                return OnboardingPage(
                  imageUrl: imageUrls[index],
                  // description: descriptions[index],
                );
              },
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: PageIndicator(
                  pageCount: imageUrls.length,
                  currentPage: _pageController.hasClients
                      ? _pageController.page?.round() ?? 0
                      : 0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NavigationScreen()));
                    // MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blueAccent,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      'Continuar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class OnboardingPage extends StatelessWidget {
  final String imageUrl;
  // final String description;

  OnboardingPage({
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Image.asset(
              imageUrl,
              // height: 300,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ),
          // SizedBox(height: 20),
          // Text(
          //   description,
          //   style: TextStyle(
          //     fontSize: 18,
          //     fontWeight: FontWeight.bold,
          //   ),
          //   textAlign: TextAlign.left,
          // ),
        ],
      ),
    );
  }
}

class PageIndicator extends StatelessWidget {
  final int pageCount;
  final int currentPage;

  PageIndicator({required this.pageCount, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pageCount,
        (index) => Container(
          width: 10,
          height: 10,
          margin: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == currentPage ? Colors.blue : Colors.grey,
          ),
        ),
      ),
    );
  }
}
