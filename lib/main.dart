import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:pets_app/api.dart';
import 'package:pets_app/pet.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: NeumorphicTheme(
          usedTheme: UsedTheme.LIGHT,
          theme: NeumorphicThemeData(
            baseColor: Color(0xFFFFFFFF),
            lightSource: LightSource.topLeft,
            depth: 10,
          ),
          darkTheme: NeumorphicThemeData(
            baseColor: Color(0xFF3E3E3E),
            lightSource: LightSource.topLeft,
            depth: 3,
          ),
          child: BuildListView(),
        ));
  }
}

class BuildListView extends StatefulWidget {
  @override
  _BuildListViewState createState() => _BuildListViewState();
}

class _BuildListViewState extends State<BuildListView> {
  var pets = new List<Pet>();
  int imgIndex = 0;

  void _prevImg() {
    setState(() {
      imgIndex = imgIndex > 0 ? imgIndex - 1 : (pets.length - 1);
    });
  }

  void _nextImg() {
    setState(() {
      imgIndex = imgIndex < pets.length - 1 ? imgIndex + 1 : 0;
    });
  }

  _getPets() {
    API.getPets().then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        pets = list.map((model) => Pet.fromJson(model)).toList();
      });
    });
  }

  _BuildListViewState() {
    _getPets();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context), body: listaPets());
  }

  listaPets() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Pets",
                style: TextStyle(
                    fontSize: 50.0,
                    fontFamily: 'GreatVibes',
                    color: _textColor(context)),
              ),
              NeumorphicButton(
                margin: EdgeInsets.only(top: 12),
                onPressed: () {
                  NeumorphicTheme.of(context).usedTheme =
                      NeumorphicTheme.isUsingDark(context)
                          ? UsedTheme.LIGHT
                          : UsedTheme.DARK;
                },
                style: NeumorphicStyle(shape: NeumorphicShape.flat),
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(100)),
                padding: const EdgeInsets.all(12.0),
                // child: Text(
                //   "Theme",
                //   style: TextStyle(color: _textColor(context)),
                // )
                child: Icon(
                  Icons.wb_sunny,
                  color: _textColor(context),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  pets[imgIndex].name,
                  style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: _textColor(context)),
                ),
                Text(
                  "R\$ " + pets[imgIndex].price.toString(),
                  style: TextStyle(fontSize: 20.0, color: _textColor(context)),
                ),
              ],
            ),
          ),
          Center(
            child: Stack(children: <Widget>[
              Neumorphic(
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(25.0)),
                style: NeumorphicStyle(shape: NeumorphicShape.convex, depth: 8),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      image: DecorationImage(
                          image: NetworkImage(pets[imgIndex].picture),
                          fit: BoxFit.cover)),
                  height: 400.0,
                  width: 400.0,
                ),
              )
            ]),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              NeumorphicButton(
                // margin: EdgeInsets.only(top: 12),
                onPressed: _prevImg,
                style: NeumorphicStyle(shape: NeumorphicShape.flat),
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0),
                child: Icon(
                  Icons.navigate_before,
                  color: _textColor(context),
                ),
              ),
              SizedBox(width: 50.0),
              NeumorphicButton(
                // margin: EdgeInsets.only(top: 12),
                onPressed: _nextImg,
                style: NeumorphicStyle(shape: NeumorphicShape.flat),
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0),
                child: Icon(
                  Icons.navigate_next,
                  color: _textColor(context),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

Color _textColor(BuildContext context) {
  if (NeumorphicTheme.isUsingDark(context)) {
    return Colors.white;
  } else {
    return Colors.black;
  }
}
