import 'dart:io';
import 'chapter11/http_client.dart';

void initPlatform() {
  HttpOverrides.global = MyHttpOverrides();
}
