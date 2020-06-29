import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:rcs_mobile/model/recycle_center_model.dart';
import 'package:rcs_mobile/model/recycled_item_model.dart';
import 'package:rcs_mobile/model/recycled_item_status_enum.dart';

class RecycledItemsProvider with ChangeNotifier {
  final _firestoreInstance = Firestore.instance;

  final String _userId = '_userId';
  final String _token = '_token';
  List<RecycledItem> _recycledItems = [];

  /*[
  RecycledItem(
  id: DateTime.now().toIso8601String(),
  dateTime: DateTime.now(),
  name: 'Office paper',
  description: 'My office paper'),
  RecycledItem(
  id: DateTime.now().toIso8601String(),
  dateTime: DateTime.now(),
  name: 'Glass bottles',
  description: 'Green, clear and brown glass bottles'),
  RecycledItem(
  id: DateTime.now().toIso8601String(),
  dateTime: DateTime.now(),
  name: 'Office newspapers',
  description: 'Newspapers and junk mail.'),
  RecycledItem(
  id: DateTime.now().toIso8601String(),
  dateTime: DateTime.now(),
  name: 'Milk cartons',
  description: 'Milk containers'),
  RecycledItem(
  id: DateTime.now().toIso8601String(),
  dateTime: DateTime.now(),
  name: 'Cans',
  description: 'Steel and aluminium cans'),
  ]*/

//  RecycledItemsProvider(
//    this._userId,
//    this._token,
//    this._recycledItems,
//  );

  Future<void> fetchAndSetItems() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String userId = user.uid.toString();

    _recycledItems = [];

    var recycledItemDoc = await _firestoreInstance
        .collection('recycled_items')
        .document(userId)
        .collection('user_recycled_items')
        .getDocuments();

    recycledItemDoc.documents.forEach((itemDoc) async {
      var recycledItemCenterDoc = await _firestoreInstance
          .collection('recycled_items')
          .document(userId)
          .collection('user_recycled_items')
          .document(itemDoc.documentID)
          .collection('recycle_center')
          .getDocuments();

      //recycledItemCenterDoc.documents.first.data
      _recycledItems.add(RecycledItem(
        id: itemDoc.documentID,
        name: itemDoc.data['name'],
        description: itemDoc.data['description'],
        imagePath: itemDoc.data['image_path'],
        image: File(itemDoc.data['image_path']),
        dateTime: DateTime.parse(itemDoc.data['date_time']),
        recycleCenter: RecycleCenter(
          id: recycledItemCenterDoc.documents.first.documentID,
          description:
              recycledItemCenterDoc.documents.first.data['description'],
          latitude: recycledItemCenterDoc.documents.first.data['latitude'],
          longitude: recycledItemCenterDoc.documents.first.data['longitude'],
        ),
        //RecycledItemStatus status;
      ));
    });
  }

  List<RecycledItem> get getItems {
    return [..._recycledItems];
  }

  RecycledItem getItemById(String id) {
    return [..._recycledItems].firstWhere((element) => element.id == id);
  }

  Future<String> addItem(RecycledItem recycledItem) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String userId = user.uid.toString();

    if (!_recycledItems.contains(recycledItem)) {
      var recycledItemDoc = await _firestoreInstance
          .collection('recycled_items')
          .document(userId)
          .collection('user_recycled_items')
          .add({
        'name': recycledItem.name,
        'description': recycledItem.description,
        'image_path': recycledItem.imagePath,
        'date_time': recycledItem.dateTime.toIso8601String(),
        'status': RecycledItemStatus.DEFAULT.toShortString(),
      });

      var recycledItemCenterDoc = await _firestoreInstance
          .collection('recycled_items')
          .document(userId)
          .collection('user_recycled_items')
          .document(recycledItemDoc.documentID)
          .collection('recycle_center')
          .add({
        'description': recycledItem.recycleCenter.description,
        'latitude': recycledItem.recycleCenter.latitude,
        'longitude': recycledItem.recycleCenter.longitude,
      });

      RecycleCenter newItemRecycleCenter = RecycleCenter(
        id: recycledItemCenterDoc.documentID,
        description: recycledItem.recycleCenter.description,
        latitude: recycledItem.recycleCenter.latitude,
        longitude: recycledItem.recycleCenter.longitude,
      );
      RecycledItem newItem = RecycledItem(
        id: recycledItemDoc.documentID,
        name: recycledItem.name,
        description: recycledItem.description,
        imagePath: recycledItem.imagePath,
        image: recycledItem.image,
        dateTime: recycledItem.dateTime,
        recycleCenter: newItemRecycleCenter,
        status: RecycledItemStatus.DEFAULT,
      );

      print('newItem ID: ' + newItem.id);

      _recycledItems.add(newItem);

      return newItem.id;
    } else {
      return null;
    }
  }

  RecycledItem updateItem(String itemId, RecycledItem newRecycledItem) {
    print('image path: ' + newRecycledItem.imagePath);
    RecycledItem oldRecycledItem =
        _recycledItems.firstWhere((element) => element.id == itemId);
    _recycledItems[_recycledItems.indexOf(oldRecycledItem)] = newRecycledItem;
    return newRecycledItem;
  }

  String deleteItem(String itemId) {
    final existingItemIndex =
        _recycledItems.indexWhere((element) => element.id == itemId);
    var existingItem = _recycledItems[existingItemIndex];
    _recycledItems.removeAt(existingItemIndex);
    return existingItem.id;
  }
}
