import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static String? postgresHost;
  static int? postgresPort;
  static String? postgresDbname;
  static String? postgresUsername;
  static String? postgresPassword;
  static bool? postgresUseSSL;

  static String? apiKey;
  static String? appId;
  static String? messagingSenderId;
  static String? projectId;
  static String? storageBucket;

  static Future<void> configure() async {
    await dotenv.load();

    postgresHost = dotenv.env['POSTGRES_HOST']!;
    postgresPort = int.parse(dotenv.env['POSTGRES_PORT']!);
    postgresDbname = dotenv.env['POSTGRES_DBNAME']!;
    postgresUsername = dotenv.env['POSTGRES_USERNAME']!;
    postgresPassword = dotenv.env['POSTGRES_PASSWORD']!;
    postgresUseSSL = (dotenv.env['POSTGRES_USE_SSL'] == "true");

    apiKey = dotenv.env['API_KEY']!;
    appId = dotenv.env['API_ID']!;
    messagingSenderId = dotenv.env['MESSAGING_SENDER_ID']!;
    projectId = dotenv.env['PROJECT_ID']!;
    storageBucket = dotenv.env['STORAGE_BUCKET']!;
  }
}
