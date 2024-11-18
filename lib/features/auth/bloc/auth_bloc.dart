import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
 
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginEvent>((event, emit)async {
      emit(AuthLoginLoadingState());
      try{
        if(event.username.isEmpty || event.password.isEmpty){
          emit(AuthLoginFailureState(message: "enter valid credentials"));
          return;
        }
            final jsonResponse = await http.post(Uri.parse("https://telephone.http.vsensetech.in/login/user"),
            body: jsonEncode({
              "user_name":event.username,
              "password":event.password,
            }));

            var response =jsonDecode(jsonResponse.body);
            if(jsonResponse.statusCode==200){
              var box = await Hive.openBox("authtoken");
              box.put("token", response['token']);
              box.close();
              emit(AuthLoginSuccessState());
              return;
            }
            emit(AuthLoginFailureState(message:response['message']));


      }catch(e){
        emit(AuthLoginFailureState(message: e.toString()));

      }
  
    });

    on<AuthLogoutEvent>((event, emit)async{
      try{
        var box = await Hive.openBox("authtoken");
        box.delete("token");
      //  box.close();
        emit(AuthLogoutSuccessState());

      }
      catch(e){
        emit(AuthLogoutFailureState(message: "Failed To Logout:$e"));
      }
    });
  }
}
