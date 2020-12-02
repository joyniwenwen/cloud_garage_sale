import 'package:geolocator/geolocator.dart';
import 'package:hyper_garage_sale/models/sale_item.dart';

class UserProfile {

  String email;
  String userId;
  Position currentPosition;
  String currentAddress;

  UserProfile({this.userId, this.email, this.currentPosition, this.currentAddress});
}