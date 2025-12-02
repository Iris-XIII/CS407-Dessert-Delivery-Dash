import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // For kDebugMode
import '../../models/recipe.dart';
import '../../utils/shake_detector.dart';

class MilkTeaGameScreen extends StatefulWidget {
  final MilkTeaRecipe targetRecipe;

  const MilkTeaGameScreen({
    Key? key,
    required this.targetRecipe,
  }) : super(key: key);

  @override
  State<MilkTeaGameScreen> createState() => _MilkTeaGameScreenState();
}

class _MilkTeaGameScreenState extends State<MilkTeaGameScreen>
    with TickerProviderStateMixin {
  // Player selections
  String? selectedTeaBase;
  String? selectedTopping;
  String? selectedSweetness;
  int shakeCount = 0;

  // Shake detector
  late ShakeDetector shakeDetector;
  bool isShaking = false;

  // Animations
  late AnimationController teaController;
  late AnimationController toppingController;
  late AnimationController sweetnessController;
  late AnimationController shakeController;

  // Required number of shakes
  final int requiredShakes = 3;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    teaController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );

    toppingController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );

    sweetnessController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );

    shakeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    // Initialize shake detector
    shakeDetector = ShakeDetector(
      onShake: _onDeviceShaken,
      shakeThreshold: 2.5,
      shakeCooldown: 600,
    );
  }

  @override
  void dispose() {
    teaController.dispose();
    toppingController.dispose();
    sweetnessController.dispose();
    shakeController.dispose();
    shakeDetector.stopListening();
    super.dispose();
  }

  // Called when device is shaken
  void _onDeviceShaken() {
    if (canShake && shakeCount < requiredShakes) {
      setState(() {
        shakeCount++;
        isShaking = true;
      });

      // Animate shake
      shakeController.forward(from: 0).then((_) {
        setState(() {
          isShaking = false;
        });
      });

      // Stop listening once we have enough shakes
      if (shakeCount >= requiredShakes) {
        shakeDetector.stopListening();
      }
    }
  }

  // Sequential enabling logic
  bool get canSelectTopping => selectedTeaBase != null;
  bool get canSelectSweetness => selectedTopping != null;
  bool get canShake => selectedSweetness != null;
  bool get isComplete => selectedTeaBase != null &&
      selectedTopping != null &&
      selectedSweetness != null &&
      shakeCount >= requiredShakes;

  void _submitMilkTea() {
    if (!isComplete) return;

    final playerRecipe = MilkTeaRecipe(
      teaBase: selectedTeaBase!,
      sweetness: selectedSweetness!,
      topping: selectedTopping!,
    );

    final isCorrect = widget.targetRecipe.matches(playerRecipe);

    // Navigate to customer reception with result
    Navigator.pushReplacementNamed(
      context,
      '/customer-reception',
      arguments: isCorrect,
    );
  }

  void _handleBackToKitchen() {
    Navigator.pop(context);
  }

  // Tea base colors
  Color _teaToColor(String? tea) {
    switch (tea) {
      case "black":
        return Color(0xFF4A2511);
      case "green":
        return Color(0xFF98D8AA);
      case "oolong":
        return Color(0xFFC68B59);
      case "taro":
        return Color(0xFFB19CD9);
      default:
        return Colors.transparent;
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
                  widget.targetRecipe.getFullOrderDescription(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Caveat',
                    fontSize: 24,
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _handleBackToKitchen();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Make Milk Tea',
              style: TextStyle(fontFamily: 'Caveat', fontSize: 28)),
          backgroundColor: Color(0xFFFFB6C1),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: _handleBackToKitchen,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: GestureDetector(
                onTap: _showOrderModal,
                child: Icon(Icons.receipt_long, size: 28, color: Colors.white),
              ),
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
              // LEFT SIDE: Tea Base & Sweetness
              Container(
                width: MediaQuery.of(context).size.width * 0.22,
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // TEA BASE SECTION
                      _buildSectionTitle('Tea Base'),
                      SizedBox(height: 6),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 6.0,
                        runSpacing: 6.0,
                        children: [
                          _teaOption('black', 'Black', Color(0xFF4A2511)),
                          _teaOption('green', 'Green', Color(0xFF98D8AA)),
                          _teaOption('oolong', 'Oolong', Color(0xFFC68B59)),
                          _teaOption('taro', 'Taro', Color(0xFFB19CD9)),
                        ],
                      ),
                      SizedBox(height: 15),

                      // SWEETNESS SECTION
                      _buildSectionTitle('Sweetness'),
                      SizedBox(height: 6),
                      Opacity(
                        opacity: canSelectSweetness ? 1.0 : 0.4,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 6.0,
                          runSpacing: 6.0,
                          children: [
                            _sweetnessOption('none', '0%'),
                            _sweetnessOption('light', '25%'),
                            _sweetnessOption('regular', '50%'),
                            _sweetnessOption('extra', '100%'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // CENTER: Cup Preview Only
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Cup Preview
                      _buildCupPreview(),

                      SizedBox(height: 20),

                      // Submit button
                      ElevatedButton(
                        onPressed: isComplete ? _submitMilkTea : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          isComplete ? Color(0xFF87D68D) : Colors.grey,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          'Serve Milk Tea!',
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
              ),

              // RIGHT SIDE: Toppings + Shake Section
              Container(
                width: MediaQuery.of(context).size.width * 0.22,
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // TOPPING SECTION
                      _buildSectionTitle('Topping'),
                      SizedBox(height: 6),
                      Opacity(
                        opacity: canSelectTopping ? 1.0 : 0.4,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 6.0,
                          runSpacing: 6.0,
                          children: [
                            _toppingOption('boba', 'Boba'),
                            _toppingOption('jelly', 'Jelly'),
                            _toppingOption('pudding', 'Pudding'),
                            _toppingOption('none', 'None'),
                          ],
                        ),
                      ),

                      SizedBox(height: 15),

                      // SHAKE SECTION (moved here!)
                      if (canShake) _buildShakeSection(),
                    ],
                  ),
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
      padding: const EdgeInsets.only(top: 4.0, bottom: 3.0),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Caveat',
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFF8B6F8F),
        ),
      ),
    );
  }

  Widget _teaOption(String value, String label, Color color) {
    bool isSelected = selectedTeaBase == value;

    return GestureDetector(
      onTap: () {
        setState(() => selectedTeaBase = value);
        teaController.forward(from: 0);
      },
      child: Container(
        width: 75,
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFFFB6C1) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Color(0xFFFF69B4) : Color(0xFFFFB6C1),
            width: isSelected ? 2.5 : 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade400, width: 1.5),
              ),
            ),
            SizedBox(height: 4),
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

  Widget _toppingOption(String value, String label) {
    bool isSelected = selectedTopping == value;
    bool isEnabled = canSelectTopping;

    return GestureDetector(
      onTap: isEnabled
          ? () {
        setState(() => selectedTopping = value);
        toppingController.forward(from: 0);
      }
          : null,
      child: Container(
        width: 75,
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFFFB6C1) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Color(0xFFFF69B4) : Color(0xFFFFB6C1),
            width: isSelected ? 2.5 : 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              child: _getToppingIcon(value),
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Caveat',
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sweetnessOption(String value, String label) {
    bool isSelected = selectedSweetness == value;
    bool isEnabled = canSelectSweetness;

    return GestureDetector(
      onTap: isEnabled
          ? () {
        setState(() {
          selectedSweetness = value;
          // Start shake detector when sweetness is selected
          if (canShake && shakeCount < requiredShakes) {
            shakeDetector.startListening();
          }
        });
        sweetnessController.forward(from: 0);
      }
          : null,
      child: Container(
        width: 75,
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFFFB6C1) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Color(0xFFFF69B4) : Color(0xFFFFB6C1),
            width: isSelected ? 2.5 : 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.water_drop,
              size: 26,
              color: isSelected ? Colors.white : Color(0xFF87D68D),
            ),
            SizedBox(height: 4),
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

  Widget _buildCupPreview() {
    return AnimatedBuilder(
      animation: shakeController,
      builder: (context, child) {
        // Shake animation offset
        double shakeOffset = isShaking ? (shakeController.value * 10 * (shakeController.value > 0.5 ? -1 : 1)) : 0;

        return Transform.translate(
          offset: Offset(shakeOffset, 0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Cup container
              Container(
                width: 100,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  border: Border.all(color: Color(0xFFFFB6C1), width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFFFB6C1).withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Tea liquid
                    if (selectedTeaBase != null)
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: _teaToColor(selectedTeaBase),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Topping at bottom of cup
              if (selectedTopping != null && selectedTopping != 'none')
                Positioned(
                  bottom: 8,
                  child: Image.asset(
                    _getToppingImagePath(selectedTopping!),
                    width: 90,
                    height: 90,
                    fit: BoxFit.contain,
                  ),
                ),

              // Placeholder text
              if (selectedTeaBase == null)
                Text(
                  'Select\nTea Base',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Caveat',
                    fontSize: 20,
                    color: Colors.grey.shade400,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShakeSection() {
    bool needsMoreShakes = shakeCount < requiredShakes;

    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: needsMoreShakes ? Color(0xFFFFE3DC) : Color(0xFF87D68D).withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: needsMoreShakes ? Color(0xFFFFB6C1) : Color(0xFF87D68D),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            needsMoreShakes ? Icons.phone_android : Icons.check_circle,
            size: 35,
            color: needsMoreShakes ? Color(0xFFFF69B4) : Color(0xFF87D68D),
          ),
          SizedBox(height: 8),
          Text(
            needsMoreShakes ? '📱 Shake Device!' : '✅ Mixed!',
            style: TextStyle(
              fontFamily: 'Caveat',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8B6F8F),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Shakes: $shakeCount/$requiredShakes',
            style: TextStyle(
              fontFamily: 'Caveat',
              fontSize: 18,
              color: Colors.black87,
            ),
          ),

          // DEBUG BUTTON - Only shows in debug mode on simulator
          if (kDebugMode && needsMoreShakes)
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: ElevatedButton(
                onPressed: () {
                  // Manually trigger shake for testing
                  if (shakeCount < requiredShakes) {
                    setState(() {
                      shakeCount++;
                      isShaking = true;
                    });
                    shakeController.forward(from: 0).then((_) {
                      setState(() {
                        isShaking = false;
                      });
                    });

                    // Stop listening once we have enough shakes
                    if (shakeCount >= requiredShakes) {
                      shakeDetector.stopListening();
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  '🧪 Test Shake',
                  style: TextStyle(
                    fontFamily: 'Caveat',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _getToppingIcon(String topping) {
    String? imagePath;

    switch (topping) {
      case 'boba':
        imagePath = 'assets/images/boba.png';
        break;
      case 'jelly':
        imagePath = 'assets/images/jelly.png';
        break;
      case 'pudding':
        imagePath = 'assets/images/pudding.png';
        break;
      case 'none':
        return Icon(Icons.close, size: 26, color: Colors.grey);
      default:
        return Icon(Icons.help, size: 26, color: Colors.grey);
    }

    return Image.asset(
      imagePath,
      width: 26,
      height: 26,
      fit: BoxFit.contain,
    );
  }

  String _getToppingImagePath(String topping) {
    switch (topping) {
      case 'boba':
        return 'assets/images/boba.png';
      case 'jelly':
        return 'assets/images/jelly.png';
      case 'pudding':
        return 'assets/images/pudding.png';
      default:
        return 'assets/images/boba.png'; // Fallback
    }
  }
}