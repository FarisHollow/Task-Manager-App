import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/auth/email_verification_screen.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

import '../../../data/models/network_response.dart';
import '../../../data/services/network_caller.dart';
import '../../../data/utils/urls.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

  final emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  final hasNumberRegex = RegExp(r'[0-9]');

  bool _signUpInProgress = false;


  Future<void> userSignUp() async {
    _signUpInProgress = true;
    if(mounted){
      setState(() {

      });
    }

    Map<String, dynamic> requestBody =  <String, dynamic>{
      "email": _emailTEController.text.trim(),
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile": _mobileTEController.text.trim(),
      "password": _passwordTEController.text,
      "photo": ""
    };
    final NetworkResponse response =
        await NetworkCaller().postRequest(Urls.registration, requestBody );
      _signUpInProgress = false;
      if(mounted){
        setState(() {

        });
      }

    if (response.isSuccess) {
       _emailTEController.clear();
       _firstNameTEController.clear();
       _lastNameTEController.clear();
       _mobileTEController.clear();
       _passwordTEController.clear();



      if(mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
            const SnackBar(content: Text('Registration succeed')));
      }
    }else {

      if(mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
            const SnackBar(content: Text('Registration failed!')));
      }

    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ScreenBackground(
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
                  'Join with us',
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
                  controller: _firstNameTEController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: 'First name',
                  ),
                  validator: (String? value) {
                    if (value?.isEmpty ?? true) {
                      return 'Enter your first name';
                    } else if (hasNumberRegex.hasMatch(value!)) {
                      return 'No numbers allowed in name';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _lastNameTEController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: 'Last name',
                  ),
                  validator: (String? value) {
                    if (value?.isEmpty ?? true) {
                      return 'Enter your first name';
                    } else if (hasNumberRegex.hasMatch(value!)) {
                      return 'No numbers allowed in name';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _mobileTEController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: 'Phone',
                  ),
                  validator: (String? value) {
                    if (value?.isEmpty ?? true) {
                      return 'Enter your phone number';
                    } else if (value!.length <= 10) {
                      return 'Phone number must be 11 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
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
                SizedBox(
                  width: double.infinity,
                  child: Visibility(
                    visible: _signUpInProgress == false,
                    replacement: const Center(child: CircularProgressIndicator()),
                    child: ElevatedButton(
                        onPressed: () {
                          if(!_formKey.currentState!.validate()){
                            return;
                          }
                          userSignUp();
                        },
                        child: const Icon(Icons.arrow_forward_ios)),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, letterSpacing: 0.5),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Sign In')),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
