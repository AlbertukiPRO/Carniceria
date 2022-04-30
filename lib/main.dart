import 'package:fluent_ui/fluent_ui.dart';
import 'componentes/contenPages/pageInventario.dart';
import 'componentes/contenPages/pageOperaciones.dart';

void main() => runApp(MyApp());

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

  @override
  Widget build(BuildContext context) {
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
                icon: const Icon(FluentIcons.table), title: const Text("Inventario")),
            PaneItem(icon: const Icon(FluentIcons.edit), title: const Text("Operaciones"))
          ],
        ),
        content: NavigationBody(
          index: index,
          children: const [
            PageInventario(),
            PageOperaciones(),
          ],
        ),
      ),
    );
  }
}
