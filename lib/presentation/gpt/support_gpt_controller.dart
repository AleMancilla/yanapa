import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:share_whatsapp/share_whatsapp.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:yanapa/presentation/home/controller_home.dart';

class SupportGptController extends GetxController {
  RxList<ModelMessageToGpt> listMessageToShow = <ModelMessageToGpt>[].obs;
  ControllerHome controllerHome = Get.find();

  RxBool waitingResponse = false.obs;
  final ChatGPT chatGPT =
      ChatGPT('sk-proj-s7R5KHZOpXHTJ4fLcPQ6T3BlbkFJcMbNKZMnxslh4vZ0oYIl');

  String _response = '';

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
    cleanChat();
    waitingResponse.value = true;
    final response = await chatGPT.preConfigGpt([
      'Seras un asistente virtual, tu nombre es YanapaBot, te dare informacion sobre capturas de pantalla para determinar si los mensajes parecen fraude o estafa o una situacion normal, por favor evita la palabra JSON en tus respuestas ya que las respuestas se mostrara a un usuario que no entiende mucho de terminologia digital',
      '''
puedes analizar la siguiente informacion? es un json que se obtuvo escaneando el texto de una captura de pantalla, y ayudarme a determinar si es una estafa, fraude o una situacion normal, y que puntos a tomar en cuenta analizaste para llegar a esa conclucion

$listJsonsToChatGPT

si consideras que tiene probabilidad de ser fraude o estafa porfavor inicia tu respuesta con el mensaje

-ALERTADEFRAUDE-
en caso de ser una estafa o fraude podrias darme un mensaje que indique
=CATEGORIA: \$nombrecategoria=
y una breve descripcion de como operan esta estafa o fraude
caso contrario o si no hay suficiente informacionpor favor inicia con el texto -REQUIEROMASINFORMACION- solicitando mas contexto de la situacion
''',
    ]);
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
                  Row(
                    children: [
                      Icon(
                        Icons.warning,
                        color: Colors.red,
                      ),
                      SizedBox(width: 20),
                      Flexible(
                        child: Text(
                          'ALERTA DE POSIBLE FRAUDE',
                          // textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
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
  }

  Future<void> sendMessage(String message) async {
    addWidgetMessage('user', message);
    waitingResponse.value = true;
    if (message.isNotEmpty) {
      final response = await chatGPT.sendMessage(message);
      waitingResponse.value = false;
      _response = _response + "/NEWLINE/" + response;
      // listOfProductsSuggest.value = getProfessionalModelSuggested(response);
      addWidgetMessage('gpt', response);
    }
  }
}

class ChatGPT {
  final String apiKey;

  ChatGPT(this.apiKey);

  cleanMessages() {
    messages = [];
  }

  List<Map<String, String>> messages = [];
  Future<String> sendMessage(String prompt) async {
    messages.add({
      'role': 'user',
      'content': prompt,
    });
    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": messages,
        }),
      );

      String decodedText = utf8.decode(res.bodyBytes);

      var jsonObject = jsonDecode(decodedText);

      log(decodedText);
      if (res.statusCode == 200) {
        String content = jsonObject['choices'][0]['message']['content'];
        content = content.trim();

        messages.add({
          'role': 'assistant',
          'content': content,
        });
        return content;
      }
      return 'An internal error occurred';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> preConfigGpt(List<String> prompt) async {
    prompt.forEach((element) {
      messages.add({
        'role': 'user',
        'content': element,
      });
    });

    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": messages,
        }),
      );

      String decodedText = utf8.decode(res.bodyBytes);

      var jsonObject = jsonDecode(decodedText);

      log(decodedText);
      if (res.statusCode == 200) {
        String content = jsonObject['choices'][0]['message']['content'];
        content = content.trim();

        messages.add({
          'role': 'assistant',
          'content': content,
        });
        return content;
      }
      return 'An internal error occurred';
    } catch (e) {
      return e.toString();
    }
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
