import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../utils/sendSMS.dart';
//firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infopet/UI/screens/gps_screen.dart';

//
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Funciones
  Future<void> requestPermissions() async {
    var status = await Permission.sms.status;
    if (status.isDenied) {
      await Permission.sms.request();
    }
  }

  void signIn() async {
    String email = emailController.text;
    String password = passwordController.text;

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // El inicio de sesión fue exitoso
      User user = userCredential.user!;
      print('Usuario autenticado: ${user.uid}');

      // //doble autentificacion
      // if (user.emailVerified) {
      //   // El usuario ha iniciado sesión y su correo electrónico está verificado
      //   DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
      //       .collection('users')
      //       .doc(user.uid)
      //       .get();
      //   if (userSnapshot.exists) {
      //     String role = userSnapshot.get('role');
      //     final snackBar =
      //         SnackBar(content: Text('Usuario autentificado correctamente.'));
      //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
      //     // Redirigir a la pantalla correspondiente según el rol
      //     if (role == 'Administrador') {
      //       Navigator.pushReplacementNamed(context, '/admin');
      //     } else if (role == 'Usuario') {
      //       print('Es un usuario');
      //       print('Usuario autenticado: ${user.email}');
      //       Navigator.pushReplacementNamed(context, '/user');
      //     }
      //   }
      // } else {
      //   // El usuario no ha verificado su correo electrónico o el inicio de sesión ha fallado
      //   final snackBar = SnackBar(content: Text('Usuario no verifico email.'));
      //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // }
      // //doble autentificacion

      //Navigator.pushReplacementNamed(context, '/admin');
      // Consultar el rol del usuario en la base de datos

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userSnapshot.exists) {
        //
        await SmsUtil.sendSms("59172057234", "999");
        //
        //String role = userSnapshot.get('role');
        final snackBar =
            SnackBar(content: Text('Usuario autentificado correctamente.'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // Redirigir a la pantalla correspondiente según el rol
        // if (role == 'admin') {
        //   Navigator.pushReplacementNamed(context, '/admin');
        // } else if (role == 'user') {
        //   print('Es un usuario');
        //   print('Usuario autenticado: ${user.email}');
        //   Navigator.pushReplacementNamed(context, '/user');
        // }
        // Navigator.pushReplacementNamed(context, '/gps',
        //     arguments: {'userId': user.uid});
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GPSScreen(userID: user.uid),
          ),
        );
      }
    } catch (e) {
      final snackBar = SnackBar(content: Text('Error al iniciar sesión.'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print('Error al iniciar sesión: $e');
    }
  }
  /////
  //SMS

  ///

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(253, 252, 252, 1),
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Image.asset('assets/icon.png', width: 220),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "Correo electronico",
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        prefixIcon: const Icon(Icons.email),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      obscureText: _obscureText,
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: "Contraseña",
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                        prefixIcon: const Icon(Icons.lock),
                      ),
                      //obscureText: true,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () {
                        // Acción al presionar el botón
                        signIn();
                        print('Botón presionado');
                        // Agrega aquí la lógica adicional que deseas ejecutar al presionar el botón
                      },
                      child: Container(
                        width: 285,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFFFF8820),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          child: Center(
                            child: Text(
                              "INGRESAR",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
