import 'package:http/http.dart' as http;
const  String serverUrl = 'http://localhost:65000/users';

void makeVoiceCall() async {
  try {
    // Create the request body
    Map<String, dynamic> requestBody = {
      'phoneNumber': '+1234567890', // Replace with the phone number to call
    };

    // Make the POST request
    final response = await http.post(
      Uri.parse(serverUrl),
      body: requestBody,
    );

    if (response.statusCode == 200) {
      // Request succeeded
      print('Voice call initiated successfully');
    } else {
      // Request failed
      print('Failed to initiate voice call');
    }
  } catch (error) {
    // Handle any exceptions or errors
    print('Error: $error');
  }
}