import 'package:flutter/material.dart';

class MemoryGameScreen extends StatefulWidget {
  const MemoryGameScreen({super.key});

  @override
  _MemoryGameScreenState createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  late List<CardModel> cards;
  CardModel? firstCard;
  CardModel? secondCard;
  bool isProcessing = false;
  int pairsFound = 0;
  final int gridSize = 4;
  final double cardSize = 150.0; // Размер карточки (можно регулировать)

  // Пути к изображениям
  final String cardBackImage = 'assets/ui/xxxx.jpg';
  final String backgroundImage = 'assets/images/photo.jpg';
  final String titleImage = 'assets/images/neonchiktwo.png';

  // Список изображений для карточек
  final List<String> imagePaths = [
    'assets/images/imagef.png',
    'assets/images/imagetwo.png',
    'assets/images/imagetw.png',
    'assets/images/imagefi.png',
    'assets/images/imagefir.png',
    'assets/images/imagefirs.png',
    'assets/images/imagefirst.png',
    'assets/images/imaget.png',
  ];

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  void initializeGame() {
    List<CardModel> initialCards = [];
    List<int> imageIndexes = [];

    for (int i = 0; i < 8; i++) {
      imageIndexes.add(i);
      imageIndexes.add(i);
    }

    imageIndexes.shuffle();

    cards = imageIndexes.asMap().entries.map((entry) {
      return CardModel(
        id: entry.key,
        imagePath: imagePaths[entry.value],
        isFaceUp: false,
        isMatched: false,
      );
    }).toList();

    pairsFound = 0;
    firstCard = null;
    secondCard = null;
    isProcessing = false;
  }

  void _handleCardTap(CardModel card) {
    if (isProcessing || card.isFaceUp || card.isMatched) return;

    setState(() {
      card.isFaceUp = true;
    });

    if (firstCard == null) {
      firstCard = card;
    } else {
      secondCard = card;
      _checkForMatch();
    }
  }

  void _checkForMatch() {
    if (firstCard != null && secondCard != null) {
      isProcessing = true;

      if (firstCard!.imagePath == secondCard!.imagePath) {
        setState(() {
          firstCard!.isMatched = true;
          secondCard!.isMatched = true;
          firstCard = null;
          secondCard = null;
          isProcessing = false;
          pairsFound++;
        });

        if (pairsFound == 8) {
          Future.delayed(const Duration(milliseconds: 500), () {
            _showWinDialog();
          });
        }
      } else {
        Future.delayed(const Duration(milliseconds: 1000), () {
          setState(() {
            firstCard!.isFaceUp = false;
            secondCard!.isFaceUp = false;
            firstCard = null;
            secondCard = null;
            isProcessing = false;
          });
        });
      }
    }
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Поздравляем!'),
          content: const Text('Вы нашли все пары карточек!'),
          actions: <Widget>[
            TextButton(
              child: const Text('Играть снова'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  initializeGame();
                });
              },
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
        centerTitle: true,
        title: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                titleImage,
                width: 40,
                height: 40,
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  'Помоги неончику найти все одинаковые карточки',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'YourFontName', // Укажите имя шрифта из pubspec.yaml
                    fontSize: 18, // Размер шрифта
                    fontWeight: FontWeight.bold, // Жирность
                    color: Colors.purple, // Цвет текста
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                initializeGame();
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: cardSize * gridSize + (gridSize - 1) * 8, // Рассчитываем ширину сетки
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: gridSize,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 1.0, // Квадратные карточки
                      ),
                      itemCount: cards.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: cardSize,
                          height: cardSize,
                          child: CardWidget(
                            card: cards[index],
                            cardBackImage: cardBackImage,
                            onTap: () => _handleCardTap(cards[index]),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CardModel {
  final int id;
  final String imagePath;
  bool isFaceUp;
  bool isMatched;

  CardModel({
    required this.id,
    required this.imagePath,
    required this.isFaceUp,
    required this.isMatched,
  });
}

class CardWidget extends StatelessWidget {
  final CardModel card;
  final String cardBackImage;
  final VoidCallback onTap;

  const CardWidget({
    super.key,
    required this.card,
    required this.cardBackImage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.white, width: 2.0),
        ),
        child: card.isMatched
            ? null
            : card.isFaceUp
            ? _buildCardFace()
            : _buildCardBack(),
      ),
    );
  }

  Widget _buildCardFace() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6.0),
      child: Image.asset(
        card.imagePath,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildCardBack() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6.0),
      child: Image.asset(
        cardBackImage,
        fit: BoxFit.cover,
      ),
    );
  }
}