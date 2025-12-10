import '../models/game_character.dart';

/// A dictionary of all characters by ID.
///
/// MilkTeaOrder fields:
///   sweetness: 'none' | 'light' | 'regular' | 'extra'
///   base:      'black' | 'green' | 'oolong' | 'taro'
///   topping:   'boba' | 'jelly' | 'pudding' | 'none'
///
/// CakeOrder fields:
///   cake:    'pink' | 'white' | 'brown' | 'blue'   // frosting / cream color
///   topping: 'strawberry' | 'sprinkles' | 'chocolate' | 'cherry'
const Map<String, GameCharacter> kCharacters = {
  // ────────────── Milk-tea-only characters ──────────────

  "Owl": GameCharacter(
    id: "Owl",
    sprite: "Owl.png",
    milkTeaOrder: MilkTeaOrder(
      sweetness: "regular", // 50%
      base: "black",
      topping: "boba",
    ),
  ),

  "Fox": GameCharacter(
    id: "Fox",
    sprite: "Fox.png",
    milkTeaOrder: MilkTeaOrder(
      sweetness: "light", // 25%
      base: "green",
      topping: "none",
    ),
  ),

  "Frog": GameCharacter(
    id: "Frog",
    sprite: "Frog.png",
    milkTeaOrder: MilkTeaOrder(
      sweetness: "extra", // 100%
      base: "taro",
      topping: "jelly",
    ),
  ),

  "Panda": GameCharacter(
    id: "Panda",
    sprite: "Panda.png",
    milkTeaOrder: MilkTeaOrder(
      sweetness: "light",
      base: "oolong",
      topping: "pudding",
    ),
  ),

  "Raccoon": GameCharacter(
    id: "Raccoon",
    sprite: "Raccoon.png",
    milkTeaOrder: MilkTeaOrder(
      sweetness: "extra",
      base: "black",
      topping: "pudding",
    ),
  ),

  "Squirel": GameCharacter(
    id: "Squirel",
    sprite: "Squirel.png",
    milkTeaOrder: MilkTeaOrder(
      sweetness: "regular",
      base: "green",
      topping: "jelly",
    ),
  ),

  // ────────────── Cake-only characters ──────────────

  "Bear": GameCharacter(
    id: "Bear",
    sprite: "Bear.png",
    cakeOrder: CakeOrder(
      cake: "brown",          // chocolate-colored cream
      topping: "chocolate",
    ),
  ),

  "Deer": GameCharacter(
    id: "Deer",
    sprite: "Deer.png",
    cakeOrder: CakeOrder(
      cake: "white",          // vanilla / whipped cream look
      topping: "strawberry",
    ),
  ),

  "Hedgehog": GameCharacter(
    id: "Hedgehog",
    sprite: "Hedgehog.png",
    cakeOrder: CakeOrder(
      cake: "brown",
      topping: "sprinkles",
    ),
  ),

  // ────────────── Magic / hybrid characters ──────────────

  "Fairy": GameCharacter(
    id: "Fairy",
    sprite: "Fairy.png",
    milkTeaOrder: MilkTeaOrder(
      sweetness: "light",
      base: "oolong",
      topping: "boba",
    ),
    cakeOrder: CakeOrder(
      cake: "pink",
      topping: "strawberry",
    ),
  ),

  "Female Elf": GameCharacter(
    id: "Female Elf",
    sprite: "Female Elf.png",
    milkTeaOrder: MilkTeaOrder(
      sweetness: "regular",
      base: "taro",
      topping: "jelly",
    ),
    cakeOrder: CakeOrder(
      cake: "white",
      topping: "cherry",
    ),
  ),

  "Gnome": GameCharacter(
    id: "Gnome",
    sprite: "Gnome.png",
    milkTeaOrder: MilkTeaOrder(
      sweetness: "regular",
      base: "green",
      topping: "pudding",
    ),
    cakeOrder: CakeOrder(
      cake: "blue",
      topping: "sprinkles",
    ),
  ),

  "Wizard": GameCharacter(
    id: "Wizard",
    sprite: "Wizard.png",
    milkTeaOrder: MilkTeaOrder(
      sweetness: "none",
      base: "black",
      topping: "none",
    ),
    cakeOrder: CakeOrder(
      cake: "blue",
      topping: "chocolate",
    ),
  ),
};
