import 'package:NeighbourPro/storage_service.dart';

Future<Map<String, String?>> getGlobalToken() async {
  final storage = StorageService();
  final token = await storage.getToken();
  final tokenType = await storage.getTokenType();

  return {'token': token, 'tokenType': tokenType};
}