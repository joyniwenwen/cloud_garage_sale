import 'package:flutter/material.dart';

class Constants {
  final Map<String, Image> catergoryToIcon = {
    "Clothes": Image.network("https://img.icons8.com/plasticine/64/000000/clothes.png"),
    "Electronics": Image.network("https://img.icons8.com/fluent/64/000000/laptop.png"),
    "Tools": Image.network("https://img.icons8.com/doodle/64/000000/screwdriver--v1.png"),
    "Books": Image.network("https://img.icons8.com/plasticine/64/000000/apple-books.png"),
    "Furniture": Image.network("https://img.icons8.com/dusk/64/000000/sofa.png"),
    "Toys": Image.network("https://img.icons8.com/cute-clipart/64/000000/toy-train.png"),
    "Other": Image.network("https://img.icons8.com/nolan/64/question-mark.png"),
  };

  Constants();
}