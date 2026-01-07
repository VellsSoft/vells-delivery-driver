# 📱 App Store Upload Guide - Vells Delivery Driver App

Complete guide to upload your Flutter app to the Apple App Store.

## 📋 Prerequisites

Before starting, ensure you have:
- [ ] **Apple Developer Account** ($99/year) - https://developer.apple.com/programs/
- [ ] **Mac computer** (required for iOS builds)
- [ ] **Xcode** installed (latest version from Mac App Store)
- [ ] **Flutter SDK** installed and configured
- [ ] **Valid Apple ID** with 2-factor authentication enabled

---

## 🎯 Overview

The process involves:
1. Prepare your app for release
2. Configure App Store Connect
3. Build and sign your app
4. Upload to App Store Connect
5. Submit for review

**Estimated Time**: 2-3 hours (first time)

---

## 📱 STEP 1: Prepare iOS App Configuration

### 1.1 Update App Information

Edit `ios/Runner/Info.plist`:

```xml
<key>CFBundleDisplayName</key>
<string>Vells Delivery</string>

<key>CFBundleName</key>
<string>Vells Delivery</string>

<key>CFBundleIdentifier</key>
<string>com.vellssoft.deliverydriver</string>

<key>CFBundleVersion</key>
<string>1</string>

<key>CFBundleShortVersionString</key>
<string>1.0.0</string>
```

### 1.2 Update Bundle Identifier

Open `ios/Runner.xcworkspace` in Xcode:

1. Click on "Runner" in the project navigator
2. Select "Runner" target
3. Go to "Signing & Capabilities"
4. Change Bundle Identifier to: `com.vellssoft.deliverydriver`
5. Select your Team (Apple Developer account)
6. Enable "Automatically manage signing"

### 1.3 Set Deployment Target

In Xcode:
1. Runner target → General
2. Set "Minimum Deployments" to: **iOS 12.0** or higher
3. Set "Supported Destinations" to: iPhone and iPad (or iPhone only)

### 1.4 Update App Icons

You need app icons in various sizes. Use a tool like:
- https://appicon.co/
- https://www.appicon.build/

Required sizes:
- 1024x1024 (App Store)
- 180x180 (iPhone)
- 167x167 (iPad Pro)
- 152x152 (iPad)
- 120x120 (iPhone)
- 87x87 (iPhone)
- 80x80 (iPad)
- 76x76 (iPad)
- 60x60 (iPhone)
- 58x58 (iPhone)
- 40x40 (iPad/iPhone)
- 29x29 (iPad/iPhone)
- 20x20 (iPad/iPhone)

Place icons in: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

---

## 🌐 STEP 2: Configure App Store Connect

### 2.1 Create App in App Store Connect

1. **Go to**: https://appstoreconnect.apple.com/
2. **Sign in** with your Apple Developer account
3. **Click** "My Apps" → "+" → "New App"

### 2.2 Fill in App Information

**Platforms**: iOS

**Name**: Vells Delivery Driver

**Primary Language**: English (U.S.)

**Bundle ID**: Select `com.vellssoft.deliverydriver`

**SKU**: `vells-delivery-driver-001` (unique identifier)

**User Access**: Full Access

Click **Create**

### 2.3 App Information

Fill in the following:

#### **Privacy Policy URL** (Required)
- Create a privacy policy page
- Example: `https://vellsprime.com/privacy-policy`
- Or use: https://www.freeprivacypolicy.com/

#### **Category**
- **Primary**: Business
- **Secondary**: Productivity

#### **Content Rights**
- Select: "No, it does not contain, show, or access third-party content"

### 2.4 Pricing and Availability

- **Price**: Free
- **Availability**: All countries (or select specific countries)

---

## 📸 STEP 3: Prepare App Store Assets

### 3.1 Screenshots (Required)

You need screenshots for:

**iPhone 6.7" Display** (iPhone 14 Pro Max, 15 Pro Max):
- Size: 1290 x 2796 pixels
- Minimum: 3 screenshots
- Maximum: 10 screenshots

**iPhone 6.5" Display** (iPhone 11 Pro Max, XS Max):
- Size: 1242 x 2688 pixels
- Minimum: 3 screenshots

**iPad Pro 12.9" Display** (if supporting iPad):
- Size: 2048 x 2732 pixels
- Minimum: 3 screenshots

