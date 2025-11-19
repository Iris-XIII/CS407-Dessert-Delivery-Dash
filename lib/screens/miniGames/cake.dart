import 'package:flutter/material.dart';
import '../../models/recipe.dart';

class CakeGameScreen extends StatefulWidget {
  final CakeRecipe targetRecipe;

  const CakeGameScreen({
    Key? key,
    required this.targetRecipe,
  }) : super(key: key);

  @override
  State<CakeGameScreen> createState() => _CakeGameScreenState();
}

class _CakeGameScreenState extends State<CakeGameScreen>
    with TickerProviderStateMixin {
  String? selectedShape = 'round'; // Default shape
  String? selectedCream;
  String? selectedTopping;

  // Animations
  late AnimationController creamController;
  late AnimationController toppingController;

  final Color _baseCakeColor = Color(0xFFFFE4B5); // Fixed cake color (Beige)

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

  bool get isComplete => selectedShape != null && selectedCream != null && selectedTopping != null;

  void _submitCake() {
    if (!isComplete) return;

    final playerRecipe = CakeRecipe(
      baseShape: selectedShape!,
      creamColor: selectedCream!,
      topping: selectedTopping!,
    );

    final isCorrect = widget.targetRecipe.matches(playerRecipe);

    // CHANGE HERE: Navigate directly to the customer reception page,
    // passing the result as an argument, and replace the current screen.
    Navigator.pushReplacementNamed(
      context,
      '/customer-reception',
      arguments: isCorrect,
    );
  }

  // ACTION 2: Custom handler for the AppBar back button/gesture
  void _handleBackToKitchen() {
    // Navigates back to the Kitchen screen (without returning a result)
    // We use Navigator.pop() as the KitchenScreen is the previous route.
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

  BorderRadius _getShapeBorderRadius(String shape) {
    switch (shape) {
      case 'square':
        return BorderRadius.circular(25.0);
      case 'round':
      default:
        return BorderRadius.circular(900.0);
    }
  }

  // --- UPDATED _shapeOption widget (Slightly larger to match others) ---
  Widget _shapeOption(String value, IconData icon) {
    bool isSelected = selectedShape == value;

    return GestureDetector(
      onTap: () {
        setState(() => selectedShape = value);
      },
      child: Container(
        width: 60,
        height: 60,
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4), // Added padding for consistency
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFFFB6C1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Color(0xFFFF69B4) : Color(0xFFFFB6C1),
            width: isSelected ? 3 : 2,
          ),
        ),
        child: Column( // Wrapped icon in Column to center vertically with potential text if needed
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 35, // Slightly larger icon for better visibility
              color: isSelected ? Colors.white : Color(0xFF8B6F8F),
            ),
          ],
        ),
      ),
    );
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
                  '${_formatName(widget.targetRecipe.baseShape)} Cake\n${_formatName(widget.targetRecipe.creamColor)} Cream + ${_formatName(widget.targetRecipe.topping)}',
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
          size: 28, // Slightly larger size for better tap target visibility
          color: Colors.white, // Color to match the rest of the AppBar
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
            children: [
              // LEFT: SHAPE AND CREAM OPTIONS
              Container(
                width: MediaQuery.of(context).size.width * 0.22,
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // 1. SHAPE OPTIONS
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildSectionTitle('Shape'),
                        SizedBox(height: 8),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 4.0,
                          runSpacing: 4.0,
                          children: [
                            _shapeOption('round', Icons.circle_outlined),
                            _shapeOption('square', Icons.square_outlined),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    // 2. CREAM COLOR OPTIONS (1*4 Layout)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildSectionTitle('Cream'),
                        SizedBox(height: 8),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 9.0,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        // 1. Plate
                        Container(
                          width: 220,
                          height: 220,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade200,
                            border: Border.all(color: Colors.grey.shade400, width: 1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                        ),

                        // 2. Base cake (Removed pink border)
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: _getShapeBorderRadius(selectedShape ?? 'round'),
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

                        // 3. Cream layer
                        AnimatedContainer(
                          duration: Duration(milliseconds: 400),
                          width: 145,
                          height: 145,
                          decoration: BoxDecoration(
                            borderRadius: _getShapeBorderRadius(selectedShape ?? 'round'),
                            color: selectedCream != null
                                ? _creamToColor(selectedCream)
                                : _baseCakeColor.withOpacity(0.8),
                          ),
                        ),

                        // 5. Topping animation
                        if (selectedTopping != null)
                          AnimatedBuilder(
                            animation: toppingController,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(
                                  0,
                                  -100 + 100 * toppingController.value,
                                ),
                                child: child,
                              );
                            },
                            child: _buildToppingPreview(selectedTopping!),
                          ),

                        // 6. Placeholder text
                        if (selectedCream == null)
                          Center(
                            child: Text(
                              'Build\nYour\nCake',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Caveat',
                                fontSize: 28,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                      ],
                    ),

                    SizedBox(height: 20),

                    // Submit button
                    ElevatedButton(
                      onPressed: isComplete ? _submitCake : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isComplete ? Color(0xFF87D68D) : Colors.grey,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
                        _toppingOption('strawberry', 'Strawberry', '🍓'),
                        _toppingOption('sprinkles', 'Sprinkles', '✨'),
                        _toppingOption('chocolate', 'Chocolate', '🍫'),
                        _toppingOption('cherry', 'Cherry', '🍒'),
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
        width: 40, // Reduced width
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 1), // Reduced padding
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
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade400, width: 2),
              ),
            ),
            SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Caveat',
                fontSize: 13, // Reduced font size
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toppingOption(String value, String label, String emoji) {
    bool isSelected = selectedTopping == value;

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
              child: Text(emoji, style: TextStyle(fontSize: 26)),
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
    String emoji;
    if (topping == 'strawberry') emoji = '🍓';
    else if (topping == 'sprinkles') emoji = '✨';
    else if (topping == 'chocolate') emoji = '🍫';
    else emoji = '🍒';

    return Text(emoji, style: TextStyle(fontSize: 45));
  }

  String _formatName(String name) {
    return name[0].toUpperCase() + name.substring(1);
  }
}