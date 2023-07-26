import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/auth/login_screen.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

import 'otp_verification_screen.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 64,
                ),
                Text(
                  'Reset your password',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  'Must be a strong 8 digit password',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                ),
                const SizedBox(
                  height: 24,
                ),
                const TextField(
                  keyboardType: TextInputType.emailAddress,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'New password',
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                const TextField(
                  keyboardType: TextInputType.emailAddress,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Confirm password',
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const LoginScreen()));
                    },
                    child: const Text("Confirm"),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Have an account?",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, letterSpacing: 0.5),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Sign in')),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
