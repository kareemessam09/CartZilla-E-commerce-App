# 🛒 Modern Flutter Ecommerce App

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Material Design](https://img.shields.io/badge/Material%20Design%203-757575?style=for-the-badge&logo=material-design&logoColor=white)

**A sophisticated Flutter ecommerce application featuring a sleek dark theme, modern UI components, and contemporary design patterns following Material Design 3 principles.**

</div>

## 📋 Table of Contents

- [Features](#-features)
- [Architecture & State Management](#-architecture--state-management)
- [Dependencies & Packages](#-dependencies--packages)
- [Project Structure](#-project-structure)
- [Getting Started](#-getting-started)
- [Design System](#-design-system)
- [Authentication](#-authentication)
- [Data Management](#-data-management)
- [Screenshots](#-screenshots)
- [Contributing](#-contributing)
- [License](#-license)

## ✨ Features

### 🎨 **Modern Design**
- **Dark Theme**: Eye-comfortable black and warm red color scheme
- **Material Design 3**: Following latest design guidelines with dynamic colors
- **Glassmorphism Effects**: Modern UI with blur and transparency
- **Smooth Animations**: Elegant transitions and micro-interactions
- **Responsive Design**: Optimized for different screen sizes and orientations

### 🛍️ **Ecommerce Functionality**
- **Product Catalog**: Browse products with beautiful grid layouts and filtering
- **Product Details**: Comprehensive product information with image gallery and variants
- **Shopping Cart**: Add, remove, and manage cart items with quantity controls
- **Categories**: Organized product categories with modern navigation
- **Search & Filter**: Advanced product search with category filtering
- **Wishlist**: Save favorite products for later purchase

### 🔐 **Authentication & User Management**
- **Modern Login Screen**: Elegant login with social sign-in options
- **Mock Authentication**: Local authentication system with multiple test accounts
- **User Profile**: Comprehensive profile screen with statistics and settings
- **Session Management**: Persistent login state across app restarts

### 📱 **User Experience**
- **Smooth Navigation**: Bottom navigation with modern styling and animations
- **State Persistence**: Cart and user preferences saved locally
- **Error Handling**: Comprehensive error states with user-friendly messages
- **Loading States**: Elegant loading indicators and skeleton screens
- **Offline Support**: Basic offline functionality with local data caching

## 🏗️ Architecture & State Management

### **Design Patterns**
- **BLoC Pattern**: Business Logic Component pattern for predictable state management
- **Repository Pattern**: Clean architecture with data layer abstraction
- **Dependency Injection**: Service location using GetIt for loose coupling
- **Clean Architecture**: Separation of concerns with clear layer boundaries

### **State Management Details**
The app uses **Flutter BLoC** for state management, providing:

- **Predictable State**: Easy to test and debug state changes
- **Reactive Programming**: Stream-based state updates
- **Event-Driven**: Clear separation between events and states
- **Immutable States**: Preventing accidental state mutations

#### **BLoC Implementation Example**
```dart
// Authentication BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  
  AuthBloc(this._authRepository) : super(AuthInitiateState()) {
    on<AuthLoginRequestEvent>(_onLoginRequest);
    on<AuthLogoutEvent>(_onLogout);
  }
}
```

### **Data Flow Architecture**
```
UI Layer (Screens/Widgets)
    ↓ Events
BLoC Layer (Business Logic)
    ↓ Calls
Repository Layer (Data Abstraction)
    ↓ Implements
DataSource Layer (Local/Remote Data)
```

## 📦 Dependencies & Packages

### **Core Dependencies**
| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_bloc` | ^8.1.6 | State management with BLoC pattern |
| `bloc` | ^8.1.4 | Core BLoC library for reactive programming |
| `get_it` | ^8.0.1 | Service locator for dependency injection |
| `equatable` | ^2.0.5 | Value equality for BLoC states and events |
| `dartz` | ^0.10.1 | Functional programming with Either type |

### **UI & Design**
| Package | Version | Purpose |
|---------|---------|---------|
| `cached_network_image` | ^3.4.1 | Efficient image loading and caching |
| `smooth_page_indicator` | ^1.1.0 | Elegant page indicators for carousels |
| `dotted_line` | ^3.2.2 | Customizable dotted lines for UI elements |

### **Data & Storage**
| Package | Version | Purpose |
|---------|---------|---------|
| `hive` | ^2.2.3 | Fast, lightweight NoSQL database |
| `hive_flutter` | ^1.1.0 | Hive integration for Flutter |
| `shared_preferences` | ^2.3.2 | Simple key-value storage for settings |
| `dio` | ^5.5.0+1 | Powerful HTTP client for API calls |

### **Development Dependencies**
| Package | Version | Purpose |
|---------|---------|---------|
| `hive_generator` | ^2.0.1 | Code generation for Hive type adapters |
| `build_runner` | ^2.4.13 | Code generation tool runner |
| `flutter_lints` | ^5.0.0 | Flutter-specific linting rules |

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point and theme configuration
├── bloc/                     # BLoC state management
│   ├── auth/                 # Authentication BLoC
│   ├── basket/               # Shopping cart BLoC
│   ├── category/             # Category management BLoC
│   └── product/              # Product-related BLoCs
├── constants/                # App-wide constants
│   └── colors.dart           # Material 3 color scheme
├── data/                     # Data layer implementation
│   ├── datasource/           # Data sources (local/remote)
│   │   ├── auth_datasource.dart
│   │   ├── banner_datasource.dart
│   │   ├── basket_datasource.dart
│   │   ├── category_datasource.dart
│   │   └── product_datasource.dart
│   ├── model/                # Data models and entities
│   │   ├── auth/
│   │   ├── banner.dart
│   │   ├── basket_item.dart
│   │   ├── category.dart
│   │   └── product.dart
│   └── repository/           # Repository implementations
│       ├── auth_repository.dart
│       ├── banner_repository.dart
│       ├── basket_repository.dart
│       ├── category_repository.dart
│       └── product_repository.dart
├── di/                       # Dependency injection setup
│   └── di.dart               # GetIt service locator configuration
├── screens/                  # UI screens and pages
│   ├── login_screen.dart     # Modern authentication screen
│   ├── home_screen.dart      # Home dashboard with banners
│   ├── category_screen.dart  # Product categories
│   ├── product_list_screen.dart  # Product catalog
│   ├── product_detail_screen.dart # Product details
│   ├── card_screen.dart      # Shopping cart
│   └── profile_screen.dart   # User profile and settings
├── util/                     # Utilities and helpers
│   ├── auth_manager.dart     # Authentication state management
│   ├── extensions.dart       # Dart extensions
│   └── payment_handler.dart  # Payment processing
└── widgets/                  # Reusable UI components
    ├── cached_image.dart     # Optimized image widget
    ├── loading_animation.dart # Loading indicators
    └── product_item.dart     # Product card component
```

## 🚀 Getting Started

### **Prerequisites**
- **Flutter SDK**: 3.3.0 or higher
- **Dart SDK**: Compatible with Flutter version
- **IDE**: Android Studio, VS Code, or IntelliJ IDEA
- **Device**: Android/iOS emulator or physical device

### **Installation Steps**

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/flutter-ecommerce-app.git
   cd flutter-ecommerce-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

### **Platform-Specific Setup**

#### **Android**
- Minimum SDK: 21 (Android 5.0)
- Target SDK: 34 (Android 14)
- Compile SDK: 34

#### **iOS**
- Minimum deployment target: iOS 11.0
- Xcode 14.0 or later required

## 🎨 Design System

### **Color Palette**
The app follows Material Design 3 principles with a custom dark theme:

```dart
// Primary Colors
static const Color primary = Color(0xffD32F2F);     // Warm dark red
static const Color primaryDark = Color(0xffB71C1C);  // Deep dark red
static const Color secondary = Color(0xffE57373);    // Warm light red

// Background Colors
static const Color backgroundPrimary = Color(0xff000000);    // Pure black
static const Color backgroundSecondary = Color(0xff0D1117);  // Very dark gray
static const Color cardBackground = Color(0xff161B22);      // Dark card background
static const Color surfaceColor = Color(0xff21262D);        // Surface color
```

### **Typography**
Custom font families for enhanced readability:

- **Gilroy Regular** (400): Body text and general content
- **Gilroy Medium** (500): Emphasized text and labels
- **Gilroy Bold** (700): Headings and important information
- **Gilroy Extra Bold** (800): Major headings
- **Gilroy Heavy** (900): Display text

### **Component Design**
- **Rounded Corners**: 16px border radius for cards, 12px for buttons
- **Elevation**: Consistent shadow system following Material guidelines
- **Spacing**: 8px grid system for consistent layouts
- **Animations**: 300ms duration for micro-interactions

## 🔐 Authentication

### **Mock Authentication System**
The app includes a complete authentication flow with local credential verification:

#### **Default Login Credentials**
```
Primary Account:
Username: kareem
Password: 123456

Additional Test Accounts:
Username: admin    | Password: admin123
Username: test     | Password: test123
```

#### **Authentication Features**
- **Login Validation**: Real-time form validation
- **Session Persistence**: Login state maintained across app restarts
- **Social Sign-in UI**: Modern social authentication buttons (UI only)
- **Password Recovery**: Forgot password flow (placeholder)
- **Account Creation**: Sign-up form interface (placeholder)

#### **Authentication BLoC States**
```dart
abstract class AuthState extends Equatable {}

class AuthInitiateState extends AuthState {}
class AuthLoadingState extends AuthState {}
class AuthResponseState extends AuthState {
  final AuthResponse authResponse;
}
```

## 💾 Data Management

### **Local Storage Strategy**
The app uses a hybrid approach for data persistence:

#### **Hive Database**
- **Shopping Cart**: Persistent cart items with quantity and variants
- **User Preferences**: Theme settings and app configurations
- **Cache**: Product data and images for offline access

#### **Shared Preferences**
- **Authentication**: User session tokens and login state
- **Settings**: Simple key-value pairs for app settings

#### **Data Models**
All data models implement proper serialization:

```dart
@HiveType(typeId: 1)
class BasketItem extends HiveObject {
  @HiveField(0)
  final Product product;
  
  @HiveField(1)
  final int count;
  
  // Hive type adapter auto-generated
}
```

### **Repository Pattern Implementation**
Clean separation between data sources and business logic:

```dart
abstract class ProductRepository {
  Future<Either<String, List<Product>>> getProducts();
  Future<Either<String, List<Product>>> getHottestProducts();
  Future<Either<String, List<Product>>> getBestSellerProducts();
  Future<Either<String, ProductDetailResponse>> getProductDetail(String productId);
}
```

## 📱 Screenshots

*Screenshots section - Add your app screenshots here*

```
Home Screen     Product List    Product Detail    Shopping Cart
┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐
│             │ │             │ │             │ │             │
│   Banners   │ │   Grid      │ │   Gallery   │ │   Items     │
│   Categories│ │   Products  │ │   Details   │ │   Summary   │
│   Featured  │ │   Filters   │ │   Variants  │ │   Checkout  │
│             │ │             │ │             │ │             │
└─────────────┘ └─────────────┘ └─────────────┘ └─────────────┘

Login Screen    Profile         Categories      Search
┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐
│             │ │             │ │             │ │             │
│   Logo      │ │   Avatar    │ │   Grid      │ │   Search    │
│   Form      │ │   Stats     │ │   Cards     │ │   Results   │
│   Social    │ │   Menu      │ │   Navigation│ │   Filters   │
│             │ │             │ │             │ │             │
└─────────────┘ └─────────────┘ └─────────────┘ └─────────────┘
```

## 🧪 Testing

### **Test Coverage**
- **Unit Tests**: BLoC logic and repository methods
- **Widget Tests**: UI component behavior
- **Integration Tests**: Complete user flows

### **Run Tests**
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/widget_test.dart
```

## 🔧 Development Workflow

### **Code Generation**
```bash
# Generate Hive type adapters
flutter packages pub run build_runner build

# Watch for changes and auto-generate
flutter packages pub run build_runner watch

# Clean and rebuild
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### **Build Commands**
```bash
# Debug build
flutter run

# Release build
flutter build apk --release
flutter build ios --release

# Build for specific flavor
flutter run --flavor production
```

## 🤝 Contributing

We welcome contributions! Please follow these guidelines:

### **Development Setup**
1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Follow the existing code style and architecture patterns
4. Write tests for new functionality
5. Update documentation as needed

### **Pull Request Process**
1. Ensure all tests pass: `flutter test`
2. Update the README.md with details of changes
3. Commit your changes: `git commit -m 'Add amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request with a clear description

### **Code Style Guidelines**
- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use meaningful variable and function names
- Keep functions small and focused
- Write comprehensive documentation for public APIs

## 🐛 Known Issues & Roadmap

### **Current Limitations**
- [ ] Social authentication is UI-only (not functional)
- [ ] Payment processing is simulated
- [ ] Product reviews are placeholder data
- [ ] Push notifications not implemented

### **Upcoming Features**
- [ ] Real API integration
- [ ] Payment gateway integration
- [ ] User reviews and ratings
- [ ] Push notifications
- [ ] Order tracking
- [ ] Multi-language support
- [ ] Advanced search filters

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2025 Kareem Essam

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
```

## 👨‍💻 Author

**Kareem Essam**
- GitHub: [@kareemessam09](https://github.com/kareemessam09)
- Email: kareemessam.me@email.com
- LinkedIn: [Kareem Essam](https://linkedin.com/in/kareemessam09)

## 🙏 Acknowledgments

- **Flutter Team**: For the amazing framework and documentation
- **Material Design**: For the comprehensive design system guidelines
- **BLoC Library**: For the excellent state management solution
- **Hive**: For the fast and lightweight local database
- **Open Source Community**: For the incredible packages and contributions

---

<div align="center">

**⭐ Star this repository if you found it helpful!**

**Made with ❤️ and Flutter**

</div>
