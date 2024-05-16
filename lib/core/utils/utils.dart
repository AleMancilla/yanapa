import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

Future<void> excecuteProcess(
    BuildContext context, Future<dynamic> Function() process) async {
  await Future.delayed(Duration.zero, () async {
    // abre loading
    showLoading(context);
    try {
      await process();
      hideLoading(context);
    } catch (e) {
      hideLoading(context);
      showToastMessage(e.toString());
    }
    // Cierra el loading
  });
}

void showLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const AlertDialog(
        backgroundColor: Colors.transparent,
        content: Center(
          child: CircularProgressIndicator(),
        ),
      );
    },
  );
}

void hideLoading(BuildContext context) {
  Navigator.of(context).pop();
}

String? validatePassword(String? value) {
  if (value != null) {
    if (value.isEmpty) {
      return 'Por favor, ingresa una contraseña';
    } else if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$')
        .hasMatch(value)) {
      return 'La contraseña debe contener al menos 8 caracteres, una mayúscula, una minúscula y un número';
    }
  }
  return null;
}

String? validateConfirmPassword(String? value, String? toCompare) {
  if (value != null) {
    if (value.isEmpty) {
      return 'Debe ingresar un dato';
    } else if (value != toCompare) {
      return 'Las contraseñas no coinciden.';
    }
  }
  return null;
}

String? validateEmail(String value) {
  if (value.isEmpty) {
    return 'Por favor, ingresa tu correo electrónico';
  } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
    return 'Por favor, ingresa un correo electrónico válido';
  }
  return null;
}

void showToastMessage(String errorMesage, {String? errorTitle}) {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(errorTitle ?? 'Error'),
        content: Text(errorMesage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Aceptar'),
          ),
        ],
      );
    },
  );
}
