import 'package:flutter/material.dart';

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
  // Example recipe data
  final Map<String, String> _recipes = {
    'Pancakes':
    'Ingredients:\n- 1 cup flour\n- 1 egg\n- 1 cup milk\n\nSteps:\n1. Mix ingredients.\n2. Cook on a pan.\n3. Serve with syrup.',
    'Salad':
    'Ingredients:\n- Lettuce\n- Tomato\n- Cucumber\n\nSteps:\n1. Chop veggies.\n2. Toss with dressing.\n3. Serve fresh.',
    'Spaghetti':
    'Ingredients:\n- Spaghetti noodles\n- Tomato sauce\n- Garlic, onions\n\nSteps:\n1. Boil noodles.\n2. Make sauce.\n3. Combine and serve.',
    'Cupcakes':
    'Ingredients:\n- 2 cups flour\n- 1 cup sugar\n- 2 eggs\n\nSteps:\n1. Mix batter.\n2. Bake for 20 mins.\n3. Frost and enjoy!',
  };

  String? _selectedRecipe;

  @override
  void initState() {
    super.initState();
    _selectedRecipe = _recipes.keys.first; // Default to first recipe
  }

  @override
  Widget build(BuildContext context) {
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
                    color: Colors.white.withValues(alpha: 0.85),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
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

                      // Right - Nav buttons
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
                          color: Colors.white.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListView.builder(
                          itemCount: _recipes.keys.length,
                          itemBuilder: (context, index) {
                            String recipeName = _recipes.keys.elementAt(index);
                            bool isSelected = recipeName == _selectedRecipe;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedRecipe = recipeName;
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
                                  recipeName,
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
                            color: Colors.white.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: _selectedRecipe == null
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
                                  _selectedRecipe!,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Caveat',
                                    color: Color(0xFF8B6F8F),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  _recipes[_selectedRecipe]!,
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

  // Reuse same icon button style
  Widget _buildIconButton({required IconData icon, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFB6C1),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
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
