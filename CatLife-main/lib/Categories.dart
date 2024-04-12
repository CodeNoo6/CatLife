import 'package:catage/age.dart';
import 'package:catage/age_human.dart';
import 'package:catage/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  int currentSelectedItem = 0;
  @override
  Widget build(BuildContext context) {
    int items = 3;
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return SliverToBoxAdapter(
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
                      left: 75,
                      //left: queryData.size.width / 5.5,
                      right: 0,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        setState(() async {
                          currentSelectedItem = index;
                          if (index == 0) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => Age(),
                              ),
                            );
                          }
                          if (index == 1) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => Age_Human(),
                              ),
                            );
                          }
                          if (index == 2) {}
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
                                      ? Icons.fastfood_rounded
                                      : index == 3
                                          ? Icons.connect_without_contact
                                          : Icons.cancel,
                          color: index == currentSelectedItem
                              ? Colors.white
                              : Colors.black.withOpacity(0.7),
                        ),
                        elevation: 3,
                        margin: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
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
                    //left: index == 0 ? 20 : 0,
                    left: 72,
                    //left: queryData.size.width / 5.5,
                    right: 0,
                  ),
                  width: 90,
                  child: Row(
                    children: [
                      Spacer(),
                      Text(
                        index == 0
                            ? S.of(context).home_text_fourtythree
                            : index == 1
                                ? S.of(context).home_text_fourtyfour
                                : index == 2
                                    ? "Food"
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
    );
  }
}
