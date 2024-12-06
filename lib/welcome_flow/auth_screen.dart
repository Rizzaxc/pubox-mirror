import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pubox/core/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../home_tab/view.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _passwordController =
      TextEditingController();

  final supabase = Supabase.instance.client;

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate() == false) {
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });
      await supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    } on AuthException catch (error) {
      if (mounted) context.showSnackBar(error.message, isError: true);
      _passwordController.clear();
    } catch (error) {
      if (mounted) {
        context.showSnackBar('Unexpected error occurred', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signInOAuth() async {
    try {
      setState(() {
        _isLoading = true;
      });
      supabase.auth.signInWithOAuth(OAuthProvider.google);
    } catch (error) {
      context.showSnackBar('error?');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Xin hãy nhập Email';
                }
                return null;
              },
            ),
            const Gap(16),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              enableSuggestions: false,
              decoration: InputDecoration(labelText: 'Password'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Xin hãy nhập Password';
                }
                if (value.length < 8) {
                  return 'Password tối thiểu 8 ký tự';
                }
                return null;
              },
            ),
            const Gap(16),
            _isLoading
                ? LoadingAnimationWidget.threeRotatingDots(
                    color: Colors.green, size: 32)
                : Column(children: [
                    ElevatedButton(
                      onPressed: _signIn,
                      child: Text('Sign In'),
                    ),
                    ElevatedButton.icon(
                      icon: Icon(FontAwesomeIcons.google),
                      onPressed: _signInOAuth,
                      label: Text('Sign In with Google'),
                    )
                  ]),
          ],
        ),
      ),
    );
  }
}
