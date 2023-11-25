import 'package:http/http.dart' as http;

class ValveStatusRequest {
  void get(String url, bool state) async {
    await http.get(Uri.parse("http://$url/relay?state=${state ? 'on' : 'off'}"));
  }
}