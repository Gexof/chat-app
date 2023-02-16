import 'dart:developer';

import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../helper/show_snack_bar.dart';
import 'chat_screen.dart';

class SignScreen extends StatefulWidget {
  SignScreen({super.key});

  @override
  State<SignScreen> createState() => _SignScreenState();
}

class _SignScreenState extends State<SignScreen> {
  String? email;

  String? password;

  bool isLoading = false;

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      opacity: 0.3,
      progressIndicator:
          const CircularProgressIndicator(color: Color(0xff703efe)),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/imgs/logo.png',
                      width: 250,
                      height: 250,
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: const [
                        Text(
                          'Sign up',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      hintText: 'Email',
                      icon: const Icon(Icons.alternate_email),
                      onChanged: (data) {
                        email = data;
                      },
                    ),
                    const SizedBox(height: 12),
                    // CustomTextField(
                    //   hintText: 'Full Name',
                    //   icon: const Icon(Icons.person),
                    // ),
                    // const SizedBox(height: 12),
                    CustomTextField(
                      hintText: 'Password',
                      icon: const Icon(Icons.lock),
                      onChanged: (data) {
                        password = data;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          isLoading = true;
                          setState(() {});
                          try {
                            await signUpUser();
                            Navigator.pushNamed(context, ChatScreen.id);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              showSnackBar(context, 'Weak Password');
                            } else if (e.code == 'email-already-in-use') {
                              showSnackBar(context, 'Email Already in Use');
                            }
                            //log for firebase ex
                            log(e.toString());
                          } catch (e) {
                            //log for any ex

                            log(e.toString());
                          }
                          isLoading = false;
                          setState(() {});
                        } else {
                          isLoading = false;
                          setState(() {});
                        }
                      },
                      buttonName: 'Sign up',
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Joined us before?',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            ' Login',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signUpUser() async {
    UserCredential user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);
  }
}
