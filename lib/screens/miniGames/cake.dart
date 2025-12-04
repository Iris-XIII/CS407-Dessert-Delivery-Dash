import 'package:flutter/material.dart';
import '../../models/game_character.dart';
import '../../models/recipe.dart';
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
  // Removed selectedShape
  String? selectedCream;
  String? selectedTopping;

  // Asset paths mapping for toppings (Re-integrated for image assets)
  final Map<String, String> _toppingAssetPaths = const {
    'strawberry': 'assets/images/strawberry.png',
    'sprinkles': 'assets/images/sprinkles.png',
    'chocolate': 'assets/images/chocolate.png',
    'cherry': 'assets/images/cherry.png',
  };

  // Animations
  late AnimationController creamController;
  late AnimationController toppingController;

  final Color _baseCakeColor = Color(0xFFFFE4B5);

  @override
  void initState() {
    super.initState();

    creamController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    toppingController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    creamController.dispose();
    toppingController.dispose();
    super.dispose();
  }

  // Updated: Only checks cream and topping
  bool get isComplete => selectedCream != null && selectedTopping != null;

  void _submitCake() {
    if (!isComplete) return;

    // You can still use this for correctness if you want
    final playerRecipe = CakeRecipe(
      creamColor: selectedCream!,
      topping: selectedTopping!,
    );
    final isCorrect = widget.targetRecipe.matches(playerRecipe);
    // (isCorrect is unused here, actual scoring can happen in Kitchen/Reception)

    final result = CakeMiniGameResult(
      creamColor: selectedCream!,
      topping: selectedTopping!,
      cakeTries: widget.cakeTries + 1,
    );

    Navigator.pop(context, result);
  }


  // Custom handler for the AppBar back button/gesture
  void _handleBackToKitchen() {
    // Navigates back to the Kitchen screen (without returning a result)
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
                  // Updated modal text to remove shape reference
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
        return false; // Prevent default back behavior
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Make Cake', style: TextStyle(fontFamily: 'Caveat', fontSize: 28)),
          backgroundColor: Color(0xFFFFB6C1),
          // Override the back button action
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: _handleBackToKitchen, // Calls the custom back handler
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
            crossAxisAlignment: CrossAxisAlignment.stretch, // STRETCHES children vertically
            children: [
              // LEFT: CREAM OPTIONS
              Container(
                width: MediaQuery.of(context).size.width * 0.22,
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // CREAM COLOR OPTIONS
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

              // CENTER: CAKE PREVIEW AREA
              Container(
                width: MediaQuery.of(context).size.width * 0.35,
                child: Column(
                  // Use Spacers to manage vertical positioning
                  mainAxisAlignment: MainAxisAlignment.start,

                  children: [
                    // Pushes the cake stack down into the center
                    const Spacer(),

                    // Cake Stack (The actual cake drawing)
                    Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        Transform.translate(
                          // plate position
                          offset: const Offset(0, 70),
                          child: Container(
                            width: 250,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Cake layers (Base and Cream stacked vertically)
                        Transform.translate(
                          // cake position
                          offset: const Offset(0, -30),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // topping position
                              SizedBox(
                                height: 100,
                                child: selectedTopping != null
                                    ? AnimatedBuilder(
                                  animation: toppingController,
                                  builder: (context, child) {
                                    // Localized drop animation relative to the 50px box's top edge
                                    final dropHeight = 80.0;
                                    return Transform.translate(
                                      offset: Offset(
                                        0,
                                        -dropHeight + dropHeight * toppingController.value,
                                      ),
                                      child: child,
                                    );
                                  },
                                  // The child is now the visually styled topping preview
                                  child: _buildToppingPreview(selectedTopping!),
                                )
                                    : const SizedBox.shrink(), // Takes up the 50px space when not visible
                              ),


                              // 3. Cream layer
                              AnimatedContainer(
                                duration: Duration(milliseconds: 400),
                                curve: Curves.easeOut,
                                width: 160,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: selectedCream != null
                                      ? _creamToColor(selectedCream)
                                      : _baseCakeColor.withValues(alpha: 0.8),
                                  boxShadow: selectedCream != null ? [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))] : null,
                                ),
                              ),

                              // 2. Base cake
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
                                      color: Color(0xFFFFB6C1).withValues(alpha: 0.3),
                                      blurRadius: 10,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 6. Placeholder text (ADJUSTED POSITION)
                        Transform.translate(
                          // Adjusted offset to position the text above the cake layers (around -100)
                          offset: const Offset(0, -100),
                          child: Opacity(
                            // Logic: Show only if BOTH cream and topping are null. Hides on the first selection.
                            opacity: (selectedCream == null && selectedTopping == null) ? 1.0 : 0.0,
                            child: IgnorePointer(
                              // Prevent clicks on the hidden text
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

                    // Pushes the cake up and the button down
                    const Spacer(),

                    // Submit button
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

                    // Add some necessary padding from the bottom edge
                    SizedBox(height: 40),
                  ],
                ),
              ),

              SizedBox(width: 20),

              // RIGHT: TOPPING OPTIONS (2x2 Layout)
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

  // Updated: width changed from 40 to 85, padding and font size adjusted to match _toppingOption
  Widget _creamOption(String value, String label, Color color) {
    bool isSelected = selectedCream == value;

    return GestureDetector(
      onTap: () {
        setState(() => selectedCream = value);
        creamController.forward(from: 0);
      },
      child: Container(
        width: 85, // Matched topping width
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8), // Matched topping padding
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
            SizedBox(height: 5), // Adjusted spacing
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Caveat',
                fontSize: 16, // Adjusted font size
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Retained _toppingOption, as it already had width: 85
  Widget _toppingOption(String value, String label) {
    bool isSelected = selectedTopping == value;
    final assetPath = _toppingAssetPaths[value]; // Get the asset path

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
                  ? Image.asset(assetPath, width: 30, height: 30) // Display the image asset
                  : Text('?'), // Fallback if path is missing
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

  // Returns Image.asset for the main preview
  Widget _buildToppingPreview(String topping) {
    final assetPath = _toppingAssetPaths[topping];

    if (assetPath == null) return const SizedBox.shrink();

    // The topping is reduced in size and slightly offset to sit nicely on the top edge
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