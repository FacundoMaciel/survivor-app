class AppConfig {
  // 🔹 Backend local
  static const String localBaseUrl = "http://localhost:4300"; 

  // 🔹 Backend deployado
  static const String prodBaseUrl  = "https://survivor-backend-shva.onrender.com";

  // 🔹 Elegí con cuál trabajar:
  static const String apiBaseUrl = localBaseUrl; // <-- cambiá entre localBaseUrl y prodBaseUrl
}