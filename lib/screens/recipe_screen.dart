import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../models/player.dart';

class RecipeScreen extends StatefulWidget {
  final Player player;

  const RecipeScreen({
    Key? key,
    required this.player,
  }) : super(key: key);

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  final List<Map<String, dynamic>> _allRecipes = [
    {
      'name': 'Strawberry Delight Cake',
      'object': CakeRecipe(
        creamColor: 'pink',
        topping: 'strawberry',
      ),
    },
    {
      'name': 'Chocolate Chip Cake',
      'object': CakeRecipe(
        creamColor: 'brown',
        topping: 'chocolate',
      ),
    },
    {
      'name': 'Funfetti Cake',
      'object': CakeRecipe(
        creamColor: 'blue',
        topping: 'sprinkles',
      )
    },
    {
      'name': 'Brown Sugar Milk Tea',
      'object': MilkTeaRecipe(
        teaBase: 'black',
        sweetness: 'regular',
        topping: 'boba',
      ),
    },
    {
      'name': 'Light Taro Pudding Tea',
      'object': MilkTeaRecipe(
        teaBase: 'taro',
        sweetness: 'light',
        topping: 'pudding',
      ),
    },
    {
      'name': 'Green Tea',
      'object': MilkTeaRecipe(
        teaBase: 'green',
        sweetness: 'none',
        topping: 'none',
      ),
    },
  ];

  Map<String, dynamic>? _selectedRecipeMap;

  @override
  void initState() {
    super.initState();
    _selectedRecipeMap = _allRecipes.first;
  }

  Color _getTeaColorFromText(String teaBaseKey) {
    switch (teaBaseKey) {
      case 'black':
        return const Color(0xFF4A2511);
      case 'green':
        return const Color(0xFF98D8AA);
      case 'oolong':
        return const Color(0xFFC68B59);
      case 'taro':
        return const Color(0xFFB19CD9);
      default:
        return Colors.grey;
    }
  }

