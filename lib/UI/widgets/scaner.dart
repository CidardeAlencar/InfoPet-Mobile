import 'package:flutter/material.dart';

class Scaner extends StatelessWidget {
  const Scaner({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Column(
          children: [
            Image.asset('assets/frame1.png'),
            const SizedBox(
              width: 240,
              child: Text(
                "ESCANEA Y OBTÉN\nINFORMACIÓN DE LA MASCOTA",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ),
            ),
            const SizedBox(
              height: 11,
            ),
            const SizedBox(
              width: 230,
              child: Text(
                "InfOPet te permite escanear el código QR y así obtener  la información detallada a tiempo real de la mascota.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  letterSpacing: -1,
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/qr');
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF8820),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Text(
                  "ESCANEAR",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    letterSpacing: -2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
