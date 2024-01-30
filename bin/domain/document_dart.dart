import 'dart:math';

import 'package:dotenv/dotenv.dart';
import 'package:webdriver/sync_io.dart';

import 'tiсket.dart';

DotEnv env = DotEnv(includePlatformEnvironment: true)..load();

class DocumentDart {
  final Future<bool> instanceStatus;
  static late WebDriver driver;
  static late Map<String, Map<String, String>> list;
  static late Map<String, Map<String, String>> set;
  static late Map<String, Map<String, String>> map;
  static late Map<String, Map<String, String>> iterable;

  DocumentDart() : instanceStatus = _loadData();

  static Future<bool> _loadData() async {
    driver = createDriver(
        uri: Uri.parse(env['WEBDRIVE_URL'] ?? ''),
        spec: WebDriverSpec.W3c,
        desired: Capabilities.firefox
        // {
        //   'browserName': 'firefox'
        //   "moz:firefoxOptions": {
        //     "args": ["--headless", "--no-sandbox", "--disable-dev-shm-usage"]
        //   }
        // }
        );
    driver.get(env['LIST_DART_SDK_API_URL'] ?? '');
    list = await _getParsingData();

    // driver.get(env['SET_DART_SDK_API_URL'] ?? '');
    // set = await _getParsingData();

    // driver.get(env['MAP_DART_SDK_API_URL'] ?? '');
    // map = await _getParsingData();

    // driver.get(env['ITERABLE_DART_SDK_API_URL'] ?? '');
    // iterable = await _getParsingData();

    return true;
  }

  static Future<Map<String, Map<String, String>>> _getParsingData() async {
    return {
      "Constructors": Map.fromIterables(
          (await _getDataElementsByXpath("//h2[text()='Constructors' ]/..//dt"))
              .map<String>((e) => e.text as String)
              .toList(),
          (await _getDataElementsByXpath("//h2[text()='Constructors' ]/..//dd"))
              .map<String>((e) => e.text as String)
              .toList()),
      "Properties": Map.fromIterables(
          (await _getDataElementsByXpath("//h2[text()='Properties' ]/..//dt"))
              .map<String>((e) => e.text as String),
          (await _getDataElementsByXpath("//h2[text()='Properties' ]/..//dd"))
              .map<String>((e) => e.text as String)),
      "Methods": Map.fromIterables(
          (await _getDataElementsByXpath("//h2[text()='Methods' ]/..//dt"))
              .map<String>((e) => e.text as String),
          (await _getDataElementsByXpath("//h2[text()='Methods' ]/..//dd"))
              .map<String>((e) => e.text as String)),
      "Operators": Map.fromIterables(
          (await _getDataElementsByXpath("//h2[text()='Operators' ]/..//dt"))
              .map<String>((e) => e.text as String),
          (await _getDataElementsByXpath("//h2[text()='Operators' ]/..//dd"))
              .map<String>((e) => e.text as String)),
      "Static Methods'": Map.fromIterables(
          (await _getDataElementsByXpath(
                  "//h2[text()='Static Methods' ]/..//dt"))
              .map<String>((e) => e.text as String),
          (await _getDataElementsByXpath(
                  "//h2[text()='Static Methods' ]/..//dd"))
              .map<String>((e) => e.text as String)),
    };
  }

  static _clickElementByXpath(String xPath, [int count = 15]) async {
    if (count > 0) {
      try {
        driver.findElementByXpath(xPath).click();
        print('click $xPath');
      } catch (e) {
        await Future.delayed(Duration(seconds: 1));
        await _clickElementByXpath(xPath, --count);
      }
    } else {
      throw '$xPath не найден';
    }
  }

  static _getDataElementsByXpath(String xPath, [int count = 15]) async {
    if (count > 0) {
      try {
        return driver.findElementsByXpath(xPath);
      } catch (e) {
        await Future.delayed(Duration(seconds: 1));
        return await _getDataElementsByXpath(xPath, --count);
      }
    } else {
      throw '$xPath не найден';
    }
  }

  static Ticket? getQuestionCollection(String subject) {
    Map<String, Map<String, String>>? collection = {
      'list': list
      // 'map': map, 'set': set, 'iterable': iterable
    }[subject];

    if (collection != null) {
      String subtopic = _getRandomKey(collection);
      String question = _getRandomKey(collection[subtopic]!);
      String correctOption = collection[subtopic]![question]!;
      // List<String> options = [];
      return Ticket(subject, subtopic, question, correctOption, [
        _getRandomElement(collection),
        _getRandomElement(collection),
        _getRandomElement(collection)
      ]);
    }
    return null;
  }

  static String _getRandomKey(Map<String, dynamic> map) {
    if (map.isEmpty) {
      // Если Map пуст, возвращаем null или какой-то другой маркер
      return 'Map is empty';
    }

    // Преобразование ключей Map в список
    List<String> keys = map.keys.toList();

    // Генерация случайного индекса
    int randomIndex = Random().nextInt(keys.length);

    // Получение случайного ключа
    String randomKey = keys[randomIndex];

    return randomKey;
  }

  static String _getRandomElement(Map<String, dynamic> map) {
    if (map.isEmpty) {
      return 'Map is empty';
    }

    List<String> keys = map.keys.toList();
    String randomKey = keys[Random().nextInt(keys.length)];
    dynamic randomElement = map[randomKey];

    // Рекурсивный вызов для вложенных Map
    if (randomElement is Map<String, dynamic>) {
      randomElement = _getRandomElement(randomElement);
    }

    return randomElement;
  }
}
