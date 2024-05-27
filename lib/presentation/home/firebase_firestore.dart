import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFirestoreController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  sendDataToFIrestore(Map<String, dynamic> dataJson) async {
    CollectionReference test = FirebaseFirestore.instance.collection('yanapa');
    await test
        .doc(DateTime.now().microsecondsSinceEpoch.toString())
        .set(dataJson)
        .then((value) => print("_______data subida correctamente"))
        .catchError((error) => print("_________Failed to add data: $error"))
        .timeout(
      Duration(seconds: 5),
      onTimeout: () {
        print(' ____timeOut');
      },
    );
  }
}
