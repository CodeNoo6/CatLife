import 'package:carousel_slider/carousel_slider.dart';
import 'package:catage/View_home.dart';
import 'package:catage/age_human.dart';
import 'package:catage/generated/l10n.dart';
import 'package:catage/respuesta.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Map<String, List> _elements = {
  'Bien': [
    'No tiene dientes',
    'Están saliendo dientes frontales, si no se ven se pueden palpar',
    'Le está iniciando el crecimiento, son dientes largos y puntiagudos al lado de los incisivos (Dientes de adelante, Caninos)',
    'Le está iniciando el crecimiento de dientes entre caninos y molares (Premolares)',
    'Tiene todos los dientes de leche, pero no tiene molares 6 incisivos superiores y 6 incisivos inferiores. 2 caninos superiores y 2 inferiores. 3 premolares superiores y 2 premolares inferiores',
    'Le están cambiando los dientes de leche por permanentes, dientes con una apariencia más grande y gruesa, primero de incisivos, luego caninos, después premolares y por último molares',
    'Tiene toda la dentadura permanente completa, Presencia de incisivos, caninos, premolares y molares permanentes',
    'Tiene los dientes completos blancos, sanos y limpios, dentadura completa',
    'Tiene los dientes un poco opacos, amarillentos e inicio de sarro en los traseros, pero tiene la dentadura completa',
    'El sarro esta extendido en todos los dientes y se observa cierto desgaste, pero tiene la dentadura completa',
    'Tiene los dientes deteriorados y desgastados con cambio de color en sus encías, pero tiene la dentadura completa',
    'Tiene la dentadura desgastada y deteriorada con mucho sarro con pérdida de algunos dientes'
  ],
};

