import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
// import 'package:flutter_launcher_icons/xml_templates.dart';
//maps
import 'package:google_maps_flutter/google_maps_flutter.dart';
//lopcation
import 'package:location/location.dart';
//firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//sms
import 'package:another_telephony/telephony.dart';

@pragma('vm:entry-point')
onBackgroundMessage(SmsMessage message) {
  debugPrint("onBackgroundMessage called");
}

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
  //sms
  final telephony = Telephony.instance;
  String _message = "";
  double? petLatitude;
  double? petLongitude;
  String? nombreMascota;
  List<Marker> _markersList = [];
  //
  BitmapDescriptor? _pawIcon;
  BitmapDescriptor? _profileIcon;
  //

  @override
  void initState() {
    super.initState();
    //sms
    initPlatformState();
    //
    _loadMarkerImage();
    _loadMarkerImage1();
    //
    location.requestPermission().then((granted) {
      if (granted == PermissionStatus.granted) {
        //location.getLocation().then((locationData) {
        location.onLocationChanged.listen((LocationData locationData) {
          if (mounted) {
            setState(() {
              _currentLocation = locationData;
              // Add the current location marker when the map is created
              if (_currentLocation != null) {
                // _markersList.add(
                //   Marker(
                //     markerId: MarkerId('currentLocation'),
                //     position: LatLng(
                //       _currentLocation!.latitude!,
                //       _currentLocation!.longitude!,
                //     ),
                //     icon: BitmapDescriptor.defaultMarkerWithHue(
                //       BitmapDescriptor.hueOrange,
                //     ),
                //     infoWindow: InfoWindow(title: 'Tu ubicación actual'),
                //   ),
                // );

                _markersList.add(
                  Marker(
                    markerId: MarkerId('currentLocation'),
                    position: LatLng(
                      _currentLocation!.latitude!,
                      _currentLocation!.longitude!,
                    ),
                    // icon: BitmapDescriptor.defaultMarkerWithHue(
                    //   BitmapDescriptor.hueOrange,
                    // ),
                    icon: _profileIcon != null
                        ? _profileIcon!
                        : BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueRed),
                    infoWindow: InfoWindow(title: 'Tu ubicación actual'),
                  ),
                );
              }
            });
          }
        });
      }
    });
  }

  Future<void> _loadMarkerImage() async {
    final ByteData data = await rootBundle.load('assets/paw_icon.png');
    final List<int> bytes = data.buffer.asUint8List();

    Uint8List uint8List = Uint8List.fromList(bytes);

    ui.Codec codec = await ui.instantiateImageCodec(uint8List,
        targetHeight: 150, targetWidth: 150);
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    ui.Image image = frameInfo.image;

    final ByteData? resizedData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    if (resizedData != null) {
      final Uint8List resizedBytes =
          Uint8List.fromList(resizedData.buffer.asUint8List());

      setState(() {
        _pawIcon = BitmapDescriptor.fromBytes(resizedBytes);
      });
    }
  }

  Future<void> _loadMarkerImage1() async {
    final ByteData data = await rootBundle.load('assets/profile_icon.png');
    final List<int> bytes = data.buffer.asUint8List();

    Uint8List uint8List = Uint8List.fromList(bytes);

    ui.Codec codec = await ui.instantiateImageCodec(uint8List,
        targetHeight: 150, targetWidth: 150);
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    ui.Image image = frameInfo.image;

    final ByteData? resizedData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    if (resizedData != null) {
      final Uint8List resizedBytes =
          Uint8List.fromList(resizedData.buffer.asUint8List());

      setState(() {
        _profileIcon = BitmapDescriptor.fromBytes(resizedBytes);
      });
    }
  }

  //sms

  onMessage(SmsMessage message) async {
    if (message.body != null) {
      extractAndShowCoordinates(message.body!);
    }
  }

  Future<void> initPlatformState() async {
    final bool? result = await telephony.requestPhoneAndSmsPermissions;

    if (result != null && result) {
      telephony.listenIncomingSms(
          onNewMessage: onMessage, onBackgroundMessage: onBackgroundMessage);
    }

    if (!mounted) return;
  }

  void extractAndShowCoordinates(String smsBody) {
    RegExp latLngRegExp = RegExp(r'lat=(-?\d+\.\d+)&lng=(-?\d+\.\d+)');
    Match? match = latLngRegExp.firstMatch(smsBody);

    if (match != null) {
      double lat = double.parse(match.group(1)!);
      double lng = double.parse(match.group(2)!);

      setState(() {
        petLatitude = lat;
        petLongitude = lng;
        _message = 'Latitud: $lat, Longitud: $lng';
        print('$_message');
        print('$_message');
        //sms
        // Add the pet marker immediately when coordinates are received
        _markersList.add(
          Marker(
            markerId: MarkerId('petLocation${_markersList.length + 1}'),
            position: LatLng(petLatitude!, petLongitude!),
            infoWindow: InfoWindow(title: 'Ubicación de la mascota'),
            // icon: BitmapDescriptor.defaultMarkerWithHue(
            //   BitmapDescriptor.hueRed,
            // ),
            icon: _pawIcon != null
                ? _pawIcon!
                : BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueOrange),
          ),
        );
        //
      });
    } else {
      setState(() {
        petLatitude = null;
        petLongitude = null;
        _message = 'No se encontraron coordenadas en el mensaje SMS.';
      });
    }
  }

  //

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-16.5205315, -68.1166503),
    zoom: 13.000,
  );

  // static const CameraPosition _kpet = CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(-16.5197865, -68.1101769),
  //     tilt: 59.440717697143555,
  //     zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
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
                              .collection('cidar_pets')
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
                            nombreMascota = mascotaSnapshot.data!['nombre'];
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
                                  subtitle: Text('$nombreMascota'),
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
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        elevation: 0,
        title: Image.asset('assets/logo.png', width: 220),
        actions: [
          IconButton(
            icon: Icon(
              Icons.person,
              color: Color(0xFFFF8820),
            ),
            onPressed: () {
              showUserDataBottomSheet(widget.userID);
            },
          ),
          const SizedBox(
            width: 30,
          ),
          IconButton(
            icon: Icon(
              Icons.pets,
              color: Color(0xFFFF8820),
            ),
            onPressed: () {
              showPetDataBottomSheet(widget.userID);
            },
          ),
          const SizedBox(
            width: 30,
          ),
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Color(0xFFFF8820),
            ),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pop(context);
            },
          ),
        ],
        leadingWidth: 100,
        centerTitle: true,
        //backgroundColor: Color.fromARGB(255, 255, 255, 255)
        backgroundColor: Colors.white,
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        markers: Set<Marker>.of(_markersList),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          if (_currentLocation != null) {
            setState(() {
              _markersList.add(
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
              );
            });
          }
        },
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: 15.0,
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: FloatingActionButton.extended(
            onPressed: _goToThePet,
            label: const Text(
              'Ver Mascotas',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            icon: const Icon(
              Icons.gps_fixed,
              color: Colors.white,
            ),
            backgroundColor: Color(0xFFFF8820),
          ),
        ),
      ),
    );
  }

  // Future<void> _goToThePet() async {
  //   final GoogleMapController controller = await _controller.future;
  //   await controller.animateCamera(CameraUpdate.newCameraPosition(_kpet));
  // }
  Future<void> _goToThePet() async {
    final GoogleMapController controller = await _controller.future;

    // Verificar si se tiene la ubicación de la mascota
    if (petLatitude != null && petLongitude != null) {
      // Animar la cámara hacia la ubicación de la mascota
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(petLatitude!, petLongitude!),
            bearing: 192.8334901395799, // Set bearing value
            tilt: 59.440717697143555, // Set tilt value
            zoom: 19.151926040649414, // Set zoom value
          ),
        ),
      );
    } else {
      // Si no hay ubicación de la mascota, mostrar un mensaje o realizar otra acción
      print('No hay ubicación de la mascota.');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
