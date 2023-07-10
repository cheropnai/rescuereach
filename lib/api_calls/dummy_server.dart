import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

void fetchUsers() async {
  const url = 'http://192.168.100.45:65201/messages';

  try {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // Handle permission denied
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    double latitude = position.latitude;
    double longitude = position.longitude;

    final body = {
      'name': 'Cherop',
      'phoneNumber': '+700',
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
    };

    final response = await http.post(Uri.parse(url), body: body);

    if (response.statusCode == 200) {
      // Request successful, process the response data
      final responseData = response.body;
      print(responseData.toString());
    } else {
      // Request failed with an error status code
      print('Request failed with status: ${response.statusCode}');
    }
  } catch (e) {
    // Error occurred during the request
    print('Error: $e');
  }
}
