# FinGenius - AI Expense Tracker

A modern Flutter app for intelligent expense tracking with AI-powered insights.

## Features

🔐 **Authentication & Security**
- Google Sign-In and Email authentication
- Biometric lock support
- Multi-currency support
- Light/Dark theme with auto-detection

💸 **Smart Expense Tracking**
- Manual, voice, and receipt scanning input
- OCR-powered receipt recognition
- AI-powered transaction categorization
- Custom categories with emojis
- Recurring transaction support

📊 **Analytics & Insights**
- Real-time dashboard with animated charts
- AI-generated spending insights
- Budget tracking with progress indicators
- Savings goals with visual progress

🤖 **AI Features**
- Voice assistant for expense logging
- Predictive spending analysis
- Personalized saving recommendations
- Smart spending alerts

## Setup Instructions

### Prerequisites

1. **Flutter SDK** (3.10.0 or higher)
2. **Firebase Project** with the following services enabled:
   - Authentication (Google & Email)
   - Firestore Database
   - Storage
3. **API Keys**:
   - OpenAI API key for AI features
   - Google Cloud Vision API (for enhanced OCR)

### Installation Steps

1. **Clone the repository**
   \`\`\`bash
   git clone <repository-url>
   cd fingenius
   \`\`\`

2. **Install dependencies**
   \`\`\`bash
   flutter pub get
   \`\`\`

3. **Firebase Setup**
   - Create a new Firebase project at https://console.firebase.google.com
   - Add an Android app with package name: `com.fingenius.expense_tracker`
   - Download `google-services.json` and place it in `android/app/`
   - Enable Authentication with Google and Email providers
   - Create a Firestore database in production mode
   - Enable Storage for receipt images

4. **Configure API Keys**
   Create a file `lib/config/api_keys.dart`:
   ```dart
   class ApiKeys {
     static const String openAI = 'your_openai_api_key_here';
     static const String googleCloud = 'your_google_cloud_api_key_here';
   }
   \`\`\`

5. **Android Configuration**
   - Update `android/app/build.gradle` with your signing configuration
   - Ensure minimum SDK version is 21 or higher

6. **Run the app**
   \`\`\`bash
   flutter run
   \`\`\`

### Building for Release

1. **Generate signed APK**
   \`\`\`bash
   flutter build apk --release
   \`\`\`

2. **Generate App Bundle for Play Store**
   \`\`\`bash
   flutter build appbundle --release
   \`\`\`

## Project Structure

\`\`\`
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── transaction.dart
│   ├── category.dart
│   └── user.dart
├── providers/                # State management
│   ├── auth_provider.dart
│   ├── expense_provider.dart
│   ├── theme_provider.dart
│   └── currency_provider.dart
├── screens/                  # UI screens
│   ├── auth/
│   ├── home/
│   ├── transactions/
│   ├── analytics/
│   └── profile/
├── services/                 # Business logic
│   ├── ai_service.dart
│   ├── ocr_service.dart
│   ├── notification_service.dart
│   └── export_service.dart
├── widgets/                  # Reusable components
├── utils/                    # Utilities and themes
└── config/                   # Configuration files
\`\`\`

## AI Integration Guide

### OpenAI Integration
The app uses OpenAI's GPT-3.5-turbo for:
- Transaction categorization
- Financial insights generation
- Chatbot responses

### Google ML Kit Integration
The app uses Google ML Kit for:
- Text recognition from receipt images
- Real-time OCR processing
- Offline text detection capabilities

### Speech-to-Text Integration
- Voice input for transaction descriptions
- Real-time speech recognition
- Multi-language support

## Monetization Strategy

### Free Tier
- Basic expense tracking
- Limited AI insights (5 per month)
- Standard categories
- Basic reports
- Ads displayed

### Pro Tier ($4.99/month)
- Unlimited AI insights and chatbot
- Advanced analytics and predictions
- Custom categories and tags
- Export to PDF/Excel
- Ad-free experience
- Priority customer support
- Advanced budgeting tools

### Affiliate Revenue
- Credit card recommendations
- Investment platform partnerships
- Financial service integrations

## Deployment Checklist

### Pre-Launch
- [ ] Test on multiple devices and screen sizes
- [ ] Verify all Firebase services are working
- [ ] Test offline functionality
- [ ] Validate AI integrations
- [ ] Performance testing and optimization
- [ ] Security audit of API keys and data handling

### Play Store Preparation
- [ ] App icons (48dp to 512dp)
- [ ] Feature graphics (1024x500)
- [ ] Screenshots for different screen sizes
- [ ] App description and keywords
- [ ] Privacy policy URL
- [ ] Content rating questionnaire
- [ ] Pricing and distribution settings

### Post-Launch
- [ ] Monitor crash reports and user feedback
- [ ] Track key metrics (DAU, retention, revenue)
- [ ] Regular updates with new features
- [ ] Customer support system
- [ ] Marketing and user acquisition

## Additional Features to Implement

### Phase 2 Features
1. **Investment Tracking**
   - Stock portfolio integration
   - Crypto tracking via CoinGecko API
   - P&L calculations
   - Asset allocation charts

2. **Bill Management**
   - Automatic bill reminders
   - Subscription tracking
   - Due date notifications
   - Payment history

3. **Advanced AI**
   - Spending pattern analysis
   - Fraud detection
   - Personalized financial advice
   - Goal achievement predictions

### Phase 3 Features
1. **Social Features**
   - Family expense sharing
   - Group budgets
   - Expense splitting
   - Financial challenges

2. **Banking Integration**
   - Bank account linking
   - Automatic transaction import
   - Real-time balance updates
   - Transaction categorization

## Support and Maintenance

### Regular Updates
- Monthly feature releases
- Security patches
- Performance improvements
- Bug fixes based on user feedback

### Customer Support
- In-app help center
- Email support for Pro users
- FAQ section
- Video tutorials

### Analytics and Monitoring
- Firebase Analytics for user behavior
- Crashlytics for error tracking
- Performance monitoring
- User feedback collection

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact

For support or business inquiries:
- Email: support@fingenius.app
- Website: https://fingenius.app
- Twitter: @FinGeniusApp

---

**Note**: Remember to replace placeholder API keys and configuration values with your actual credentials before building for production.
\`\`\`

Let's also create the remaining essential files:

```dart file="lib/providers/theme_provider.dart"
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  
  ThemeMode get themeMode => _themeMode;
  
  ThemeProvider() {
    _loadThemeMode();
  }
  
  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString('theme_mode') ?? 'system';
    
    switch (themeModeString) {
      case 'light':
        _themeMode = ThemeMode.light;
        break;
      case 'dark':
        _themeMode = ThemeMode.dark;
        break;
      default:
        _themeMode = ThemeMode.system;
    }
    
    notifyListeners();
  }
  
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    String modeString;
    
    switch (mode) {
      case ThemeMode.light:
        modeString = 'light';
        break;
      case ThemeMode.dark:
        modeString = 'dark';
        break;
      default:
        modeString = 'system';
    }
    
    await prefs.setString('theme_mode', modeString);
  }
}