**How to create screenshots**:
1. Run app on iOS Simulator
2. Navigate to key screens
3. Press `Cmd + S` to save screenshot
4. Screenshots saved to Desktop

**Recommended screens to capture**:
1. Login screen
2. Orders list (home screen)
3. Order details screen
4. Map/location tracking (if implemented)

### 3.2 App Preview Video (Optional)

- Length: 15-30 seconds
- Format: .mov or .mp4
- Shows key features

### 3.3 App Description

```
Vells Delivery Driver - Professional delivery management app for drivers.

FEATURES:
• Secure driver authentication
• Real-time order management
• View order details and customer information
• Update delivery status on the go
• GPS location tracking
• Professional, easy-to-use interface

PERFECT FOR:
• Delivery drivers
• Courier services
• Last-mile delivery operations
• Food delivery services
• Package delivery

BENEFITS:
• Streamline your delivery workflow
• Stay organized with real-time order updates
• Improve customer satisfaction
• Track your deliveries efficiently
• Professional tools for professional drivers

Download now and start managing your deliveries more efficiently!
```

### 3.4 Keywords

```
delivery, driver, courier, logistics, orders, tracking, GPS, delivery app, driver app, courier app
```

### 3.5 Promotional Text (Optional)

```
Streamline your delivery operations with our professional driver app. Real-time order management, GPS tracking, and more!
```

### 3.6 Support URL

```
https://vellsprime.com/support
```

### 3.7 Marketing URL (Optional)

```
https://vellsprime.com
```

---

## 🔨 STEP 4: Build the App

### 4.1 Clean and Prepare

```bash
cd d:\antigravity\allens\delivery_boy
flutter clean
flutter pub get
cd ios
pod install
cd ..
```

### 4.2 Build for Release

**Option A: Using Flutter Command**

```bash
flutter build ios --release
```

**Option B: Using Xcode**

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select "Any iOS Device (arm64)" as destination
3. Product → Archive
4. Wait for archive to complete

### 4.3 Archive and Upload

After archive completes:

1. **Xcode Organizer** opens automatically
2. Select your archive
3. Click **Distribute App**
4. Select **App Store Connect**
5. Click **Upload**
6. Select **Automatically manage signing**
7. Click **Upload**
8. Wait for upload to complete (5-30 minutes)

---

## 📤 STEP 5: Submit for Review

### 5.1 Complete App Information

In App Store Connect:

1. **Go to**: Your app → App Store tab
2. **Select**: iOS App → 1.0 Prepare for Submission

### 5.2 Fill Required Fields

#### **Screenshots**
- Upload screenshots for each required device size

#### **Description**
- Paste the description from Step 3.3

#### **Keywords**
- Add keywords (max 100 characters)

#### **Support URL**
- Add your support URL

#### **Marketing URL** (Optional)
- Add your website

#### **Version**
- 1.0.0

#### **Copyright**
- 2026 VellsSoft

### 5.3 Build Selection

1. Scroll to **Build** section
2. Click **Select a build before you submit your app**
3. Select the build you uploaded
4. Click **Done**

### 5.4 App Review Information

**Contact Information**:
- First Name: Your name
- Last Name: Your last name
- Phone: Your phone number
- Email: prakaldathanvelan@gmail.com

**Demo Account** (if login required):
```
Username: driver@test.com
Password: password
```

**Notes**:
```
This is a delivery driver app. Please use the demo credentials provided to test the app. The app connects to a backend API for order management.
```

### 5.5 Version Release

Select:
- **Automatically release this version** (recommended)
- Or: **Manually release this version**

### 5.6 Submit

1. Click **Add for Review**
2. Click **Submit to App Review**
3. Confirm submission

---

## ⏱️ STEP 6: Wait for Review

### Review Timeline
- **Typical**: 24-48 hours
- **First submission**: May take up to 7 days
- **Status updates**: Via email and App Store Connect

### Review Statuses
1. **Waiting for Review** - In queue
2. **In Review** - Being reviewed
3. **Pending Developer Release** - Approved, waiting for your release
4. **Ready for Sale** - Live on App Store!

### Common Rejection Reasons
- Missing demo account credentials
- App crashes on launch
- Incomplete metadata
- Privacy policy issues
- Missing required permissions descriptions

