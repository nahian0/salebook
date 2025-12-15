// Complete VoiceParserProductUpdated with Enhanced Number Extraction

class VoiceParserProductUpdated {
  // Comprehensive product database with Bangla names and variations
  static const Map<String, Map<String, dynamic>> _productDatabase = {
    // Grains & Rice
    'চাল': {
      'variations': ['চাল', 'chal', 'rice', 'ধান'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Grains'
    },
    'আটা': {
      'variations': ['আটা', 'atta', 'ata', 'flour', 'ময়দা'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Grains'
    },
    'ময়দা': {
      'variations': ['ময়দা', 'moida', 'maida', 'refined flour'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Grains'
    },
    'সুজি': {
      'variations': ['সুজি', 'suji', 'sooji', 'semolina'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Grains'
    },
    'চিড়া': {
      'variations': ['চিড়া', 'chira', 'flattened rice', 'poha'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Grains'
    },
    'মুড়ি': {
      'variations': ['মুড়ি', 'muri', 'puffed rice'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Grains'
    },

    // Pulses & Lentils
    'ডাল': {
      'variations': ['ডাল', 'dal', 'daal', 'lentils'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Pulses'
    },
    'মসুর ডাল': {
      'variations': ['মসুর', 'মসুর ডাল', 'masoor', 'red lentils'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Pulses'
    },
    'মুগ ডাল': {
      'variations': ['মুগ', 'মুগ ডাল', 'moong', 'mung dal'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Pulses'
    },
    'ছোলা': {
      'variations': ['ছোলা', 'chola', 'chickpeas', 'বুট'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Pulses'
    },
    'মটর': {
      'variations': ['মটর', 'motor', 'peas'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Pulses'
    },

    // Vegetables
    'আলু': {
      'variations': ['আলু', 'alu', 'aloo', 'potato', 'potatoes'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Vegetables'
    },
    'পেঁয়াজ': {
      'variations': ['পেঁয়াজ', 'পিয়াজ', 'peyaj', 'piaj', 'onion', 'onions'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Vegetables'
    },
    'রসুন': {
      'variations': ['রসুন', 'rosun', 'garlic'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Vegetables'
    },
    'আদা': {
      'variations': ['আদা', 'ada', 'ginger'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Vegetables'
    },
    'টমেটো': {
      'variations': ['টমেটো', 'টোমাটো', 'tomato', 'tomatoes'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Vegetables'
    },
    'বেগুন': {
      'variations': ['বেগুন', 'begun', 'eggplant', 'brinjal'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Vegetables'
    },
    'গাজর': {
      'variations': ['গাজর', 'gajor', 'carrot', 'carrots'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Vegetables'
    },
    'মুলা': {
      'variations': ['মুলা', 'mula', 'radish'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Vegetables'
    },
    'পালং শাক': {
      'variations': ['পালং', 'পালং শাক', 'palang', 'spinach'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Vegetables'
    },
    'লাউ': {
      'variations': ['লাউ', 'lau', 'bottle gourd'],
      'defaultUnit': 'Piece',
      'category': 'Vegetables'
    },
    'কুমড়া': {
      'variations': ['কুমড়া', 'কুমড়ো', 'kumra', 'pumpkin'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Vegetables'
    },
    'শসা': {
      'variations': ['শসা', 'shasha', 'cucumber'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Vegetables'
    },
    'করলা': {
      'variations': ['করলা', 'korola', 'bitter gourd'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Vegetables'
    },
    'ঝিঙ্গা': {
      'variations': ['ঝিঙ্গা', 'jhinga', 'ridge gourd'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Vegetables'
    },
    'কাঁচা মরিচ': {
      'variations': ['মরিচ', 'কাঁচা মরিচ', 'morich', 'green chili', 'chilli'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Vegetables'
    },
    'ফুলকপি': {
      'variations': ['ফুলকপি', 'fulkopi', 'cauliflower'],
      'defaultUnit': 'Piece',
      'category': 'Vegetables'
    },
    'বাঁধাকপি': {
      'variations': ['বাঁধাকপি', 'bandhakopi', 'cabbage'],
      'defaultUnit': 'Piece',
      'category': 'Vegetables'
    },

    // Fruits
    'আম': {
      'variations': ['আম', 'aam', 'mango', 'mangoes'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Fruits'
    },
    'কলা': {
      'variations': ['কলা', 'kola', 'banana', 'bananas'],
      'defaultUnit': 'Dozen',
      'category': 'Fruits'
    },
    'আপেল': {
      'variations': ['আপেল', 'apple', 'apples'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Fruits'
    },
    'কমলা': {
      'variations': ['কমলা', 'komola', 'orange', 'oranges'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Fruits'
    },
    'আঙুর': {
      'variations': ['আঙুর', 'angur', 'grapes'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Fruits'
    },
    'তরমুজ': {
      'variations': ['তরমুজ', 'tormuj', 'watermelon'],
      'defaultUnit': 'Piece',
      'category': 'Fruits'
    },
    'পেঁপে': {
      'variations': ['পেঁপে', 'পেপে', 'pepe', 'papaya'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Fruits'
    },
    'লিচু': {
      'variations': ['লিচু', 'lichu', 'lychee', 'litchi'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Fruits'
    },
    'জাম': {
      'variations': ['জাম', 'jam', 'blackberry'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Fruits'
    },

    // Meat & Fish
    'মুরগি': {
      'variations': ['মুরগি', 'মুরগির মাংস', 'murgi', 'chicken'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Meat'
    },
    'গরুর মাংস': {
      'variations': ['গরুর মাংস', 'গরু', 'beef', 'cow meat'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Meat'
    },
    'খাসির মাংস': {
      'variations': ['খাসির মাংস', 'খাসি', 'mutton', 'goat meat'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Meat'
    },
    'মাছ': {
      'variations': ['মাছ', 'mach', 'fish'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Fish'
    },
    'রুই মাছ': {
      'variations': ['রুই', 'রুই মাছ', 'rui', 'rohu fish'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Fish'
    },
    'কাতলা মাছ': {
      'variations': ['কাতলা', 'কাতলা মাছ', 'katla', 'catla fish'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Fish'
    },
    'ইলিশ মাছ': {
      'variations': ['ইলিশ', 'ইলিশ মাছ', 'ilish', 'hilsa fish'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Fish'
    },
    'চিংড়ি': {
      'variations': ['চিংড়ি', 'chingri', 'prawn', 'shrimp'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Fish'
    },

    // Dairy Products
    'দুধ': {
      'variations': ['দুধ', 'dudh', 'milk'],
      'defaultUnit': 'Liter (L)',
      'category': 'Dairy'
    },
    'দই': {
      'variations': ['দই', 'doi', 'yogurt', 'curd'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Dairy'
    },
    'মাখন': {
      'variations': ['মাখন', 'makhan', 'butter'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Dairy'
    },
    'পনির': {
      'variations': ['পনির', 'ponir', 'cheese', 'paneer'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Dairy'
    },
    'ঘি': {
      'variations': ['ঘি', 'ghee', 'clarified butter'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Dairy'
    },

    // Eggs
    'ডিম': {
      'variations': ['ডিম', 'dim', 'egg', 'eggs'],
      'defaultUnit': 'Dozen',
      'category': 'Eggs'
    },
    'হাঁসের ডিম': {
      'variations': ['হাঁসের ডিম', 'duck egg', 'duck eggs'],
      'defaultUnit': 'Dozen',
      'category': 'Eggs'
    },

    // Oils & Ghee
    'তেল': {
      'variations': ['তেল', 'tel', 'oil'],
      'defaultUnit': 'Liter (L)',
      'category': 'Oil'
    },
    'সয়াবিন তেল': {
      'variations': ['সয়াবিন', 'সয়াবিন তেল', 'soybean oil'],
      'defaultUnit': 'Liter (L)',
      'category': 'Oil'
    },
    'সরিষার তেল': {
      'variations': ['সরিষার তেল', 'সরিষা', 'mustard oil'],
      'defaultUnit': 'Liter (L)',
      'category': 'Oil'
    },

    // Spices
    'লবণ': {
      'variations': ['লবণ', 'lobon', 'salt'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Spices'
    },
    'চিনি': {
      'variations': ['চিনি', 'chini', 'sugar'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Spices'
    },
    'হলুদ': {
      'variations': ['হলুদ', 'holud', 'turmeric'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Spices'
    },
    'মরিচ গুঁড়া': {
      'variations': ['মরিচ গুঁড়া', 'মরিচের গুঁড়া', 'chili powder'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Spices'
    },
    'ধনিয়া': {
      'variations': ['ধনিয়া', 'dhonia', 'coriander'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Spices'
    },
    'জিরা': {
      'variations': ['জিরা', 'jira', 'cumin'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Spices'
    },
    'এলাচ': {
      'variations': ['এলাচ', 'elach', 'cardamom'],
      'defaultUnit': 'Gram (g)',
      'category': 'Spices'
    },
    'দারচিনি': {
      'variations': ['দারচিনি', 'darchini', 'cinnamon'],
      'defaultUnit': 'Gram (g)',
      'category': 'Spices'
    },
    'লবঙ্গ': {
      'variations': ['লবঙ্গ', 'lobongo', 'cloves'],
      'defaultUnit': 'Gram (g)',
      'category': 'Spices'
    },
    'গরম মসলা': {
      'variations': ['গরম মসলা', 'gorom moshla', 'garam masala'],
      'defaultUnit': 'Gram (g)',
      'category': 'Spices'
    },

    // Beverages
    'চা': {
      'variations': ['চা', 'cha', 'tea'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Beverages'
    },
    'কফি': {
      'variations': ['কফি', 'coffee'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Beverages'
    },
    'পানি': {
      'variations': ['পানি', 'pani', 'water'],
      'defaultUnit': 'Liter (L)',
      'category': 'Beverages'
    },

    // Snacks & Others
    'বিস্কুট': {
      'variations': ['বিস্কুট', 'biscuit', 'biscuits', 'cookies'],
      'defaultUnit': 'Pack',
      'category': 'Snacks'
    },
    'চানাচুর': {
      'variations': ['চানাচুর', 'chanachur', 'mixture'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Snacks'
    },
    'কেক': {
      'variations': ['কেক', 'cake'],
      'defaultUnit': 'Piece',
      'category': 'Snacks'
    },
    'রুটি': {
      'variations': ['রুটি', 'ruti', 'bread'],
      'defaultUnit': 'Piece',
      'category': 'Bakery'
    },
    'বান': {
      'variations': ['বান', 'bun', 'buns'],
      'defaultUnit': 'Piece',
      'category': 'Bakery'
    },
    'সাবান': {
      'variations': ['সাবান', 'soap'],
      'defaultUnit': 'Piece',
      'category': 'Household'
    },
    'ডিটারজেন্ট': {
      'variations': ['ডিটারজেন্ট', 'detergent', 'washing powder'],
      'defaultUnit': 'Kilogram (kg)',
      'category': 'Household'
    },
    'টিস্যু': {
      'variations': ['টিস্যু', 'tissue', 'tissues'],
      'defaultUnit': 'Box',
      'category': 'Household'
    },
  };

  // All supported units with their variations
  static const Map<String, List<String>> _unitVariations = {
    'কেজি': [
      'কেজি', 'কিলোগ্রাম', 'কিলো', 'কেজিএম',
      'kilogram', 'kilograms', 'kg', 'kgs', 'kilo', 'kilos'
    ],
    'গ্রাম': [
      'গ্রাম',
      'gram', 'grams', 'g', 'gm', 'gms'
    ],
    'লিটার': [
      'লিটার',
      'liter', 'liters', 'litre', 'litres', 'l'
    ],
    'মিলিলিটার': [
      'মিলিলিটার', 'এমএল',
      'milliliter', 'milliliters', 'millilitre', 'millilitres', 'ml'
    ],
    'পিস': [
      'পিস', 'টা', 'টি', 'খানা', 'খান',
      'piece', 'pieces', 'pcs', 'pc', 'ta'
    ],
    'ডজন': [
      'ডজন',
      'dozen', 'doz'
    ],
    'প্যাক': [
      'প্যাক', 'প্যাকেট', 'প্যাকেজ',
      'pack', 'packs', 'packet', 'packets', 'package', 'packages'
    ],
    'বক্স': [
      'বক্স', 'বাক্স',
      'box', 'boxes'
    ],
    'বোতল': [
      'বোতল',
      'bottle', 'bottles', 'btl'
    ],
    'ক্যান': [
      'ক্যান', 'ক্যান',
      'can', 'cans', 'tin', 'tins'
    ],
    'ব্যাগ': [
      'ব্যাগ', 'থলে',
      'bag', 'bags', 'sack', 'sacks'
    ],
    'বান্ডিল': [
      'বান্ডিল', 'বান্ডেল', 'আঁটি',
      'bundle', 'bundles', 'bunch', 'bunches'
    ],
    'কার্টন': [
      'কার্টন',
      'carton', 'cartons'
    ],
    'জার': [
      'জার',
      'jar', 'jars'
    ],
    'পাউন্ড': [
      'পাউন্ড',
      'pound', 'pounds', 'lb', 'lbs'
    ],
    'টন': [
      'টন', 'মেট্রিক টন',
      'ton', 'tons', 'tonne', 'tonnes', 'mt'
    ],
    'কুইন্টাল': [
      'কুইন্টাল', 'মণ',
      'quintal', 'quintals', 'mon', 'maund'
    ],
    'সের': [
      'সের',
      'ser', 'seer'
    ],
    'ছটাক': [
      'ছটাক',
      'chhatak', 'chattak'
    ],
    'গজ': [
      'গজ',
      'yard', 'yards', 'yd', 'yds'
    ],
    'ফুট': [
      'ফুট',
      'foot', 'feet', 'ft'
    ],
    'ইঞ্চি': [
      'ইঞ্চি',
      'inch', 'inches', 'in'
    ],
    'বর্গফুট': [
      'বর্গফুট', 'স্কয়ার ফিট',
      'square foot', 'square feet', 'sqft', 'sq ft'
    ],
    'বর্গমিটার': [
      'বর্গমিটার', 'স্কয়ার মিটার',
      'square meter', 'square metre', 'sqm', 'sq m'
    ],
    'বস্তা': [
      'বস্তা',
      'bosta', 'sack'
    ],
    'কাপ': [
      'কাপ',
      'cup', 'cups'
    ],
    'চামচ': [
      'চামচ', 'চা চামচ',
      'spoon', 'spoons', 'teaspoon', 'teaspoons', 'tsp'
    ],
    'টেবিল চামচ': [
      'টেবিল চামচ', 'টেবিল-চামচ',
      'tablespoon', 'tablespoons', 'tbsp'
    ],
    'গ্লাস': [
      'গ্লাস',
      'glass', 'glasses'
    ],
    'প্লেট': [
      'প্লেট',
      'plate', 'plates'
    ],
    'বালতি': [
      'বালতি',
      'bucket', 'buckets', 'pail', 'pails'
    ],
    'ড্রাম': [
      'ড্রাম',
      'drum', 'drums', 'barrel', 'barrels'
    ],
    'রোল': [
      'রোল',
      'roll', 'rolls'
    ],
    'শীট': [
      'শীট',
      'sheet', 'sheets'
    ],
    'সেট': [
      'সেট',
      'set', 'sets'
    ],
    'জোড়া': [
      'জোড়া',
      'pair', 'pairs'
    ],
  };

  // Bangla to English digit mapping
  static const Map<String, String> _banglaDigits = {
    '০': '0', '১': '1', '২': '2', '৩': '3', '৪': '4',
    '৫': '5', '৬': '6', '৭': '7', '৮': '8', '৯': '9',
  };

  // Bangla number words with their numeric values
  static const Map<String, double> _banglaNumberWords = {
    // Basic (0-20)
    'শূন্য': 0, 'এক': 1, 'দুই': 2, 'তিন': 3, 'চার': 4, 'পাঁচ': 5,
    'ছয়': 6, 'সাত': 7, 'আট': 8, 'নয়': 9, 'দশ': 10,
    'এগারো': 11, 'বারো': 12, 'তেরো': 13, 'চৌদ্দ': 14, 'পনেরো': 15,
    'ষোল': 16, 'সতেরো': 17, 'আঠারো': 18, 'উনিশ': 19, 'বিশ': 20,

    // Tens (30-90)
    'ত্রিশ': 30, 'চল্লিশ': 40, 'পঞ্চাশ': 50, 'ষাট': 60,
    'সত্তর': 70, 'আশি': 80, 'নব্বই': 90,

    // Compound numbers (21-99)
    'একুশ': 21, 'বাইশ': 22, 'তেইশ': 23, 'চব্বিশ': 24, 'পঁচিশ': 25,
    'ছাব্বিশ': 26, 'সাতাশ': 27, 'আঠাশ': 28, 'ঊনত্রিশ': 29,
    'একত্রিশ': 31, 'বত্রিশ': 32, 'তেত্রিশ': 33, 'চৌত্রিশ': 34, 'পঁয়ত্রিশ': 35,
    'ছত্রিশ': 36, 'সাঁইত্রিশ': 37, 'আটত্রিশ': 38, 'ঊনচল্লিশ': 39,
    'একচল্লিশ': 41, 'বিয়াল্লিশ': 42, 'তেতাল্লিশ': 43, 'চুয়াল্লিশ': 44, 'পঁয়তাল্লিশ': 45,
    'ছেচল্লিশ': 46, 'সাতচল্লিশ': 47, 'আটচল্লিশ': 48, 'ঊনপঞ্চাশ': 49,
    'একান্ন': 51, 'বাহান্ন': 52, 'তিপ্পান্ন': 53, 'চুয়ান্ন': 54, 'পঞ্চান্ন': 55,
    'ছাপ্পান্ন': 56, 'সাতান্ন': 57, 'আটান্ন': 58, 'ঊনষাট': 59,
    'একষট্টি': 61, 'বাষট্টি': 62, 'তেষট্টি': 63, 'চৌষট্টি': 64, 'পঁয়সট্টি': 65,
    'ছেষট্টি': 66, 'সাতষট্টি': 67, 'আটষট্টি': 68, 'ঊনসত্তর': 69,
    'একাত্তর': 71, 'বাহাত্তর': 72, 'তিয়াত্তর': 73, 'চুয়াত্তর': 74, 'পঁচাত্তর': 75,
    'ছিয়াত্তর': 76, 'সাতাত্তর': 77, 'আটাত্তর': 78, 'ঊনআশি': 79,
    'একাশি': 81, 'বিরাশি': 82, 'তিরাশি': 83, 'চুরাশি': 84, 'পঁচাশি': 85,
    'ছিয়াশি': 86, 'সাতাশি': 87, 'আটাশি': 88, 'ঊননব্বই': 89,
    'একানব্বই': 91, 'বিরানব্বই': 92, 'তিরানব্বই': 93, 'চুরানব্বই': 94, 'পঁচানব্বই': 95,
    'ছিয়ানব্বই': 96, 'সাতানব্বই': 97, 'আটানব্বই': 98, 'নিরানব্বই': 99,

    // Multipliers
    'শত': 100, 'হাজার': 1000,

    // Common fractions
    'আধা': 0.5, 'সাড়ে': 0.5, 'পৌনে': 0.75, 'ডেড়': 1.5, 'আড়াই': 2.5,
    'সাড়েতিন': 3.5, 'সাড়েচার': 4.5, 'সাড়েপাঁচ': 5.5,
  };

  // English number words
  static const Map<String, double> _englishNumberWords = {
    'zero': 0, 'one': 1, 'two': 2, 'three': 3, 'four': 4,
    'five': 5, 'six': 6, 'seven': 7, 'eight': 8, 'nine': 9,
    'ten': 10, 'eleven': 11, 'twelve': 12, 'thirteen': 13, 'fourteen': 14,
    'fifteen': 15, 'sixteen': 16, 'seventeen': 17, 'eighteen': 18, 'nineteen': 19,
    'twenty': 20, 'thirty': 30, 'forty': 40, 'fifty': 50,
    'sixty': 60, 'seventy': 70, 'eighty': 80, 'ninety': 90,
    'hundred': 100, 'thousand': 1000,
  };

  // Price indicators
  static const List<String> _priceIndicators = [
    'টাকা', 'taka', 'tk', 'rupees', 'rupee', 'টক', 'price', 'dam', 'দাম'
  ];

  /// Main method: Parse complete voice input and extract all fields
  static Map<String, String> parseFullProductInput(String input) {
    if (input.trim().isEmpty) {
      return {
        'productName': '',
        'quantity': '',
        'unit': 'লিটার',
        'price': '',
      };
    }

    print('\n=== PARSING FULL PRODUCT INPUT ===');
    String cleaned = input.trim();
    String cleanedLower = cleaned.toLowerCase();
    print('Original input: "$input"');
    print('Cleaned input: "$cleaned"');
    print('Lowercase input: "$cleanedLower"');

    // Step 1: Extract product name from ORIGINAL text
    String productName = _extractProductNameBeforeNumbers(cleaned);
    print('Extracted product name: "$productName"');

    // Step 2: Match product from database
    String? matchedProduct = _matchProductFromDatabase(productName.toLowerCase());
    print('Matched product from DB: $matchedProduct');

    // Step 3: Extract all numeric values
    List<double> numbers = _extractAllNumbers(cleaned);
    print('Extracted numbers: $numbers');

    // Step 4: Detect unit - IMPORTANT: Use original cleaned text, not lowercase
    print('\n--- Detecting Unit ---');
    String? detectedUnit = _detectUnit(cleaned);
    print('Detected unit from voice: $detectedUnit');

    String finalUnit = 'লিটার';

    if (detectedUnit != null) {
      finalUnit = detectedUnit;
      print('✓ Using detected unit: $finalUnit');
    } else if (matchedProduct != null) {
      String defaultUnit = _productDatabase[matchedProduct]!['defaultUnit'] as String;
      finalUnit = _convertUnitToBangla(defaultUnit);
      print('✓ Using default unit from product DB: $finalUnit');
    } else {
      print('⚠ No unit detected, using default: $finalUnit');
    }

    // Use matched product if found
    String finalProductName = matchedProduct ?? productName;

    // Step 5: Parse quantity and price
    String quantity = '';
    String price = '';

    if (numbers.isNotEmpty) {
      quantity = numbers[0].toString();
      if (numbers.length > 1) {
        price = numbers[1].toString();
      }
    }

    print('\n=== FINAL RESULT ===');
    print('Product: $finalProductName');
    print('Quantity: $quantity');
    print('Unit: $finalUnit');
    print('Price: $price');
    print('===================\n');

    return {
      'productName': finalProductName,
      'quantity': quantity,
      'unit': finalUnit,
      'price': price,
    };
  }

  /// Extract product name before any number (digits OR number words)
  static String _extractProductNameBeforeNumbers(String text) {
    List<String> words = text.trim().split(RegExp(r'\s+'));
    String productName = '';

    for (String word in words) {
      String wordLower = word.toLowerCase();

      // Stop if we encounter a digit
      if (RegExp(r'\d').hasMatch(word)) {
        break;
      }

      // Stop if we encounter a Bangla number word
      bool isBanglaNumber = _banglaNumberWords.containsKey(wordLower);
      if (isBanglaNumber) {
        break;
      }

      // Stop if we encounter an English number word
      bool isEnglishNumber = _englishNumberWords.containsKey(wordLower);
      if (isEnglishNumber) {
        break;
      }

      // Stop if we encounter a unit word
      bool isUnit = false;
      for (var variations in _unitVariations.values) {
        if (variations.any((v) => v.toLowerCase() == wordLower)) {
          isUnit = true;
          break;
        }
      }
      if (isUnit) break;

      // Add word to product name
      if (productName.isEmpty) {
        productName = word;
      } else {
        productName += ' ' + word;
      }
    }

    return productName.trim();
  }

  /// Convert Bangla digits to English
  static String _convertBanglaDigits(String text) {
    String result = text;
    _banglaDigits.forEach((bangla, english) {
      result = result.replaceAll(bangla, english);
    });
    return result;
  }

  /// Replace number words with their numeric values
  static String _replaceNumberWords(String text) {
    String result = text;

    // Replace Bangla number words (sort by length descending to match longer phrases first)
    var sortedBangla = _banglaNumberWords.entries.toList()
      ..sort((a, b) => b.key.length.compareTo(a.key.length));

    for (var entry in sortedBangla) {
      String word = entry.key;
      double value = entry.value;
      String numStr = value % 1 == 0 ? value.toInt().toString() : value.toString();

      // Use word boundary matching for Bangla
      result = result.replaceAllMapped(
          RegExp(r'(?:^|\s)' + RegExp.escape(word) + r'(?:\s|$)', unicode: true),
              (match) {
            String matched = match.group(0)!;
            return matched.replaceAll(word, numStr);
          }
      );
    }

    // Replace English number words
    _englishNumberWords.forEach((word, value) {
      String numStr = value % 1 == 0 ? value.toInt().toString() : value.toString();
      RegExp regex = RegExp(r'\b' + RegExp.escape(word) + r'\b', caseSensitive: false);
      result = result.replaceAll(regex, numStr);
    });

    return result;
  }

  /// Extract all numeric values from text
  static List<double> _extractAllNumbers(String text) {
    // First convert number words to digits
    String processed = _replaceNumberWords(text);
    // Then convert Bangla digits
    processed = _convertBanglaDigits(processed);

    // Extract all numeric values
    List<double> numbers = [];
    RegExp numberRegex = RegExp(r'\d+\.?\d*');
    Iterable<Match> matches = numberRegex.allMatches(processed);

    for (Match match in matches) {
      double? num = double.tryParse(match.group(0)!);
      if (num != null) {
        numbers.add(num);
      }
    }

    return numbers;
  }

  /// Match product from database
  static String? _matchProductFromDatabase(String text) {
    for (var entry in _productDatabase.entries) {
      String productName = entry.key;
      List<String> variations = (entry.value['variations'] as List).cast<String>();

      for (String variation in variations) {
        RegExp regex = RegExp(
          r'\b' + RegExp.escape(variation.toLowerCase()) + r'\b',
          caseSensitive: false,
          unicode: true,
        );

        if (regex.hasMatch(text)) {
          return productName;
        }
      }
    }
    return null;
  }

  /// Detect unit from the input text
  static String? _detectUnit(String text) {
    print('🔍 Detecting unit from text: "$text"');

    String? longestMatch;
    int longestMatchLength = 0;

    for (var entry in _unitVariations.entries) {
      String unit = entry.key; // This is the Bangla unit like 'কেজি'
      List<String> variations = entry.value;

      print('  Checking unit: $unit with variations: $variations');

      for (String variation in variations) {
        // For Bangla variations, do case-sensitive exact match
        bool isBangla = RegExp(r'[\u0980-\u09FF]').hasMatch(variation);

        if (isBangla) {
          // Case-sensitive match for Bangla
          if (text.contains(variation)) {
            print('    ✓ Found Bangla match: "$variation" → $unit');
            if (variation.length > longestMatchLength) {
              longestMatch = unit;
              longestMatchLength = variation.length;
            }
          }
        } else {
          // Case-insensitive match for English
          RegExp regex = RegExp(
            r'\b' + RegExp.escape(variation) + r'\b',
            caseSensitive: false,
            unicode: true,
          );

          if (regex.hasMatch(text)) {
            print('    ✓ Found English match: "$variation" → $unit');
            if (variation.length > longestMatchLength) {
              longestMatch = unit;
              longestMatchLength = variation.length;
            }
          }
        }
      }
    }

    print('  Final detected unit: $longestMatch');
    return longestMatch;
  }


  /// Convert English unit names to Bangla
  static String _convertUnitToBangla(String englishUnit) {
    const Map<String, String> unitMap = {
      'Kilogram (kg)': 'কেজি',
      'Gram (g)': 'গ্রাম',
      'Liter (L)': 'লিটার',
      'Milliliter (ml)': 'মিলিলিটার',
      'Piece': 'পিস',
      'Dozen': 'ডজন',
      'Pack': 'প্যাক',
      'Box': 'বক্স',
      'Meter (m)': 'মিটার',
      'Centimeter (cm)': 'সেন্টিমিটার',
    };

    return unitMap[englishUnit] ?? 'লিটার';
  }

  /// Parse voice input for product name and unit only
  static Map<String, String> parseVoiceInput(String input) {
    if (input.trim().isEmpty) {
      return {'name': '', 'unit': 'পিস'};
    }

    String cleaned = input.trim();
    String cleanedLower = cleaned.toLowerCase();

    // Extract product name before any numbers
    String productName = _extractProductNameBeforeNumbers(cleaned);

    // Match product from database
    String? matchedProduct = _matchProductFromDatabase(productName.toLowerCase());

    // Detect unit
    String? detectedUnit = _detectUnit(cleanedLower);
    String finalUnit = 'পিস';

    if (detectedUnit != null) {
      finalUnit = detectedUnit;
    } else if (matchedProduct != null) {
      String defaultUnit = _productDatabase[matchedProduct]!['defaultUnit'] as String;
      finalUnit = _convertUnitToBangla(defaultUnit);
    }

    // Use matched product if found
    String finalProductName = matchedProduct ?? productName;

    return {
      'name': finalProductName,
      'unit': finalUnit,
    };
  }

  /// Get product suggestions based on partial input
  static List<String> getProductSuggestions(String input) {
    if (input.trim().isEmpty) return [];

    String searchText = input.toLowerCase().trim();
    List<String> suggestions = [];

    for (var entry in _productDatabase.entries) {
      String productName = entry.key;
      List<String> variations = (entry.value['variations'] as List).cast<String>();

      for (String variation in variations) {
        if (variation.toLowerCase().contains(searchText)) {
          suggestions.add(productName);
          break;
        }
      }
    }

    return suggestions;
  }

  /// Get default unit for a specific product
  static String getDefaultUnit(String productName) {
    if (_productDatabase.containsKey(productName)) {
      String unit = _productDatabase[productName]!['defaultUnit'] as String;
      return _convertUnitToBangla(unit);
    }

    String? matched = _matchProductFromDatabase(productName.toLowerCase());
    if (matched != null && _productDatabase.containsKey(matched)) {
      String unit = _productDatabase[matched]!['defaultUnit'] as String;
      return _convertUnitToBangla(unit);
    }

    return 'পিস';
  }

  /// Get all supported units (in Bangla)
  static List<String> getSupportedUnits() {
    return _unitVariations.keys.toList();
  }

  /// Get all products by category
  static Map<String, List<String>> getProductsByCategory() {
    Map<String, List<String>> result = {};

    for (var entry in _productDatabase.entries) {
      String productName = entry.key;
      String category = entry.value['category'] as String;

      if (!result.containsKey(category)) {
        result[category] = [];
      }
      result[category]!.add(productName);
    }

    return result;
  }
}