import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'limiter.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(350, 200),
    minimumSize: Size(350, 200),
    center: true,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(MaterialApp(
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: const MyApp()));
}

class MyApp extends HookWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final limit = useState(getCurrentLimit());

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {
                    limit.value = 60;
                  },
                  child: const Text("60%")),
              TextButton(
                  onPressed: () {
                    limit.value = 80;
                  },
                  child: const Text("80%")),
              TextButton(
                  onPressed: () {
                    limit.value = 100;
                  },
                  child: const Text("100%")),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  child: Icon(
                    Icons.delete,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {
                    resetEverything();
                  }),
              Slider(
                  value: limit.value.roundToDouble(),
                  min: 0,
                  max: 100,
                  onChanged: (v) {
                    limit.value = v.round();
                  }),
              TextButton(
                  child: Text(limit.value.toString() + "%"), onPressed: () {}),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  child: const Text("Set Temporarly"),
                  onPressed: () {
                    setTempLimit(limit.value);
                  }),
              const SizedBox(width: 10),
              TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.red,
                  ),
                  child: const Text("Set Permanently"),
                  onPressed: () {
                    setPermLimit(limit.value);
                  })
            ],
          ),
        ],
      ),
    );
  }
}
