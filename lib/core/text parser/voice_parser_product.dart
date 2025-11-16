class VoiceParserProduct {
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
    'Piece': ['piece', 'pieces', 'pcs', 'pc', 'ta', 'টা', 'টি', 'khana', 'খানা', 'খান'],
    'Kilogram (kg)': [
      'kilogram', 'kilograms', 'kg', 'kgs', 'kilo', 'kilos',
      'কেজি', 'কিলোগ্রাম', 'কিলো'
    ],
    'Gram (g)': ['gram', 'grams', 'g', 'gm', 'gms', 'গ্রাম'],
    'Liter (L)': ['liter', 'liters', 'litre', 'litres', 'l', 'লিটার'],
    'Milliliter (ml)': [
      'milliliter', 'milliliters', 'millilitre', 'millilitres', 'ml',
      'মিলিলিটার', 'এমএল'
    ],
    'Meter (m)': ['meter', 'meters', 'metre', 'metres', 'm', 'মিটার'],
    'Centimeter (cm)': [
      'centimeter', 'centimeters', 'centimetre', 'centimetres', 'cm',
      'সেন্টিমিটার', 'সেমি'
    ],
    'Box': ['box', 'boxes', 'বক্স', 'বাক্স'],
    'Dozen': ['dozen', 'doz', 'ডজন'],
    'Pack': ['pack', 'packs', 'packet', 'packets', 'প্যাকেট', 'প্যাক', 'প্যাকেজ'],
  };

  // Bangla numbers (0-10 and common numbers)
  static const Map<String, String> _banglaNumbers = {
    '০': '0', '১': '1', '২': '2', '৩': '3', '৪': '4',
    '৫': '5', '৬': '6', '৭': '7', '৮': '8', '৯': '9',
  };

  // Common filler words to remove (including Bangla)
  static const List<String> _fillerWords = [
    'add', 'new', 'product', 'item', 'in', 'of', 'the', 'a', 'an',
    'please', 'i', 'want', 'to', 'need',
    'একটি', 'নতুন', 'দিন', 'চাই', 'লাগবে', 'নিতে'
  ];

  // Number words in Bangla
  static const List<String> _banglaNumberWords = [
    'এক', 'দুই', 'তিন', 'চার', 'পাঁচ', 'ছয়', 'সাত', 'আট', 'নয়', 'দশ',
    'এগারো', 'বারো', 'তেরো', 'চৌদ্দ', 'পনেরো', 'ষোল', 'সতেরো', 'আঠারো', 'উনিশ', 'বিশ',
    'ত্রিশ', 'চল্লিশ', 'পঞ্চাশ', 'ষাট', 'সত্তর', 'আশি', 'নব্বই', 'শত', 'হাজার'
  ];

  /// Parse voice input text and extract product name and unit
  /// Uses product database for better matching and default units
  static Map<String, String> parseVoiceInput(String input) {
    if (input.trim().isEmpty) {
      return {'name': '', 'unit': 'Piece'};
    }

    // Clean the input
    String cleaned = input.trim();
    String cleanedLower = cleaned.toLowerCase();

    // Convert Bangla numbers to English numbers
    cleaned = _convertBanglaNumbers(cleaned);
    cleanedLower = _convertBanglaNumbers(cleanedLower);

    // First, try to match a product from database
    String? matchedProduct = _matchProductFromDatabase(cleanedLower);

    // Detect unit (either from input or use product's default unit)
    String? detectedUnit = _detectUnit(cleanedLower);
    String finalUnit = 'Piece';

    if (detectedUnit != null) {
      finalUnit = detectedUnit;
    } else if (matchedProduct != null) {
      // Use default unit from product database
      finalUnit = _productDatabase[matchedProduct]!['defaultUnit'] as String;
    }

    // Extract product name
    String productName;
    if (matchedProduct != null) {
      productName = matchedProduct;
    } else {
      productName = _extractProductName(cleaned, detectedUnit);
    }

    return {
      'name': productName,
      'unit': finalUnit,
    };
  }

  /// Match product from database
  static String? _matchProductFromDatabase(String text) {
    // Check each product in database
    for (var entry in _productDatabase.entries) {
      String productName = entry.key;
      List<String> variations = entry.value['variations'] as List<String>;

      for (String variation in variations) {
        // Check if variation exists in the text
        RegExp regex = RegExp(
          r'\b' + RegExp.escape(variation.toLowerCase()) + r'\b',
          caseSensitive: false,
          unicode: true,
        );

        if (regex.hasMatch(text)) {
          return productName; // Return the standard product name
        }
      }
    }

    return null;
  }

  /// Get product suggestions based on partial input
  static List<String> getProductSuggestions(String input) {
    if (input.trim().isEmpty) return [];

    String searchText = input.toLowerCase().trim();
    List<String> suggestions = [];

    for (var entry in _productDatabase.entries) {
      String productName = entry.key;
      List<String> variations = entry.value['variations'] as List<String>;

      // Check if any variation starts with or contains the search text
      for (String variation in variations) {
        if (variation.toLowerCase().contains(searchText)) {
          suggestions.add(productName);
          break;
        }
      }
    }

    return suggestions;
  }

  /// Convert Bangla numbers to English numbers
  static String _convertBanglaNumbers(String text) {
    String result = text;
    _banglaNumbers.forEach((bangla, english) {
      result = result.replaceAll(bangla, english);
    });
    return result;
  }

  /// Detect unit from the input text
  static String? _detectUnit(String text) {
    String? longestMatch;
    int longestMatchLength = 0;

    for (var entry in _unitVariations.entries) {
      String unit = entry.key;
      List<String> variations = entry.value;

      for (String variation in variations) {
        RegExp regex = RegExp(
          r'\b' + RegExp.escape(variation) + r'\b',
          caseSensitive: false,
          unicode: true,
        );

        if (regex.hasMatch(text)) {
          if (variation.length > longestMatchLength) {
            longestMatch = unit;
            longestMatchLength = variation.length;
          }
        }
      }
    }

    return longestMatch;
  }

  /// Extract product name by removing unit, numbers, and filler words
  static String _extractProductName(String text, String? detectedUnit) {
    String result = text;

    // Remove detected unit and its variations
    if (detectedUnit != null) {
      List<String> variations = _unitVariations[detectedUnit] ?? [];
      for (String variation in variations) {
        RegExp regex = RegExp(
          r'\s*\b' + RegExp.escape(variation) + r'\b\s*',
          caseSensitive: false,
          unicode: true,
        );
        result = result.replaceAll(regex, ' ');
      }
    }

    // Remove English numbers
    result = result.replaceAll(RegExp(r'\s*\b\d+\.?\d*\b\s*'), ' ');

    // Remove Bangla number words
    for (String numberWord in _banglaNumberWords) {
      RegExp regex = RegExp(
        r'\s*\b' + RegExp.escape(numberWord) + r'\b\s*',
        caseSensitive: false,
        unicode: true,
      );
      result = result.replaceAll(regex, ' ');
    }

    // Remove English number words
    const englishNumberWords = [
      'zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven',
      'eight', 'nine', 'ten', 'eleven', 'twelve', 'thirteen', 'fourteen',
      'fifteen', 'sixteen', 'seventeen', 'eighteen', 'nineteen', 'twenty',
      'thirty', 'forty', 'fifty', 'sixty', 'seventy', 'eighty', 'ninety',
      'hundred', 'thousand'
    ];

    for (String number in englishNumberWords) {
      RegExp regex = RegExp(
        r'\s*\b' + RegExp.escape(number) + r'\b\s*',
        caseSensitive: false,
      );
      result = result.replaceAll(regex, ' ');
    }

    // Remove filler words
    for (String filler in _fillerWords) {
      RegExp regex = RegExp(
        r'\s*\b' + RegExp.escape(filler) + r'\b\s*',
        caseSensitive: false,
        unicode: true,
      );
      result = result.replaceAll(regex, ' ');
    }

    // Clean up extra spaces
    result = result.trim().replaceAll(RegExp(r'\s+'), ' ');

    // Capitalize first letter only if it's English text
    if (result.isNotEmpty && _isEnglishText(result)) {
      result = result[0].toUpperCase() + result.substring(1).toLowerCase();
    }

    return result.isEmpty ? 'Unknown Product' : result;
  }

  /// Check if text is primarily English
  static bool _isEnglishText(String text) {
    if (text.isEmpty) return false;
    final firstChar = text.codeUnitAt(0);
    return (firstChar >= 65 && firstChar <= 90) ||
        (firstChar >= 97 && firstChar <= 122);
  }

  /// Get default unit for a specific product
  static String getDefaultUnit(String productName) {
    // Check if product exists in database
    if (_productDatabase.containsKey(productName)) {
      return _productDatabase[productName]!['defaultUnit'] as String;
    }

    // If not found, try to match with variations
    String? matched = _matchProductFromDatabase(productName.toLowerCase());
    if (matched != null && _productDatabase.containsKey(matched)) {
      return _productDatabase[matched]!['defaultUnit'] as String;
    }

    return 'Piece'; // Default fallback
  }

  /// Get all supported units
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

  /// Test the parser with Bangla inputs
  static void testParser() {
    final testCases = [
      'চাল ৫ কেজি',
      'মুরগি ২ কেজি',
      'ডিম এক ডজন',
      'দুধ ১ লিটার',
      'আলু 5 kg',
      'পেঁয়াজ ৩ কেজি',
      'তেল ২ লিটার',
      'চিনি ১ কেজি',
      'আটা 10 কেজি',
      'টমেটো ২ কেজি',
    ];

    print('=== Voice Parser Test Results (with Database) ===\n');
    for (String test in testCases) {
      var result = parseVoiceInput(test);
      print('Input: "$test"');
      print('Output: Name="${result['name']}", Unit="${result['unit']}"');
      print('---');
    }
  }
}