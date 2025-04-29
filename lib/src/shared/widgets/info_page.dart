import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/begin.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 80.0, left: 16.0, right: 16.0), // Отступ сверху для текста
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Заголовок с белым текстом
                  Text(
                    'Neoflex — российская ИТ-компания, специализирующаяся на разработке высоконагруженных бизнес-приложений.',
                    style: TextStyle(
                      fontSize: 20, // Сделаем текст чуть меньше
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Белый цвет текста
                    ),
                  ),
                  SizedBox(height: 20),

                  // Описание компании
                  Text(
                    '🔹 Ключевые направления:\n'
                        '• Микросервисы, Fast Data, MLOps\n'
                        '• BI-аналитика, мобильная разработка (iOS/Android)\n'
                        '• Облачные решения (Yandex Cloud)\n'
                        '• Автоматизация отчетности (Neoflex Reporting)\n\n'
                        '🔹 География: проекты в 20+ странах (РФ, ЕС, Азия, Африка).\n'
                        '🔹 Клиенты: крупные банки (Росбанк, Уралсиб), страховые компании, международные организации (AIIB).\n'
                        '🔹 Развитие:\n'
                        '• 1400+ сотрудников (2024), офисы в РФ, ЮАР, Китае.\n'
                        '• Собственные продукты и центры компетенций (Data Science, DevOps).\n'
                        '• Партнерства с Lightbend, Camunda, WSO2.',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(height: 40),
                  _buildInfoBlock(
                    icon: Icons.phone,
                    title: 'Телефон',
                    content: '+7 (8452) 659 705',
                  ),
                  SizedBox(height: 20),
                  _buildInfoBlock(
                    icon: Icons.location_on,
                    title: 'Наш адрес',
                    content: '410012 г. Саратов, ул. Аткарская, д. 66, 3 этаж, Деловой центр "Спутник"',
                  ),
                  SizedBox(height: 20),
                  _buildInfoBlock(
                    icon: Icons.email,
                    title: 'Контакт по email',
                    content: 'rodionov@neoflex.ru.',
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),

          // Стрелка назад с кружком
          Positioned(
            top: 10, // Уменьшен отступ сверху для стрелки
            left: 16, // Расстояние от левого края экрана
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Цвет фона круга
                shape: BoxShape.circle, // Сделаем контейнер круглым
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.purple, size: 30),
                onPressed: () {
                  Navigator.pop(context); // Закрывает текущий экран
                },
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VacanciesPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                ),
                child: Text(
                  'Смотреть вакансии',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Метод для создания блока с иконкой и текстом
  Widget _buildInfoBlock({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.purple,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    content,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class VacanciesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Фоновая картинка
          Positioned.fill(
            child: Image.asset(
              'assets/images/begin.jpg', // Путь к изображению
              fit: BoxFit.cover, // Заполняет весь экран
            ),
          ),

          // Основное содержимое
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 60), // Отступ сверху
                  Text(
                    'Текущие вакансии:',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Цвет текста - белый
                    ),
                  ),
                  SizedBox(height: 20),

                  _buildVacancyLink(
                    title: 'Frontend Developer',
                    url: 'https://hh.ru/vacancy/119006731',
                  ),
                  SizedBox(height: 20),
                  _buildVacancyLink(
                    title: 'Backend Developer',
                    url: 'https://hh.ru/vacancy/118827841',
                  ),
                ],
              ),
            ),
          ),

          // Стрелка назад на странице вакансий
          Positioned(
            top: 10, // Уменьшен отступ сверху для стрелки
            left: 16, // Расстояние от левого края экрана
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Цвет фона круга
                shape: BoxShape.circle, // Сделаем контейнер круглым
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.purple, size: 30),
                onPressed: () {
                  Navigator.pop(context); // Закрывает текущий экран и возвращает на предыдущий
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Метод для создания ссылки на вакансию
  Widget _buildVacancyLink({required String title, required String url}) {
    return GestureDetector(
      onTap: () async {
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Не удалось открыть ссылку: $url';
        }
      },
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
          decoration: TextDecoration.overline,
        ),
      ),
    );
  }
}