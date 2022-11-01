import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:music_desktop/podo/router_manager.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController(),
        passwordController = TextEditingController();
    return Material(
      color: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/login.jpg'), fit: BoxFit.cover)),
        child: SizedBox(
          width: 300,
          height: 415,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //TODO: Fade in image
                    Center(
                      child: Image.asset(
                        'assets/logo.png',
                        height: 150,
                        width: 150,
                      ),
                    ),
                    // Text(
                    //   'Login',
                    //   style: TextStyle(
                    //       fontSize: 20.0,
                    //       fontWeight: FontWeight.w600,
                    //       color: Theme.of(context).colorScheme.onPrimary),
                    // ),
                    // SizedBox(height: 10,),
                    SizedBox(
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                            hintText: 'Enter Email',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      child: TextField(
                        obscureText: true,
                        controller: passwordController,
                        decoration: InputDecoration(
                            hintText: 'Password',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          'Forgot password?',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                        )),
                    const SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.of(context).pushNamed(RouteName.tab);
                      },
                      enableFeedback: true,
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: const Text('Login'),
                      ),
                    ),
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          'No Account? Sign up',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                              color:
                              Theme.of(context).colorScheme.onPrimary),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