---

## 🔧 STEP 7: Configure Permissions (Important!)

### 7.1 Update Info.plist

Add permission descriptions in `ios/Runner/Info.plist`:

```xml
<!-- Location Permission -->
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to track deliveries and provide accurate navigation.</string>

<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>We need your location to track deliveries even when the app is in the background.</string>

<key>NSLocationAlwaysUsageDescription</key>
<string>We need your location to track deliveries and update your position.</string>

<!-- Camera Permission (if using for proof of delivery) -->
<key>NSCameraUsageDescription</key>
<string>We need camera access to capture proof of delivery photos.</string>

<!-- Photo Library Permission -->
<key>NSPhotoLibraryUsageDescription</key>
<string>We need access to your photo library to attach delivery photos.</string>
```

---

## 🚀 ALTERNATIVE: Use Codemagic for Automated Upload

### Benefits
- Automated builds
- Automatic code signing
- Direct upload to TestFlight
- No Mac required!

### Setup

1. **Already configured** in `codemagic.yaml`
2. **Connect Apple Developer account** in Codemagic
3. **Enable iOS workflow**
4. **Push to GitHub** → Automatic build and upload!

See `CODEMAGIC_SETUP.md` for details.

---

## 📱 TestFlight (Beta Testing)

Before submitting to App Store, test with TestFlight:

### 7.1 Enable TestFlight

1. In App Store Connect → TestFlight tab
2. Your build appears automatically after upload
3. Add beta testers (email addresses)
4. Testers receive invitation email
5. They install TestFlight app
6. They can test your app

### 7.2 Benefits
- Test with real users
- Get feedback before public release
- No review required for TestFlight
- Up to 10,000 testers

---

## 🔐 Code Signing (Manual Method)

If automatic signing doesn't work:

### Create Certificates

1. **Go to**: https://developer.apple.com/account/
2. **Certificates, IDs & Profiles**
3. **Create**:
   - iOS Distribution Certificate
   - App Store Provisioning Profile

### In Xcode

1. Signing & Capabilities
2. Uncheck "Automatically manage signing"
3. Select your provisioning profile
4. Select your certificate

---

## 💰 Costs

- **Apple Developer Program**: $99/year (required)
- **App Store listing**: Free
- **TestFlight**: Free

---

## 📊 After Approval

### Monitor Performance
- App Store Connect → Analytics
- Downloads, crashes, ratings

### Update App
1. Increment version number
2. Build new version
3. Upload to App Store Connect
4. Submit for review

---

## 🐛 Troubleshooting

### Build Fails
```bash
# Clean everything
flutter clean
cd ios
pod deintegrate
pod install
cd ..
flutter build ios --release
```

### Signing Issues
- Verify Apple Developer account is active
- Check Bundle ID matches
- Regenerate certificates if needed

### Upload Fails
- Check internet connection
- Try uploading from Xcode Organizer
- Use Application Loader (legacy tool)

### Rejected by Review
- Read rejection reason carefully
- Fix issues mentioned
- Resubmit with explanation

---

## ✅ Checklist

Before submission:
- [ ] Apple Developer account active
- [ ] Bundle ID configured
- [ ] App icons added (all sizes)
- [ ] Screenshots prepared (all sizes)
- [ ] Description written
- [ ] Privacy policy URL added
- [ ] Support URL added
- [ ] Demo credentials provided
- [ ] Permissions configured in Info.plist
- [ ] App tested on real device
- [ ] Build uploaded to App Store Connect
- [ ] All metadata filled in
- [ ] Build selected
- [ ] Submitted for review

---

## 📞 Support Resources

- **App Store Connect**: https://appstoreconnect.apple.com/
- **Developer Portal**: https://developer.apple.com/account/
- **App Review Guidelines**: https://developer.apple.com/app-store/review/guidelines/
- **Human Interface Guidelines**: https://developer.apple.com/design/human-interface-guidelines/
- **Flutter iOS Deployment**: https://docs.flutter.dev/deployment/ios

---

## 🎉 Success!

Once approved, your app will be available on the App Store!

**App Store URL**: `https://apps.apple.com/app/idYOUR_APP_ID`

---

**Good luck with your App Store submission! 🚀**
