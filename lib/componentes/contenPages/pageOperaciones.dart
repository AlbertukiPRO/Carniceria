import 'package:fluent_ui/fluent_ui.dart';

class PageOperaciones extends StatefulWidget {
  const PageOperaciones({Key? key}) : super(key: key);

  @override
  State<PageOperaciones> createState() => _PageOperacionesState();
}

class _PageOperacionesState extends State<PageOperaciones> {
  @override
  Widget build(BuildContext context) {
    return  const ScaffoldPage(
      header: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Text(
          "Operaciones",
          style: TextStyle(fontSize: 30),
        ),
      ),
      content: Center(),
    );
  }
}
