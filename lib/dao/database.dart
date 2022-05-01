import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:mutex/mutex.dart';
import 'package:postgres/postgres.dart';
import 'package:flutter_notes/config.dart';

class Database {
  static PostgreSQLConnection connection = PostgreSQLConnection(
  Config.postgresHost!, Config.postgresPort!, Config.postgresDbname!,
  username: Config.postgresUsername!, password: Config.postgresPassword!);

  static final Mutex lock = Mutex();

  static Future<PostgreSQLConnection> getConnection() async {
    lock.acquire();
    if (connection.isClosed) {
      try {
        await connection.open();
      } on TimeoutException catch (_, e) {
        debugPrint(e.toString());
      }
      debugPrint("Connection opened");
    }
    lock.release();
    return connection;
  }

  static Future<void> closeConnection() async {
    lock.acquire();
    if (!connection.isClosed) {
      try {
        await connection.close();
      } on TimeoutException catch (_, e) {
        debugPrint(e.toString());
      }
      debugPrint("Connection closed");
    }
    lock.release();
  }
}