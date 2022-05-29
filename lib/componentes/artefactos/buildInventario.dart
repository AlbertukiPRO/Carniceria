import 'package:carniceria/componentes/artefactos/viewInventario.dart';
import 'package:carniceria/providers/CarritoCompras.dart';
import 'package:carniceria/services/models/Cortes.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../services/obtenerCortes.dart';

class BuildInventario extends StatefulWidget {
  const BuildInventario();

  @override
  State<BuildInventario> createState() => _BuildInventarioState();
}

class _BuildInventarioState extends State<BuildInventario> {
  Future<List<Cortes>>? preloadDatos;


  @override
  void initState() {
    super.initState();
    preloadDatos = _getData();
  }

  Future<List<Cortes>> _getData() async {
    return await fetchCortes(http.Client());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        child: FutureBuilder<List<Cortes>>(
      future: preloadDatos,
      builder: (context, snapshot) {
        print("Snapshot: " + snapshot.data.toString());
        return snapshot.connectionState == ConnectionState.done
            ? snapshot.hasData
                ? snapshot.data!.length != 0
                    ? Container(
                        constraints: BoxConstraints(
                          maxHeight: size.height*0.65,
                          minHeight: 50,
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 0),
                        child: ViewInventario(lista:snapshot.data),
                      )
                    : const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text('Sin cortes disponibles'),
                      )
                : Container(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.center,
                    child: const Text('No fue posible cargar los datos'),
                  )
            : const ProgressRing();
      },
    ));
  }
}
