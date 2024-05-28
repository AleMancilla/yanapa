import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:http/http.dart' as http;
import 'package:share_whatsapp/share_whatsapp.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:yanapa/core/utils/firebase_firestore.dart';
import 'package:yanapa/core/utils/firebase_storage_controller.dart';
import 'package:yanapa/core/utils/geolocation_controller.dart';
import 'package:yanapa/presentation/remoteconfigs/remoteconfigs_controller.dart';

class SupportGptController extends GetxController {
  RxList<ModelMessageToGpt> listMessageToShow = <ModelMessageToGpt>[].obs;
  RemoteConfigController remoteConfigController = Get.find();
  RxList<XFile> listOfImages = <XFile>[].obs;

  RxBool waitingResponse = false.obs;
  final ChatGPT chatGPT = ChatGPT();
  final ScrollController scrollController = ScrollController();
  List<Map<String, String>> listOfJsonsTextToAnalize = [];
  GeolocationController geolocationController =
      Get.put(GeolocationController());

  String _response = '';

  chargeTextInListData() async {
    listOfJsonsTextToAnalize = await getJsonOfTextSinceImages();
  }

  Future<List<Map<String, String>>> getJsonOfTextSinceImages() async {
    List<Map<String, String>> listOfJsons = [];
    for (var xfile in listOfImages) {
      // listOfImages.forEach((xfile) async {
      Map<String, String> tempJson = await _getTextFromImage(xfile);

      listOfJsons.add(tempJson);
    }

    log(jsonEncode(listOfJsons));
    print(listOfJsons);

    return listOfJsons;
  }

  Future<Map<String, String>> _getTextFromImage(XFile xfile) async {
    print(' ------------------------- ');
    final inputImage = InputImage.fromFile(File(xfile.path));
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    // String text = recognizedText.text;
    Map<String, String> tempJson = {};
    int i = 0;
    for (TextBlock block in recognizedText.blocks) {
      i = i + 1;
      tempJson["block_$i"] = (block.text.replaceAll('\n', ' ')).trim();
      print(' --- ${block.text.trim()}');
    }
    return tempJson;
  }

