import 'package:assignment_internshala/authentication_repo/authentication_repo.dart';
import 'package:assignment_internshala/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});




  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //final TextEditingController phoneController = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();

  /* final _initialCountryCode = 'IND';
  var _country;*/
  var phoneNumber;
  var countrycode;


  @override
  Widget build(BuildContext context) {
    /* _country =
        countries.firstWhere((element) => element.code == _initialCountryCode);*/
    return Scaffold(
        body: Form(
      key: _loginFormKey,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Align(
            alignment: Alignment.topCenter,
            child:  CircleAvatar(
             // radius: 40,
              minRadius: 20,
              maxRadius: 64,
              foregroundImage: AssetImage("assets/images/blackcoffer_2_logo-removebg-preview.png",),
              backgroundColor: Colors.white38,
          //    backgroundImage:
            )   ),
        const SizedBox(
          height: 68,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 20),
          child: IntlPhoneField(
            style: const TextStyle(
                fontFamily: 'Satoshi',
                fontSize: 12,
                color: Colors.white60),
            decoration: const InputDecoration(
              hintText: 'Phone Number',
              hintStyle: TextStyle(
                fontFamily: 'Satoshi',
                fontSize: 12,
                color: Colors.white60),
              errorStyle: TextStyle(
                fontFamily: 'Satoshi',
                fontSize: 12,
                color: Colors.white60),
                contentPadding:
              EdgeInsets.fromLTRB(24, 12, 12, 12),
            ),
            languageCode: "en",
            initialCountryCode: 'IN',
            onChanged: (phone) {
              print(
                  "-------------------------------------------------->$phone.completeNumber");
              print(
                  "-------------------------------------------------->Country changed to: ${phone.countryCode}");
              countrycode = phone.countryCode;
              phoneNumber = "${phone.countryCode}${phone.number}";
              print(
                  "-------------------------------------------------->Country changed to: $phoneNumber");
            },
            validator: (value) {
              if (value!.isValidNumber()) {
                return "Enter valid Number";
              } else {
                return null;
              }
            },
            onCountryChanged: (country) {
              print('Country changed to: ${country.name}');
            },
          ),
        ),
        SizedBox(height: 36,),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 8),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black,
                      spreadRadius: 2,
                      offset: Offset(2.4, 3.2)),
                ]),
            child: ElevatedButton(
              onPressed: () async {
                if (_loginFormKey.currentState!.validate()) {
                  // Get.off(() =>  OTPScreen(phoneNo: phoneNumber.toString().trim()));
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        OTPScreen(phoneNo: phoneNumber.toString().trim()),
                  ));
                }
                await AuthenticationRepo.instance
                    .phoneAuthentication(phoneNumber.toString().trim());
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(4),
                fixedSize: const Size(368, 44),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                "Get Otp",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ]),
      /*IntlPhoneField(
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
                counterText: '',
              ),
              initialCountryCode: _initialCountryCode,
              validator: (value) {
                if (!(value!.number.length >= _country.minLength &&
                    value.number.length <= _country.maxLength)) {
                  return "Enter Valid Phone Number";
                } else {
                  return null;
                }
              },
              onSubmitted: (p0) {
                phoneNumber = p0;
              },
              onCountryChanged: (country) => _country = country,
            ),*/
      /*Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              */ /*
              validator: (value) {
                if (value!.length != 10) {
                          return "Enter valid Number";
                } else if (value!.isEmpty){
                      return "Enter Phone Number to Login";
                } else {
                  return null;
                }
              },
              controller: phoneController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w200,
                  fontSize: 20,
                  color: Colors.white),
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                suffixIcon: Icon(Icons.phone),
                contentPadding: EdgeInsets.fromLTRB(24, 4, 12, 12),
                label:  Text(
                 "Enter Phone Number",
                ),
              ),
            ),
        ),*/
    ));
  }


}
