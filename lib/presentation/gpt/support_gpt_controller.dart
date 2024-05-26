import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:share_whatsapp/share_whatsapp.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:yanapa/presentation/home/controller_home.dart';
import 'package:yanapa/presentation/remoteconfigs/remoteconfigs_controller.dart';

class SupportGptController extends GetxController {
  RxList<ModelMessageToGpt> listMessageToShow = <ModelMessageToGpt>[].obs;
  ControllerHome controllerHome = Get.find();
  RemoteConfigController remoteConfigController = Get.find();

  RxBool waitingResponse = false.obs;
  final ChatGPT chatGPT = ChatGPT();
  final ScrollController scrollController = ScrollController();

  String _response = '';

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
  void onInit() {
    // initChat();
    super.onInit();
  }

  void cleanChat() {
    listMessageToShow.value = [];
    chatGPT.cleanMessages();
  }

  Future<void> initChat(List<Map<String, String>> listJsonsToChatGPT) async {
    // $listJsonsToChatGPT
    cleanChat();
    waitingResponse.value = true;
    final response = await chatGPT.preConfigGpt(
      (remoteConfigController.jsonRemoteConfigData!.messajes ?? [])
          .map(
            (e) => e.replaceAll(
              '#####DATA_INJECTION_1#####',
              listJsonsToChatGPT.toString(),
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
    }
  }

  bool isFraud = false;

  Rx<Widget> alertMessage = Rx<Widget>(Container());

  showAlertDialog() {
    alertMessage.value = Container(
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
                          shareWhatsapp.shareFile(
                              controllerHome.listOfImages.first,
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
                          child: Image.asset('assets/images/telephone.png'),
                          width: 50,
                          height: 50,
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Ink(
                          child: Image.asset('assets/images/gmail.png'),
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
