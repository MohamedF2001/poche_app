// lib/core/config/gemini_config.dart

class GeminiConfig {
  // 🔐 IMPORTANT: Remplacez par votre vraie clé API Gemini
  // Obtenez votre clé sur: https://makersuite.google.com/app/apikey
  //static const String apiKey = 'AIzaSyDwe1g3bMoVGB4WRcOAcVVXjsTXGemvja0';

  // Pour des raisons de sécurité, vous pouvez aussi charger depuis:
  // 1. Variables d'environnement
  // 2. Fichier .env (avec flutter_dotenv)
  // 3. Firebase Remote Config

  //static bool get isConfigured => apiKey != 'AIzaSyDwe1g3bMoVGB4WRcOAcVVXjsTXGemvja0';

  static const String apiKey = 'AIzaSyDwe1g3bMoVGB4WRcOAcVVXjsTXGemvja0';

  static bool get isConfigured => apiKey.trim().isNotEmpty;
}

// GUIDE D'OBTENTION DE LA CLÉ API GEMINI:
//
// 1. Visitez: https://makersuite.google.com/app/apikey
// 2. Connectez-vous avec votre compte Google
// 3. Cliquez sur "Get API Key" ou "Create API Key"
// 4. Copiez la clé générée
// 5. Remplacez 'YOUR_GEMINI_API_KEY_HERE' par votre clé
//
// ⚠️ NE COMMITEZ JAMAIS VOTRE CLÉ API DANS GIT !
// Ajoutez ce fichier à .gitignore si vous utilisez Git

// Exemple d'utilisation avec flutter_dotenv:
//
// 1. Ajoutez dans pubspec.yaml:
//    dependencies:
//      flutter_dotenv: ^5.1.0
//
// 2. Créez un fichier .env à la racine:
//    GEMINI_API_KEY=votre_clé_ici
//
// 3. Chargez dans main.dart:
//    await dotenv.load(fileName: ".env");
//    final apiKey = dotenv.env['GEMINI_API_KEY']!;