# 🚚 Vells Delivery - Driver App

A professional Flutter-based delivery driver application for managing and tracking order deliveries in real-time.

## 📱 Features

- **Driver Authentication**: Secure login system for delivery drivers
- **Order Management**: View assigned orders with complete details
- **Real-time Updates**: Update order status (Processing → Out for Delivery → Delivered)
- **GPS Tracking**: Track driver location in real-time
- **Order Details**: View customer information, delivery addresses, and order items
- **Professional UI**: Clean, modern interface optimized for delivery operations

## 🛠️ Tech Stack

- **Framework**: Flutter 3.x
- **State Management**: Provider pattern with SharedPreferences
- **HTTP Client**: http package for API communication
- **Maps**: Google Maps integration for location tracking
- **Platform Support**: Android, iOS, Web, Windows, macOS, Linux

## 📋 Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- Backend API server running (Laravel-based)

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/delivery_boy.git
cd delivery_boy
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Configure API Endpoint

Edit `lib/services/api_service.dart` and update the `baseUrl`:

```dart
static const String baseUrl = 'YOUR_API_URL/backend/api';
```

**Platform-specific URLs:**
- **Web/Desktop**: `http://localhost:8001/backend/api`
- **Android Emulator**: `http://10.0.2.2:8001/backend/api`
- **iOS Simulator**: `http://127.0.0.1:8001/backend/api`
- **Production**: `https://yourdomain.com/admin/public/backend/api`

### 4. Run the App

```bash
# For Chrome (Web)
flutter run -d chrome

# For Android
flutter run -d android

# For iOS
flutter run -d ios

# For Windows
flutter run -d windows
```

## 🔑 Test Credentials

```
Email: driver@test.com
Password: password
```

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── screens/
│   ├── login_screen.dart     # Driver login
│   ├── home_screen.dart      # Orders list
│   └── order_detail_screen.dart  # Order details
└── services/
    └── api_service.dart      # API communication
```

## 🔌 API Endpoints

The app communicates with the following backend endpoints:

### Authentication
- `POST /drivers/login.php` - Driver login

### Orders
- `GET /drivers/orders.php` - Fetch assigned orders
- `POST /drivers/update_status.php?order_id={id}` - Update order status
- `POST /drivers/update_location.php` - Update driver GPS location

## 🗺️ Google Maps Setup

For location tracking features, you need to configure Google Maps API:

1. Get an API key from [Google Cloud Console](https://console.cloud.google.com/)
2. Follow the setup guide in `GOOGLE_MAPS_SETUP.md`
3. Enable the following APIs:
   - Maps SDK for Android
   - Maps SDK for iOS
   - Maps JavaScript API (for web)

## 📱 Platform-Specific Setup

### Android
1. Update `android/app/src/main/AndroidManifest.xml` with your Google Maps API key
2. Minimum SDK version: 21

### iOS
1. Update `ios/Runner/AppDelegate.swift` with your Google Maps API key
2. Minimum iOS version: 12.0

### Web
1. Update `web/index.html` with your Google Maps API key

## 🔧 Configuration

### Order Status Flow
```
Processing → Out for Delivery → Delivered
```

### Supported Order Statuses
- `processing` - Order is being prepared
- `confirmed` - Order confirmed and ready for pickup
- `out_for_delivery` - Driver is delivering
- `delivered` - Order completed
- `cancelled` - Order cancelled

## 🎨 UI Features

- **Dark Theme**: Professional dark color scheme
- **Real-time Updates**: Auto-refresh order list
- **Responsive Design**: Works on all screen sizes
- **Material Design**: Following Flutter Material guidelines

## 🔐 Security

- Token-based authentication
- Secure API communication
- Driver verification for all operations
- Active driver status checking

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  shared_preferences: ^2.2.2
  google_maps_flutter: ^2.5.0
  location: ^5.0.3
```

## 🐛 Troubleshooting

### Login Issues
- Verify backend server is running
- Check API URL configuration
- Ensure driver account exists and is active

### Orders Not Showing
- Check order status in database (must be: processing, confirmed, or out_for_delivery)
- Verify driver token is valid
- Check network connectivity

### Location Tracking
- Enable location permissions on device
- Verify Google Maps API key is configured
- Check GPS is enabled

## 🔄 CI/CD with Codemagic

This project is configured for automated builds using Codemagic.

### Quick Setup
1. Sign up at [Codemagic](https://codemagic.io/signup)
2. Connect your GitHub repository
3. Codemagic will auto-detect `codemagic.yaml`
4. Start your first build!

### Available Workflows
- **Android**: Builds release APK (~10-15 min)
- **iOS**: Builds IPA for App Store (~15-20 min)
- **Web**: Builds web app (~5-10 min)
- **Windows**: Builds Windows executable (~10-15 min)

### Documentation
- See `CODEMAGIC_QUICK_START.md` for 3-minute setup
- See `CODEMAGIC_SETUP.md` for detailed guide

### Free Tier
- 500 build minutes/month
- All platforms supported
- Perfect for this project!

## 🚀 Deployment

### Android (APK/AAB)
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

### iOS (IPA)
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 📝 Backend Requirements

This app requires a Laravel-based backend with the following:

1. **Database Tables**:
   - `drivers` - Driver accounts
   - `orders` - Order information
   - `order_items` - Order line items
   - `users` - Customer information

2. **API Endpoints**: See API Endpoints section above

3. **Driver Table Structure**:
```sql
- id
- name
- email
- password (hashed)
- phone
- vehicle_type
- vehicle_number
- is_active
- is_available
- current_lat
- current_lng
- token
- created_at
- updated_at
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License.

## 👥 Authors

- **VellsSoft** - Initial work

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Google Maps for location services
- Laravel for the backend API

## 📞 Support

For support, email support@vellsprime.com or create an issue in the repository.

---

**Made with ❤️ by VellsSoft**
