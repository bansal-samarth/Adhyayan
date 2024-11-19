import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> fetchData() async {
  const apiUrl = "https://mtqlvltkr5.execute-api.us-east-1.amazonaws.com/timetflambda";
  final queryParams = {"ClassDay": "Friday", "Class_ID":"KV_8"}; // Pass query params if needed
  final uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);

  try {
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Data from DynamoDB: $data");
    } else {
      print("Error: ${response.statusCode}");
    }
  } catch (e) {
    print("Failed to fetch data: $e");
  }
}

void main(List<String> args) {
  fetchData();
}