class Age extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Responsive Sizer Example',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: MaterialApp(
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
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                  backgroundColor: Colors.yellow[800]),
            ),
            color: HexColor("08CAF7"),
            home: Scaffold(
              backgroundColor: Color.fromARGB(255, 230, 244, 253),
              extendBody: true,
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  color: Colors.grey[900],
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: Text(
                  'Edad Felina',
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
              body: GroupListView(
                sectionsCount: _elements.keys.toList().length,
                countOfItemInSection: (int section) {
                  return _elements.values.toList()[section].length;
                },
                itemBuilder: _itemBuilder,
                groupHeaderBuilder: (BuildContext context, int section) {
                  return _elements.keys.toList()[section] == "Bien"
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(10, 10, 2, 160),
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
                                        text: '¿Sabias que?',
                                        isSender: false,
                                        color: HexColor("08CAF7"),
                                        textStyle: GoogleFonts.aBeeZee(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      BubbleSpecialOne(
                                        text:
                                            'Mediante el estado de la dentadura de tu amigo peludo podemos calcular su edad',
                                        isSender: false,
                                        color: Colors.white,
                                        textStyle: GoogleFonts.aBeeZee(
                                          textStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      BubbleSpecialOne(
                                        text:
                                            'Selecciona el estado de la dentadura:',
                                        isSender: false,
                                        color: Colors.white,
                                        textStyle: GoogleFonts.aBeeZee(
                                          textStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Spacer();
                },
                separatorBuilder: (context, index) => SizedBox(height: 10),
                sectionSeparatorBuilder: (context, section) =>
                    SizedBox(height: 10),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _itemBuilder(BuildContext context, IndexPath index) {
    String user = _elements.values.toList()[index.section][index.index];
    int rnum = index.index + 1;
    String num = rnum.toString();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        color: HexColor("B2E4F9"),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 10.0),
          leading: CircleAvatar(
              child: Icon(
                IcoFontIcons.tooth,
                color: Colors.white,
                size: 20,
              ),
              backgroundColor: HexColor("08CAF7")),
          title: Text(
            _elements.values.toList()[index.section][index.index] ==
                    "No tiene dientes"
                ? S.of(context).home_text_three
                : _elements.values.toList()[index.section][index.index] ==
                        "Están saliendo dientes frontales, si no se ven se pueden palpar"
                    ? S.of(context).home_text_four
                    : _elements.values.toList()[index.section][index.index] ==
                            "Le está iniciando el crecimiento, son dientes largos y puntiagudos al lado de los incisivos (Dientes de adelante, Caninos)"
                        ? S.of(context).home_text_five
                        : _elements.values.toList()[index.section]
                                    [index.index] ==
                                "Le está iniciando el crecimiento de dientes entre caninos y molares (Premolares)"
                            ? S.of(context).home_text_six
                            : _elements.values.toList()[index.section]
                                        [index.index] ==
                                    "Tiene todos los dientes de leche, pero no tiene molares 6 incisivos superiores y 6 incisivos inferiores. 2 caninos superiores y 2 inferiores. 3 premolares superiores y 2 premolares inferiores"
                                ? S.of(context).home_text_seven
                                : _elements.values.toList()[index.section]
                                            [index.index] ==
                                        "Le están cambiando los dientes de leche por permanentes, dientes con una apariencia más grande y gruesa, primero de incisivos, luego caninos, después premolares y por último molares"
                                    ? S.of(context).home_text_eight
                                    : _elements.values.toList()[index.section]
                                                [index.index] ==
                                            "Tiene toda la dentadura permanente completa, Presencia de incisivos, caninos, premolares y molares permanentes"
                                        ? S.of(context).home_text_nine
                                        : _elements.values.toList()[index.section]
                                                    [index.index] ==
                                                "Tiene los dientes completos blancos, sanos y limpios, dentadura completa"
                                            ? S.of(context).home_text_eleven
                                            : _elements.values.toList()[index.section]
                                                        [index.index] ==
                                                    "Tiene los dientes un poco opacos, amarillentos e inicio de sarro en los traseros, pero tiene la dentadura completa"
                                                ? S.of(context).home_text_twelve
                                                : _elements.values.toList()[index.section]
                                                            [index.index] ==
                                                        "El sarro esta extendido en todos los dientes y se observa cierto desgaste, pero tiene la dentadura completa"
                                                    ? S.of(context).home_text_fourteen
                                                    : _elements.values.toList()[index.section][index.index] == "Tiene los dientes deteriorados y desgastados con cambio de color en sus encías, pero tiene la dentadura completa"
                                                        ? S.of(context).home_text_five
                                                        : _elements.values.toList()[index.section][index.index] == "Tiene la dentadura desgastada y deteriorada con mucho sarro con pérdida de algunos dientes"
                                                            ? S.of(context).home_text_sixteen
                                                            : "",
            style: GoogleFonts.aBeeZee(
              textStyle: TextStyle(
                color: Colors.indigo[900],
                fontSize: 18,
              ),
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => Respuesta(
                  id: index.index,
                ),
              ),
            );
          },
          trailing: Icon(Icons.arrow_forward, color: Colors.black),
        ),
      ),
    );
  }

  String _getInitials(String user) {
    var buffer = StringBuffer();
    var split = user.split(" ");
    for (var s in split) buffer.write(s[0]);

    return buffer.toString().substring(0, split.length);
  }
}

class CarouselM extends StatefulWidget {
  @override
  _CarouselMState createState() => _CarouselMState();
}

class _CarouselMState extends State<CarouselM> {
  int _currentIndex = 0;

  List cardList = [Item1()];

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CarouselSlider(
          options: CarouselOptions(
            height: 200.0,
            autoPlay: false,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            pauseAutoPlayOnTouch: true,
            aspectRatio: 2.0,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: cardList.map((card) {
            return Builder(builder: (BuildContext context) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.30,
                width: MediaQuery.of(context).size.width,
                child: Card(
                  color: Colors.blueAccent,
                  child: card,
                ),
              );
            });
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: map<Widget>(cardList, (index, url) {
            return Container(
              width: 10.0,
              height: 10.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index ? Colors.blueAccent : Colors.grey,
              ),
            );
          }),
        ),
      ],
    );
  }
}

class Item1 extends StatelessWidget {
  const Item1({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [
              0.3,
              1
            ],
            colors: [
              Colors.blue,
              Colors.blue,
            ]),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Data",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold)),
          Text("Data",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
