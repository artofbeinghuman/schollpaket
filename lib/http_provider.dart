import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

/// Return a Map with the Schollheim resident's name as keys and the number
/// of packages as value.
Future<Map<String, int>> getParcels() async {
  var client = http.Client();
  // get webpage html
  String document =
      (await client.get('http://10.1.1.1/intern/verwaltung/packchen-pakete'))
          .body;
  // get parcel table from http document
  var table = parse(document)
      .querySelectorAll('table')
      .firstWhere((table) => table.className == 'listing nosort')
      .getElementsByTagName('td')[0]
      .innerHtml;
  var rows = table.split('<br>');
  // remove empty rows
  rows.removeWhere((String r) => r == '');
  // remove dates
  rows.removeWhere(
      (String r) => RegExp(r"([0-9]){2}.([0-9]){2}.([0-9]){4}").hasMatch(r));
  // clean strings
  var names = rows
      .map((String name) =>
          name.replaceAll('&nbsp;', '').replaceAll('</strong>', ''))
      .toList();

  // extract names and parcel counts
  Map<String, int> parcels = {};
  for (String name in names) {
    var count = 1;
    var match = RegExp(r"[0-9]+ x").firstMatch(name);
    if (match != null) {
      name = name.substring(0, match.start - 1);
      count = int.parse(
          match.input.substring(match.start, match.end).replaceAll(' x', ''));
    }
    parcels = {...parcels, name: count};
  }

  return parcels;
}
