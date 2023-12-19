import 'package:assignment_internshala/otpController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';


class OTPScreen extends StatefulWidget {
   OTPScreen({super.key,required this.phoneNo});

  var phoneNo ;


  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {

  var phoneNumber;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setPhoneNumber(widget.phoneNo);
  }

  void setPhoneNumber(String phoneNo){
    setState(() {
      phoneNumber = phoneNo;
    });
  }

  var otpEntered ;
  final otpcontroller =Get.put(OTPController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .background,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "BlackCoffer",
              style: TextStyle(color: Colors.grey[400],fontSize: 16,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w500,
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(
                Icons.notifications_active_outlined,
              ),
            )
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("CO",style: TextStyle(fontSize: 32,
              color: Colors.white,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w500,
            )),
            const Text("DE",style: TextStyle(fontSize: 32,
              color: Colors.white,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w500,
            )),
            const Text("Verification",style: TextStyle(fontSize: 32,
              color: Colors.white,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w500,
            )),
            const SizedBox(height: 40,),
            Text("Enter the verification code sent at $phoneNumber",textAlign: TextAlign.center,style: TextStyle(fontSize: 16,
              color: Colors.white,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w500,
            )),
            const SizedBox(height: 20,),
            OtpTextField(
              textStyle:TextStyle(fontSize: 16,
              color: Colors.white,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w500,
            ),
              numberOfFields: 6,
              fillColor: Colors.black.withOpacity(0.1),
              filled: true,
              keyboardType: TextInputType.number,
              onSubmit: (value) {
                print("--------------------otp is ->$value");
                setOtp(value);
              },
            ),
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, bottom: 8),
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
                  onPressed: () {
                   otpcontroller.verifyOtp(otpEntered);
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
                    "Confirm",
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

          ],
        ),
      ) ,
    );
  }

  void setOtp(String value) {
    otpEntered = value;
  }
}
