import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:hyper_garage_sale/models/storage.dart';
import 'package:hyper_garage_sale/models/sale_item.dart';
import 'package:hyper_garage_sale/models/constants.dart';
import 'package:hyper_garage_sale/components/camera_boxes.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';
import 'package:hyper_garage_sale/models/user_profile.dart';

class NewPost extends StatelessWidget {
  final UserProfile userProfile;
  final VoidCallback addNewpostCallback;
  NewPost({this.userProfile, this.addNewpostCallback});

  @override
  Widget build(BuildContext context) {
    print(userProfile.email);
    return NewPostForm(userProfile: userProfile, addNewpostCallback: addNewpostCallback);
  }
}

class NewPostForm extends StatefulWidget {
  final UserProfile userProfile;
  final VoidCallback addNewpostCallback;
  NewPostForm({this.userProfile, this.addNewpostCallback});

  @override
  _NewPostFormState createState() => _NewPostFormState();
}

class _NewPostFormState extends State<NewPostForm> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<CameraBoxesState> _camera_access_state = GlobalKey<CameraBoxesState>();
  final Storage storage_ = Storage();
  SaleItem _sale_item = SaleItem(
    title: '',
    price: 0.0,
    description: '',
    imageUrls: [],
  );
  var _uuid = Uuid();

  final _fb = FirebaseDatabase.instance;

  @override
  void initState() {
    super.initState();
    _sale_item.ownerEmail = widget.userProfile.email;
    if (widget.userProfile.currentPosition != null) {
      _sale_item.address = widget.userProfile.currentAddress;
      _sale_item.position = widget.userProfile.currentPosition;
    }
  }

  // Check if form is valid before perform login or signup
  Future<bool> validateAndSave() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      _sale_item.imageUrls = [];
      for (var i = 0; i <  _camera_access_state.currentState.imageCount(); i++) {
        if (_camera_access_state.currentState.getImage(i) != null) {
          String filename;
          filename = await storage_.uploadFile(File(_camera_access_state.currentState.getImage(i).path));
          _sale_item.imageUrls.add(filename);
        }
      }
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              new CircularProgressIndicator(),
              new Text("Processing Data"),
            ],
          ),
        );
      },
    );
    bool isValid = await validateAndSave();
    if (isValid) {
      _fb.reference().child('users/joyniwenwen').child('hyper_garage_sale').child(_uuid.v4()).set({
        'title': _sale_item.title,
        'price': _sale_item.price,
        'description': _sale_item.description,
        'imageUrls': _sale_item.imageUrls,
        'category': _sale_item.category,
        'ownerEmail': _sale_item.ownerEmail,
        'position': _sale_item.position == null ? null : _sale_item.position.toJson(),
        'address': _sale_item.address == null ? null : _sale_item.address.toString(),
      }).then((_){
        Navigator.pop(context);
        widget.addNewpostCallback();
      }).catchError( (error) {
        Navigator.pop(context);
        print(error);
      });
    } else {
      Navigator.pop(context);
    }
  }

  final Constants _constants = Constants();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InputDecorator(
              decoration: InputDecoration(
                labelText: 'Item Category',
              ),
              child: DropdownButtonFormField(
                onChanged: (value)=>{},
                items:  _constants.catergoryToIcon.entries.map(
                        (entry) {
                      return DropdownMenuItem<String>(
                        value: entry.key,
                        child: Row(
                          children: <Widget>[
                            entry.value,
                            Text(entry.key),
                          ],
                        ),
                      );
                    }
                ).toList(),
                onSaved: (value) => _sale_item.category = value.trim(),
                validator: (value) {
                  if ((value == null) || value.isEmpty) {
                    return 'Category can not be empty';
                  }
                  return null;
                },
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(
                  Icons.title,
                  color: Colors.blue,
                ),
                hintText: 'Enter the title to sell',
                labelText: 'Title',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Title can not be empty.';
                }
                return null;
              },
              onSaved: (value) => _sale_item.title = value.trim(),
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.monetization_on, color: Colors.blue),
                hintText: 'Enter the price',
                labelText: 'Price',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Price can not be empty';
                }
                String pattern = r'(^[0-9]+[.]*[0-9]*$)';
                RegExp regExp = new RegExp(pattern);
                if (!regExp.hasMatch(value)) {
                  return 'Invalid price, should be a decimal value.';
                }
                return null;
              },
              onSaved: (value) => _sale_item.price = double.parse(value.trim()),
              maxLines: 1,
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.description,
                  color: Colors.blue),
                hintText: 'Enter the description',
                labelText: 'Description',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Description should not be empty.';
                }
                return null;
              },
              onSaved: (value) => _sale_item.description = value.trim(),
              minLines: 1,
              maxLines: 5,
            ),
            Card(
                child: ListTile(
                  leading: Icon(Icons.location_pin,
                      color: Colors.blue),
                  title: Text(
                      widget.userProfile.currentAddress != null ? widget.userProfile.currentAddress:'position not available'
                  ),
                ),
            ),
            Card(child: CameraBoxes(key: _camera_access_state, height: 100, width: 400, boxNumber: 4, perRowNumber: 4)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                RaisedButton(
                  textColor: Colors.blueAccent,
                  child: Text(
                    'Post',
                    style: TextStyle(),
                  ),
                  onPressed: validateAndSubmit,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

