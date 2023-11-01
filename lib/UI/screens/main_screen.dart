import 'package:flutter/material.dart';
import 'package:infopet/UI/widgets/localitation.dart';
import 'package:infopet/UI/widgets/scaner.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ManualQRScreen extends StatefulWidget {
  const ManualQRScreen({super.key});

  @override
  State<ManualQRScreen> createState() => _ManualQRScreenState();
}

class _ManualQRScreenState extends State<ManualQRScreen> {
  final controller = PageController(viewportFraction: 0.8, keepPage: true);

  @override
  Widget build(BuildContext context) {
    final pages = [
      const Scaner(),
      const Localitation(),
    ];
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Image.asset('assets/logo.png', width: 220),
                  ),
                ],
              ),
              SizedBox(
                height: 625,
                // width: 700,
                child: PageView.builder(
                  controller: controller,
                  itemCount: pages.length,
                  itemBuilder: (_, index) {
                    return pages[index];
                  },
                ),
              ),
              SmoothPageIndicator(
                controller: controller,
                count: pages.length,
                effect: const WormEffect(
                  dotHeight: 16,
                  dotWidth: 16,
                  type: WormType.thinUnderground,
                  dotColor: Color(0xFFD9D9D9),
                  activeDotColor: Color(0xFFFE412A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
