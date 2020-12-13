import 'package:flutter/material.dart';

class ImageDetail extends StatelessWidget {
  Map _data = {};
  @override
  Widget build(BuildContext context) {
    _data = _data.isNotEmpty ? _data : ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('View Image'),
        backgroundColor: Colors.grey,
    ),
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'detailImage',
            child: Image.network(
              _data['url']
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}