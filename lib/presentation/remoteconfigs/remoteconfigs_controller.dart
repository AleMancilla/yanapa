import 'dart:convert';
import 'dart:developer';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:yanapa/presentation/remoteconfigs/json_gpt_remoteconfig_model.dart';

class RemoteConfigController extends GetxController {
  // FirebaseRemoteConfig? remoteConfig;

  FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
  JsonGptRemoteConfig? jsonRemoteConfigData;
  String? validTocken;

  getValidGptTocken() {
    validTocken = jsonRemoteConfigData!.listOfTokens?.first ?? '';
  }

  rotateTocken() {
    jsonRemoteConfigData!.listOfTokens?.remove(validTocken);
    getValidGptTocken();
  }

  preLoadData() async {
    try {
      // Using zero duration to force fetching from remote server.
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ));

      // fetch and activate
      log('Fetch values = ${await remoteConfig.fetchAndActivate()}');
    } on PlatformException catch (exception) {
      // Fetch exception.
      log('Error fetching remote config: $exception');
    } catch (exception) {
      log('Unable to fetch remote config. Cached or default values will be '
          'used');
      log(exception.toString());
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await preLoadData();
    chargeRemoteData();
    getValidGptTocken();
  }

  chargeRemoteData() {
    final remoteAppStrings = remoteConfig.getValue('gpt_configs').asString();
    // final remoteAppStringsJson = json.decode(remoteAppStrings);
    jsonRemoteConfigData = jsonGptRemoteConfigFromJson(remoteAppStrings);
  }
}
