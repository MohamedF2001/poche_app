import 'dart:convert';
import 'package:http/http.dart' as http;

const String apiKey = "AIzaSyDwe1g3bMoVGB4WRcOAcVVXjsTXGemvja0"; // ← Remplace ici

Future<void> main() async {
  final url = Uri.parse(
    "https://generativelanguage.googleapis.com/v1beta/models?key=$apiKey",
  );

  print("📡 Appel API en cours...");

  final response = await http.get(url);

  if (response.statusCode != 200) {
    print("❌ Erreur HTTP: ${response.statusCode}");
    print(response.body);
    return;
  }

  final data = jsonDecode(response.body);

  print("\n📌 Modèles disponibles pour ta clé API:\n");

  if (data["models"] == null) {
    print("⚠️ Aucun modèle disponible !");
    print(data);
    return;
  }

  for (var model in data["models"]) {
    print("➡️ ${model['name']}");

    if (model["supportedMethods"] != null) {
      print("   Méthodes: ${model['supportedMethods']}");
    }
  }

  print("\n🎯 Test terminé");
}
