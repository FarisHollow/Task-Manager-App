import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/models/auth_utility.dart';
import 'package:task_manager/data/models/login_model.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/screens/bottom_nav_base_screen.dart';
import 'package:task_manager/ui/screens/email_verification_screen.dart';
import 'package:task_manager/ui/screens/auth/signup_screen.dart';
import 'package:task_manager/ui/state_managers/login_controller.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();



  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailRegex =
  RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: ScreenBackground(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 64,
                      ),
                      Text(
                        'Get Started With',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: _emailTEController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                        ),
                        validator: (String? value) {
                          if (value?.isEmpty ?? true) {
                            return 'Enter your email';
                          } else if (!emailRegex.hasMatch(value!)) {
                            return 'Invalid email format';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        controller: _passwordTEController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'Password',
                        ),
                        validator: (String? value) {
                          if ((value?.isEmpty ?? true) || value!.length < 8) {
                            return 'Enter password correctly with minimum 8 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      GetBuilder<LoginController>(
                        builder: (loginController) {
                          return SizedBox(
                            width: double.infinity,
                            child: Visibility(
                              visible: loginController.loginInProgress == false,
                              replacement: const Center(
                                child: CircularProgressIndicator(),
                              ),
                              child: ElevatedButton(
                                  onPressed: () {
                                    if(!_formKey.currentState!.validate()){
                                      return;
                                    }


                                    loginController.login(
                                        _emailTEController.text.trim(),
                                        _passwordTEController.text
                                    ).then((result) {
                                      if(result == true){
                                        Get.offAll(const BottomNavBaseScreen());
                                      }else{
                                        Get.snackbar("Opps!", "Failed to login",
                                            snackPosition: SnackPosition.TOP,
                                            showProgressIndicator: true,
                                            animationDuration: const Duration(milliseconds: 500),
                                            icon: const Icon(Icons.error_outline_rounded));
                                      }
                                    });
                                  },
                                  child: const Icon(Icons.arrow_forward_ios)),
                            ),
                          );
                        }
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Center(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    const EmailVerificationScreen()));
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account?",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, letterSpacing: 0.5),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const SignUpScreen()));
                              },
                              child: const Text('Sign up')),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}