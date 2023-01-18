import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laborales/launcher/launcher_view.dart';
import 'package:laborales/launcher/launcher_view_model.dart';
import 'package:laborales/repository/preferences.dart';
import 'package:laborales/themes/theme.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  Future<void> initialization(WidgetRef ref) async {
    await loadPreferences();
    await ref.read(launcherProvider).initialize();
    await initializeDateFormatting("ja_JP");
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Laborales',
      theme: lightTheme,
      home: FutureBuilder(
        future: initialization(ref),
        builder: (context, snapshot) => !snapshot.hasData &&
                snapshot.connectionState != ConnectionState.done
            ? const Center(child: FlutterLogo(size: 300))
            : const LauncherView(),
      ),
    );
  }
}
