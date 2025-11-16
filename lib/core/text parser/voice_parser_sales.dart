class VoiceParserSales {
  // Bangla numbers
  static const Map<String, String> _banglaNumbers = {
    '০': '0', '১': '1', '২': '2', '৩': '3', '৪': '4',
    '৫': '5', '৬': '6', '৭': '7', '৮': '8', '৯': '9',
  };

  // COMPREHENSIVE PRODUCT DATABASE - All common products
  static const Map<String, String> _productDatabase = {
    // Rice & Grains
    'চাল': 'চাল', 'chal': 'চাল', 'rice': 'Rice',
    'আটা': 'আটা', 'atta': 'আটা', 'ata': 'আটা', 'flour': 'Flour',
    'ময়দা': 'ময়দা', 'moida': 'ময়দা', 'maida': 'ময়দা',
    'সুজি': 'সুজি', 'suji': 'সুজি', 'sooji': 'Sooji',
    'চিড়া': 'চিড়া', 'chira': 'চিড়া',
    'মুড়ি': 'মুড়ি', 'muri': 'মুড়ি',

    // Pulses
    'ডাল': 'ডাল', 'dal': 'Dal', 'daal': 'Dal',
    'মসুর': 'মসুর ডাল', 'masoor': 'Masoor Dal',
    'মুগ': 'মুগ ডাল', 'moong': 'Moong Dal',
    'ছোলা': 'ছোলা', 'chola': 'ছোলা', 'chickpeas': 'Chickpeas',
    'মটর': 'মটর', 'motor': 'মটর',

    // Vegetables
    'আলু': 'আলু', 'alu': 'আলু', 'aloo': 'আলু', 'potato': 'Potato',
    'পেঁয়াজ': 'পেঁয়াজ', 'পিয়াজ': 'পেঁয়াজ', 'peyaj': 'পেঁয়াজ', 'piaj': 'পেঁয়াজ', 'onion': 'Onion',
    'রসুন': 'রসুন', 'rosun': 'রসুন', 'garlic': 'Garlic',
    'আদা': 'আদা', 'ada': 'আদা', 'ginger': 'Ginger',
    'টমেটো': 'টমেটো', 'টোমাটো': 'টমেটো', 'tomato': 'Tomato',
    'বেগুন': 'বেগুন', 'begun': 'বেগুন', 'eggplant': 'Eggplant',
    'গাজর': 'গাজর', 'gajor': 'গাজর', 'carrot': 'Carrot',
    'মুলা': 'মুলা', 'mula': 'মুলা', 'radish': 'Radish',
    'পালং': 'পালং শাক', 'palang': 'পালং শাক', 'spinach': 'Spinach',
    'লাউ': 'লাউ', 'lau': 'লাউ',
    'কুমড়া': 'কুমড়া', 'কুমড়ো': 'কুমড়া', 'kumra': 'কুমড়া', 'pumpkin': 'Pumpkin',
    'শসা': 'শসা', 'shasha': 'শসা', 'cucumber': 'Cucumber',
    'করলা': 'করলা', 'korola': 'করলা',
    'ঝিঙ্গা': 'ঝিঙ্গা', 'jhinga': 'ঝিঙ্গা',
    'মরিচ': 'কাঁচা মরিচ', 'morich': 'কাঁচা মরিচ', 'chili': 'Chili',
    'ফুলকপি': 'ফুলকপি', 'fulkopi': 'ফুলকপি', 'cauliflower': 'Cauliflower',
    'বাঁধাকপি': 'বাঁধাকপি', 'bandhakopi': 'বাঁধাকপি', 'cabbage': 'Cabbage',

    // Fruits
    'আম': 'আম', 'aam': 'আম', 'mango': 'Mango',
    'কলা': 'কলা', 'kola': 'কলা', 'banana': 'Banana',
    'আপেল': 'আপেল', 'apple': 'Apple',
    'কমলা': 'কমলা', 'komola': 'কমলা', 'orange': 'Orange',
    'আঙুর': 'আঙুর', 'angur': 'আঙুর', 'grapes': 'Grapes',
    'তরমুজ': 'তরমুজ', 'tormuj': 'তরমুজ', 'watermelon': 'Watermelon',
    'পেঁপে': 'পেঁপে', 'পেপে': 'পেঁপে', 'pepe': 'পেঁপে', 'papaya': 'Papaya',
    'লিচু': 'লিচু', 'lichu': 'লিচু', 'lychee': 'Lychee',
    'জাম': 'জাম', 'jam': 'জাম',

    // Meat & Fish
    'মুরগি': 'মুরগি', 'murgi': 'মুরগি', 'chicken': 'Chicken',
    'গরু': 'গরুর মাংস', 'beef': 'Beef',
    'খাসি': 'খাসির মাংস', 'mutton': 'Mutton',
    'মাছ': 'মাছ', 'mach': 'মাছ', 'fish': 'Fish',
    'রুই': 'রুই মাছ', 'rui': 'রুই মাছ', 'rohu': 'Rohu',
    'কাতলা': 'কাতলা মাছ', 'katla': 'কাতলা মাছ',
    'ইলিশ': 'ইলিশ মাছ', 'ilish': 'ইলিশ মাছ', 'hilsa': 'Hilsa',
    'চিংড়ি': 'চিংড়ি', 'chingri': 'চিংড়ি', 'prawn': 'Prawn',

    // Dairy
    'দুধ': 'দুধ', 'dudh': 'দুধ', 'milk': 'Milk',
    'দই': 'দই', 'doi': 'দই', 'yogurt': 'Yogurt',
    'মাখন': 'মাখন', 'makhan': 'মাখন', 'butter': 'Butter',
    'পনির': 'পনির', 'ponir': 'পনির', 'cheese': 'Cheese', 'paneer': 'Paneer',
    'ঘি': 'ঘি', 'ghee': 'Ghee',

    // Eggs
    'ডিম': 'ডিম', 'dim': 'ডিম', 'egg': 'Egg', 'eggs': 'Egg',

    // Oils
    'তেল': 'তেল', 'tel': 'তেল', 'oil': 'Oil',
    'সয়াবিন': 'সয়াবিন তেল', 'soybean': 'Soybean Oil',
    'সরিষা': 'সরিষার তেল', 'mustard': 'Mustard Oil',

    // Spices
    'লবণ': 'লবণ', 'lobon': 'লবণ', 'salt': 'Salt',
    'চিনি': 'চিনি', 'chini': 'চিনি', 'sugar': 'Sugar',
    'হলুদ': 'হলুদ', 'holud': 'হলুদ', 'turmeric': 'Turmeric',
    'ধনিয়া': 'ধনিয়া', 'dhonia': 'ধনিয়া', 'coriander': 'Coriander',
    'জিরা': 'জিরা', 'jira': 'জিরা', 'cumin': 'Cumin',
    'এলাচ': 'এলাচ', 'elach': 'এলাচ', 'cardamom': 'Cardamom',
    'দারচিনি': 'দারচিনি', 'darchini': 'দারচিনি', 'cinnamon': 'Cinnamon',
    'লবঙ্গ': 'লবঙ্গ', 'lobongo': 'লবঙ্গ', 'cloves': 'Cloves',

    // Beverages
    'চা': 'চা', 'cha': 'চা', 'tea': 'Tea',
    'কফি': 'কফি', 'coffee': 'Coffee',
    'পানি': 'পানি', 'pani': 'পানি', 'water': 'Water',

    // Snacks & Others
    'বিস্কুট': 'বিস্কুট', 'biscuit': 'Biscuit',
    'চানাচুর': 'চানাচুর', 'chanachur': 'চানাচুর',
    'কেক': 'কেক', 'cake': 'Cake',
    'রুটি': 'রুটি', 'ruti': 'রুটি', 'bread': 'Bread',
    'বান': 'বান', 'bun': 'Bun',
    'সাবান': 'সাবান', 'soap': 'Soap',
    'ডিটারজেন্ট': 'ডিটারজেন্ট', 'detergent': 'Detergent',
    'টিস্যু': 'টিস্যু', 'tissue': 'Tissue',
  };

  // Unit variations
  static const Map<String, List<String>> _unitVariations = {
    'Kilogram (kg)': ['kilogram', 'kg', 'kilo', 'কেজি', 'কিলো'],
    'Gram (g)': ['gram', 'g', 'gm', 'গ্রাম'],
    'Liter (L)': ['liter', 'litre', 'l', 'লিটার'],
    'Milliliter (ml)': ['milliliter', 'ml', 'মিলিলিটার'],
    'Dozen': ['dozen', 'doz', 'ডজন'],
    'Piece': ['piece', 'pieces', 'pcs', 'pc', 'টা', 'টি', 'খানা'],
    'Pack': ['pack', 'packet', 'প্যাকেট', 'প্যাক'],
    'Box': ['box', 'বক্স'],
  };

  // Price keywords
  static const List<String> _priceKeywords = ['টাকা', 'taka', 'tk', 'rupee'];

  /// MAIN PARSER - Simple word-by-word logic
  static Map<String, dynamic> parseSalesInput(String input) {
    if (input.trim().isEmpty) {
      return {
        'customerName': '',
        'productName': '',
        'quantity': 0.0,
        'unit': 'Piece',
        'totalPrice': 0.0,
      };
    }

    // Convert Bangla digits
    String cleaned = _convertBanglaDigits(input);
    List<String> words = cleaned.split(RegExp(r'\s+'));

    String customerName = '';
    String productName = '';
    double quantity = 0.0;
    String unit = 'Piece';
    double totalPrice = 0.0;

    int i = 0;

    // STEP 1: First word(s) = Customer Name (max 2 words, stop at product or number)
    while (i < words.length && i < 2) {
      String word = words[i].toLowerCase().trim();

      // Stop if we hit a product
      if (_isProduct(word)) break;

      // Stop if we hit a number
      if (_isNumber(word)) break;

      customerName += (customerName.isEmpty ? '' : ' ') + words[i];
      i++;
    }

    // STEP 2: Next word = Product (must be in product database)
    if (i < words.length) {
      String word = words[i].toLowerCase().trim();
      if (_isProduct(word)) {
        productName = _productDatabase[word]!;
        i++;
      }
    }

    // STEP 3: Next word = Quantity (number)
    if (i < words.length) {
      String word = words[i].trim();
      if (_isNumber(word)) {
        quantity = _parseNumber(word);
        i++;
      }
    }

    // STEP 4: Next word = Unit (kg, liter, etc.)
    if (i < words.length) {
      String word = words[i].toLowerCase().trim();
      String? foundUnit = _findUnit(word);
      if (foundUnit != null) {
        unit = foundUnit;
        i++;
      }
    }

    // STEP 5: Look for price (number before টাকা/taka OR last remaining number)
    for (int j = i; j < words.length; j++) {
      String word = words[j].toLowerCase().trim();

      // Check if next word is price keyword
      if (j + 1 < words.length && _isPriceKeyword(words[j + 1].toLowerCase().trim())) {
        if (_isNumber(word)) {
          totalPrice = _parseNumber(word);
          break;
        }
      }

      // Or just take last number as price
      if (_isNumber(word)) {
        totalPrice = _parseNumber(word);
      }
    }

    // Capitalize customer name if English
    if (customerName.isNotEmpty && _isEnglishText(customerName)) {
      customerName = customerName[0].toUpperCase() + customerName.substring(1);
    }

    return {
      'customerName': customerName.trim(),
      'productName': productName.isEmpty ? 'Product' : productName,
      'quantity': quantity,
      'unit': unit,
      'totalPrice': totalPrice,
    };
  }

  /// Check if word is in product database
  static bool _isProduct(String word) {
    return _productDatabase.containsKey(word.toLowerCase());
  }

  /// Check if word is a number
  static bool _isNumber(String word) {
    return RegExp(r'^\d+\.?\d*$').hasMatch(word);
  }

  /// Parse number from string
  static double _parseNumber(String word) {
    return double.tryParse(word) ?? 0.0;
  }

  /// Find unit match
  static String? _findUnit(String word) {
    for (var entry in _unitVariations.entries) {
      if (entry.value.contains(word.toLowerCase())) {
        return entry.key;
      }
    }
    return null;
  }

  /// Check if word is price keyword
  static bool _isPriceKeyword(String word) {
    return _priceKeywords.contains(word.toLowerCase());
  }

  /// Convert Bangla digits to English
  static String _convertBanglaDigits(String text) {
    String result = text;
    _banglaNumbers.forEach((bangla, english) {
      result = result.replaceAll(bangla, english);
    });
    return result;
  }

  /// Check if text is English
  static bool _isEnglishText(String text) {
    if (text.isEmpty) return false;
    final firstChar = text.codeUnitAt(0);
    return (firstChar >= 65 && firstChar <= 90) || (firstChar >= 97 && firstChar <= 122);
  }

  /// Test the parser
  static void testSalesParser() {
    final testCases = [
      'নাহিয়ান চাল ১০ কেজি ১০০ টাকা',
      'nahian chal 10 kg 100 taka',
      'রহিম তেল ৫ লিটার ৫০০',
      'করিম মুরগি ২ কেজি ৩০০ টাকা',
      'সালমান ডিম ১ ডজন ১২০',
      'fahim rice 10 kg',
      'rahim oil 2 liter 200',
    ];

    print('=== Sales Parser Test ===\n');
    for (String test in testCases) {
      print('Input: "$test"');
      var result = parseSalesInput(test);
      print('Customer: "${result['customerName']}"');
      print('Product: "${result['productName']}"');
      print('Quantity: ${result['quantity']} ${result['unit']}');
      print('Price: ৳${result['totalPrice']}\n');
    }
  }
}