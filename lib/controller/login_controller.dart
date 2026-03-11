import 'dart:developer';

import 'package:asrology/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:toastification/toastification.dart';
import '../api_services/api_client.dart';
import '../model/login_model.dart';
import '../routes/SessionManger.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;
  var isPasswordHidden = true.obs;

  Future<void> login(GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      final LoginResponseModel response = await AuthApi.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (response.success == true) {
        await SessionManager.saveUserSession(
          token: response.token.toString(),
          userId: response.data!.id!,
          name: response.data!.name!,
          email: response.data!.email!,
        );

        toastification.show(
          alignment: Alignment.topCenter,
          autoCloseDuration: const Duration(seconds: 3),
          title: const Text("Login Successful 🎉"),
          description: Text("Welcome ${response.data!.name}"),
          type: ToastificationType.success,
        );

        Get.offAllNamed(AppRoutes.dashboard);
      } else {
        toastification.show(
          alignment: Alignment.topCenter,
          autoCloseDuration: const Duration(seconds: 3),
          title: const Text("Login Failed"),
          description: Text(response.message ?? "Something went wrong"),
          type: ToastificationType.error,
        );
      }
    } on DioException catch (e) {
      String errorMessage = "Something went wrong";

      if (e.response != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      }

      toastification.show(
        alignment: Alignment.topCenter,
        autoCloseDuration: const Duration(seconds: 3),
        title: const Text("Error ❌"),
        description: Text(errorMessage),
        type: ToastificationType.error,
      );
    } catch (e) {
      toastification.show(
        alignment: Alignment.topCenter,
        autoCloseDuration: const Duration(seconds: 3),
        title: const Text("Error ❌"),
        description: Text(e.toString()),
        type: ToastificationType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String? validateEmail(String value) {
    if (value.isEmpty) return "Email required";
    if (!GetUtils.isEmail(value)) return "Enter valid email";
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) return "Password required";
    if (value.length < 6) return "Minimum 6 characters";
    return null;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
