# Google Maps Setup Guide

## Step 1: Get Google Maps API Key

1. Go to: https://console.cloud.google.com/
2. Create a new project or select existing one
3. Enable these APIs:
   - Maps JavaScript API
   - Geocoding API
   - Directions API
4. Go to "Credentials" → "Create Credentials" → "API Key"
5. Copy your API key

## Step 2: Configure the API Key

### For Web (Chrome):
Edit: `delivery_boy/web/index.html`
Replace `YOUR_GOOGLE_MAPS_API_KEY` with your actual key

### For Android:
Edit: `delivery_boy/android/app/src/main/AndroidManifest.xml`
Replace `YOUR_GOOGLE_MAPS_API_KEY_HERE` with your actual key

## Step 3: Restrict API Key (Recommended)

In Google Cloud Console:
1. Go to your API key
2. Set Application restrictions
3. Add your domain/package name

## Important Notes:
- The current implementation uses OpenStreetMap (no key needed)
- To switch to Google Maps, follow this guide
- Google Maps has a free tier: $200/month credit
- For testing, you can use the current OpenStreetMap setup
