import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class NavigationRai extends StatefulWidget {
  const NavigationRai({super.key});

  @override
  State<NavigationRai> createState() => _NavigationRaiState();
}

class _NavigationRaiState extends State<NavigationRai> {
  List<NavigationRailDestination> destinations = [
    NavigationRailDestination(icon: Icon(Icons.abc), label: Text('data')),
    NavigationRailDestination(
      icon: Icon(Icons.abc), 
      label: Text('data'),
      padding: EdgeInsets.fromLTRB(12, 12, 12, 36)),
    NavigationRailDestination(icon: Icon(Icons.abc), label: Text('data')),
    NavigationRailDestination(icon: Icon(Icons.abc), label: Text('data')),
  ];
  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      leading: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.crop_16_9),
          Icon(Icons.crop_16_9),
        ],
      ),
      backgroundColor: Colors.grey.shade200,
      extended: true,
      destinations: destinations, 
      selectedIndex: 0,);
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRai()
        ],
      ),
      
    );
  }
}