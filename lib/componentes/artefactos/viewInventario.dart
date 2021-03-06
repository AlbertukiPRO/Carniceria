import 'dart:ui';

import 'package:carniceria/componentes/variables.dart';
import 'package:carniceria/providers/CarritoCompras.dart';
import 'package:carniceria/services/models/Cortes.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../services/models/ProductoModelo.dart';

class ViewInventario extends StatefulWidget {
  final List<Cortes>? lista;

  ViewInventario({this.lista, Key? key}) : super(key: key);

  @override
  State<ViewInventario> createState() => _ViewInventarioState();
}

class _ViewInventarioState extends State<ViewInventario> {
  bool isView = false;

  bool _checked = false;

  viewToast(context, String sms, String title) {
    showDialog(
        context: context,
        builder: (context) {
          return ContentDialog(
            title: Text(title),
            content: Text(sms),
            actions: [
              FilledButton(
                child: const Text('Cerrar'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  modalUpdate(context, String idCorte, String nombreCorte, String descip,
      String precio, String url) {
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
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.6,
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
                    placeholder: 'Escribe aqu??',
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextBox(
                    controller: controllerDescripcion,
                    header: 'Descripci??n Corte',
                    placeholder: 'Escribe aqu??',
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextBox(
                    controller: controllerPrecio,
                    header: 'Precio Corte',
                    placeholder: 'Escribe aqu??',
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextBox(
                    controller: controllerIMG,
                    header: 'URL imagen corte',
                    placeholder: 'Escribe aqu??',
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
        datosCorte[3] +
        "&idCorte=" +
        datosCorte[4]));

    if (resultado.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  deleteCorte(String idCorte, context) async {
    var cliente = http.Client();

    var resultado = await cliente.get(Uri.parse(urls[3] + "?id=" + idCorte));

    print(resultado.body);
    if (resultado.body == "1") {
      setState(() {
        Provider.of<UserData>(context, listen: false).refresh = true;
      });
    } else {
      viewToast(
          context, 'No pudimos borrar tu corte verifica el error', "Ups !!");
    }
    Phoenix.rebirth(context);
  }

  addProducto(context, idProducto, nombreProducto, precio, urlIMG) {
    Provider.of<UserData>(context, listen: false).addProduc(int.parse(idProducto), nombreProducto, double.parse(precio), urlIMG);
    Provider.of<UserData>(context, listen: false).sumaTotal += double.parse(precio);
    print(Provider.of<UserData>(context, listen: false).sumaTotal.toString()+" + " + precio);
  }

  @override
  Widget build(BuildContext context) {
      return ListView.builder(
        itemCount: widget.lista!.length,
        itemBuilder: (context, int index) {
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
                    OutlinedButton(
                      child: const Text('Agregar'),
                      onPressed: () => addProducto(
                          context,
                          widget.lista![index].idCorte,
                          widget.lista![index].nombreCorte,
                          widget.lista![index].precioCorte,
                          widget.lista![index].imgCorte),
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
                            onPressed: () {
                              deleteCorte(widget.lista![index].idCorte!, context);
                            }),
                        const SizedBox(
                          width: 25,
                        ),
                        FilledButton(
                          child: const Icon(FluentIcons.update_restore,
                              color: Colors.white),
                          onPressed: () {
                            modalUpdate(
                                context,
                                widget.lista![index].idCorte!,
                                widget.lista![index].nombreCorte!,
                                widget.lista![index].descripcionCorte!,
                                widget.lista![index].precioCorte!,
                                widget.lista![index].imgCorte!);
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
