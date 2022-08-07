import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'api_serivce/api_image_model.dart';
import 'api_serivce/call_api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('API structure'.toUpperCase())),
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
              onPressed: () {
                /// call fun for get apis
                AppApi.getApiFunction();
              },
              child: const Text("GET API")),
          TextButton(
              onPressed: () {
                /// call fun for post apis and send request body
                Map requestBody = {
                  "email": "test@gmail.com",
                  "password": "123456"
                };
                AppApi.apiPostFunction(requestBody);
              },
              child: const Text("POST API")),
          TextButton(
              onPressed: () {
                /// call fun for post apis and send request body and media file, you can send multiple file in list

                Map requestBody = {"useraname": "demouser", "age": "20"};

                List<ApiImageModel> imageList = [
                  ApiImageModel(
                      file: File("filepath"),
                      isFromWeb: kIsWeb,
                      keyName: "image")
                ];
                AppApi.apiPostFunctionWithFileUpload(requestBody, imageList);
              },
              child: const Text("POST WITH IMAGE UPLOAD")),
        ],
      )),
    );
  }
}
