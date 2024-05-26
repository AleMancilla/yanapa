import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:yanapa/presentation/home/home_screen.dart';
import 'package:yanapa/presentation/home/notice_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<NavigationScreen> {
  /// Controller to handle PageView and also handles initial page
  final _pageController = PageController(initialPage: 1);

  /// Controller to handle bottom nav bar and also handles initial page
  final NotchBottomBarController _controller =
      NotchBottomBarController(index: 1);

  int maxCount = 3;

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// widget list
    final List<Widget> bottomBarPages = [
      NoticeScreen(),
      HomeScreen(),
      DenunciaWebViewScreen(),
    ];
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
            bottomBarPages.length, (index) => bottomBarPages[index]),
      ),
      extendBody: true,
      bottomNavigationBar: (bottomBarPages.length <= maxCount)
          ? AnimatedNotchBottomBar(
              // circleMargin: 20,
              bottomBarHeight: 0,

              removeMargins: true,

              /// Provide NotchBottomBarController
              notchBottomBarController: _controller,
              color: Color(0xFF30BE94),

              showLabel: true,
              textOverflow: TextOverflow.visible,
              maxLine: 1,
              shadowElevation: 0,

              kBottomRadius: 0.0,
              showTopRadius: true,
              showBottomRadius: false,

              // circleMargin: 0,

              // notchShader: const SweepGradient(
              //   startAngle: 0,
              //   endAngle: pi / 2,
              //   colors: [Colors.red, Colors.green, Colors.orange],
              //   tileMode: TileMode.mirror,
              // ).createShader(
              //     Rect.fromCircle(center: Offset.zero, radius: 20.0)),
              notchColor: Color(0xFF30BE94),

              /// restart app if you change removeMargins
              // removeMargins: false,
              bottomBarWidth: double.infinity,
              showShadow: false,
              durationInMilliSeconds: 300,

              itemLabelStyle: const TextStyle(fontSize: 10),

              elevation: 0,
              bottomBarItems: [
                BottomBarItem(
                  inActiveItem: SvgPicture.asset(
                    'assets/images/Yanapa/breaking_news.svg',
                    width: 40,
                    height: 40,
                    color: Colors.white,
                  ),
                  activeItem: SvgPicture.asset(
                    'assets/images/Yanapa/breaking_news.svg',
                    width: 40,
                    height: 40,
                    color: Colors.white,
                  ),
                  // itemLabel: 'Page 1',
                  itemLabelWidget: Text(
                    'Noticias',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
                BottomBarItem(
                  inActiveItem: SvgPicture.asset(
                    'assets/images/Yanapa/frame_inspect.svg',
                    width: 40,
                    height: 40,
                    color: Colors.white,
                  ),
                  activeItem: SvgPicture.asset(
                    'assets/images/Yanapa/frame_inspect.svg',
                    width: 40,
                    height: 40,
                    color: Colors.white,
                  ),
                  itemLabelWidget: Text(
                    'Analiza',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.warning,
                    color: Colors.white,
                  ),
                  activeItem: Icon(
                    Icons.warning,
                    color: Colors.white,
                  ),
                  itemLabelWidget: Text(
                    'Denuncia',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
              onTap: (index) {
                // log('current selected index $index');
                _pageController.jumpToPage(index);
              },
              kIconSize: 24.0,
            )
          : null,
    );
  }
}

class DenunciaWebViewScreen extends StatelessWidget {
  DenunciaWebViewScreen({Key? key}) : super(key: key);

  WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        // onHttpError: (HttpResponseError error) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse('https://bloquealaestafa.att.gob.bo/'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
            color: Colors.white,
            child: WebViewWidget(
              controller: controller,
              // initialUrl: 'https://flutter.dev',
            )),
      ),
    );
  }
}
