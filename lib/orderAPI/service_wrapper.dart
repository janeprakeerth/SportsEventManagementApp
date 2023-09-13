import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../Helper/apis.dart';

class servicewrapper {
  call_order_api(String amount) async {
    dynamic jsonresponse = "[]";
    final body = {'amount': amount};

    // without header
    final response = await http.post(rzpPaymentApi, body: body);

    print(" get response done " + response.body.toString());
    try {
      jsonresponse = json.decode(response.body.toString());
    } catch (error) {
      print(" get-categrrory error " + error.toString());
    }
    return jsonresponse;
  }
}
