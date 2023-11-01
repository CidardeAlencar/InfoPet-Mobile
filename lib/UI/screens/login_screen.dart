import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                        hintText: "Numero de IMEI",
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        prefixIcon: const Icon(Icons.numbers),
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
                        //signIn();
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

                    // TextFormField(
                    //     // //controller: numberOneController,
                    //     // decoration: const InputDecoration(
                    //     //   filled: true,
                    //     //   hintText: "Nombre de usuario",
                    //     //   // icon: Icon(Icons.input_sharp,
                    //     //   //     color: const Color.fromARGB(255, 255, 255, 255),
                    //     //   //     size: 36),
                    //     //   focusColor:
                    //     //       const Color.fromARGB(255, 255, 255, 255),
                    //     // ),
                    //     // //cursorColor: const Color.fromARGB(255, 255, 255, 255),

                    //     // //keyboardType: TextInputType.number,
                    //     ),
                  ],
                  // child: Center(

                  //   child: Text(
                  //     "hola",
                  //     style: TextStyle(
                  //         color: Color.fromARGB(255, 255, 255, 255),
                  //         fontSize: 64,
                  //         fontWeight: FontWeight.w500),
                  //   ),

                  // ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
