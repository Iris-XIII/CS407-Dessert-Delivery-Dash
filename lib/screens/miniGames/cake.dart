import 'package:flutter/material.dart';
import '../../models/game_character.dart';
import '../../models/recipe.dart';
import '../../services/audio_manager.dart';
import '../kitchen_screen.dart';

class CakeMiniGameResult {
  final String creamColor;
  final String topping;
  final int cakeTries;

  const CakeMiniGameResult({
    required this.creamColor,
    required this.topping,
    required this.cakeTries,
  });
}

class CakeGameScreen extends StatefulWidget {
  final CakeRecipe targetRecipe;
  final int day;
  final int currCustomer;
  final int money;
  final GameCharacter customer;
  final String? cakeFrosting;
  final String? cakeTopping;
  final int cakeTries;
  final String? teaBase;
  final String? teaTopping;
  final int teaTries;

  const CakeGameScreen({
    super.key,
    required this.targetRecipe,
    required this.day,
    required this.currCustomer,
    required this.money,
    required this.customer,
    required this.teaTries,
    required this.cakeTries,
    this.cakeFrosting,
    this.cakeTopping,
    this.teaBase,
    this.teaTopping
  });

  @override
  State<CakeGameScreen> createState() => _CakeGameScreenState();
}

class _CakeGameScreenState extends State<CakeGameScreen>
    with TickerProviderStateMixin {
  final AudioManager _audioManager = AudioManager();

  String? selectedCream;
  String? selectedTopping;

  final Map<String, String> _toppingAssetPaths = const {
    'strawberry': 'assets/images/strawberry.png',
    'sprinkles': 'assets/images/sprinkles.png',
    'chocolate': 'assets/images/chocolate.png',
    'cherry': 'assets/images/cherry.png',
  };

  late AnimationController creamController;
  late AnimationController toppingController;

  final Color _baseCakeColor = Color(0xFFFFE4B5);

  @override
  void initState() {
    super.initState();
    _playMusic();

    creamController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    toppingController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
  }

  Future<void> _playMusic() async {
    await _audioManager.playMusic('Game Pages.mp3');
  }

  @override
  void dispose() {
    creamController.dispose();
    toppingController.dispose();
    super.dispose();
  }

  bool get isComplete => selectedCream != null && selectedTopping != null;

  void _submitCake() {
    if (!isComplete) return;

    final playerRecipe = CakeRecipe(
      creamColor: selectedCream!,
      topping: selectedTopping!,
    );
    final isCorrect = widget.targetRecipe.matches(playerRecipe);

    final result = CakeMiniGameResult(
      creamColor: selectedCream!,
      topping: selectedTopping!,
      cakeTries: widget.cakeTries + 1,
    );

    Navigator.pop(context, result);
  }

  void _handleBackToKitchen() {
    Navigator.pop(context);
  }

  Color _creamToColor(String? cream) {
    switch (cream) {
      case "pink":
        return Color(0xFFFFB6C1);
      case "white":
        return Colors.white;
      case "brown":
        return Color(0xFF8B4513);
      case "blue":
        return Color(0xFFADD8E6);
      default:
        return Color(0xFFFFE4B5);
    }
  }

  void _showOrderModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Color(0xFFFACAE7), width: 3),
          ),
          backgroundColor: Color(0xFFFFE5EC),
          title: Text(
            'Current Order',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Caveat',
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8B6F8F),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Color(0xFFFFE3DC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Color(0xFFFFB6C1), width: 2),
                ),
                child: Text(
                  '${_formatName(widget.targetRecipe.creamColor)} Cream Cake + ${_formatName(widget.targetRecipe.topping)} Topping',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Caveat',
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Got it!',
                  style: TextStyle(
                    fontFamily: 'Caveat',
                    fontSize: 24,
                    color: Color(0xFFFF69B4),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppBarIconButton({required IconData icon, required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: GestureDetector(
        onTap: onPressed,
        child: Icon(
          icon,
          size: 28,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _handleBackToKitchen();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Make Cake', style: TextStyle(fontFamily: 'Caveat', fontSize: 28)),
          backgroundColor: Color(0xFFFFB6C1),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: _handleBackToKitchen,
          ),
          actions: [
            _buildAppBarIconButton(
              icon: Icons.receipt_long,
              onPressed: _showOrderModal,
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFE5EC), Color(0xFFFFF0F5)],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // LEFT: CREAM OPTIONS
              Container(
                width: MediaQuery.of(context).size.width * 0.22,
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildSectionTitle('Cream'),
                        SizedBox(height: 8),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: [
                            _creamOption('white', 'White', Colors.white),
                            _creamOption('pink', 'Pink', Color(0xFFFFB6C1)),
                            _creamOption('brown', 'Brown', Color(0xFF8B4513)),
                            _creamOption('blue', 'Blue', Color(0xFFADD8E6)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(width: 20),

              // CENTER: CAKE PREVIEW
              Container(
                width: MediaQuery.of(context).size.width * 0.35,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Spacer(),
                    Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        Transform.translate(
                          offset: const Offset(0, 70),
                          child: Container(
                            width: 250,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(0, -30),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 100,
                                child: selectedTopping != null
                                    ? AnimatedBuilder(
                                  animation: toppingController,
                                  builder: (context, child) {
                                    final dropHeight = 80.0;
                                    return Transform.translate(
                                      offset: Offset(
                                        0,
                                        -dropHeight + dropHeight * toppingController.value,
                                      ),
                                      child: child,
                                    );
                                  },
                                  child: _buildToppingPreview(selectedTopping!),
                                )
                                    : const SizedBox.shrink(),
                              ),
                              AnimatedContainer(
                                duration: Duration(milliseconds: 400),
                                curve: Curves.easeOut,
                                width: 160,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: selectedCream != null
                                      ? _creamToColor(selectedCream)
                                      : _baseCakeColor.withOpacity(0.8),
                                  boxShadow: selectedCream != null ? [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))] : null,
                                ),
                              ),
                              Container(
                                width: 170,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: _baseCakeColor,
                                  border: Border.all(
                                      color: Color(0xFFF8A66F),
                                      width: 3
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFFFFB6C1).withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(0, -100),
                          child: Opacity(
                            opacity: (selectedCream == null && selectedTopping == null) ? 1.0 : 0.0,
                            child: IgnorePointer(
                              ignoring: selectedCream != null || selectedTopping != null,
                              child: Text(
                                'Select\nCream & Topping',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Caveat',
                                  fontSize: 28,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: isComplete ? _submitCake : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isComplete ? Color(0xFF87D68D) : Colors.grey,
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        'Serve Cake!',
                        style: TextStyle(
                          fontFamily: 'Caveat',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),

              SizedBox(width: 20),

              // RIGHT: TOPPING OPTIONS
              Container(
                width: MediaQuery.of(context).size.width * 0.22,
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Topping'),
                    SizedBox(height: 8),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: [
                        _toppingOption('strawberry', 'Strawberry'),
                        _toppingOption('sprinkles', 'Sprinkles'),
                        _toppingOption('chocolate', 'Chocolate'),
                        _toppingOption('cherry', 'Cherry'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Caveat',
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Color(0xFF8B6F8F),
        ),
      ),
    );
  }

  Widget _creamOption(String value, String label, Color color) {
    bool isSelected = selectedCream == value;

    return GestureDetector(
      onTap: () {
        setState(() => selectedCream = value);
        creamController.forward(from: 0);
      },
      child: Container(
        width: 85,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFFFB6C1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Color(0xFFFF69B4) : Color(0xFFFFB6C1),
            width: isSelected ? 3 : 2,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade400, width: 2),
              ),
            ),
            SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Caveat',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toppingOption(String value, String label) {
    bool isSelected = selectedTopping == value;
    final assetPath = _toppingAssetPaths[value];

    return GestureDetector(
      onTap: () {
        setState(() => selectedTopping = value);
        toppingController.forward(from: 0);
      },
      child: Container(
        width: 85,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFFFB6C1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Color(0xFFFF69B4) : Color(0xFFFFB6C1),
            width: isSelected ? 3 : 2,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 35,
              height: 35,
              alignment: Alignment.center,
              child: assetPath != null
                  ? Image.asset(assetPath, width: 30, height: 30)
                  : Text('?'),
            ),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Caveat',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToppingPreview(String topping) {
    final assetPath = _toppingAssetPaths[topping];

    if (assetPath == null) return const SizedBox.shrink();

    return Transform.translate(
      offset: const Offset(0, 30),
      child: Image.asset(
        assetPath,
        width: 50,
        height: 50,
        fit: BoxFit.contain,
      ),
    );
  }

  String _formatName(String name) {
    return name[0].toUpperCase() + name.substring(1);
  }
}