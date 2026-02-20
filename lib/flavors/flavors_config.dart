
import 'package:todo_app/config/env.dart';

enum Flavors { dev, prod }

class FlavorsConfig {
  final Flavors flavor;
  final String baseUrl;
  final String apiKey;
  final String paymentKey;
  final String appName;
  final bool enableLogging;
  final String name;

  FlavorsConfig._({
    required this.flavor,
    required this.baseUrl,
    required this.apiKey,
    required this.paymentKey,
    required this.appName,
    required this.enableLogging,
    required this.name,
  });

  static late FlavorsConfig _instance;

  static FlavorsConfig get instance => _instance;

  static void initialize(Flavors flavor) {
    _instance = FlavorsConfig._(
      flavor: flavor,
      baseUrl: Env.baseUrl,
      apiKey: Env.apiKey,
      paymentKey: Env.paymentKey,
      appName: Env.appName,
      enableLogging: Env.enableLogging.toLowerCase() == 'true',
      name: flavor == Flavors.dev ? "Development" : "Production",
    );
  }

  static bool get isDev => _instance.flavor == Flavors.dev;
  static bool get isProd => _instance.flavor == Flavors.prod;
}
