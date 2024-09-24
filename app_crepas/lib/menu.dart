import 'package:app_crepas/clases/cusuario.dart';
import 'package:app_crepas/services/firebase_service.dart';
import 'package:flutter/material.dart';

/// Flutter code sample for [NavigationBar].

class MyMenuNav extends StatelessWidget {
  final List<Usuario> usuario;

  const MyMenuNav({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: NavigationExample(us: usuario),
    );
  }
}

String producto = '';
double costo = 0;

class NavigationExample extends StatefulWidget {
  final List<Usuario>? us;
  final nombreprodcontroller = TextEditingController();
  final costoprodcontroller = TextEditingController();
  final docidprodcontroller = TextEditingController();

  NavigationExample({super.key, this.us});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();

  Widget widgetusuario() {
    return ListView.builder(
      itemCount: us?.length,
      itemBuilder: (context, index) {
        return Card(
          // Con esta propiedad modificamos la forma de nuestro card
          // Aqui utilizo RoundedRectangleBorder para proporcionarle esquinas circulares al Card
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

          // Con esta propiedad agregamos margen a nuestro Card
          // El margen es la separación entre widgets o entre los bordes del widget padre e hijo
          margin: const EdgeInsets.all(15),

          // Con esta propiedad agregamos elevación a nuestro card
          // La sombra que tiene el Card aumentará
          elevation: 10,

          // La propiedad child anida un widget en su interior
          // Usamos columna para ordenar un ListTile y una fila con botones
          child: Column(
            children: <Widget>[
              // Usamos ListTile para ordenar la información del card como titulo, subtitulo e icono
              ListTile(
                contentPadding: const EdgeInsets.fromLTRB(15, 10, 25, 0),
                title: const Text('Perfil de Usuario'),
                subtitle: Text(
                    'Nombre: ${us?[index].nombre} ${us?[index].apellidop} ${us?[index].apellidom} \nUsuario: ${us?[index].usuario} \nContraseña: ${us?[index].password}',
                    style: const TextStyle(fontSize: 18)),
                leading: const Icon(Icons.person),
              ),

              // Usamos una fila para ordenar los botones del card
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  // FlatButton(onPressed: () => {}, child: Text('Aceptar')),
                  // FlatButton(onPressed: () => {}, child: Text('Cancelar'))
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget widgetbar() {
    bool isDark = false;

    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   mainAxisSize: MainAxisSize.min,
    //   children: <Widget>[
    return SearchAnchor(
        builder: (BuildContext context, SearchController controller) {
      return SearchBar(
        controller: controller,
        // padding: const MaterialStatePropertyAll<EdgeInsets>(
        //     EdgeInsets.symmetric(horizontal: 8.0)),
        onTap: () {
          controller.openView();
        },
        onChanged: (_) {
          controller.openView();
        },
        leading: const Icon(Icons.search),
        trailing: <Widget>[
          Tooltip(
            message: 'Change brightness mode',
            child: IconButton(
              isSelected: isDark,
              onPressed: () {
                isDark = !isDark;
              },
              icon: const Icon(Icons.wb_sunny_outlined),
              selectedIcon: const Icon(Icons.brightness_2_outlined),
            ),
          )
        ],
      );
    }, suggestionsBuilder: (BuildContext context, SearchController controller) {
      return List<ListTile>.generate(5, (int index) {
        final String item = 'item $index';
        return ListTile(
          title: Text(item),
          onTap: () {
            controller.closeView(item);
          },
        );
      });
    });
    //   ],
    // );
  }

  Widget widgetlist() {
    BuildContext? bcontext;

    return FutureBuilder(
      future: getProductos(),
      builder: (context, snap) {
        return ListView.separated(
            separatorBuilder: (context, index) => const Divider(
                  color: Colors.black,
                ),
            itemCount: snap.data!.length,
            itemBuilder: (context, index) {
              return ListTile(
                  title: const Text(''),
                  subtitle: Text(
                      'Document ID:${snap.data?[index].documentId} \nProducto: ${snap.data?[index].nombre} \nCosto: ${snap.data?[index].costo}',
                      style: const TextStyle(fontSize: 18)),
                  leading: const Icon(Icons.flood_outlined),
                  trailing: PopupMenuButton(
                    icon: const Icon(Icons.more_vert),
                    tooltip: 'Mas',
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: snap.data?[index].documentId,
                        onTap: () {
                          nombreprodcontroller.text =
                              '${snap.data?[index].nombre}';
                          costoprodcontroller.text =
                              '${snap.data?[index].costo}';
                          docidprodcontroller.text =
                              '${snap.data?[index].documentId}';
                          showDialog(
                              context: context,
                              builder: (context) {
                                bcontext = context;
                                return AlertDialog(
                                  title: const Text('Editar'),
                                  content: widgetaddprod(),
                                  actions: [
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .labelLarge,
                                      ),
                                      child: const Text('Cancelar'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        docidprodcontroller.text = '';
                                        costoprodcontroller.text = '';
                                        nombreprodcontroller.text = '';
                                      },
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .labelLarge,
                                      ),
                                      child: const Text('Aceptar'),
                                      onPressed: () {
                                        updateProducto(
                                                nombreprodcontroller.text,
                                                double.tryParse(
                                                    costoprodcontroller.text),
                                                docidprodcontroller.text)
                                            .then((value) {
                                          showDialog(
                                              context: context,
                                              builder: (builder) {
                                                Future.delayed(
                                                    const Duration(seconds: 3),
                                                    () {
                                                  dismiss(bcontext);
                                                  docidprodcontroller.text='';
                                                  nombreprodcontroller.text =
                                                      '';
                                                  costoprodcontroller.text = '';
                                                  dismiss(bcontext);
                                                });
                                                return AlertDialog(
                                                  title: const Text('Aviso'),
                                                  content: Text(value),
                                                );
                                              });
                                        });
                                      },
                                    )
                                  ],
                                );
                              });
                        },
                        // row has two child icon and text.
                        child: const Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(
                              // sized box with width 10
                              width: 10,
                            ),
                            Text("Editar")
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: snap.data?[index].documentId,
                        // onTap: () {

                        // },
                        // row has two child icon and text.
                        child: const Row(
                          children: [
                            Icon(Icons.delete),
                            SizedBox(
                              // sized box with width 10
                              width: 10,
                            ),
                            Text("Eliminar")
                          ],
                        ),
                      )
                    ],
                  ));
            });
      },
    );
  }

  Widget widgetaddprod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextField(
          controller: docidprodcontroller,
          obscureText: false,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            enabled: false,
            labelText: 'DocId',
          ),
        ),
        TextField(
          controller: nombreprodcontroller,
          obscureText: false,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'Nombre',
          ),
        ),
        TextField(
          controller: costoprodcontroller,
          obscureText: false,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'Costo',
          ),
        ),
      ],
    );
  }

  String retnomprod() {
    final text = nombreprodcontroller.text;
    return text;
  }

  double retcostoprod() {
    final costo = double.parse(costoprodcontroller.text);
    return costo;
  }

  dismiss(BuildContext? context) {
    if (context != null) {
      Navigator.pop(context);
    }
  }
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;
  BuildContext? dcontext;

  dismissDailog() {
    if (dcontext != null) {
      Navigator.pop(dcontext!);
    }
  }

  AlertDialog verificarDatosProd() {
    if (widget.nombreprodcontroller.text == '') {
      return const AlertDialog(
        title: Text('Aviso'),
        content: Text('El producto debe contener un nombre'),
      );
    } else if (double.tryParse(widget.costoprodcontroller.text) == null) {
      return const AlertDialog(
        title: Text('Aviso'),
        content: Text('el costo ingresado es incorrecto'),
      );
    } else if (widget.costoprodcontroller.text == '') {
      return const AlertDialog(
        title: Text('Aviso'),
        content: Text('el producto debe contener un costo'),
      );
    } else {
      return const AlertDialog(
        title: Text(''),
        content: Text(''),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme =
        ThemeData(useMaterial3: true, brightness: Brightness.dark);

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.food_bank)),
            label: 'Productos',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text('2'),
              child: Icon(Icons.messenger_sharp),
            ),
            label: 'Messages',
          ),
        ],
      ),
      body: <Widget>[
        /// Home page
        Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: Center(child: widget.widgetusuario()),
          ),
        ),

        /// Notifications page
        Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              widget.widgetbar(),
              Expanded(child: widget.widgetlist()),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            elevation: 50,
            tooltip: 'Agregar',
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            mini: false,
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  dcontext = context;
                  return AlertDialog(
                    title: const Text('Agregar'),
                    content: widget.widgetaddprod(),
                    actions: <Widget>[
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                        ),
                        child: const Text('Cancelar'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          widget.costoprodcontroller.text = '';
                          widget.nombreprodcontroller.text = '';
                        },
                      ),
                      TextButton(
                          style: TextButton.styleFrom(
                            textStyle: Theme.of(context).textTheme.labelLarge,
                          ),
                          child: const Text('Aceptar'),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (ctx) {
                                  return verificarDatosProd();
                                });

                            postProducto(
                                    widget.retnomprod(), widget.retcostoprod())
                                .then((value) {
                              showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    Future.delayed(const Duration(seconds: 3),
                                        () {
                                      Navigator.of(context).pop();
                                      setState(() {});
                                      dismissDailog();
                                      widget.nombreprodcontroller.text = '';
                                      widget.costoprodcontroller.text = '';
                                      dismissDailog();
                                    });

                                    return AlertDialog(
                                      title: const Text('Aviso'),
                                      content: Text(value),
                                    );
                                  });
                            });
                          })
                    ],
                  );
                },
              );
            },
            child: const Icon(Icons.add),
          ),
        ),

        /// Messages page
        ListView.builder(
          reverse: true,
          itemCount: 2,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    'Hello',
                    style: theme.textTheme.bodyLarge!
                        .copyWith(color: theme.colorScheme.onPrimary),
                  ),
                ),
              );
            }
            return Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  'Hi!',
                  style: theme.textTheme.bodyLarge!
                      .copyWith(color: theme.colorScheme.onPrimary),
                ),
              ),
            );
          },
        ),
      ][currentPageIndex],
    );
  }
}
