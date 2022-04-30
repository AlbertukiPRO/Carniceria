import 'dart:ui';

import 'package:carniceria/componentes/contenPages/pageInventario.dart';
import 'package:carniceria/componentes/variables.dart';
import 'package:carniceria/services/models/Cortes.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:http/http.dart' as http;
import 'package:image_cacheing/image_cacheing.dart';

class ViewInventario extends StatefulWidget {
  final List<Cortes>? lista;
  ViewInventario({this.lista, Key? key}) : super(key: key);

  @override
  State<ViewInventario> createState() => _ViewInventarioState();
}

class _ViewInventarioState extends State<ViewInventario> {
  bool isView = false;

  bool _checked = false;

  viewToast(context) {
    showDialog(
        context: context,
        builder: (context) {
          return ContentDialog(
            title: const Text('Upps !!'),
            content: const Text('No pudimos borrar tu corte verifica el error'),
            actions: [
              FilledButton(
                child: const Text('Cerrar'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  modalUpdate(context, String idCorte, String nombreCorte, String descip, String precio, String url){

    List<String> cortes = [];

    final controllerNombre = TextEditingController();
    final controllerDescripcion = TextEditingController();
    final controllerPrecio = TextEditingController();
    final controllerIMG = TextEditingController();

    controllerNombre.text = nombreCorte;
    controllerIMG.text = url;
    controllerPrecio.text = precio;
    controllerDescripcion.text = descip;

    showDialog(
        context: context,
        builder: (context) {
          return ContentDialog(
            title: const Text('Modifica los datos necesarios'),
            content: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.5,
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.6,
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
                  cortes.add(idCorte);

                  bool res = await updateCorte(cortes);
                  if (res) {
                    Navigator.pop(context);
                  }
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

  updateCorte(List<String> datosCorte) async {
    var cliente = http.Client();
    var resultado = await cliente.get(Uri.parse(urls[2] +
        "?nombreCorte=" +
        datosCorte[0] +
        "&descripcionCorte=" +
        datosCorte[1] +
        "&precioCorte=" +
        datosCorte[2] +
        "&imgCorte=" +
        datosCorte[3] + "&idCorte="+datosCorte[4]));

    if (resultado.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  deleteCorte(String idCorte) async {
    var cliente = http.Client();

    var resultado = await cliente.get(Uri.parse(
        urls[3] +
            "?id=" +idCorte));

    print(resultado.body);
    if (resultado.body == "1") {
      setState(() {
      });
    } else {
      viewToast(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.lista!.length,
        itemBuilder: (context, int index) {
          int id = int.parse(widget.lista![index].idCorte!);
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              border: Border.all(color: Colors.grey.withOpacity(0.1)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '#${widget.lista![index].idCorte!}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ClipRRect(
                      child: Image.network(
                        "${widget.lista![index].imgCorte}",
                        width: 80,
                        height: 80,
                        scale: 1,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          widget.lista![index].nombreCorte!,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        Text(widget.lista![index].descripcionCorte!,
                            style: const TextStyle(fontSize: 15)),
                      ],
                    ),
                    Text(
                      '\$ ${widget.lista![index].precioCorte!}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.teal),
                    ),
                    Row(
                      children: [
                        FilledButton(
                          child: const Icon(
                            FluentIcons.delete,
                            color: Colors.white,
                          ),
                          onPressed: ()  {
                            deleteCorte(widget.lista![index].idCorte!);
                          }
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        FilledButton(
                          child: const Icon(FluentIcons.update_restore,
                              color: Colors.white),
                          onPressed: () {
                            modalUpdate(context, widget.lista![index].idCorte!, widget.lista![index].nombreCorte!, widget.lista![index].descripcionCorte!, widget.lista![index].precioCorte!, widget.lista![index].imgCorte!);
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }
}
