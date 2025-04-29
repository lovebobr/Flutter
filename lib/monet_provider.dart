import 'package:flutter/material.dart';

class MonetProvider extends ChangeNotifier {
  int wallet = 0; // начальное количество монет
  final List<Map<String, dynamic>> products = [
    {'image': 'assets/images/blok1.jpg', 'name': 'Блокнот 1', 'price': 100},
    {'image': 'assets/images/blok2.jpg', 'name': 'Блокнот 2', 'price': 100},
    {'image': 'assets/images/zaklad.jpg', 'name': 'Закладки', 'price': 150},
    {'image': 'assets/images/bottle.jpg', 'name': 'Спортивная бутылка', 'price': 200},
    {'image': 'assets/images/termos.jpg', 'name': 'Термос', 'price': 300},
    {'image': 'assets/images/power.jpg', 'name': 'Павербанк', 'price': 400},
    {'image': 'assets/images/kol.jpg', 'name': 'Колонка', 'price': 400},
    {'image': 'assets/images/porkol.jpg', 'name': 'Портативная колонка', 'price': 450},
  ];

  void addMoney(int amount) {
    wallet += amount;
    notifyListeners(); // Уведомляем слушателей об изменении
  }

  void handlePurchase(int price, int index) {
    if (wallet >= price) {
      wallet -= price;
      products[index]['purchased'] = true;
      notifyListeners();
    } else {
      products[index]['insufficientFunds'] = true;
      notifyListeners();
      Future.delayed(const Duration(seconds: 2), () {
        products[index]['insufficientFunds'] = false;
        notifyListeners();
      });
    }
  }
}
