import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:http/http.dart' as http;
import 'text_theme.dart';
import 'dart_to_hue_color_converter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hue Control',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 26, 150, 15),
        scaffoldBackgroundColor: Colors.black,
        fontFamily: 'Roboto',
        textTheme: CommonMethod.themedata,
      ),
      home: const MyHomePage(title: 'Hue app'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color selectedColor = Colors.red;
  int sliderBrightness = 255;
  int sliderSaturation = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: const TextStyle(
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).colorScheme.inverseSurface,
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.jpg"),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text("Saturation"),
                            Expanded(
                              flex: 1,
                              child: SfSlider.vertical(
                                min: 0.0,
                                max: 255.0,
                                value: sliderSaturation,
                                interval: 1,
                                minorTicksPerInterval: 1,
                                activeColor: selectedColor,
                                onChanged: (dynamic value) {
                                  setState(() {
                                    sliderSaturation =
                                        (value as double).toInt();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text("Brightness"),
                      Expanded(
                        flex: 1,
                        child: SfSlider.vertical(
                          min: 0.0,
                          max: 255.0,
                          value: sliderBrightness,
                          interval: 1,
                          minorTicksPerInterval: 1,
                          activeColor: selectedColor,
                          onChanged: (dynamic value) {
                            setState(() {
                              sliderBrightness = (value as double).toInt();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: _openColorPicker,
                        child: Container(
                          width: MediaQuery.of(context).size.width / 8,
                          height: MediaQuery.of(context).size.width / 8,
                          color: selectedColor,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(selectedColor),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                        onPressed: () async {
                          int hue = convertColorToHue(selectedColor);
                          int brightness = sliderBrightness;
                          int saturation = sliderSaturation;
                          var body = {
                            "hue": hue,
                            "bri": brightness,
                            "sat": saturation,
                            "on": brightness > 2 ? true : false
                          };
                          await http.put(
                            Uri.parse(""
                                // add URL here
                                ),
                            headers: {'Content-Type': 'application/json'},
                            body: jsonEncode(body),
                          );

                          await Fluttertoast.showToast(
                            msg: "Lights on !",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        },
                        child: const Text(
                          'Set Color',
                          softWrap: true,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                        onPressed: () async {
                          await http.put(
                            Uri.parse(""
                                // add URL here
                                ),
                            headers: {'Content-Type': 'application/json'},
                            body: jsonEncode({"on": false}),
                          );
                          await Fluttertoast.showToast(
                            msg: 'Lights off !',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        },
                        child: const Text(
                          'Lights off',
                          softWrap: true,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openColorPicker() async {
    await ColorPicker(
      color: selectedColor,
      onColorChanged: (Color newColor) {
        setState(() {
          selectedColor = newColor;
        });
      },
      width: 40,
      height: 40,
      borderRadius: 20,
      spacing: 10,
      runSpacing: 10,
      heading: const Text('Pick a color'),
      subheading: const Text('Select a color for your widget'),
      wheelDiameter: 200,
      wheelWidth: 20,
    ).showPickerDialog(context);
  }
}
