import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Page'),
        centerTitle: true,
        leading: BackButton(),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color(0xff65799b),
                  Color(0xff5e2563),
                ],
                begin: FractionalOffset.topLeft,
                end: FractionalOffset.bottomRight),
            image: DecorationImage(
              image: AssetImage("assets/pattern.png"),
              fit: BoxFit.none,
              repeat: ImageRepeat.repeat,
            ),
          ),
        ),
      ),
      body: Container(
        child: Center(child: Text("About Page"),),
      ),
    );
  }
}
