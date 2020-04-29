import 'package:flutter/material.dart';
import 'package:schollpaket/cached_shared_preferences.dart';

import './http_provider.dart';
import './strings.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.title,
      theme: ThemeData(
          primaryColor: Colors.grey[300],
          textTheme: Theme.of(context).textTheme.copyWith(
                body1: Theme.of(context).textTheme.body1.copyWith(fontSize: 16),
                title: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(fontSize: 20, color: Colors.green[600]),
              )),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isInitialising = true;
  CachedSharedPreferences prefs;

  /// Whether the user is currently setting a new name
  bool settingNewName = false;

  /// The controller used to type in a new name
  TextEditingController textEditingController;

  /// Number of packages waiting at the administrations office
  int count = 0;

  /// Show an indicator, that the app is loading
  bool showLoadingIndicator = false;

  // On starting the app, get parcels and setup texteditingcontroller
  @override
  void didChangeDependencies() async {
    if (isInitialising) {
      isLoading();
      prefs = await CachedSharedPreferences.getInstance();

      var name = prefs.getString('name');
      textEditingController =
          TextEditingController(text: name != null ? name : '');
      await loadParcels(name);
      if (name == null) {
        setState(() => settingNewName = true);
      }
      isInitialising = false;
    }
    super.didChangeDependencies();
  }

  Future<void> loadParcels(String name) async {
    isLoading();
    if (name != null) {
      var parcels = await getParcels();
      if (parcels.containsKey(name)) {
        setState(() => count = parcels[name]);
      } else
        setState(() => count = 0);
    }
    isNotLoading();
  }

  void isLoading() {
    setState(() => showLoadingIndicator = true);
  }

  void isNotLoading() {
    setState(() => showLoadingIndicator = false);
  }

  void startEditingName() {
    setState(() => settingNewName = true);
  }

  void doneEditingName() async {
    prefs.setString('name', textEditingController.text);
    setState(() => settingNewName = false);
    await loadParcels(textEditingController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        children: <Widget>[
          Image.asset(
            'assets/logo.png',
            scale: 1.5,
            fit: BoxFit.contain,
          ),
          SizedBox(width: 10),
          Text(Strings.title),
        ],
      )),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return showLoadingIndicator
            ? Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () async =>
                    await loadParcels(prefs.getString('name')),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8),
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: viewportConstraints.maxHeight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          leading: Text(
                            Strings.yourName,
                          ),
                          title: TextField(
                            enabled: settingNewName,
                            controller: textEditingController,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (val) => doneEditingName(),
                            decoration: InputDecoration(
                                hintText: Strings.enterYourName),
                          ),
                          trailing: settingNewName
                              ? IconButton(
                                  icon: Icon(Icons.done),
                                  onPressed: doneEditingName,
                                )
                              : IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: startEditingName,
                                ),
                        ),
                        SizedBox(height: viewportConstraints.maxHeight * 0.19),
                        SizedBox(height: viewportConstraints.maxHeight * 0.19),
                        Text(
                          count > 0
                              ? Strings.parcels(count)
                              : Strings.noParcels,
                          textAlign: TextAlign.center,
                          style: count > 0
                              ? Theme.of(context).textTheme.title
                              : Theme.of(context).textTheme.body1,
                        )
                      ],
                    ),
                  ),
                ),
              );
      }),
    );
  }
}