  void scrollToBottom() {
    try {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void onInit() async {
    super.onInit();
  }

  void cleanChat() {
    listMessageToShow.value = [];
    chatGPT.cleanMessages();
  }

  Future<void> initChat() async {
    // $listJsonsToChatGPT
    cleanChat();
    waitingResponse.value = true;
    final response = await chatGPT.preConfigGpt(
      (remoteConfigController.jsonRemoteConfigData!.messajes ?? [])
          .map(
            (e) => e.replaceAll(
              '#####DATA_INJECTION_1#####',
              listOfJsonsTextToAnalize.toString(),
            ),
          )
          .toList(),
      apiKey: remoteConfigController.validTocken ?? '',
      baseUrl: remoteConfigController.jsonRemoteConfigData!.baseUrl ??
          'https://api.openai.com/v1/chat/completions',
      model: remoteConfigController.jsonRemoteConfigData!.modelGpt ??
          'gpt-3.5-turbo',
    );
    _response = "$_response/NEWLINE/$response";
    waitingResponse.value = false;
    addWidgetMessage('gpt', response);
    if (response.contains('-ALERTADEFRAUDE-')) {
      isFraud = true;
      showAlertDialog();
      updateToFirestore();
    }
  }

  updateToFirestore() async {
    try {
      int i = 0;
      List<Map<String, String>> listOfJsons = [];
      List<Map<String, String>> listOfJsonsToFirestore = [];
      for (var xfile in listOfImages) {
        // listOfImages.forEach((xfile) async {
        Map<String, String> tempJson = listOfJsonsTextToAnalize[i];
        i = i + 1;

        String? urlResult =
            await FirebaseStorageController().uploadImage(File(xfile.path));

        // listOfJsons.add(tempJson);
        tempJson["urlResult"] = urlResult ?? '_';
        // tempJson["dateTime"] = DateTime.now().toString();
        listOfJsonsToFirestore.add(tempJson);
      }

      log(jsonEncode(listOfJsons));
      print(listOfJsons);
      try {
        FirebaseFirestoreController().sendDataToFIrestore(
          {
            "informationRecoilated": listOfJsonsToFirestore,
            "dateTime": DateTime.now().toString(),
            "lat": geolocationController.position?.latitude ?? 0,
            "lng": geolocationController.position?.longitude ?? 0
          },
        );
      } catch (e) {
        log(' -------- e : $e');
      }
    } catch (e) {}
  }

  bool isFraud = false;

  Rx<Widget> alertMessage = Rx<Widget>(Container());

  Widget widgetAlert({Function? ontap}) {
    return Container(
      width: MediaQuery.of(Get.context!).size.width,
      height: MediaQuery.of(Get.context!).size.height,
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(child: Container()),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      if (ontap != null) {
                        ontap!.call();
                      }
                      alertMessage.value = Container();
                    },
                    child: Ink(
                      // margin: EdgeInsets.all(20),
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: Text(
                        'X',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 40,
                )
              ],
            ),
            Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.only(left: 50, right: 50, bottom: 100),
              decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Image.asset(
                      'assets/images/alert.png',
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                    width: 150,
                    // height: 250,
                  ),
                  Flexible(
                    child: Text(
                      'ALERTA DE POSIBLE FRAUDE',
                      // textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 10),
                  Flexible(
                    child: Text(
                        'Se detecto una posible alerta de fraude, puedes brindar mas informacion a nuestro ChatBot para mas informacion o denunciar a instancias de la ATT en los botones a continuacion'),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Denuncialo en cualquiera de los siguientes botones',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          // shareWhatsapp.shareFile(
                          //     controllerHome.listOfImages.first,
                          //     phone: '59171533208');
                          shareWhatsapp.shareText(
                              'Hola, quiero registrar una denuncia de estafa/fraude digital.',
                              phone: '59171533208');
                        },
                        child: Ink(
                          child: Image.asset('assets/images/whatsapp.png'),
                          width: 50,
                          height: 50,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          launchUrlString(
                            "tel://800106000",
                          );
                        },
                        child: Ink(
                          child: Image.asset('assets/images/call-center.png'),
                          width: 50,
                          height: 50,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          launchUrlString(
                              "https://bloquealaestafa.att.gob.bo/");
                        },
                        child: Ink(
                          child: Image.asset('assets/images/internet.png'),
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  showAlertDialog() {
    alertMessage.value = widgetAlert();
  }

  void addWidgetMessage(String rol, String message) {
    listMessageToShow.add(ModelMessageToGpt(
      message: message,
      rol: rol,
      date: DateTime.now().millisecond,
    ));
    Future.delayed(Duration(milliseconds: 300), () {
      scrollToBottom();
    });
  }

  Future<void> sendMessage(String message) async {
    addWidgetMessage('user', message);
    waitingResponse.value = true;
    if (message.isNotEmpty) {
      final response = await chatGPT.sendMessage(
        message,
        apiKey: remoteConfigController.validTocken ?? '',
        baseUrl: remoteConfigController.jsonRemoteConfigData!.baseUrl ??
            'https://api.openai.com/v1/chat/completions',
        model: remoteConfigController.jsonRemoteConfigData!.modelGpt ??
            'gpt-3.5-turbo',
      );
      waitingResponse.value = false;
      _response = _response + "/NEWLINE/" + response;
      // listOfProductsSuggest.value = getProfessionalModelSuggested(response);
      addWidgetMessage('gpt', response);
      if (response.contains('-ALERTADEFRAUDE-')) {
        isFraud = true;
      }
    }
  }
}

class ChatGPT {
  ChatGPT();

  cleanMessages() {
    messages = [];
  }

  List<Map<String, String>> messages = [];
  Future<String> sendMessage(String prompt,
      {required String apiKey,
      required String baseUrl,
      required String model}) async {
    messages.add({
      'role': 'user',
      'content': prompt,
    });
    return await postRequestGpt(apiKey: apiKey, baseUrl: baseUrl, model: model);
  }

  int requestIntent = 0;
  Future<String> postRequestGpt(
      {required String apiKey,
      required String baseUrl,
      required String model}) async {
    try {
      final res = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          "model": model,
          "messages": messages,
        }),
      );

      String decodedText = utf8.decode(res.bodyBytes);

      var jsonObject = jsonDecode(decodedText);

      log(decodedText);
      if (res.statusCode == 200) {
        requestIntent = 0;
        String content = jsonObject['choices'][0]['message']['content'];
        content = content.trim();

        messages.add({
          'role': 'assistant',
          'content': content,
        });
        return content;
      } else if (res.statusCode == 401) {
        requestIntent = requestIntent + 1;
        if (requestIntent < 5) {
          RemoteConfigController remoteConfigController = Get.find();
          remoteConfigController.rotateTocken();
          //unauthorized
          return await postRequestGpt(
              apiKey: remoteConfigController.validTocken ?? '',
              baseUrl: baseUrl,
              model: model);
        }
      }
      return 'An internal error occurred';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> preConfigGpt(List<String> prompt,
      {required String apiKey,
      required String baseUrl,
      required String model}) async {
    prompt.forEach((element) {
      messages.add({
        'role': 'user',
        'content': element,
      });
    });

    return await postRequestGpt(apiKey: apiKey, baseUrl: baseUrl, model: model);
  }
}

class ModelMessageToGpt {
  String message;
  String rol;
  int date;
  ModelMessageToGpt({
    required this.message,
    required this.rol,
    required this.date,
  });
}
