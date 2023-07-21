import 'dart:convert';

import 'package:authentication_task/Screens/Register/register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../components/buttons.dart';
import 'package:flutter/material.dart';
import '../../../../constants.dart';
import '../../HomePage.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({Key? key}) : super(key: key);

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final _formKey = GlobalKey<FormState>();

  // TODO: Create Your Variables Here

  late String emailValue;
  late String passwordValue;


  @override
  Widget build(BuildContext context) {
    bool emptyArea = false;

    return SafeArea(
        child: SingleChildScrollView(
      child: Column(
        children: [
///////////////////////////////////////////////////////////////////////////////////
          Padding(
            padding: const EdgeInsets.only(top: 120).r,
            child: SizedBox(
              width: 260.w,
              child: Column(
                children: [
                  Text(
                    "Login!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: mainFontSize.sp,
                      fontWeight: mainFontWeight,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "Welcome back ! Login with your credentials",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: commonTextSize.sp,
                      color: lightGreyReceiptBG,
                    ),
                  ),
                ],
              ),
            ),
          ),
///////////////////////////////////////////////////////////////////////////////////

          SizedBox(width: double.infinity.w, height: 40.h),
          Form(
            key: _formKey,
            child: Column(
              children: [
///////////////////////////////////////////////////////////////////////////////////
                Padding(
                  padding: const EdgeInsets.only(right: 20.0).r,
                  child: SizedBox(
                    width: 220.w,
                    height: 90.h,
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          displaySnackBar("enter your email");
                          emptyArea = true;
                          return "empty";
                        }
                        return null;
                      },
                      cursorColor: textBlack,
                      style: TextStyle(fontSize: subFontSize.sp),
                      decoration: InputDecoration(
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: textBlack),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: textBlack),
                        ),
                        icon: const Icon(
                          Icons.email_outlined,
                          color: textBlack,
                        ),
                        labelText: "Email",
                        hintText: "abc@gmail.com",
                        labelStyle: TextStyle(
                            color: textBlack,
                            fontSize: mainFontSize.sp,
                            fontWeight: mainFontWeight),
                        hintStyle: TextStyle(
                            color: textBlack, fontSize: subFontSize.sp),
                      ),
                      onChanged: (text){
                        // TODO: add your code to fetch the user email
                        emailValue =text;
                      },
                    ),
                  ),
                ),
///////////////////////////////////////////////////////////////////////////////////
                Padding(
                  padding: const EdgeInsets.only(right: 20.0).r,
                  child: SizedBox(
                    width: 220.w,
                    height: 90.h,
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          displaySnackBar("enter your email");
                          emptyArea = true;
                          return "empty";
                        }
                        return null;
                      },
                      cursorColor: textBlack,
                      style: TextStyle(fontSize: subFontSize.sp),
                      decoration: InputDecoration(
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: textBlack),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: textBlack),
                        ),
                        icon: const Icon(
                          Icons.password_outlined,
                          color: textBlack,
                        ),
                        labelText: "Password",
                        hintText: "******",
                        labelStyle: TextStyle(
                            color: textBlack,
                            fontSize: mainFontSize.sp,
                            fontWeight: mainFontWeight),
                        hintStyle: TextStyle(
                            color: textBlack, fontSize: subFontSize.sp),
                      ),
                      onChanged: (text){
                        // TODO: add your code to fetch the user password
                        passwordValue = text;
                      },
                    ),
                  ),
                ),
///////////////////////////////////////////////////////////////////////////////////
                SizedBox(height: 30.h, width: double.infinity.w),
                DefaultButton(
                    text: "Log in",
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        emptyArea = false;
                      }
                      if (emptyArea == false) {
                        await displaySnackBar("loading");
                        // TODO: add your code to log in by email & password
                        userLogin(email:emailValue , password: passwordValue);
                        Navigator.pushNamed(context, HomePage.routeName);
                      }
                    }),
///////////////////////////////////////////////////////////////////////////////////
                SizedBox(height: 20.h, width: double.infinity.w),
                Text(
                  "Do not have an account ?",
                  style: (TextStyle(
                      color: textBlack, fontSize: commonTextSize.sp)),
                ),
///////////////////////////////////////////////////////////////////////////////////
                InkWell(
                  child: Text(
                    'Register',
                    style: TextStyle(
                        color: textBlack,
                        fontSize: commonTextSize.sp,
                        fontWeight: commonTextWeight),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, Register.routeName);
                  },
                )
              ],
            ),
          )
        ],
      ),
    ));
  }

  // TODO: Create Your Functions Here

void userLogin ({
    required String email,
    required String password,
})
{

  FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password
  ).then((value){
    print('logged in successfully');
    print(value.user!.email);
    print(value.user!.uid);
    checkForUserDataInFirestore(value.user!.uid,email,password);
  } ).catchError((error){
    print(error.toString());
  });
}

void checkForUserDataInFirestore(uId,email,password)
{
  FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) async {
    if(value.data()!['userEmail']==email && value.data()!['userPassword']== password)
      {
        print('User Email & password exist in FireStore');
      }
    print('User data in firestore checked successfully');
  }).catchError((error){
    print(error.toString());
  });
}

}
