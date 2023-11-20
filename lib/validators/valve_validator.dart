import 'dart:convert';
import 'package:http/http.dart' as http;

class ValveValidator {
  Future<bool> validate(String url) async {
    try {
      if (url.isEmpty) return false;
      if (!RegExp(r'^(\d{1,3}\.){3}\d{1,3}$').hasMatch(url)) {
        return false;
      }
      final response = await http.get(Uri.parse("http://$url/check"));
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody["is_valve"]==true) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}