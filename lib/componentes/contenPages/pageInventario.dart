import 'package:carniceria/componentes/artefactos/buildInventario.dart';
import 'package:carniceria/componentes/variables.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';

class PageInventario extends StatefulWidget {
  const PageInventario({Key? key}) : super(key: key);

  @override
  State<PageInventario> createState() => _PageInventarioState();
}

Future<bool> saveCorte(List<String> datosCorte) async {
  var cliente = http.Client();
  var resultado = await cliente.get(Uri.parse(urls[1] +
      "?nombreCorte=" +
      datosCorte[0] +
      "&descripcionCorte=" +
      datosCorte[1] +
      "&precioCorte=" +
      datosCorte[2] +
      "&imgCorte=" +
      datosCorte[3]));

  if (resultado.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

class _PageInventarioState extends State<PageInventario> {
  void Modal(context) {
    List<String> cortes = [];

    final controllerNombre = TextEditingController();
    final controllerDescripcion = TextEditingController();
    final controllerPrecio = TextEditingController();
    final controllerIMG = TextEditingController();

    showDialog(
        context: context,
        builder: (context) {
          return ContentDialog(
            title: const Text('Nuevo Corte'),
            content: Container(
              width: MediaQuery.of(context).size.width*0.5,
              height: MediaQuery.of(context).size.height*0.6,
              child: Column(
                children: [
                  const Text(
                    'Llene el siguiente Formulario',
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  TextBox(
                    controller: controllerNombre,
                    header: 'Nombre Corte',
                    placeholder: 'Escribe aquí',
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextBox(
                    controller: controllerDescripcion,
                    header: 'Descripción Corte',
                    placeholder: 'Escribe aquí',
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextBox(
                    controller: controllerPrecio,
                    header: 'Precio Corte',
                    placeholder: 'Escribe aquí',
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextBox(
                    controller: controllerIMG,
                    header: 'URL imagen corte',
                    placeholder: 'Escribe aquí',
                  ),
                ],
              ),
            ),
            actions: [
              Button(
                child: const Text('Guardar'),
                autofocus: true,
                onPressed: () async {
                  cortes.add(controllerNombre.text);
                  cortes.add(controllerDescripcion.text);
                  cortes.add(controllerPrecio.text);
                  cortes.add(controllerIMG.text);

                  bool res = await saveCorte(cortes);
                  if (res) {
                    Navigator.pop(context);
                  }
                  setState(() {

                  });
                },
              ),
              FilledButton(
                child: const Text('Cancelar'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Inventario",
                style: TextStyle(fontSize: 30),
              ),
              FilledButton(
                child: const Text('Agregar corte'),
                onPressed: () => Modal(context),
              ),
            ],
          ),
        ),
      ),
      content: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Container(
            width: double.infinity,
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children:  [
                Row(children: [Text('ID '),Icon(FluentIcons.number_field,color: Colors.green)],),
                const Text('Imagen'),
                const Text('Nombre Corte'),
                const Text('Description corte'),
                const Text('Operaciones'),
              ],
            ),
          ),
          //TODO: B C Y D
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 25),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  //                   <--- left side
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: BuildInventario(),
          ),
        ],
      ),
    );
  }
}
