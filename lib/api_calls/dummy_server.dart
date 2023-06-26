import 'package:http/http.dart' as http;

void fetchUsers() async {
  const url = 'http://192.168.100.45:65000/users';

  try {
    final response = await http.post(Uri.parse(url));

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
