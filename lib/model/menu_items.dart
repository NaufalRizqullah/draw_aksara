import 'package:draw_aksara/model/menu_item.dart';
import 'package:flutter/material.dart';

class MenuItems {
  // buat item yg ingin ditampilkan
  static const itemSettingStroke = MenuItem(
    text: "Setting Stroke",
    icon: Icons.brush,
  );

  static const itemAboutPage = MenuItem(
    text: "About",
    icon: Icons.person_pin,
  );

  static const itemSignOut = MenuItem(
    text: "Exit",
    icon: Icons.exit_to_app,
  );

  // buat list menu item yg ingin ditampilkan
  static const List<MenuItem> itemsFirst = [
    itemSettingStroke,
    itemAboutPage,
  ];

  static const List<MenuItem> itemSecond = [
    itemSignOut,
  ];
}
