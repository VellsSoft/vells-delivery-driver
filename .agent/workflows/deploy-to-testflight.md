---
description: Deploy Flutter app from Git to Codemagic to TestFlight
---

# Deploy Flutter App: Git → Codemagic → TestFlight

This workflow guides you through the complete process of deploying your Flutter application to TestFlight using Codemagic CI/CD.

## Prerequisites

Before starting, ensure you have:
- [ ] Apple Developer Account (paid membership required)
- [ ] GitHub account with your Flutter project repository
- [ ] Codemagic account (free tier available)
- [ ] Xcode installed (if testing locally on macOS)
- [ ] App Store Connect access

---

## Phase 1: Prepare Your Flutter Project

### 1. Update iOS Configuration

Ensure your `ios/Runner/Info.plist` has all required permissions and metadata:

```xml
<key>CFBundleDisplayName</key>
<string>Your App Name</string>
<key>CFBundleIdentifier</key>
<string>com.yourcompany.appname</string>
<key>CFBundleVersion</key>
<string>1</string>
<key>CFBundleShortVersionString</key>
<string>1.0.0</string>
```

### 2. Update `pubspec.yaml`

Ensure version is set correctly:
```yaml
version: 1.0.0+1
```

### 3. Verify iOS Bundle ID

Check `ios/Runner.xcodeproj/project.pbxproj` or open in Xcode:
- Bundle Identifier should match your App Store Connect app
- Example: `com.vellssoft.deliveryboy`

---

## Phase 2: Push to GitHub

### 1. Initialize Git (if not already done)

```bash
git init
```

### 2. Create `.gitignore`

Ensure you have a proper Flutter `.gitignore`:
```
# Flutter/Dart
.dart_tool/
.packages
build/
.flutter-plugins
.flutter-plugins-dependencies

# iOS
ios/Pods/
ios/.symlinks/
ios/Flutter/Flutter.framework
ios/Flutter/Flutter.podspec
*.ipa
*.dSYM.zip

# Secrets
*.env
*.pem
*.p12
*.mobileprovision
```

### 3. Commit and Push

```bash
git add .
git commit -m "Initial commit for Codemagic deployment"
git branch -M main
git remote add origin https://github.com/yourusername/your-repo.git
git push -u origin main
```

---

## Phase 3: Set Up App Store Connect

### 1. Create App in App Store Connect

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Click **My Apps** → **+** → **New App**
3. Fill in:
   - **Platform**: iOS
   - **Name**: Your app name
   - **Primary Language**: English (or your choice)
   - **Bundle ID**: Select the one matching your Xcode project
   - **SKU**: Unique identifier (e.g., `delivery-boy-001`)
   - **User Access**: Full Access

### 2. Prepare App Information

Fill in the required fields:
- App Privacy Policy URL
- App Category
- Content Rights
- Age Rating (complete questionnaire)

### 3. Create App Icons and Screenshots

Required iOS assets:
- **App Icon**: 1024x1024px (no transparency, no alpha channel)
- **Screenshots**: 
  - iPhone 6.7" (1290 x 2796 px) - at least 3 screenshots
  - iPhone 6.5" (1242 x 2688 px) - at least 3 screenshots
  - iPad Pro 12.9" (2048 x 2732 px) - if supporting iPad

---

## Phase 4: Generate iOS Certificates & Provisioning Profiles

### Option A: Using Codemagic (Recommended - Automatic)

Codemagic can automatically manage certificates for you.

### Option B: Manual Setup

