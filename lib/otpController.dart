import 'package:assignment_internshala/authentication_repo/authentication_repo.dart';
import 'package:assignment_internshala/explore_page.dart';

import 'package:get/get.dart';

class OTPController extends GetxController{

  static OTPController get instance => Get.find();

  void verifyOtp(String otp) async {
    var isVerified = await AuthenticationRepo.instance.verifyOtp(otp);
    isVerified ? Get.offAll(()=> const ExplorePage()) : Get.back();
  }
}