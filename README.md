# ☕ Coffee Taste

A complete coffee ordering app built with Flutter. Browse drinks, customize size and milk, save favorites, manage a cart with promo codes, check out, and track your orders. Everything works offline with local storage, so there is no backend to set up.

---

## ✨ Features

**Onboarding and account**
- Animated splash screen that routes automatically (home if logged in, login if onboarding was seen, otherwise onboarding)
- 3-page onboarding with skip, page dots and smooth transitions (shown once)
- Sign up (name, phone, password, confirm password) and sign in with form validation
- Password show/hide, loading states, friendly error messages
- Forgot password (local reset by phone number)
- Session is remembered, so you stay logged in after restarting the app
- Log out with confirmation

**Browsing**
- Personalized greeting and avatar initials
- Promo banner (tap to copy the code)
- Category chips: All, Coffee, Tea, Frozen, Smoothies, Bubble Tea
- Horizontal sections (Popular, Frozen, Bubble Tea) with "See all" grid pages
- Sort by most popular, price (low or high) or top rated
- Live search with suggestions and instant results
- 21 drinks with ratings, calories and descriptions

**Ordering**
- Product details with hero animation, size (S/M/L), milk choice with extra cost, and quantity
- Quick add (+) button on every card
- Cart with quantity stepper, swipe to remove with Undo, and cart badge on the bottom bar
- Pickup or delivery option (delivery fee added)
- Working promo codes: `COFFEE10` (10% off) and `WELCOME20` (20% off)
- Itemized totals: subtotal, discount, tax, delivery, total
- Checkout with success screen, then order tracking (Preparing, Ready or On the way, Completed)

**Personal**
- Favorites tab (heart any drink)
- Order history with live status
- Profile with stats, edit name, promo info and about dialog
- All data saved per account on the device

---

## 🛠️ Tech Stack

| Area | Tool |
|------|------|
| Framework | Flutter (Dart) |
| State management | Built-in `ChangeNotifier` (no extra package) |
| Local storage | `shared_preferences` |
| Password hashing | `crypto` (salted SHA-256) |

Only two packages are needed.

---

## 📁 Project Structure

```
lib/
├── main.dart                      # Entry point, loads saved data, runs the app
├── core/
│   ├── constants.dart             # Colors, currency, tax, delivery fee, promo codes
│   ├── theme.dart                 # App theme
│   └── utils.dart                 # Toasts, fade route, validators, tab controller
├── models/
│   ├── product.dart               # Product, categories, sizes, milk options
│   ├── cart_item.dart             # Cart line (drink + options + quantity)
│   └── order.dart                 # Order and order lines
├── data/
│   └── menu.dart                  # The drink menu (edit this to change the menu)
├── state/
│   └── app_state.dart             # Auth, favorites, cart, orders, persistence
├── widgets/
│   ├── common_widgets.dart        # Logo, buttons, text field, stepper, empty state
│   └── product_card.dart          # Reusable drink card
└── screens/
    ├── splash_screen.dart
    ├── onboarding_screen.dart
    ├── login_screen.dart
    ├── signup_screen.dart
    ├── main_shell.dart            # Bottom navigation (Home, Favorites, Cart, Profile)
    ├── home_screen.dart
    ├── search_screen.dart
    ├── product_list_screen.dart   # "See all" grid
    ├── product_details_screen.dart
    ├── favorites_screen.dart
    ├── cart_screen.dart
    ├── order_success_screen.dart
    ├── orders_screen.dart
    └── profile_screen.dart
```

---

## 🚀 Getting Started

### 1. Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.7 or newer recommended)
- An Android or iOS device or emulator

### 2. Set up the project
1. Copy the `lib/` folder into your Flutter project (replace the old one).
2. **Delete the old files** that used spaces in their names (`home screen.dart`, `login screen.dart`, `sign up screen.dart`, `splash screen.dart`, `on boarding screen.dart`). The new structure replaces them.
3. Merge `pubspec.yaml` with yours, or run:

```bash
flutter pub add shared_preferences crypto
```

4. Make sure your logo is declared as an asset in `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/images/
```

and that `assets/images/coffee.png` exists. (If it is missing, the app shows a coffee icon instead of crashing.)

### 3. Run

```bash
flutter pub get
flutter run
```

### 4. Try it
1. Finish onboarding, then tap **Sign Up** and create an account.
2. Add a few drinks, open the cart and apply `COFFEE10`.
3. Choose Pickup or Delivery, tap **Checkout**, then **Track my order**.

---

## 📦 Build

```bash
flutter build apk --release        # Android APK
flutter build appbundle --release  # Play Store bundle
flutter build ios --release        # iOS (on macOS)
```

**Internet permission (Android):** drink photos load from the network, so make sure `android/app/src/main/AndroidManifest.xml` contains:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

Photos are optional: if one fails to load (or a drink has no photo), a colored tile with the drink's emoji is shown instead.

---

## ⚙️ Customization

| What | Where |
|------|-------|
| Currency symbol | `kCurrency` in `core/constants.dart` |
| Tax rate and delivery fee | `kTaxRate`, `kDeliveryFeeCents` in `core/constants.dart` |
| Promo codes | `kPromoCodes` in `core/constants.dart` |
| Brand colors | `AppColors` in `core/constants.dart` |
| Menu items, prices, photos | `data/menu.dart` |
| Sizes and price multipliers | `kSizes` in `models/product.dart` |
| Milk options and extra cost | `kMilks` in `models/product.dart` |
| Onboarding text | `_pages` in `screens/onboarding_screen.dart` |

**Adding a drink:** add a `Product(...)` entry to `kMenu` in `data/menu.dart`. Prices are stored in cents (`450` = 4.50). Leave `imageUrl` empty to use the emoji tile, or use your own image URL.

---

## 🧠 How It Works

- `AppState` (`state/app_state.dart`) is the single source of truth. Screens listen to it with `AnimatedBuilder`, so the cart badge, favorites hearts and totals update instantly everywhere.
- Data is saved per account in `shared_preferences` (users, session, favorites, cart, orders) and restored on launch.
- Money is handled in integer cents to avoid rounding errors.
- Identical drinks with identical options merge into one cart line.
- Order status is simulated from elapsed time (Preparing under 2 min, Ready or On the way under 5 min, then Completed), since there is no server.

---

## ⚠️ Important Notes

- **Accounts are stored only on the device.** Passwords are salted and hashed, but this is a demo-grade setup. For a production app, replace the auth and order code in `AppState` with a real backend (Firebase Auth and Firestore, or your own API), and use secure storage for sessions.
- Payments are simulated. No real payment is processed.
- "Forgot password" resets locally by phone number. A real app should verify the user with an OTP or email first.

---

## 🩺 Troubleshooting

| Problem | Fix |
|---------|-----|
| Build error about `crypto` or `shared_preferences` | Run `flutter pub add shared_preferences crypto`, then `flutter pub get` |
| Logo not showing | Check `assets/images/coffee.png` exists and `assets/images/` is listed in `pubspec.yaml` |
| Photos not loading | Check internet and the `INTERNET` permission. Emoji tiles are shown as a fallback |
| Old import errors (`home screen.dart`) | Delete the old files with spaces in their names |
| Want to see onboarding again | Clear app data or uninstall the app |

---

## 🗺️ Roadmap Ideas

- Real backend (Firebase or REST API) with live order status
- Online payments
- Saved delivery addresses and map
- Push notifications for order updates
- Reorder button and loyalty points
- Dark theme and localization

---

## 📄 License

Add your preferred license here (for example, MIT).
