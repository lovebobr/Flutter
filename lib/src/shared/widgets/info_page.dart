import 'package:flutter/material.dart';


class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Информация'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Добро пожаловать в игру!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Это игра, в которой вам предстоит пройти серию уровней. На каждом уровне будет предложен вопрос или задача. Если ответ правильный, вы продвигаетесь дальше, если нет, вам придется начать снова.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Правила игры:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '- Пройдите все уровни.\n- С каждым уровнем задания становятся сложнее.\n- Вы можете использовать бонусы, чтобы облегчить прохождение.',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}