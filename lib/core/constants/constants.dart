import 'package:flutter_dotenv/flutter_dotenv.dart';

const String newsAPIBaseURL = 'https://newsapi.org/v2';
const String countryQuery = 'us';
const String categoryQuery = 'general';
final String newsAPIKey = dotenv.env['NEWS_API_KEY'] ?? '';