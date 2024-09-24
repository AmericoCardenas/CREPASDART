import 'package:app_crepas/clases/cusuario.dart';
import 'package:app_crepas/menu.dart';
import 'package:app_crepas/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MissCrepas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'MissCrepas'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final usuarioController = TextEditingController();
  final passwordController = TextEditingController();
  Future<List<Usuario>>? usuario;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            clipBehavior: Clip.antiAlias,
            width: 120,
            height: 120,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Image.network(
              'https://i.pinimg.com/originals/82/2c/cb/822ccb274ea38dcd3d81d3e861828b51.png',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: usuarioController,
                    obscureText: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Usuario',
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Contraseña',
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 35),
          FilledButton(
            onPressed: () {
              login(usuarioController.text, passwordController.text).then(
                  (list) {
                if (list.isEmpty) {
                  showDialog(
                      context: context,
                      builder: (ctx) => const AlertDialog(
                            title: Text('Aviso'),
                            content: Text('Usuario o Contraseña incorrecta'),
                          ));
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyMenuNav(usuario: list),
                    ),
                  );
                }
              }, onError: (error, stackTrace) {
                const AlertDialog(
                  title: Text('Aviso'),
                  content: Text('Usuario o Contraseña incorrecta'),
                );
              });
            },
            child: const Text('Iniciar Sesión'),
          )
        ],
      ),
    );
  }
}
