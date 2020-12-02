import 'package:geolocator/geolocator.dart';

class SaleItem {
  String title;
  double price;
  String description;
  String ownerEmail;
  String category;
  List<String> imageUrls;

  Position position;
  String address;

  SaleItem({this.title, this.price, this.ownerEmail, this.category, this.description, this.imageUrls, this.position, this.address});
}