import 'dart:developer';

import 'package:chat_app/helper/show_snack_bar.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      children: const [
                        Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // email text field
                    CustomTextField(
                      onChanged: (data) {
                        email = data;
                      },
                      hintText: 'Email',
                      icon: const Icon(Icons.alternate_email),
                    ),
                    const SizedBox(height: 12),
                    // password text field
                    CustomTextField(
                      onChanged: (data) {
                        password = data;
                      },
                      hintText: 'Password',
                      icon: const Icon(Icons.lock),
                    ),
                    const SizedBox(height: 16),
                    // button
                    CustomButton(
                      buttonName: 'Login',
                      onTap: () async {
                        isLoading = true;
                        setState(() {});
                        if (formKey.currentState!.validate()) {
                          try {
                            await loginUser();
                            Navigator.pushNamed(context, ChatScreen.id);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              showSnackBar(
                                  context, 'No user found for that email');
                            } else if (e.code == 'wrong-password') {
                              showSnackBar(context, 'Wrong password');
                            }
                            //log for firebase ex
                            log(e.toString());
                          } catch (e) {
                            //log for any ex
                            showSnackBar(context, e.toString());
                            log(e.toString());
                          }
                          isLoading = false;
                          setState(() {});
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'New to Bad Mood?',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, 'SignScreen');
                          },
                          child: const Text(
                            ' Register',
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

  Future<void> loginUser() async {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
  }
}
