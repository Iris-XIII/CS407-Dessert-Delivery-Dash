import '../models/day_plan.dart';

/// 30 days, max 8 customers per day, roughly increasing difficulty.
///
/// Valid character IDs (from characters.dart):
///   Bear, Deer, Fairy, Female Elf, Fox, Frog,
///   Gnome, Hedgehog, Owl, Panda, Raccoon, Squirrel, Wizard
const List<day_plan> kDays = [
  // Days 1–5: very easy, 2–3 customers
  day_plan(dayNumber: 1, characterIds: ["Owl", "Bear"]),
  day_plan(dayNumber: 2, characterIds: ["Fox", "Owl", "Frog"]),
  day_plan(dayNumber: 3, characterIds: ["Frog", "Squirel", "Bear"]),
  day_plan(dayNumber: 4, characterIds: ["Owl", "Panda", "Deer"]),
  day_plan(dayNumber: 5, characterIds: ["Hedgehog", "Squirel", "Fox"]),

  // Days 6–10: 3–4 customers, mix of tea + cake
  day_plan(dayNumber: 6, characterIds: ["Owl", "Bear", "Squirel", "Fox"]),
  day_plan(dayNumber: 7, characterIds: ["Fox", "Frog", "Panda", "Deer"]),
  day_plan(dayNumber: 8, characterIds: ["Hedgehog", "Raccoon", "Owl", "Bear"]),
  day_plan(dayNumber: 9, characterIds: ["Squirel", "Panda", "Frog", "Deer"]),
  day_plan(dayNumber: 10, characterIds: ["Raccoon", "Fox", "Hedgehog", "Owl"]),

  // Days 11–15: 4–5 customers, start introducing magic characters
  day_plan(dayNumber: 11, characterIds: ["Fairy", "Owl", "Fox", "Bear"]),
  day_plan(dayNumber: 12, characterIds: ["Frog", "Squirel", "Panda", "Deer"]),
  day_plan(dayNumber: 13, characterIds: ["Hedgehog", "Raccoon", "Fairy", "Owl", "Fox"]),
  day_plan(dayNumber: 14, characterIds: ["Bear", "Squirel", "Panda", "Frog", "Deer"]),
  day_plan(dayNumber: 15, characterIds: ["Fox", "Hedgehog", "Raccoon", "Owl", "Fairy"]),

  // Days 16–20: 5–6 customers, add Gnome and Wizard
  day_plan(dayNumber: 16, characterIds: ["Gnome", "Owl", "Bear", "Squirel", "Fox"]),
  day_plan(dayNumber: 17, characterIds: ["Frog", "Panda", "Deer", "Hedgehog", "Raccoon"]),
  day_plan(dayNumber: 18, characterIds: ["Fairy", "Gnome", "Owl", "Fox", "Squirel", "Bear"]),
  day_plan(dayNumber: 19, characterIds: ["Panda", "Frog", "Deer", "Hedgehog", "Raccoon", "Owl"]),
  day_plan(dayNumber: 20, characterIds: ["Wizard", "Fox", "Squirel", "Bear", "Gnome", "Fairy"]),

  // Days 21–25: 6–7 customers, include Female Elf
  day_plan(dayNumber: 21, characterIds: ["Owl", "Fox", "Squirel", "Bear", "Frog", "Panda", "Deer"]),
  day_plan(dayNumber: 22, characterIds: ["Hedgehog", "Raccoon", "Gnome", "Fairy", "Female Elf", "Owl"]),
  day_plan(dayNumber: 23, characterIds: ["Fox", "Squirel", "Bear", "Frog", "Panda", "Deer", "Female Elf"]),
  day_plan(dayNumber: 24, characterIds: ["Raccoon", "Hedgehog", "Gnome", "Fairy", "Wizard", "Owl", "Fox"]),
  day_plan(dayNumber: 25, characterIds: ["Bear", "Squirel", "Panda", "Frog", "Deer", "Female Elf", "Wizard"]),

  // Days 26–30: 7–8 customers (max difficulty)
  day_plan(dayNumber: 26, characterIds: [
    "Owl",
    "Fox",
    "Squirel",
    "Bear",
    "Frog",
    "Panda",
    "Raccoon",
  ]),
  day_plan(dayNumber: 27, characterIds: [
    "Hedgehog",
    "Gnome",
    "Fairy",
    "Female Elf",
    "Owl",
    "Fox",
    "Squirel",
  ]),
  day_plan(dayNumber: 28, characterIds: [
    "Bear",
    "Frog",
    "Panda",
    "Deer",
    "Raccoon",
    "Hedgehog",
    "Gnome",
    "Fairy",
  ]),
  day_plan(dayNumber: 29, characterIds: [
    "Wizard",
    "Owl",
    "Fox",
    "Squirel",
    "Bear",
    "Panda",
    "Raccoon",
    "Female Elf",
  ]),
  day_plan(dayNumber: 30, characterIds: [
    "Wizard",
    "Fairy",
    "Female Elf",
    "Gnome",
    "Owl",
    "Fox",
    "Squirel",
    "Bear",
  ]),
];
