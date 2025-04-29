import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../monet_provider.dart'; // Импортируем MonetProvider

class ShopScreen extends StatelessWidget {
  const ShopScreen({Key? key}) : super(key: key);

  // Функция для отображения диалога о успешной покупке
  void showPurchaseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Поздравляем!'),
          content: const Text(
            'Позовите сотрудника для получения приза. Не закрывайте окно до получения приза.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Закрываем диалог
              },
              child: const Text('Закрыть'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton( // Кнопка назад
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Магазин',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: [
          Consumer<MonetProvider>(
            builder: (context, monetProvider, child) {
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Center(
                  child: Text(
                    '${monetProvider.wallet} монет',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<MonetProvider>(
        builder: (context, monetProvider, child) {
          return Stack(
            children: [
              // Фон
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/begin.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Затемнение фона для читаемости
              Container(
                color: Colors.black.withOpacity(0.3),
              ),
              // Сетка товаров
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  itemCount: monetProvider.products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) {
                    final product = monetProvider.products[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: product['purchased'] == true
                            ? Colors.green.withOpacity(0.9)
                            : Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Center(
                                child: Image.asset(
                                  product['image'] as String,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              product['name'] as String,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${product['price']} монет',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  monetProvider.handlePurchase(
                                      product['price'] as int, index);

                                  // Если покупка успешна, показываем диалог
                                  if (product['purchased'] == true) {
                                    showPurchaseDialog(context);

                                    // После закрытия окна обновляем статус товара
                                    Future.delayed(const Duration(milliseconds: 300), () {
                                      monetProvider.products[index]['purchased'] = false;
                                      monetProvider.notifyListeners();
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: product['insufficientFunds'] == true
                                      ? Colors.red
                                      : Colors.deepPurple,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                ),
                                child: const Text(
                                  'Купить',
                                  style: TextStyle(
                                    color: Colors.black, // Черный текст
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