  Widget _buildMilkTeaDetailRow(String label, String value, String key, String type, TextStyle style) {
    Widget iconWidget;

    if (type == 'teaBase') {
      iconWidget = Container(
        width: 30,
        height: 30,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: _getTeaColorFromText(key),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey.shade400, width: 1),
        ),
      );
    } else if (type == 'sweetness') {
      iconWidget = const SizedBox(width: 40, height: 30);
    } else if (type == 'topping') {
      if (key == 'none') {
        iconWidget = const SizedBox(width: 40, height: 30);
      } else {
        iconWidget = Container(
          width: 30,
          height: 30,
          margin: const EdgeInsets.only(right: 10),
          child: Image.asset(
            'assets/images/$key.png',
            errorBuilder: (context, error, stackTrace) =>
            const Icon(
                Icons.fiber_manual_record, size: 20, color: Colors.brown),
          ),
        );
      }
    } else {
      iconWidget = const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        children: [
          iconWidget,
          Text(
            '$label ',
            style: style.copyWith(fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: style,
          ),
        ],
      ),
    );
  }

  Widget _formatRecipeDetails(dynamic recipeObject) {
    const TextStyle detailStyle = TextStyle(
      fontSize: 20,
      fontFamily: 'Caveat',
      color: Color(0xFF4E4E4E),
    );

    const TextStyle headerStyle = TextStyle(
      fontSize: 22,
      fontFamily: 'Caveat',
      fontWeight: FontWeight.bold,
      color: Color(0xFF8B6F8F),
    );

    if (recipeObject is CakeRecipe) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cake Type: Standard',
            style: headerStyle,
          ),
          const SizedBox(height: 10),
          const Text(
            'Ingredients:',
            style: headerStyle,
          ),
          const SizedBox(height: 5),

          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: _getColorFromText(recipeObject.creamColor),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade400),
                ),
              ),
              Text('Cream Color: ${recipeObject.creamColor.toUpperCase()}',
                  style: detailStyle),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                margin: const EdgeInsets.only(right: 10),
                child: Image.asset(
                  'assets/images/${recipeObject.topping.toLowerCase()}.png',
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.star, size: 30, color: Color(0xFFFFB6C1)),
                ),
              ),
              Text('Topping: ${recipeObject.topping.toUpperCase()}',
                  style: detailStyle),
            ],
          ),

          const SizedBox(height: 20),
        ],
      );
    } else if (recipeObject is MilkTeaRecipe) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Milk Tea Type: Standard',
            style: headerStyle,
          ),
          const SizedBox(height: 10),
          const Text('Ingredients:', style: headerStyle),
          const SizedBox(height: 5),

          _buildMilkTeaDetailRow(
              'Tea Base:',
              recipeObject.getTeaBaseName(),
              recipeObject.teaBase,
              'teaBase',
              detailStyle
          ),
          _buildMilkTeaDetailRow(
              'Sweetness:',
              recipeObject.getSweetnessName(),
              recipeObject.sweetness,
              'sweetness',
              detailStyle
          ),
          _buildMilkTeaDetailRow(
              'Topping:',
              recipeObject.getToppingName(),
              recipeObject.topping,
              'topping',
              detailStyle
          ),
        ],
      );
    }

    return const Text(
        'Recipe details unavailable for this type.', style: detailStyle);
  }

  Color _getColorFromText(String colorText) {
    switch (colorText.toLowerCase()) {
      case 'white':
        return Colors.white;
      case 'pink':
        return Colors.pink.shade100;
      case 'brown':
        return Colors.brown;
      case 'blue':
        return Colors.blue.shade100;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    String recipeName = _selectedRecipeMap?['name'] ?? 'Select a recipe';

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/StartPage.jpeg',
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Top Bar with white background and styled text
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left - Day and Level with Caveat styling
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Day ${widget.player.day}',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Caveat',
                              color: Color(0xFF8B6F8F),
                            ),
                          ),
                          Text(
                            'Level: ${widget.player.level}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontFamily: 'Caveat',
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF8B6F8F),
                            ),
                          ),
                        ],
                      ),

                      // Middle - Money with Caveat styling
                      Text(
                        'Money: \$${widget.player.money}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontFamily: 'Caveat',
                          color: Color(0xFF87D68D),
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // Right - Nav buttons
                      Row(
                        children: [
                          _buildIconButton(
                            icon: Icons.arrow_back,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const SizedBox(width: 8),
                          _buildIconButton(
                            icon: Icons.person,
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/profile',
                                arguments: widget.player,
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          _buildIconButton(
                            icon: Icons.home,
                            onPressed: () {
                              Navigator.pushNamed(context, '/starting');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Main content area
                Expanded(
                  child: Row(
                    children: [
                      // Sidebar with scrollable recipe list
                      Container(
                        width: 150,
                        margin: const EdgeInsets.only(
                            top: 10, bottom: 10, left: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListView.builder(
                          itemCount: _allRecipes.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> recipeMap = _allRecipes[index];
                            bool isSelected = recipeMap['name'] ==
                                _selectedRecipeMap?['name'];

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedRecipeMap = recipeMap;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 6),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFFFFB6C1)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  recipeMap['name'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Caveat',
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF8B6F8F),
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Recipe display area
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: _selectedRecipeMap == null
                              ? const Center(
                            child: Text(
                              'Select a recipe from the sidebar',
                              style: TextStyle(
                                fontSize: 22,
                                fontFamily: 'Caveat',
                                color: Color(0xFF8B6F8F),
                              ),
                            ),
                          )
                              : SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  recipeName,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Caveat',
                                    color: Color(0xFF8B6F8F),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                _formatRecipeDetails(_selectedRecipeMap!['object']),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({required IconData icon, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFB6C1),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon),
        color: Colors.white,
        iconSize: 24,
        onPressed: onPressed,
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(),
      ),
    );
  }
}