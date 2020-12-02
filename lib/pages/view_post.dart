import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hyper_garage_sale/models/sale_item.dart';
import 'package:hyper_garage_sale/components/image_carousal.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ViewPost extends StatefulWidget {
  @override
  _ViewPostState createState() => _ViewPostState();
}

class _ViewPostState extends State<ViewPost> {
  Map _data = {};
  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    _data = _data.isNotEmpty ? _data : ModalRoute.of(context).settings.arguments;
    SaleItem saleItem = _data['saleItem'];

    var images = [...saleItem.imageUrls];
    if (saleItem.imageUrls.length <= 0) {
      images.add('https://www.thermaxglobal.com/wp-content/uploads/2020/05/image-not-found.jpg');
    }
    print(saleItem.address);
    print(saleItem.position);
    return Scaffold(
      appBar: AppBar(
        title: Text('View Post'),
        backgroundColor: Colors.grey,
      ),
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ImageCarousal(imageUrls:images),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Title',
                    style: TextStyle(
                      color: Colors.grey,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    saleItem.title,
                    style: TextStyle(
                      color: Colors.amberAccent[200],
                      letterSpacing: 2,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Price',
                    style: TextStyle(
                      color: Colors.grey,
                      letterSpacing: 8,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '\$' + saleItem.price.toString(),
                    style: TextStyle(
                      color: Colors.amberAccent[200],
                      letterSpacing: 2,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Owner',
                    style: TextStyle(
                      color: Colors.grey,
                      letterSpacing: 8,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.email,
                        color: Colors.grey[400],
                      ),
                      SizedBox(width: 10),
                      Text(
                        saleItem.ownerEmail,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 18,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Description',
                    style: TextStyle(
                      color: Colors.grey,
                      letterSpacing: 8,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    saleItem.description,
                    style: TextStyle(
                      color: Colors.amberAccent[200],
                      letterSpacing: 2,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Location',
                    style: TextStyle(
                      color: Colors.grey,
                      letterSpacing: 8,
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 400,
                    child: GoogleMap(
                      markers: Set<Marker>.of([
                        Marker(
                          markerId: MarkerId('item location'),
                          position: LatLng(saleItem.position.latitude, saleItem.position.longitude),
                          infoWindow: InfoWindow(title: saleItem.title, snippet: saleItem.ownerEmail),
                        ),
                      ]),
                      myLocationEnabled: true,
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(saleItem.position.latitude, saleItem.position.longitude),
                        zoom: 8.5,
                      ),
                    ),
                  ),
                ],
              ),
            ]
        ),
      ),
    );
  }
}