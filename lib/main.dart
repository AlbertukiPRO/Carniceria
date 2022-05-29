import 'package:carniceria/providers/CarritoCompras.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'componentes/contenPages/pageCarrito.dart';
import 'componentes/contenPages/pageInventario.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:http/http.dart' as http;

void main() => runApp(
      Phoenix(
        child: MultiProvider(providers: [
          ChangeNotifierProvider(
            create: (_) => UserData(),
          ),
        ], child: MyApp()),
      ),
    );

class MyApp extends StatelessWidget {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return const FluenteApp();
  }
}

class FluenteApp extends StatefulWidget {
  const FluenteApp({Key? key}) : super(key: key);

  @override
  State<FluenteApp> createState() => _FluenteAppState();
}

class _FluenteAppState extends State<FluenteApp> {
  int index = 0;
  double saldo = 0;

  void getSaldoCliente(context) async {
    var response = await http.get(Uri.parse(
        "http://localhost/Carniceria/apis/getSaldoCliente.php?idUser=1"));
    Provider.of<UserData>(context, listen: false).saldo =
        double.parse(response.body);
  }

  @override
  Widget build(BuildContext context) {
    getSaldoCliente(context);

    return FluentApp(
      title: 'Carnicería Betos ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white.withOpacity(0.5),
          accentColor: Colors.blue,
          iconTheme: const IconThemeData(size: 24)),
      darkTheme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          accentColor: Colors.blue,
          iconTheme: const IconThemeData(size: 24)),
      home: NavigationView(
        appBar: const NavigationAppBar(title: Text("CRUD Carnicería")),
        pane: NavigationPane(
          onChanged: (newIndex) {
            setState(() {
              index = newIndex;
            });
          },
          displayMode: PaneDisplayMode.compact,
          selected: index,
          items: [
            PaneItem(
              icon: const Icon(FluentIcons.table),
              title: const Text("Inventario"),
            ),
            PaneItem(
              icon: const Icon(FluentIcons.shopping_cart),
              title: const Text("Carrito"),
              infoBadge: InfoBadge(
                source: Text(Provider.of<UserData>(context)
                    .cantidadProductos
                    .toString()),
              ),
            )
          ],
        ),
        content: NavigationBody(
          index: index,
          children: const [
            PageInventario(),
            CarritoCompras(),
          ],
        ),
      ),
    );
  }
}
