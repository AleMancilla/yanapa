import 'package:flutter/material.dart';
import 'package:yanapa/presentation/home/home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with AutomaticKeepAliveClientMixin {
  final PageController _pageController = PageController(initialPage: 0);

  final List<String> imageUrls = [
    'assets/images/undraw_mobile_ux_re_59hr.png',
    'assets/images/undraw_Emails_re_cqen.png',
    'assets/images/undraw_Alert_re_j2op.png',
  ];

  final List<String> descriptions = [
    '''Detecta de forma temprana: Gracias a nuestro modelo de inteligencia artificial de última generación, podemos identificar posibles señales de enfermedades oculares como:
- Ojos saltones
- Cataratas
- Ojos cruzados
- Glaucoma
- Uveítis''',
    'Te brinda un diagnóstico personalizado: Nuestro sistema de análisis avanzado interpreta los datos proporcionados por la IA y te ofrece un diagnóstico inicial y recomendaciones de cuidados específicos para tu caso.',
    'Te conecta con oftalmólogos de confianza: En base a tu ubicación y necesidades, te sugerimos oftalmólogos de prestigio en tu zona para que puedas obtener un diagnóstico definitivo y el tratamiento adecuado.',
  ];

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
                  description: descriptions[index],
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
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
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
          SizedBox(height: 50),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class OnboardingPage extends StatelessWidget {
  final String imageUrl;
  final String description;

  OnboardingPage({required this.imageUrl, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imageUrl,
            height: 300,
            width: 300,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 20),
          Text(
            description,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
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
