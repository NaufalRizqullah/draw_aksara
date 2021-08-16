import 'package:draw_aksara/model/index.dart';
import 'package:draw_aksara/page/homepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/assets_image_base.dart';

void main() {
  // ntah masih bingung ini buat apa :v  https://stackoverflow.com/questions/63873338/what-does-widgetsflutterbinding-ensureinitialized-do/63873689
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AssetsImageBase()),
        ChangeNotifierProvider(create: (context) => Index()),
      ],
      child: new MaterialApp(
        home: new HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}
