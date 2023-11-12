// import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:flutter_launcher_icons/xml_templates.dart';
//maps
import 'package:google_maps_flutter/google_maps_flutter.dart';
//lopcation
import 'package:location/location.dart';
//firebase
import 'package:cloud_firestore/cloud_firestore.dart';

class GPSScreen extends StatefulWidget {
  final String userID;
  const GPSScreen({super.key, required this.userID});

  @override
  State<GPSScreen> createState() => _GPSScreenState();
}

class _GPSScreenState extends State<GPSScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  LocationData? _currentLocation;
  Location location = Location();
  @override
  void initState() {
    super.initState();
    // Solicita permiso para acceder a la ubicación
    location.requestPermission().then((granted) {
      if (granted == PermissionStatus.granted) {
        // Obtiene la ubicación actual
        //location.getLocation().then((locationData) {
        location.onLocationChanged.listen((LocationData locationData) {
          setState(() {
            _currentLocation = locationData;
          });
        });
      }
    });
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-16.5205315, -68.1166503),
    zoom: 13.000,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(-16.5197865, -68.1101769),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    // void showUserDataDialogUser(userId) {
    //   showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         title: Text('Información del Usuario'),
    //         content: Container(
    //           width: double.maxFinite,
    //           child: SingleChildScrollView(
    //             child: Column(
    //               mainAxisSize: MainAxisSize.min,
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 FutureBuilder<DocumentSnapshot>(
    //                   future: FirebaseFirestore.instance
    //                       .collection('users')
    //                       .doc(userId)
    //                       .get(),
    //                   builder: (BuildContext context,
    //                       AsyncSnapshot<DocumentSnapshot> snapshot) {
    //                     if (snapshot.connectionState ==
    //                         ConnectionState.waiting) {
    //                       return Center(
    //                         child: CircularProgressIndicator(),
    //                       );
    //                     }
    //                     if (snapshot.hasError) {
    //                       return Text('Error al obtener los datos del usuario');
    //                     }
    //                     if (!snapshot.hasData || !snapshot.data!.exists) {
    //                       return Text(
    //                           'No se encontró el usuario en Cloud Firestore');
    //                     }

    //                     // Accede a los campos de los datos del usuario
    //                     String apellido_materno =
    //                         snapshot.data!['apellido_materno'];
    //                     String apellido_paterno =
    //                         snapshot.data!['apellido_paterno'];
    //                     String celular = snapshot.data!['celular'];
    //                     String nombres = snapshot.data!['nombres'];
    //                     String email = snapshot.data!['email'];

    //                     return Column(
    //                       mainAxisSize: MainAxisSize.min,
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         Text('Apellido Paterno: $apellido_paterno'),
    //                         Text('Apellido Materno: $apellido_materno'),
    //                         Text('Nombres: $nombres'),
    //                         Text('Email: $email '),
    //                         Text('Número de celular: $celular'),
    //                       ],
    //                     );
    //                   },
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //         actions: [
    //           TextButton(
    //             child: Text('Cerrar'),
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //             },
    //           ),
    //         ],
    //       );
    //     },
    //   );
    // }

    //obtener datos usuario
    void showUserDataBottomSheet(userId) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16.0),
              // decoration: BoxDecoration(
              //   color: Colors.orange,
              //   borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
              // ),
              child: FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Text('Error al obtener los datos del usuario');
                  }
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Text('No se encontró el usuario en Cloud Firestore');
                  }

                  // Accede a los campos de los datos del usuario
                  String apellido_materno = snapshot.data!['apellido_materno'];
                  String apellido_paterno = snapshot.data!['apellido_paterno'];
                  String celular = snapshot.data!['celular'];
                  String nombres = snapshot.data!['nombres'];
                  String email = snapshot.data!['email'];

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          'USUARIO',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF8820),
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'Apellido Paterno',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF8820),
                          ),
                        ),
                        subtitle: Text(apellido_paterno),
                      ),
                      ListTile(
                        title: Text(
                          'Apellido Materno',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF8820),
                          ),
                        ),
                        subtitle: Text(apellido_materno),
                      ),
                      ListTile(
                        title: Text(
                          'Nombres',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF8820),
                          ),
                        ),
                        subtitle: Text(nombres),
                      ),
                      ListTile(
                        title: Text(
                          'Email',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF8820),
                          ),
                        ),
                        subtitle: Text(email),
                      ),
                      ListTile(
                        title: Text(
                          'Número de celular',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF8820),
                          ),
                        ),
                        subtitle: Text(celular),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      );
    }
    //fin obtener datos usuario

    //obtener datos mascotas
    void showPetDataBottomSheet(userId) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Text('Error al obtener los datos del usuario');
                  }
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Text('No se encontró el usuario en Cloud Firestore');
                  }

                  List<dynamic> idsMascotas = snapshot.data!['id_mascota'];

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        child: Text(
                          'MASCOTAS',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF8820),
                          ),
                        ),
                      ),

                      // Itera sobre los IDs de mascotas y obtén la información de cada mascota
                      for (var idMascota in idsMascotas)
                        FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('mascotas')
                              .doc(idMascota)
                              .get(),
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> mascotaSnapshot) {
                            if (mascotaSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (mascotaSnapshot.hasError) {
                              return Text(
                                  'Error al obtener los datos de una mascota');
                            }
                            if (!mascotaSnapshot.hasData ||
                                !mascotaSnapshot.data!.exists) {
                              return Text(
                                  'No se encontró la mascota en Cloud Firestore');
                            }
                            String nombreMascota =
                                mascotaSnapshot.data!['nombre'];
                            String colorMascota =
                                mascotaSnapshot.data!['color'];
                            String edadMascota =
                                mascotaSnapshot.data!['edad_meses'];
                            String especieMascota =
                                mascotaSnapshot.data!['especie'];
                            String razaMascota = mascotaSnapshot.data!['raza'];
                            String sexoMascota = mascotaSnapshot.data!['sexo'];
                            String imageUrl = mascotaSnapshot.data!['imagen'];
                            //GPS Info
                            String IMEIGPS = mascotaSnapshot.data!['IMEI'];
                            int bateria = mascotaSnapshot.data!['bateria'];
                            Timestamp fechaLimiteTimestamp =
                                mascotaSnapshot.data!['fecha_limite'];
                            DateTime fechaL = fechaLimiteTimestamp.toDate();
                            return Column(
                              children: [
                                const Divider(
                                  color: Color(0xFFFF8820),
                                  thickness: 3,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Image.network(
                                  imageUrl,
                                  height: 250,
                                  width: 190,
                                  fit: BoxFit.cover,
                                ),
                                ListTile(
                                  title: Text(
                                    'Nombre',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFFF8820),
                                    ),
                                  ),
                                  subtitle: Text(nombreMascota),
                                ),
                                ListTile(
                                  title: Text(
                                    'Edad',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFFF8820),
                                    ),
                                  ),
                                  subtitle: Text(edadMascota),
                                ),
                                ListTile(
                                  title: Text(
                                    'Sexo',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFFF8820),
                                    ),
                                  ),
                                  subtitle: Text(sexoMascota),
                                ),
                                ListTile(
                                  title: Text(
                                    'Color',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFFF8820),
                                    ),
                                  ),
                                  subtitle: Text(colorMascota),
                                ),
                                ListTile(
                                  title: Text(
                                    'Especie',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFFF8820),
                                    ),
                                  ),
                                  subtitle: Text(especieMascota),
                                ),
                                ListTile(
                                  title: Text(
                                    'Raza',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFFF8820),
                                    ),
                                  ),
                                  subtitle: Text(razaMascota),
                                ),
                                const Divider(
                                  thickness: 2,
                                ),
                                ListTile(
                                  title: Text(
                                    'IMEI',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFFF8820),
                                    ),
                                  ),
                                  subtitle: Text(IMEIGPS),
                                ),
                                ListTile(
                                  title: Text(
                                    'Nivel de Batería',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFFF8820),
                                    ),
                                  ),
                                  subtitle: Text('$bateria%'),
                                ),
                                ListTile(
                                  title: Text(
                                    'Fecha Límite',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFFF8820),
                                    ),
                                  ),
                                  subtitle: Text('${fechaL.toLocal()}'),
                                ),
                                // const Divider(
                                //   color: Color(0xFFFF8820),
                                //   thickness: 3,
                                // ),
                              ],
                            );
                          },
                        ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      );
    }

    //fin obtener datos masocta
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        title: Image.asset('assets/logo.png', width: 220),

        actions: [
          IconButton(
            //icon: Image.asset('assets/icon _info circle.png'),
            icon: Icon(
              Icons.person,
              color: Color(0xFFFF8820),
            ),
            onPressed: () {
              //showUserDataDialog('5j4qcd9NIRzGGKly5Y1f');
              //showUserDataDialogUser(widget.userID);
              showUserDataBottomSheet(widget.userID);
            },
          ),
          const SizedBox(
            width: 30,
          ),
          IconButton(
            //icon: Image.asset('assets/icon _arrow circle right.png'),
            icon: Icon(
              Icons.pets,
              color: Color(0xFFFF8820),
            ),
            onPressed: () {
              // Add your close functionality here
              showPetDataBottomSheet(widget.userID);
              //Navigator.pushReplacementNamed(context, '/user');
              //Navigator.pop(context);
            },
          ),
          const SizedBox(
            width: 30,
          ),
          IconButton(
            //icon: Image.asset('assets/icon _close circle.png'),
            icon: Icon(
              Icons.gps_fixed,
              color: Color(0xFFFF8820),
            ),
            onPressed: () {},
          ),
          // const SizedBox(
          //   width: 30,
          // ),
          // IconButton(
          //   //icon: Image.asset('assets/icon _close circle.png'),
          //   icon: Icon(Icons.exit_to_app),
          //   onPressed: () {
          //     // Add your close functionality here
          //     exit(0);
          //   },
          // ),
        ],
        leadingWidth: 100,
        centerTitle: true,
        //backgroundColor: Color.fromARGB(255, 255, 255, 255)
        backgroundColor: Colors.white,
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        // Muestra la ubicación actual si está disponible
        markers: _currentLocation != null
            ? {
                Marker(
                  markerId: MarkerId('currentLocation'),
                  position: LatLng(
                    _currentLocation!.latitude!,
                    _currentLocation!.longitude!,
                  ),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueOrange,
                  ),
                  infoWindow: InfoWindow(title: 'Tu ubicación actual'),
                ),
              }
            : {},
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: 15.0,
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: FloatingActionButton.extended(
            onPressed: _goToTheLake,
            label: const Text(
              'Ver Mascota!',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            icon: const Icon(
              Icons.pets,
              color: Colors.white,
            ),
            backgroundColor: Color(0xFFFF8820),
          ),
        ),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