1. **Create App ID**:
   - Go to [Apple Developer Portal](https://developer.apple.com/account)
   - Certificates, IDs & Profiles → Identifiers → **+**
   - Select App IDs → Continue
   - Enter Bundle ID (must match your app)

2. **Create Distribution Certificate**:
   - Certificates → **+**
   - Select **Apple Distribution** → Continue
   - Create CSR (Certificate Signing Request) on your Mac:
     - Open Keychain Access → Certificate Assistant → Request a Certificate
     - Save to disk
   - Upload CSR and download certificate

3. **Create Provisioning Profile**:
   - Profiles → **+**
   - Select **App Store** → Continue
   - Select your App ID
   - Select your Distribution Certificate
   - Name it and download

---

## Phase 5: Configure Codemagic

### 1. Connect Repository

1. Go to [Codemagic](https://codemagic.io)
2. Click **Add application**
3. Select **GitHub** and authorize
4. Choose your repository
5. Select **Flutter App**

### 2. Configure iOS Code Signing

**Method 1: Automatic (Recommended)**
1. In Codemagic app settings → **Code signing**
2. Click **iOS code signing**
3. Click **Enable automatic code signing**
4. Connect your Apple Developer account:
   - Click **Connect Apple Developer Portal**
   - Sign in with your Apple ID
   - Codemagic will automatically fetch/create certificates

**Method 2: Manual**
1. Upload your Distribution Certificate (.p12)
2. Upload your Provisioning Profile (.mobileprovision)
3. Enter certificate password

### 3. Configure App Store Connect API Key

1. In App Store Connect → Users and Access → Keys
2. Click **+** to generate new key
3. Name it "Codemagic"
4. Access: **Developer**
5. Download the `.p8` key file (only available once!)
6. Note the **Key ID** and **Issuer ID**

7. In Codemagic:
   - Go to **Teams** → **Integrations** → **App Store Connect**
   - Upload the `.p8` file
   - Enter Key ID and Issuer ID

### 4. Create `codemagic.yaml`

Create this file in your project root:

```yaml
workflows:
  ios-testflight:
    name: iOS TestFlight
    max_build_duration: 120
    instance_type: mac_mini_m1
    environment:
      ios_signing:
        distribution_type: app_store
        bundle_identifier: com.vellssoft.deliveryboy
      vars:
        APP_STORE_CONNECT_ISSUER_ID: your-issuer-id
        APP_STORE_CONNECT_KEY_IDENTIFIER: your-key-id
        APP_STORE_CONNECT_PRIVATE_KEY: Encrypted(your-encrypted-key)
        CERTIFICATE_PRIVATE_KEY: Encrypted(your-cert-key)
      flutter: stable
      xcode: latest
      cocoapods: default
    scripts:
      - name: Set up code signing settings on Xcode project
        script: |
          xcode-project use-profiles
      - name: Get Flutter packages
        script: |
          flutter packages pub get
      - name: Install pods
        script: |
          find . -name "Podfile" -execdir pod install \;
      - name: Flutter build ipa
        script: |
          flutter build ipa --release \
            --build-name=1.0.0 \
            --build-number=$(($(app-store-connect get-latest-testflight-build-number "$APP_STORE_APPLE_ID") + 1)) \
            --export-options-plist=/Users/builder/export_options.plist
    artifacts:
      - build/ios/ipa/*.ipa
      - /tmp/xcodebuild_logs/*.log
      - flutter_drive.log
    publishing:
      email:
        recipients:
          - your-email@example.com
        notify:
          success: true
          failure: true
      app_store_connect:
        api_key: $APP_STORE_CONNECT_PRIVATE_KEY
        key_id: $APP_STORE_CONNECT_KEY_IDENTIFIER
        issuer_id: $APP_STORE_CONNECT_ISSUER_ID
        submit_to_testflight: true
        beta_groups:
          - Internal Testers
```

### 5. Commit and Push `codemagic.yaml`

```bash
git add codemagic.yaml
git commit -m "Add Codemagic configuration"
git push
```

---

## Phase 6: Trigger Build

### 1. Start Build in Codemagic

1. In Codemagic dashboard, select your app
2. Click **Start new build**
3. Select branch: `main`
4. Select workflow: `ios-testflight`
5. Click **Start new build**

### 2. Monitor Build Progress

Watch the build logs for:
- ✅ Dependencies installation
- ✅ Code signing
- ✅ Flutter build
- ✅ IPA generation
- ✅ Upload to TestFlight

Build typically takes 15-30 minutes.

---

## Phase 7: TestFlight Distribution

### 1. Wait for Processing

After Codemagic uploads:
1. Go to App Store Connect → TestFlight
2. Your build will appear under "iOS Builds"
3. Wait for "Processing" to complete (10-30 minutes)
4. Status will change to "Ready to Submit" or "Missing Compliance"

### 2. Export Compliance

If prompted:
1. Click on the build
2. Answer export compliance questions:
   - Does your app use encryption? (Usually "No" for basic apps)
3. Click **Submit**

### 3. Add Internal Testers

1. Go to **TestFlight** → **Internal Testing**
2. Click **+** next to Internal Testers
3. Add testers (up to 100 internal testers with Apple Developer account)
4. They'll receive an email invitation

### 4. Add External Testers (Optional)

1. Go to **TestFlight** → **External Testing**
2. Create a new group
3. Add testers (up to 10,000 external testers)
4. Submit for Beta App Review (required for external testing)

---

## Phase 8: Install on Device

### For Testers:

1. Install **TestFlight** app from App Store
2. Open invitation email
3. Click **View in TestFlight**
4. Click **Install**
5. App will download and install

---

## Troubleshooting

### Build Fails - Code Signing Issues
- Verify Bundle ID matches everywhere
- Check certificate hasn't expired
- Ensure provisioning profile includes your device UDID (for development)

### Build Fails - Dependencies
```bash
flutter clean
flutter pub get
cd ios && pod install --repo-update
```

### Upload to TestFlight Fails
- Verify App Store Connect API key is valid
- Check app version/build number isn't duplicate
- Ensure app has correct entitlements

### "Missing Compliance" in TestFlight
- Answer the export compliance questions
- For most apps without custom encryption: select "No"

---

## Quick Reference Commands

```bash
# Check Flutter setup
flutter doctor

# Build iOS locally (requires macOS)
flutter build ios --release

# Build IPA locally (requires macOS)
flutter build ipa --release

# Clean build
flutter clean

# Update pods
cd ios && pod install --repo-update && cd ..

# Check Git status
git status

# View Git remote
git remote -v
```

---

## Next Steps After TestFlight

Once testing is complete:
1. Fix any bugs found by testers
2. Prepare App Store listing (description, keywords, screenshots)
3. Submit for App Store Review
4. Wait for approval (typically 1-3 days)
5. Release to App Store! 🎉

---

## Useful Links

- [Codemagic Documentation](https://docs.codemagic.io/flutter-code-signing/ios-code-signing/)
- [App Store Connect](https://appstoreconnect.apple.com)
- [Apple Developer Portal](https://developer.apple.com/account)
- [TestFlight Documentation](https://developer.apple.com/testflight/)
- [Flutter iOS Deployment](https://docs.flutter.dev/deployment/ios)
