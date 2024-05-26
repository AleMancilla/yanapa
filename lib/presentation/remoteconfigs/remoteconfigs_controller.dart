import 'dart:developer';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:yanapa/presentation/remoteconfigs/jsonNoticeRemote.dart';
import 'package:yanapa/presentation/remoteconfigs/json_gpt_remoteconfig_model.dart';

class RemoteConfigController extends GetxController {
  // FirebaseRemoteConfig? remoteConfig;

  FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
  JsonGptRemoteConfig? jsonRemoteConfigData;
  JsonNoticeRemoteSection? jsonNoticeRemoteSection;
  String? validTocken;

  Map<String, dynamic> data = {
    "listOfNotices": [
      {
        "urlPhotoOrigin":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQq3ocfRh49vG4zcwOOvpdcwJzH8vTAuFyHWEuC2J9nPQ&s",
        "nameOrigin": "Unitel",
        "publicationDate": "2024-05-24T14:30:00",
        "publicationTitle":
            "Estafas digitales: Reos con sentencia por violación y fraude operaban desde Palmasola captando víctimas en las redes sociales",
        "publicationDescription":
            "Una banda de estafadores fue desarticulada en Santa Cruz de la Sierra, cuatro operaban en una vivienda de la Villa Primero de Mayo, y otros seis dentro de los pabellones del PC4 en el penal de Palmasola. Hay más de 400 víctimas, confirmaron desde la Policía Boliviana.",
        "publicationRedTimeInMinutes": "5",
        "publicationImage":
            "https://estaticos.unitel.bo/binrepository/1279x719/-1c163/1280d545/none/246276540/GGFC/palmasola1_101-8989752_20240517002513.jpg",
        "urlToRedirect":
            "https://unitel.bo/noticias/seguridad/estafas-digitales-reos-con-sentencia-por-violacion-y-fraude-operaban-desde-palmasola-captando-victimas-en-las-redes-sociales-NB11987082"
      },
      {
        "urlPhotoOrigin":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQq3ocfRh49vG4zcwOOvpdcwJzH8vTAuFyHWEuC2J9nPQ&s",
        "nameOrigin": "Unitel",
        "publicationDate": "2024-05-24T14:30:00",
        "publicationTitle": "titulo2",
        "publicationDescription":
            "Una banda de estafadores fue desarticulada en Santa Cruz de la Sierra, cuatro operaban en una vivienda de la Villa Primero de Mayo, y otros seis dentro de los pabellones del PC4 en el penal de Palmasola. Hay más de 400 víctimas, confirmaron desde la Policía Boliviana.",
        "publicationRedTimeInMinutes": "5",
        "publicationImage":
            "https://estaticos.unitel.bo/binrepository/1279x719/-1c163/1280d545/none/246276540/GGFC/palmasola1_101-8989752_20240517002513.jpg",
        "urlToRedirect":
            "https://unitel.bo/noticias/seguridad/estafas-digitales-reos-con-sentencia-por-violacion-y-fraude-operaban-desde-palmasola-captando-victimas-en-las-redes-sociales-NB11987082"
      }
    ]
  };

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
    final remoteAppStringsNotices = remoteConfig.getValue('notices').asString();
    jsonNoticeRemoteSection =
        jsonNoticeRemoteSectionFromJson(remoteAppStringsNotices);
  }
}
