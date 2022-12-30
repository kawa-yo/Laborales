import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/repository/preferences.dart';
import 'package:laborales/root/root_view.dart';
import 'package:laborales/themes/theme.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> initialization() async {
  await loadPreferences();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laborales',
      theme: lightTheme,
      home: FutureBuilder(
        future: initialization(),
        builder: (context, snapshot) => !snapshot.hasData &&
                snapshot.connectionState != ConnectionState.done
            ? const Center(child: FlutterLogo(size: 300))
            : const RootView(),
      ),
    );
  }
}
