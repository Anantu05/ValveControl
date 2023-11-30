import 'dart:convert';
import 'package:http/http.dart' as http;

class ValveValidator {
  Future<int> validate(String url) async {
    try {
      if (url.isEmpty) return 3;
      if (!RegExp(r'^(\d{1,3}\.){3}\d{1,3}$').hasMatch(url)) {
        return 4;
      }
      final response = await http.get(Uri.parse("http://$url/check"));
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody["is_valve"]==true) {
          return 0;
        } else {
          return 1;
        }
      } else {
        return 2;
      }
    } catch (e) {
      print(e);
      return 5;
    }
  }
}