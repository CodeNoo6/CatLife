import 'package:catage/Modelo/Gato.dart';
import 'package:catage/Modelo/GatoxPropietario.dart';
import 'package:catage/Modelo/Propietario.dart';
import 'package:catage/NewApp/MenuPage.dart';
import 'package:catage/pets/pet_widget.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import '../Database/Database.dart';
import '../Registro.dart';
import '../View_home.dart';
import '../age_human.dart';

class Principal extends StatefulWidget {
  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  List<GatoxPropietario> gatosxPropietarios = new List();
  bool _loading = false;

  void _onLoading() {
    setState(() {
      _loading = true;
      new Future.delayed(new Duration(seconds: 2), _login);
    });
  }

  Future _login() async {
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.grey,
          cardColor: Colors.white,
          appBarTheme: AppBarTheme(
            color: HexColor("08CAF7"),
            centerTitle: true,
          ),
          bottomAppBarColor: HexColor("08CAF7"),
        ),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Color.fromARGB(255, 230, 244, 253),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.grey[900],
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => MenuPage()),
                );
              },
            ),
            title: Text(
              'Amigos Peludos',
              style: GoogleFonts.aBeeZee(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),
            ),
            automaticallyImplyLeading:
                false, // Desactiva la flecha de devolución
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => Registro(),
                ),
              );
            },
            icon: Icon(Icons.pets),
            backgroundColor: HexColor("EC6337"), // Color del botón
            label: Text("Nuevo Felino"),
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.0,
                ),
                _loading
                    ? Text("")
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 0, 2, 60),
                            child: CircleAvatar(
                              backgroundColor: Colors.white70,
                              radius: 35,
                              child: CircleAvatar(
                                radius: 30,
                                child: CircleAvatar(
                                  backgroundImage:
                                      AssetImage('images/logo.png'),
                                  radius: 30,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 250,
                            padding: EdgeInsets.all(3),
                            child: Column(
                              children: [
                                BubbleSpecialOne(
                                  text:
                                      'Dentro de cada amigo peludo hay un carné de vacunación digital',
                                  isSender: false,
                                  color: HexColor("08CAF7"),
                                  textStyle: GoogleFonts.aBeeZee(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                _loading
                    ? Container(
                        child: new Stack(
                          children: <Widget>[
                            new Container(
                              alignment: AlignmentDirectional.center,
                              decoration: new BoxDecoration(
                                color: Color.fromARGB(255, 230, 244, 253),
                              ),
                              child: new Container(
                                decoration: new BoxDecoration(
                                    color: Color.fromARGB(255, 230, 244, 253),
                                    borderRadius:
                                        new BorderRadius.circular(10.0)),
                                width: 300.0,
                                height: 200.0,
                                alignment: AlignmentDirectional.center,
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Center(
                                      child: new SizedBox(
                                        height: 50.0,
                                        width: 50.0,
                                        child: new CircularProgressIndicator(
                                          color: HexColor("08CAF7"),
                                          value: null,
                                          strokeWidth: 7.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        height: 280,
                        child: ListView(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          children: buildNewestPet(),
                        ),
                      ),
                /*Container(
                  height: 130,
                  margin: EdgeInsets.only(bottom: 16),
                  child: PageView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      buildVet(
                          "", "Animal Emergency Hospital", "(369) 133-8956"),
                      buildVet(
                          "", "Artemis Veterinary Center", "(706) 722-9159"),
                      buildVet("", "Big Lake Vet Hospital", "(598) 4986-9532"),
                      buildVet(
                          "", "Veterinary Medical Center", "(33) 8974-559-555"),
                    ],
                  ),
                ),*/
              ],
            ),
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Map<String, dynamic> data;

  void getData() async {
    _onLoading();
    data = (await Database.obtenerFelinos());
    setState(() {});
  }

  List<Widget> buildNewestPet() {
    Propietario objPropietario = new Propietario();
    objPropietario.foto = data['propietario']['Foto'];
    objPropietario.nombreApellido = data['propietario']['NombreApellido'];
    objPropietario.celular = data['propietario']['Celular'];
    objPropietario.direccion = data['propietario']['Direccion'];
    for (var felino in data['felinos']) {
      Gato objGato = new Gato();
      GatoxPropietario objGatoxPropietario = new GatoxPropietario();
      objGato.foto = felino['Foto'];
      objGato.nombre = felino['Nombre'];
      objGato.especie = felino['Especie'];
      objGato.fechaNacimiento = felino['FechaNacimiento'];
      objGato.raza = felino['Raza'];
      objGato.color = felino['Color'];
      objGato.genero = felino['Genero'];
      objGato.microchip = felino['Microchip'];
      objGato.peso = felino['Peso'];
      objGato.esterilizado = felino['Esterilizado'];
      objGato.edadMeses = felino['EdadMeses'];
      objGato.felinoId = felino['FelinoId'];
      objGatoxPropietario.objGato = objGato;
      objGatoxPropietario.objPropietario = objPropietario;
      gatosxPropietarios.add(objGatoxPropietario);
    }
    List<Widget> list = [];
    for (var i = 0; i < gatosxPropietarios.length; i++) {
      list.add(PetWidget(
        pet: gatosxPropietarios[i].objGato,
        index: i,
        objPropietario: gatosxPropietarios[i].objPropietario,
      ));
    }
    return list;
  }

  Widget buildVet(String imageUrl, String name, String phone) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 4),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
        border: Border.all(
          width: 1,
          color: Colors.grey[300],
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 98,
            width: 98,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imageUrl),
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Icon(
                    Icons.phone,
                    color: Colors.grey[800],
                    size: 18,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    phone,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  "OPEN - 24/7",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
