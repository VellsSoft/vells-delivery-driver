# 🚀 Codemagic Setup Guide - Vells Delivery Driver App

This guide will help you set up automated builds and deployments using Codemagic CI/CD.

## 📋 What is Codemagic?

Codemagic is a CI/CD platform specifically designed for Flutter apps. It provides:
- Automated builds for Android, iOS, Web, Windows, macOS, and Linux
- Integration with App Store Connect and Google Play Console
- Automated testing
- Build artifacts storage
- Email and Slack notifications

## ✅ Prerequisites

Before starting, ensure you have:
- [ ] GitHub account with your repository uploaded
- [ ] Codemagic account (sign up at https://codemagic.io)
- [ ] For iOS: Apple Developer account
- [ ] For Android: Google Play Console account (optional)

---

## 🎯 Step-by-Step Setup

### Step 1: Sign Up for Codemagic

1. **Go to Codemagic:**
   - Visit: https://codemagic.io/signup
   
2. **Sign up with GitHub:**
   - Click "Sign up with GitHub"
   - Authorize Codemagic to access your repositories
   - This is FREE for open-source projects!

### Step 2: Add Your Application

1. **In Codemagic Dashboard:**
   - Click "Add application"
   - Select "Flutter App"
   
2. **Connect Repository:**
   - Select "GitHub"
   - Choose your repository: `vells-delivery-driver`
   - Click "Finish: Add application"

### Step 3: Configure Build Settings

Codemagic will automatically detect the `codemagic.yaml` file in your repository.

#### **For Android Builds:**

1. **No signing required for testing** - APK will build without signing
2. **For Play Store (optional):**
   - Generate a keystore file
   - Upload to Codemagic: Settings → Code signing identities → Android
   - Add keystore, key alias, and passwords

#### **For iOS Builds:**

1. **Connect Apple Developer Account:**
   - Settings → Integrations → App Store Connect
   - Click "Enable App Store Connect integration"
   - Follow the wizard to connect your Apple ID

2. **Code Signing:**
   - Codemagic can automatically manage certificates
   - Or upload manual provisioning profiles

#### **For Web Builds:**

- No additional configuration needed
- Builds will be ready to deploy to any web hosting

### Step 4: Environment Variables (Optional)

If your app needs API keys or secrets:

1. **Go to:** Settings → Environment variables
2. **Add variables:**
   - `API_BASE_URL` - Your backend URL
   - `GOOGLE_MAPS_API_KEY` - Your Maps API key
   - Any other secrets

3. **Mark as secure** to hide values in logs

### Step 5: Start Your First Build

1. **Trigger Build:**
   - Click "Start new build"
   - Select workflow (android-workflow, ios-workflow, web-workflow, or windows-workflow)
   - Click "Start new build"

2. **Monitor Progress:**
   - Watch the build logs in real-time
   - Build typically takes 5-15 minutes

3. **Download Artifacts:**
   - Once complete, download APK/IPA/Web files
   - Artifacts are stored for 30 days

---

## 📱 Workflows Included

### 1. **Android Workflow**
- Builds release APK
- Runs tests and analysis
- Outputs: `app-release.apk`
- Duration: ~10-15 minutes

### 2. **iOS Workflow**
- Builds IPA for App Store
- Submits to TestFlight (if configured)
- Outputs: `Runner.ipa`
- Duration: ~15-20 minutes

### 3. **Web Workflow**
- Builds web app with CanvasKit renderer
- Outputs: `build/web/` folder
- Duration: ~5-10 minutes

### 4. **Windows Workflow**
- Builds Windows executable
- Outputs: `.exe` and `.msix` files
- Duration: ~10-15 minutes

---

## 🔧 Configuration File Explained

The `codemagic.yaml` file contains all build configurations:

```yaml
workflows:
  android-workflow:      # Workflow name
    name: Android Workflow
    instance_type: mac_mini_m1  # Build machine type
    environment:
      flutter: stable    # Flutter version
    scripts:
      - flutter build apk --release  # Build commands
    artifacts:
      - build/**/*.apk   # Files to save
    publishing:
      email:             # Notifications
        recipients:
          - your@email.com
```

---

## 📧 Notifications

### Email Notifications
- Already configured in `codemagic.yaml`
- Update email address: Change `prakaldathanvelan@gmail.com` to your email

### Slack Notifications (Optional)
1. Settings → Integrations → Slack
2. Connect your Slack workspace
3. Uncomment Slack section in `codemagic.yaml`

---

## 🚀 Automated Deployments

### Deploy to Google Play (Android)

1. **Set up Google Play:**
   - Settings → Integrations → Google Play
   - Upload service account JSON key
   
2. **Update `codemagic.yaml`:**
   ```yaml
   publishing:
     google_play:
       credentials: $GCLOUD_SERVICE_ACCOUNT_CREDENTIALS
       track: internal  # or alpha, beta, production
   ```

### Deploy to App Store (iOS)

1. **Already configured** in `codemagic.yaml`
2. **Enable in workflow:**
   - Set `submit_to_testflight: true`
   - Set `submit_to_app_store: true` for production

### Deploy Web App

1. **Build completes** → Download `build/web/` folder
2. **Deploy to:**
   - Firebase Hosting
   - Netlify
   - Vercel
   - GitHub Pages
   - Your own server

---

## 🔄 Automatic Builds on Push

### Enable Automatic Builds:

1. **Go to:** Settings → Build triggers
2. **Enable:** "Trigger on push"
3. **Select branches:** `main` or `master`
4. **Select workflow:** Choose which workflow to run

Now every push to GitHub will automatically trigger a build!

---

## 💰 Pricing

### Free Tier:
- ✅ 500 build minutes/month
- ✅ Unlimited team members
- ✅ All platforms
- ✅ Perfect for this project!

### Paid Plans:
- Start at $99/month for more build minutes
- Enterprise options available

---

## 🐛 Troubleshooting

### Build Fails - Dependencies
```bash
# Add to scripts section:
- name: Clean and get packages
  script: |
    flutter clean
    flutter pub get
```

### Build Fails - Gradle
```bash
# Increase build timeout:
max_build_duration: 120  # minutes
```

### iOS Code Signing Issues
- Use automatic code signing in Codemagic
- Or manually upload provisioning profiles

### Web Build Issues
```bash
# Try different renderer:
flutter build web --release --web-renderer html
```

---

## 📊 Build Status Badge

Add to your README.md:

```markdown
[![Codemagic build status](https://api.codemagic.io/apps/YOUR_APP_ID/YOUR_WORKFLOW_ID/status_badge.svg)](https://codemagic.io/apps/YOUR_APP_ID/YOUR_WORKFLOW_ID/latest_build)
```

Get your app ID from Codemagic dashboard URL.

---

## 🔐 Security Best Practices

1. **Never commit:**
   - API keys
   - Passwords
   - Keystore files
   - Certificates

2. **Use environment variables** for all secrets

3. **Enable 2FA** on your Codemagic account

4. **Rotate credentials** regularly

---

## 📝 Customization

### Change Flutter Version:
```yaml
environment:
  flutter: 3.16.0  # Specific version
  # or
  flutter: stable  # Latest stable
  # or
  flutter: beta    # Latest beta
```

### Add Custom Scripts:
```yaml
scripts:
  - name: Run custom script
    script: |
      echo "Running custom commands"
      dart run build_runner build
```

### Change Build Machine:
```yaml
instance_type: mac_mini_m1     # For iOS/macOS
instance_type: linux_x2        # For Android/Web
instance_type: windows_x2      # For Windows
```

---

## 🎯 Next Steps After Setup

1. **Test all workflows** - Run each workflow once
2. **Set up automatic builds** - Enable on push
3. **Configure notifications** - Add your email/Slack
4. **Set up deployments** - Connect to stores (optional)
5. **Add status badge** - Show build status in README

---

## 📞 Support

- **Codemagic Docs:** https://docs.codemagic.io/
- **Flutter Docs:** https://docs.flutter.dev/
- **Community:** Codemagic Slack community

---

## ✅ Checklist

After setup, verify:
- [ ] Codemagic account created
- [ ] Repository connected
- [ ] `codemagic.yaml` detected
- [ ] Android workflow builds successfully
- [ ] iOS workflow configured (if needed)
- [ ] Web workflow builds successfully
- [ ] Email notifications working
- [ ] Artifacts downloadable

---

## 🎉 You're All Set!

Your app will now build automatically on Codemagic. Every push to GitHub can trigger a new build, and you'll receive notifications when builds complete.

**Codemagic Dashboard:** https://codemagic.io/apps

---

## 📱 Quick Commands Reference

```bash
# Update codemagic.yaml
git add codemagic.yaml
git commit -m "Update: Codemagic configuration"
git push origin main

# This will trigger automatic build if enabled!
```

---

**Happy Building! 🚀**
