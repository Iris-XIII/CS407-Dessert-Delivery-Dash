import '../models/game_character.dart';

/// A dictionary of all characters by ID.
const Map<String, GameCharacter> kCharacters = {
  // Milk tea–only characters
  "Owl": GameCharacter(
    id: "Owl",
    sprite: "Owl.png",
    milkTeaOrder: "Black tea, 50% sweet, classic boba",
  ),
  "Fox": GameCharacter(
    id: "Fox",
    sprite: "Fox.png",
    milkTeaOrder: "Earl Grey milk tea, 30% sweet, no toppings",
    cakeOrder: "Chocolate cake, 2 layers, chocolate frosting, sprinkles",
  ),
  "squirrel": GameCharacter(
    id: "squirrel",
    sprite: "squirrel.png",
    milkTeaOrder: "Oolong tea, 70% sweet, tapioca pearls",
  ),
  "deer": GameCharacter(
    id: "deer",
    sprite: "deer.png",
    milkTeaOrder: "Jasmine green tea, 25% sweet, aloe vera",
  ),
  "raccoon": GameCharacter(
    id: "raccoon",
    sprite: "raccoon.png",
    milkTeaOrder: "Brown sugar milk, 100% sweet, boba + pudding",
  ),
  "Frog": GameCharacter(
    id: "Frog",
    sprite: "Frog.png",
    milkTeaOrder: "Matcha latte, 50% sweet, red bean",
  ),
  "rabbit": GameCharacter(
    id: "rabbit",
    sprite: "rabbit.png",
    milkTeaOrder: "Taro milk tea, 75% sweet, grass jelly",
  ),

  // Cake-only characters
  "bear": GameCharacter(
    id: "bear",
    sprite: "bear.png",
    cakeOrder: "Chocolate cake, 2 layers, chocolate frosting, sprinkles",
  ),
  "hedgehog": GameCharacter(
    id: "hedgehog",
    sprite: "hedgehog.png",
    cakeOrder: "Vanilla cake, 1 layer, pink frosting, strawberry slices",
  ),
  "cat": GameCharacter(
    id: "cat",
    sprite: "cat.png",
    cakeOrder: "Lemon sponge, 2 layers, white frosting, blueberry topping",
  ),
  "dog": GameCharacter(
    id: "dog",
    sprite: "dog.png",
    cakeOrder: "Red velvet, 3 layers, cream cheese frosting, no toppings",
  ),
  "mouse": GameCharacter(
    id: "mouse",
    sprite: "mouse.png",
    cakeOrder: "Cheesecake, 1 layer, plain, raspberry drizzle",
  ),
  "panda": GameCharacter(
    id: "panda",
    sprite: "panda.png",
    cakeOrder: "Matcha roll cake, 1 layer, whipped cream, azuki beans",
  ),
  "koala": GameCharacter(
    id: "koala",
    sprite: "koala.png",
    cakeOrder: "Coconut cake, 2 layers, coconut frosting, toasted flakes",
  ),
};