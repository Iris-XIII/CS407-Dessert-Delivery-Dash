import 'package:dessert_delivery_dash/models/day_plan.dart';

import '../models/day_plan.dart';

/// 30 days, max 8 customers per day, roughly increasing difficulty.
const List<day_plan> kDays = [
  // Days 1–5: very easy, 2–3 customers
  day_plan(dayNumber: 1, characterIds: ["Owl", "bear"]),
  day_plan(dayNumber: 2, characterIds: ["Fox", "Owl", "Frog"]),
  day_plan(dayNumber: 3, characterIds: ["Frog", "cat", "squirrel"]),
  day_plan(dayNumber: 4, characterIds: ["frog", "mouse", "owl"]),
  day_plan(dayNumber: 5, characterIds: ["rabbit", "hedgehog", "deer"]),

  // Days 6–10: 3–4 customers, mix of tea + cake
  day_plan(dayNumber: 6, characterIds: ["owl", "bear", "squirrel", "cat"]),
  day_plan(dayNumber: 7, characterIds: ["fox", "dog", "frog", "mouse"]),
  day_plan(dayNumber: 8, characterIds: ["deer", "panda", "rabbit", "bear"]),
  day_plan(dayNumber: 9, characterIds: ["raccoon", "cat", "owl", "hedgehog"]),
  day_plan(dayNumber: 10, characterIds: ["squirrel", "koala", "fox", "mouse"]),

  // Days 11–15: 4–5 customers
  day_plan(dayNumber: 11, characterIds: ["owl", "fox", "bear", "cat", "frog"]),
  day_plan(dayNumber: 12, characterIds: ["rabbit", "dog", "deer", "mouse", "panda"]),
  day_plan(dayNumber: 13, characterIds: ["raccoon", "hedgehog", "squirrel", "cat", "owl"]),
  day_plan(dayNumber: 14, characterIds: ["frog", "bear", "koala", "fox", "mouse"]),
  day_plan(dayNumber: 15, characterIds: ["panda", "rabbit", "deer", "cat", "hedgehog"]),

  // Days 16–20: 5–6 customers
  day_plan(dayNumber: 16, characterIds: ["owl", "fox", "squirrel", "bear", "cat", "mouse"]),
  day_plan(dayNumber: 17, characterIds: ["frog", "raccoon", "deer", "dog", "hedgehog", "rabbit"]),
  day_plan(dayNumber: 18, characterIds: ["panda", "koala", "owl", "cat", "mouse", "bear"]),
  day_plan(dayNumber: 19, characterIds: ["fox", "squirrel", "frog", "panda", "dog", "hedgehog"]),
  day_plan(dayNumber: 20, characterIds: ["rabbit", "deer", "raccoon", "cat", "mouse", "koala"]),

  // Days 21–25: 6–7 customers
  day_plan(dayNumber: 21, characterIds: ["owl", "fox", "squirrel", "bear", "cat", "frog", "mouse"]),
  day_plan(dayNumber: 22, characterIds: ["rabbit", "deer", "panda", "dog", "hedgehog", "koala", "owl"]),
  day_plan(dayNumber: 23, characterIds: ["raccoon", "fox", "squirrel", "cat", "mouse", "bear", "frog"]),
  day_plan(dayNumber: 24, characterIds: ["deer", "rabbit", "panda", "koala", "hedgehog", "dog", "owl"]),
  day_plan(dayNumber: 25, characterIds: ["fox", "squirrel", "frog", "bear", "cat", "mouse", "raccoon"]),

  // Days 26–30: 7–8 customers (max difficulty)
  day_plan(dayNumber: 26, characterIds: ["owl", "fox", "squirrel", "bear", "cat", "frog", "mouse", "panda"]),
  day_plan(dayNumber: 27, characterIds: ["rabbit", "deer", "raccoon", "dog", "hedgehog", "koala", "owl", "cat"]),
  day_plan(dayNumber: 28, characterIds: ["panda", "fox", "squirrel", "bear", "mouse", "frog", "deer", "rabbit"]),
  day_plan(dayNumber: 29, characterIds: ["raccoon", "koala", "hedgehog", "cat", "dog", "owl", "squirrel", "mouse"]),
  day_plan(dayNumber: 30, characterIds: ["owl", "fox", "frog", "panda", "bear", "cat", "rabbit", "raccoon"]),
];
