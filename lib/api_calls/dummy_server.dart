import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

void fetchUsers() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser;
  
  if (currentUser != null) {
    final userId = currentUser.uid;
    final userEmail = currentUser.email;
    
    final usersCollection = firestore.collection('users');
    final userDocument = await usersCollection.doc(currentUser.uid).get();
    final userPhoneNumber = userDocument.get('phone');
    
    print('User phone number: $userPhoneNumber');
    
    const url = 'http://192.168.100.45:65201/messages';

    try {
      LocationPermission permission = await Geolocator.requestPermission();
      
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        print('Location permission denied.');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      double latitude = position.latitude;
      double longitude = position.longitude;
      
      print('Latitude: ${latitude.toString()}');
      print('Longitude: ${longitude.toString()}');

      final body = {
        'id': userId,
        'email':userEmail,
        'phoneNumber': userPhoneNumber,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
      };

      final response = await http.post(Uri.parse(url), body: body);

      if (response.statusCode == 200) {
        final responseData = response.body;
        print('Response: $responseData');
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  } else {
    print('No current user logged in.');
  }
}
