import 'package:draw_aksara/model/index.dart';
import 'package:draw_aksara/page/homepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/assets_image_base.dart';

void main() => runApp(
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
