import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraBoxes extends StatefulWidget {
  CameraBoxes({Key key, this.width, this.height, this.boxNumber, this.perRowNumber}): super(key: key);
  final double width;
  final double height;
  final int boxNumber;
  final int perRowNumber;
  @override
  CameraBoxesState createState() => CameraBoxesState();
}

class CameraBoxesState extends State<CameraBoxes> {
  List<PickedFile> _images = new List(4);
  final ImagePicker _picker = ImagePicker();
  @override
  void _imgFromCamera(int index) async {
    final image = await _picker.getImage(source: ImageSource.camera,
        imageQuality: 50);
    setState( () {
      _images[index] = image;
    });
  }

  int imageCount() {
    return _images.length;
  }

  PickedFile getImage(int index) {
    return _images[index];
  }

  void _imgFromGallery(int index) async {
    final image = await _picker.getImage(source: ImageSource.gallery,
        imageQuality: 50);
    setState( () {
      _images[index] = image;
    });
  }

  Widget buildImageBox(int index) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black54,
          width: 0.3,
        ),
      ),
      child: FlatButton(
        onPressed: (){
          _imgFromCamera(index);
        },
        child:  SizedBox.expand(child: _images[index] == null ? Icon(Icons.image) : Image.file(File( _images[index].path), fit: BoxFit.fill)),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Icon(
            Icons.camera_alt,
            color: Colors.blue,
          ),
        ),
        Container(
          constraints: BoxConstraints(
            maxWidth: widget.width,
            maxHeight: widget.height,
          ),
          child: GridView.count(
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 5.0,
            crossAxisCount: widget.perRowNumber,
            children: List.generate(widget.boxNumber, (index){
              return buildImageBox(index);
            }),
          ),
        ),
      ],
    );
  }
}