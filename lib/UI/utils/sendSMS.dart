// lib/utils/sms_util.dart
import 'package:another_telephony/telephony.dart';
// import 'package:permission_handler/permission_handler.dart';

// Future<void> requestPermissions() async {
//   var status = await Permission.sms.status;
//   if (status.isDenied) {
//     await Permission.sms.request();
//   }
// }

class SmsUtil {
  static Future<void> sendSms(String to, String message) async {
    Telephony telephony = Telephony.instance;

    try {
      // requestPermissions();
      await telephony.sendSmsByDefaultApp(
        to: to,
        message: message,
      );
      print('SMS enviado con éxito');
    } catch (e) {
      print('Error al enviar SMS: $e');
    }
  }
}
