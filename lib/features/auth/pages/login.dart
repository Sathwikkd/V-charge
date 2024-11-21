import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sathwik_app/features/auth/bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoginLoadingState) {
          setState(() {
            _isLoading = true;
          });
        }
        if (state is AuthLoginSuccessState) {
          Navigator.pushReplacementNamed(context, '/devicelist');
        }
        if (state is AuthLoginFailureState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          // leading: Icon(Icons.lock,color: Colors.white,),
          backgroundColor: Colors.black,
          title: Text(
            "Login Page",
            style: GoogleFonts.nunito(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo.png',
                height: 180,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  cursorColor: Colors.black,
                  controller: _usernameController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(20),
                    fillColor: Colors.white,
                    labelText: "Username",
                    labelStyle:
                        GoogleFonts.nunito(color: Colors.black, fontSize: 20),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  cursorColor: Colors.black,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(20),
                    fillColor: Colors.white,
                    labelText: "Password",
                    labelStyle:
                        GoogleFonts.nunito(color: Colors.black, fontSize: 20),
                  ),
                  obscureText: true,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              ElevatedButton(
                onPressed: () {
                  BlocProvider.of<AuthBloc>(context).add(
                    AuthLoginEvent(
                      username: _usernameController.text,
                      password: _passwordController.text,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: Size(
                    360,
                    60,
                  ),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text(
                        "Login",
                        style: GoogleFonts.nunito(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
