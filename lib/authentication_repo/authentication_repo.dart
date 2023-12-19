import 'dart:developer';

import 'package:assignment_internshala/explore_page.dart';
import 'package:assignment_internshala/login_screen/login_screen.dart';
import 'package:assignment_internshala/upload/take_video.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AuthenticationRepo extends GetxController {
  static AuthenticationRepo get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;
  var verificationId = ''.obs;
  final _db = FirebaseFirestore.instance;


  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream((_auth.userChanges()));
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    user == null
        ? Get.offAll(() => const LoginScreen())
        : Get.offAll(() =>  const ExplorePage());
  }


  Future<void> phoneAuthentication(String phoneNo) async {
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNo,
        verificationCompleted: (credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (e) {
          if (e.code == 'invalid-phone-number') {
            Get.snackbar("oops", "Currently this feature is under devlopment",
                titleText: const Text(
                  "Error",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w200,
                  ),
                ),
                isDismissible: true,
                duration: const Duration(milliseconds: 1800),
                messageText: const Text(
                  "Not a valid number",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Satoshi',
                    // fontWeight: FontWeight.w400,
                  ),
                ),
                snackPosition: SnackPosition.TOP,
                snackStyle: SnackStyle.FLOATING,
                shouldIconPulse: true,
                margin: const EdgeInsets.all(40));
          } else {
            Get.snackbar("oops", "Currently this feature is under devlopment",
                titleText: const Text(
                  "Error",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w200,
                  ),
                ),
                isDismissible: true,
                duration: const Duration(milliseconds: 1800),
                messageText:  Text(
                  "${e.message}",
                  style:const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Satoshi',
                    // fontWeight: FontWeight.w400,
                  ),
                ),
                snackPosition: SnackPosition.TOP,
                snackStyle: SnackStyle.FLOATING,
                shouldIconPulse: true,
                margin: const EdgeInsets.all(40));
          }
        },
        codeSent: (verificationId, resentToken) {
          this.verificationId.value = verificationId;
        },
        codeAutoRetrievalTimeout: (verificationId) {
          this.verificationId.value = verificationId;
        });
  }

  Future<bool> verifyOtp(String otp) async {
    var credentials = await _auth.signInWithCredential(
        PhoneAuthProvider.credential(
            verificationId: verificationId.value, smsCode: otp));
    return credentials.user != null ? true : false;
  }
  Future<void> logout() async {
    // firebaseUser.value == null;
    await _auth.signOut();

  }

  Future<void> addVideoToDb(
      String title,String category,String location,String videoUrl,String thumbnailUrl, String videoLength) async {
    // var uuid = const Uuid().v4();
    User? user = FirebaseAuth.instance.currentUser;
    final docID = _db.collection('Videos').doc();

    try{
      log("--------------------------------------> Starting to insert data into database");
      //String dateTime = DateTime.timestamp()..toString();
      await docID.set({
        'Title': title,
        'Category': category,
        'Location' :location,
        'Date': DateTime.now(),
        'Video': videoUrl,
        'videoLength':videoLength,
        'Thumbnail': thumbnailUrl,
        'id':docID.id,
        'uid': user!.uid,
      }
      ).whenComplete(() =>  Get.snackbar("oops", "Currently this feature is under devlopment",
          titleText:const Text(
            "Success",
            style: TextStyle(
              color: Colors.lightGreenAccent,
              fontSize: 12,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w200,
            ),
          ),
          isDismissible: true,
          duration: const Duration(milliseconds: 1800),
          messageText: const Text(
            "Your Video has been posted successfully.",
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Satoshi',
              // fontWeight: FontWeight.w400,
            ),
          ),
          snackPosition: SnackPosition.TOP,
          snackStyle: SnackStyle.FLOATING,
          shouldIconPulse: true,
          margin: const EdgeInsets.all(40)));
    }catch (error){
      log("------------------------------>this is the adding task error:- $error");
    }

  }




}
