import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hyper_garage_sale/models/sale_item.dart';
import 'package:hyper_garage_sale/models/user_profile.dart';
import 'package:hyper_garage_sale/models/constants.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:geolocator/geolocator.dart';

class BrowsePosts extends StatefulWidget {
  final UserProfile userProfile;
  BrowsePosts({this.userProfile});
  @override
  _BrowsePostsState createState() => _BrowsePostsState();
}

class _BrowsePostsState extends State<BrowsePosts> {
  final _firebaseref = FirebaseDatabase().reference().child('users/joyniwenwen/hyper_garage_sale');

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: _firebaseref.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData && !snapshot.hasError && snapshot.data.snapshot.value != null) {
            Map data = snapshot.data.snapshot.value;
            List<SaleItem> items = [];
            data.forEach((index, data) {
              SaleItem saleItem = SaleItem(
                  title: data['title'],
                  description: data['description'],
                  price: data['price'].toDouble(),
                  address: data['address'],
                  category: data['category'],
                  position: data['position'] == null ? null : Position(
                    longitude: data['position']['longitude'],
                    latitude: data['position']['latitude'].toDouble(),
                  ),
                  ownerEmail: data['ownerEmail'],
                  imageUrls: List<String>.from(data.keys.contains('imageUrls') ? data['imageUrls']:[])
              );
              items.add(saleItem);
            });
            return StaggeredGridView.countBuilder(
              crossAxisCount: 4,
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) => Container(
                child: _Tile(saleItem: items[index], userProfile: widget.userProfile),
              ),
              staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
            );
          } else {
            return Text('No data');
          }
        },
      ),
    );
  }
}

class _Tile extends StatefulWidget {
  _Tile({this.saleItem, this.userProfile});

  final SaleItem saleItem;
  final UserProfile userProfile;

  @override
  __TileState createState() => __TileState();
}

class __TileState extends State<_Tile> {
  double distance;
  final Constants _constants = Constants();

  @override
  void initState() {
    if (widget.userProfile.currentPosition == null || widget.saleItem.position == null) {
      distance = -1;
      print('distance is null');
      return;
    }
    distance = Geolocator.distanceBetween(
        widget.userProfile.currentPosition.latitude,
        widget.userProfile.currentPosition.longitude,
        widget.saleItem.position.latitude,
        widget.saleItem.position.longitude,
    );
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/view_post', arguments: {
          'saleItem': widget.saleItem,
          'userProfile': widget.userProfile,
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.userProfile.email == widget.saleItem.ownerEmail ? Colors.blue:Colors.white,
          ),
        ),
        child: Card(
          child: Column(
            children: <Widget>[
              Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: <Widget>[
                  Center(
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: widget.saleItem.imageUrls.length <= 0 ||
                          widget.saleItem.imageUrls[0] == null
                          ? 'https://www.thermaxglobal.com/wp-content/uploads/2020/05/image-not-found.jpg'
                          : widget.saleItem.imageUrls[0],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                    ),
                    width: 40,
                    height: 40,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                            '\$' + widget.saleItem.price.toString(),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  children: <Widget>[
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(child: _constants.catergoryToIcon[widget.saleItem.category], height: 20),
                          Text(
                            widget.saleItem.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    distance == null ? CircularProgressIndicator(): FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.location_pin),
                          Text(distance > 0 ? 'within ' + (distance/1600).toStringAsFixed(1) + ' miles' : 'unknown distance'),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}