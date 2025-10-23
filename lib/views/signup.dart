import 'package:clothify_app/controllers/auth_service.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final formkey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Column(
            children: [
              SizedBox(height: 120),
              SizedBox(
                width: MediaQuery.of(context).size.width * .9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Signup",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text("Create a new account to get started"),
                    SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .9,
                      child: TextFormField(
                        validator: (value) =>
                            value!.isEmpty ? "Name cannot be empty." : null,
                        controller: _nameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text("Name"),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .9,
                      child: TextFormField(
                        validator: (value) =>
                            value!.isEmpty ? "Email cannot be empty." : null,
                        controller: _emailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text("Email"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * .9,
                child: TextFormField(
                  validator: (value) => value!.length < 8
                      ? "Password must be at least 8 characters."
                      : null,
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Password"),
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width * .9,
                child: ElevatedButton(
                  onPressed: () {
                    if (formkey.currentState!.validate()) {
                      AuthService()
                          .createAccountWithEmail(
                            _nameController.text,
                            _emailController.text,
                            _passwordController.text,
                          )
                          .then((value) {
                            if (value == "Account created successfully") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Account created successfully"),
                                ),
                              );
                              Navigator.restorablePushNamedAndRemoveUntil(
                                context,
                                "/home",
                                (route) => false,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    value,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.red.shade400,
                                ),
                              );
                            }
                          });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent.shade400,
                    foregroundColor: Colors.white,
                  ),
                  child: Text("Sign Up", style: TextStyle(fontSize: 16)),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Login"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
