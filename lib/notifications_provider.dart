import 'package:flutter/material.dart';

class NotificationsProvider extends ChangeNotifier {
  static NotificationsProvider instance = NotificationsProvider();

  int _unread = 0;
  int get unread => _unread;

  void addNotification() {
    _unread++;
    print("Tengo $_unread notificaciones");
    notifyListeners();
  }

  void clear() {
    _unread = 0;
    notifyListeners();
  }
}
