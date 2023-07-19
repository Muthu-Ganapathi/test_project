import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:test_project/model/user.dart';

import 'model/userDetails.dart';

class UserRepo {
  final Dio dioClient = Dio();
  // UserRepo({required this.dioClient});
  Future<UserResponce?> getUsers(int page) async {
    try {
      final res = await dioClient.get("https://reqres.in/api/users?page=$page");
      final userResponce = userResponceFromJson(json.encode(res.data));
      return userResponce;
    } catch (e) {
      return null;
    }
  }

  Future<UserDetails?> getUser(User user) async {
    try {
      final res = await dioClient.get("https://reqres.in/api/users/${user.id}");
      final userResponce = userDetailsFromJson(json.encode(res.data));
      return userResponce;
    } catch (e) {
      return null;
    }
  }
}
