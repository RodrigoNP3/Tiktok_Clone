import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone/views/screens/add_video_screen.dart';

import 'controllers/auth_controller.dart';

//PAGES
const pages = [
  Center(
    child: Text('Home screen'),
  ),
  Center(
    child: Text('Search screen'),
  ),
  AddVideoScreen(),
  Center(
    child: Text('Messages screen'),
  ),
  Center(
    child: Text('Profile screen'),
  ),
];

// COLORS
const backgroundColor = Colors.black;
var buttonColor = Colors.red[400];
const borderColor = Colors.grey;

// FIREBASE
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;

//CONTROLLERS
var authController = AuthController.instance;
