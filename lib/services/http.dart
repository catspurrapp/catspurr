import 'package:http/http.dart' as http;
import '/services/storage.dart';

class HTTPService {
  HTTPService();

  static final httpClient = http.Client();

  static Future<http.Response?> get(String url,
      {Map<String, String>? headers}) async {
    return await httpClient.get(Uri.parse(url), headers: headers);
  }

  static Future<http.Response?> post(String url,
      {Map<String, String>? headers, Object? body}) async {
    headers?["Authorization"] = StorageService.token ?? "";
    return await httpClient.post(Uri.parse(url), headers: headers, body: body);
  }

  static Future<http.Response?> put(String url,
      {Map<String, String>? headers, Object? body}) async {
    headers?["Authorization"] = StorageService.token ?? "";
    return await httpClient.put(Uri.parse(url), headers: headers, body: body);
  }

  static Future<http.Response?> patch(String url,
      {Map<String, String>? headers, Object? body}) async {
    headers?["Authorization"] = StorageService.token ?? "";
    return await httpClient.patch(Uri.parse(url), headers: headers, body: body);
  }

  static Future<http.Response?> delete(String url,
      {Map<String, String>? headers, Object? body}) async {
    headers?["Authorization"] = StorageService.token ?? "";
    return await httpClient.delete(Uri.parse(url),
        headers: headers, body: body);
  }
}
