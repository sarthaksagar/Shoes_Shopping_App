import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart'; // 🔒 For password hashing
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:footware_page/pages/home_page.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference userCollection;
  var obscureText = true.obs; // Observable for password visibility

  TextEditingController registerNameCtrl = TextEditingController();
  TextEditingController registerEmailCtrl = TextEditingController();
  TextEditingController registerMobileNumberCtrl = TextEditingController();
  TextEditingController registerPasswordCtrl = TextEditingController();

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    userCollection = firestore.collection('users');
  }
  
  // 🔹 Hash Password (SHA-256)
  String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  // 🔹 Add User to Firestore (Avoid Duplicate Email)
  Future<void> addUser({required String name, required String email, required String password}) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'All fields are required!',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      // ✅ Check if email already exists
      QuerySnapshot query = await userCollection.where("email", isEqualTo: email).get();
      if (query.docs.isNotEmpty) {
        Get.snackbar('Error', 'Email already registered!',
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      // ✅ Hash Password before storing
      String hashedPassword = hashPassword(password);

      DocumentReference doc = userCollection.doc();
      await doc.set({
        "id": doc.id,
        "name": name,
        "email": email,
        "password": hashedPassword, 
        "created_at": Timestamp.now(),
      });

      Get.snackbar('Success', 'User registered successfully!',
          backgroundColor: Colors.green, colorText: Colors.white);

      clearFields();
      Get.offNamed('/login');

    } catch (e) {
      Get.snackbar('Error', 'Failed to register user: ${e.toString()}',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // 🔹 Login User (Check Hashed Password)
  Future<void> loginUser({required String email, required String password}) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Please fill in both fields!',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;

    try {
      QuerySnapshot query = await userCollection.where("email", isEqualTo: email).get();

      if (query.docs.isNotEmpty) {
        var userData = query.docs.first.data() as Map<String, dynamic>;

        // ✅ Compare hashed password
        if (userData['password'] == hashPassword(password)) {
          Get.to(HomePage());
          Get.snackbar('Success', 'Login successful!',
              backgroundColor: Colors.green, colorText: Colors.white);
          clearFields();
          Get.offNamed('/home');
        } else {
          Get.snackbar('Error', 'Invalid Password!',
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      } else {
        Get.snackbar('Error', 'User not found!',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Login failed: ${e.toString()}',
          backgroundColor: Colors.red, colorText: Colors.white);
    }

    isLoading.value = false;
  }

  // 🔹 Clear Fields
  void clearFields() {
    registerNameCtrl.clear();
    registerEmailCtrl.clear();
    registerMobileNumberCtrl.clear();
    registerPasswordCtrl.clear();
    update();
  }
}
