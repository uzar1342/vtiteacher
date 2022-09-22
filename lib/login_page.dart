import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:random_string/random_string.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';

import 'configs/globals.dart';
import 'configs/shared_prefs_keys.dart';
import 'configs/urls.dart';
import 'dash_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool currentViewIsOtpPage = false;
  bool isLoading = false;

  final GlobalKey<FormState> _loginFormKey = GlobalKey();
  // final GlobalKey<FormState> _otpFormKey = GlobalKey();

  TextEditingController editingControllerPhone = TextEditingController();
  TextEditingController editingControllerpass = TextEditingController();





  @override
  void initState() {
    super.initState();
  }


  login() async {
    setState(() {
      isLoading = true;
    });
    Dio dio=Dio();
    var formData = FormData.fromMap({
      'username': editingControllerPhone.text,
      'password': editingControllerpass.text,
    });
    print(formData.fields);
    var response = await dio.post('http://training.virash.in/auth-user', data:formData);
    if (response.statusCode == 200) {
     var res=response.data;
      if (res['success'] == '1') {
        Fluttertoast.showToast(msg: res['message']);
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        _prefs.setBool(userLoginStatusKey, true);
        _prefs.setString(userPhoneKey, res["data"]['mobile_number'].toString());
        _prefs.setString(userFirstNameKey, res["data"]['employee_name']);
        _prefs.setString(profileimageKEY, res["data"]['profile_image']);
        _prefs.setString(employeeroleKEY, res["data"]['employee_role']);
        _prefs.setString(statusKEY, res["data"]['user_status']);
        _prefs.setString(addressKey, res["data"]['employee_address']);
        _prefs.setString(userEmailKey, res["data"]['employee_email']);
        _prefs.setString(userIdKey, res["data"]['employee_id'].toString());
        setState(() {
          userPhone = res["data"]['mobile_number'].toString();
          userFirstName = res["data"]['employee_name'];
          userEmail = res["data"]['employee_email'];
          userId = res["data"]['employee_id'].toString();
          employee_address = res["data"]['employee_address'].toString();
          user_status =res["data"]['user_status'].toString();
          employee_address = res["data"]['employee_address'].toString();
          profile_image = res["data"]['profile_image'].toString();
        });
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const DashPage()),
            (route) => false);
      } else {
        Fluttertoast.showToast(msg: res['message']);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false);
      }
    }
    else
      {
        Fluttertoast.showToast(msg: response.statusCode.toString());
      }
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: currentViewIsOtpPage
              ? Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                currentViewIsOtpPage = false;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(
                                top: 10.0,
                                left: 15.0,
                              ),
                              //padding: const EdgeInsets.only(left: 5.0),
                              height: h * 0.05,
                              width: h * 0.05,
                              decoration: BoxDecoration(
                                  // color: primaryColor,
                                  border: Border.all(
                                      color: Colors.black26, width: 1.0),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12.0))),
                              child: const Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.black87,
                                size: 18.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Center(
                        child: Container(
                          height: h * 0.3,
                          width: h * 0.4,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/login.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("LOGIN",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 20.0,
                            ),

                          ],
                        ),
                      ),
                      SizedBox(
                        height: h * 0.02,
                      ),
                      SizedBox(
                        height: h * 0.04,
                      ),
                      InkWell(
                        onTap: () {

                        },
                        child: Center(
                          child: Container(
                            height: 60,
                            width: w * 0.8,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(18.0),
                              ),
                            ),
                            child: isLoading
                                ? const Center(
                                    child: SpinKitChasingDots(
                                      color: Colors.white,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        "Submit",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: h * 0.02,
                      ),

                    ],
                  ),
                )
              : Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    top: 10.0,
                                    left: 15.0,
                                  ),
                                  //padding: const EdgeInsets.only(left: 3.0),
                                  height: h * 0.05,
                                  width: h * 0.05,
                                  decoration: BoxDecoration(
                                      // color: primaryColor,
                                      border: Border.all(
                                          color: Colors.black26, width: 1.0),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12.0))),
                                  child: const Center(
                                    child: Icon(
                                      Icons.arrow_back_ios_new,
                                      color: Colors.black87,
                                      size: 18.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: h * 0.06,
                    ),
                    Container(
                      height: h * 0.3,
                      width: h * 0.4,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/login.png"),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      // child: RiveAnimation.asset(
                      //   'assets/images/login.riv',
                      // ),
                    ),
                    SizedBox(
                      height: h * 0.03,
                    ),
                    inputFields(),
                    SizedBox(
                      height: h * 0.03,
                    ),
                    InkWell(
                      onTap: () {

                      if(editingControllerPhone.text.trim()!=""&&editingControllerpass.text.trim()!="")
                        {
                          login();
                        }
                      else
                        {
                          Fluttertoast.showToast(msg: "Fill Credential");
                        }



                      },
                      child: Container(
                        height: 60,
                        width: w * 0.84,
                        margin: const EdgeInsets.symmetric(horizontal: 12.0),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(18.0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            isLoading
                                ? const SpinKitChasingDots(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    "LOGIN",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: h * 0.02,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget inputFields() {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Container(
      width: w * 0.9,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Form(
        key: _loginFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "LOGIN",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0),
            ),
            SizedBox(
              height: h * 0.03,
            ),

            Column(
              children: [
                Container(
                  width: w * 0.9,
                  child: TextFormField(
                    controller: editingControllerPhone,
                    validator: (value) {
                      if (value!.length != "") {
                        return 'Enter a valid user';
                      }
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black12, width: 2.0),
                            borderRadius: BorderRadius.all(
                              Radius.circular(12.0),
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor, width: 2.0),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12.0))),
                        labelText: 'USER NAME',
                        labelStyle: TextStyle(color: primaryColor),
                        suffixIcon: const Icon(
                          Icons.person,
                          color: Colors.black45,
                        )),
                  ),
                ),
                SizedBox(
                  height: h * 0.03,
                ),
                Container(
                  width: w * 0.9,
                  child: TextFormField(
                    controller: editingControllerpass,
                    validator: (value) {
                      if (value!.length != "") {
                        return 'Enter a valid password';
                      }
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black12, width: 2.0),
                            borderRadius: BorderRadius.all(
                              Radius.circular(12.0),
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor, width: 2.0),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12.0))),
                        labelText: 'PASSWORD',
                        labelStyle: TextStyle(color: primaryColor),
                        suffixIcon: const Icon(
                          Icons.password,
                          color: Colors.black45,
                        )),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


}
