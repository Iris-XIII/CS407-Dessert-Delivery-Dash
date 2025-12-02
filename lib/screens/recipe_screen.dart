import 'package:flutter/material.dart';
import '../models/recipe.dart';

class RecipeScreen extends StatefulWidget {
  final int dayNumber;
  final int level;
  final double money;

  const RecipeScreen({
    Key? key,
    this.dayNumber = 1,
    this.level = 1,
    this.money = 0.0,
  }) : super(key: key);

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  final List<Map<String, dynamic>> _allRecipes = [
    // Cake Recipes
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

    // Milk Tea Recipes
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
      'name': 'Green Tea No Sugar',
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
    _selectedRecipeMap = _allRecipes.first; // Default to the first recipe
  }

  // Helper method to format recipe details based on type
  String _formatRecipeDetails(dynamic recipeObject) {
    if (recipeObject is Recipe) {
      // Logic for the base Recipe
      String ingredientsList = recipeObject.ingredients.map((i) => '- $i').join('\n');
      return '''
Ingredients:
$ingredientsList

Preparation Time: ${recipeObject.preparationTime} minutes

Selling Price: \$${recipeObject.price.toStringAsFixed(2)}
''';
    } else if (recipeObject is CakeRecipe) {
      // Logic for CakeRecipe
      return '''
Cake Type: Custom Cake

Specifications:
- Cream Color: ${recipeObject.creamColor.toUpperCase()}
- Topping: ${recipeObject.topping.toUpperCase()}

NOTE: Prices and Preparation Times are determined by the customer order.
''';
    } else if (recipeObject is MilkTeaRecipe) {
      // Logic for MilkTeaRecipe
      // Uses the helper methods defined in your MilkTeaRecipe model
      return '''
Milk Tea Type: Custom Drink

Order Description:
${recipeObject.getFullOrderDescription()}

Details:
- Tea Base: ${recipeObject.getTeaBaseName()}
- Sweetness: ${recipeObject.getSweetnessName()}
- Topping: ${recipeObject.getToppingName()}
''';
    }
    return 'Recipe details unavailable for this type.';
  }

  @override
  Widget build(BuildContext context) {
    // Determine the name for display. The 'name' key in the map holds the descriptive title.
    String recipeName = _selectedRecipeMap?['name'] ?? 'Select a recipe';

    return Scaffold(
      body: Stack(
        children: [
          // Background
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
                // Top Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
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
                      // Left - Day and Level
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Day ${widget.dayNumber}',
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Caveat',
                              color: Color(0xFF8B6F8F),
                            ),
                          ),
                          Text(
                            'Level: ${widget.level}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontFamily: 'Caveat',
                              color: Color(0xFF8B6F8F),
                            ),
                          ),
                        ],
                      ),

                      // Middle - Money
                      Text(
                        'Money: \$${widget.money.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'Caveat',
                          color: Color(0xFF87D68D),
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // Right - Nav buttons (using the corrected _buildIconButton)
                      Row(
                        children: [
                          _buildIconButton(
                            icon: Icons.person,
                            onPressed: () {
                              Navigator.pushNamed(context, '/profile');
                            },
                          ),
                          const SizedBox(width: 8),
                          _buildIconButton(
                            icon: Icons.restaurant,
                            onPressed: () {
                              Navigator.pushNamed(context, '/kitchen');
                            },
                          ),
                          const SizedBox(width: 8),
                          _buildIconButton(
                            icon: Icons.home,
                            onPressed: () {
                              Navigator.pushNamed(context, '/starting');
                            },
                          ),
                          const SizedBox(width: 8),
                          _buildIconButton(
                            icon: Icons.people,
                            onPressed: () {
                              Navigator.pushNamed(context, '/customer-reception');
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
                        margin: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
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
                            bool isSelected = recipeMap['name'] == _selectedRecipeMap?['name'];

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedRecipeMap = recipeMap;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
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
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
                                // Recipe Name (from the Map's 'name' key)
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
                                // Recipe Details (using the dynamic object from the Map)
                                Text(
                                  _formatRecipeDetails(_selectedRecipeMap!['object']),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Caveat',
                                    color: Color(0xFF4E4E4E),
                                  ),
                                ),
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

  // Reuse same icon button style (using .withOpacity for correctness)
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