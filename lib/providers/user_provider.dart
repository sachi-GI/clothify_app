import 'dart:async';

import 'package:clothify_app/controllers/db_service.dart';
import 'package:clothify_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  StreamSubscription<DocumentSnapshot>? _userSubscription;

  String name = "User";
  String email = "";
  String phone = "";
  String address = "";

  UserProvider() {
    loadUserData();
  }

  void loadUserData() {
    _userSubscription?.cancel();
    _userSubscription = DbService().readUserData().listen((snapshot) {
      print(snapshot.data());
      final UserModel data = UserModel.fromJson(
        snapshot.data() as Map<String, dynamic>,
      );
      name = data.name;
      email = data.email;
      phone = data.phone;
      address = data.address;
      notifyListeners();
    });
  }

  void cancelProvider() {
    _userSubscription?.cancel();
  }

  @override
  void dispose() {
    cancelProvider();
    super.dispose();
  }
}
