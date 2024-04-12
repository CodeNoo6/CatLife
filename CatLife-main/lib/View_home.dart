import 'dart:io';
import 'package:catage/Database/Database.dart';
import 'package:catage/Header.dart';
import 'package:catage/Registro.dart';
import 'package:catage/age.dart';
import 'package:catage/age_human.dart';
import 'package:catage/generated/l10n.dart';
import 'package:catage/pets/principal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Authenticator/Authenticator.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        S.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.grey,
        cardColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: HexColor("08CAF7"),
          centerTitle: true,
        ),
        bottomAppBarColor: HexColor("08CAF7"),
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: Colors.yellow[800]),
      ),
      home: HomeP(),
    );
  }
}

class HomeP extends StatefulWidget {
  @override
  _HomePState createState() => _HomePState();
}

const String testDevice = 'YOUR_DEVICE_ID';
const int maxFailedLoadAttempts = 3;

class _HomePState extends State<HomeP> {
  int currentSelectedItem = 0;
  int items = 3;
  bool _loading = false;

  void _onLoading() {
    setState(() {
      _loading = true;
      new Future.delayed(new Duration(seconds: 10), _login);
    });
  }

  Future _login() async {
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  var data;

  void getData() async {
    data = (await Database.validaRegistro());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Scaffold(
            body: Container(
              child: new Stack(
                children: <Widget>[
                  new Container(
                    alignment: AlignmentDirectional.center,
                    decoration: new BoxDecoration(
                      color: Colors.white70,
                    ),
                    child: new Container(
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.circular(10.0)),
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
                                color: Colors.lightGreen,
                                value: null,
                                strokeWidth: 7.0,
                              ),
                            ),
                          ),
                          new Container(
                            margin: const EdgeInsets.only(top: 25.0),
                            child: new Center(
                              child: new Text(
                                "Cargando... por favor espera",
                                style: new TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: Colors.grey,
              cardColor: Colors.white,
              appBarTheme: AppBarTheme(
                color: HexColor("08CAF7"),
                centerTitle: true,
              ),
              bottomAppBarColor: HexColor("08CAF7"),
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                  backgroundColor: Colors.yellow[800]),
            ),
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              S.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            home: Builder(builder: (BuildContext context) {
              return Scaffold(
                body: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      title: Text(
                        "Cat Life",
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      //leading: IconButton(icon: Icon(Icons.menu), onPressed: () {}),
                      actions: [
                        IconButton(
                          icon: Icon(
                            Icons.logout,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            exit(0);
                          },
                        )
                      ],
                    ),
                    Header(),
                    SliverToBoxAdapter(
                      child: Container(
                        height: 5.0.h,
                        margin: EdgeInsets.only(
                          left: 20.sp,
                        ),
                        child: Container(
                          width: 90.w,
                          height: 90.h,
                          child: Text(
                            S.of(context).home_text_fourtytwo,
                            style: GoogleFonts.aBeeZee(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 18.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    /*SliverToBoxAdapter(
            child: Container(
              height: 500,
              margin: EdgeInsets.only(
                left: 20,
                right: 0,
              ),
              child: Container(
                width: 90,
                height: 90,
                child: Flexible(
                  child: new FirebaseAnimatedList(
                      query: _ref,
                      itemBuilder: (BuildContext context, DataSnapshot snapshot,
                          Animation<double> animation, int index) {
                        return new ListTile(
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _ref.child(snapshot.key).remove(),
                          ),
                          title:
                              new Text(ubicacion = snapshot.value['latitude']),
                        );
                      }),
                ),
              ),
            ),
          ),*/
                    SliverToBoxAdapter(
                      child: Container(
                        height: 100,
                        margin: EdgeInsets.only(top: 10),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: items,
                          itemBuilder: (context, index) => Stack(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    height: 90,
                                    width: 90,
                                    margin: EdgeInsets.only(
                                      left: 7.w,
                                      //left: queryData.size.width / 5.5,
                                      right: 0,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          currentSelectedItem = index;
                                          if (index == 0) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        Age(),
                                              ),
                                            );
                                          }
                                          if (index == 1) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        Age_Human(),
                                              ),
                                            );
                                          }
                                          if (index == 2) {
                                            if (data['Felinos'] == null) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          Registro(),
                                                ),
                                              );
                                            } else {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        Principal(),
                                                  ));
                                            }
                                          }
                                          if (index == 3) {}
                                        });
                                      },
                                      child: Card(
                                        color: index == currentSelectedItem
                                            ? Colors.yellow[800]
                                            : Colors.white,
                                        child: Icon(
                                          index == 0
                                              ? Icons.pets
                                              : index == 1
                                                  ? Icons.person
                                                  : index == 2
                                                      ? Icons
                                                          .medical_information_outlined
                                                      : index == 3
                                                          ? Icons
                                                              .connect_without_contact
                                                          : Icons.cancel,
                                          color: index == currentSelectedItem
                                              ? Colors.white
                                              : Colors.black.withOpacity(0.7),
                                        ),
                                        elevation: 3,
                                        margin: EdgeInsets.all(10),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  margin: EdgeInsets.only(
                                    left: 7.w,
                                    right: 0,
                                  ),
                                  width: 90,
                                  child: Row(
                                    children: [
                                      Spacer(),
                                      Text(
                                        index == 0
                                            ? S
                                                .of(context)
                                                .home_text_fourtythree
                                            : index == 1
                                                ? S
                                                    .of(context)
                                                    .home_text_fourtyfour
                                                : index == 2
                                                    ? "Salud"
                                                    : index == 3
                                                        ? "Reportar"
                                                        : "",
                                        style: GoogleFonts.aBeeZee(
                                          textStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15.sp,
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    /*SliverToBoxAdapter(
            child: Container(
              height: 25,
              margin: EdgeInsets.only(
                left: 20,
                right: 0,
              ),
              child: Container(
                width: 90,
                height: 90,
                child: Text(
                  "Food calendar",
                  style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),*/
                    SliverToBoxAdapter(
                      child: Container(
                        height: 20.h,
                      ),
                    ),
                    /*widget.id_robo != null
              ? SliverToBoxAdapter(
                  child: Container(
                    height: 25,
                    margin: EdgeInsets.only(
                      left: 20,
                      right: 0,
                    ),
                    child: Container(
                      width: 90,
                      height: 90,
                      child: Text(
                        "¡Alertas de robo!",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              : SliverToBoxAdapter(
                  child: Container(
                    height: 25,
                    margin: EdgeInsets.only(
                      left: 20,
                      right: 0,
                    ),
                    child: Container(
                      width: 90,
                      height: 90,
                      child: Text(
                        "",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),*/
                    /*Portfolio(
            id_robo: widget.id_robo,
            imagen: widget.imagen,
            descripcion: widget.descripcion,
          )*/
                  ],
                ),
              );
            }));
  }
}
