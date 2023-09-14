import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) =>
            const SplashScreen(), // => the next page after the splashscreen
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 412,
        height: 860,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(color: Colors.white),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: -51,
              child: Container(
                width: 475,
                height: 526,
                decoration: const BoxDecoration(color: Color(0xFFF9DCDE)),
              ),
            ),
            const Positioned(
              left: 100,
              top: 215,
              child: SizedBox(
                width: 160,
                height: 51,
                child: Text(
                  'Preggo',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFD77D7C),
                    fontSize: 40,
                    fontFamily: 'Signika',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 143,
              top: 435,
              child: Container(
                width: 78,
                height: 80,
                decoration: const ShapeDecoration(
                  color: Colors.white,
                  shape: OvalBorder(),
                ),
              ),
            ),
            Positioned(
              left: 130, // the postion of the logo
              top: 430,
              child: Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('assets/images/logoNoName.png'),
                  fit: BoxFit.fill,
                )),
              ),
            ),
            Positioned(
                left: 54,
                top: 615,
                child: RichText(
                  text: const TextSpan(
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Signika',
                        fontWeight: FontWeight.w700,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Stay ',
                            style: TextStyle(color: Colors.black)),
                        TextSpan(
                            text: 'Connected,',
                            style: TextStyle(color: Color(0xFFD77D7C))),
                        TextSpan(
                            text: ' Stay ',
                            style: TextStyle(color: Colors.black)),
                        TextSpan(
                            text: 'Informed',
                            style: TextStyle(color: Color(0xFFD77D7C)))
                      ]),
                )),
          ],
        ),
      ),
    );
  }
}
