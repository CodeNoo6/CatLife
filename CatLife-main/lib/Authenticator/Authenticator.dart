import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authenticator extends GetxController {
  var _googleSignIn = GoogleSignIn();
  var googleAccount = Rx<GoogleSignInAccount>(null);

  login() async {
    googleAccount.value = await _googleSignIn.signIn();
  }

  getData() {
    return googleAccount;
  }
}
