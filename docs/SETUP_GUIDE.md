# 🚀 دليل الـ Setup خطوة بخطوة

هاك الخطوات الكاملة عشان تشغل CineVault على الماك M5 بتاعك.

---

## ✅ Step 1: تأكد إن Flutter شغال

```bash
flutter --version
flutter doctor
```

المفروض تشوف نتيجة حلوة. لو فيه مشاكل مع iOS أو Android SDK `flutter doctor` هيقولك إيه اللي ناقص.

---

## ✅ Step 2: اعمل المشروع على الماك

افتح Terminal وروح للمكان اللي عايز تحط فيه المشروع:

```bash
cd ~/Developer    # أو أي فولدر بتحب
flutter create cine_vault \
  --org com.ismail \
  --platforms=android,ios \
  --description "A clean architecture Flutter movie app"
cd cine_vault
```

---

## ✅ Step 3: انسخ الـ files اللي عملتها

هعدي عليك الـ files اللي إحنا عاملينها. المطلوب:

1. استبدل `pubspec.yaml` بالملف اللي في المشروع
2. انسخ فولدر `lib/` بالكامل
3. أنشئ `.env` من `.env.example`

```bash
# في الفولدر الرئيسي للمشروع:
cp .env.example .env
```

---

## ✅ Step 4: احصل على TMDB API Key

1. روح https://www.themoviedb.org/signup
2. Sign up (مجاني خالص)
3. بعد تأكيد الإيميل: Settings → API → **Create**
4. اختار **"Developer"**
5. املى الفورم:
   - Application Name: `CineVault`
   - Application URL: `https://github.com/yourname/cine_vault`
   - Application Summary: `Personal learning project for Flutter`

هتاخد حاجتين:
- **API Key (v3)**: `1234567890abcdef...`
- **API Read Access Token (v4)**: `eyJhbGciOiJIUzI1NiJ9...`

---

## ✅ Step 5: حط الـ Keys في `.env`

افتح `.env` وحط:

```env
TMDB_API_KEY=<الـ API Key v3 هنا>
TMDB_ACCESS_TOKEN=<الـ Read Access Token v4 هنا>
TMDB_BASE_URL=https://api.themoviedb.org/3
TMDB_IMAGE_BASE_URL=https://image.tmdb.org/t/p
```

**مهم جداً:** متحطش الـ `.env` في Git! هنضيفه في `.gitignore`:

```bash
echo ".env" >> .gitignore
```

---

## ✅ Step 6: ثبت الـ Dependencies

```bash
flutter pub get
```

لو لقيت warnings، متقلقش — تقدر تشغل عادي.

---

## ✅ Step 7: افتحه في Android Studio

```bash
open -a "Android Studio" .
```

لو في Android Studio الـ Flutter plugin مش موجود:
**Preferences → Plugins** → ابحث عن "Flutter" → Install → Restart

---

## ✅ Step 8: اختار Simulator/Emulator

### Android Emulator:
1. في Android Studio: **Tools → Device Manager**
2. Create Device → اختار جهاز (Pixel 8 مناسب)
3. اختار System Image (API 34 أو أحدث)
4. Finish → ابدأ الـ emulator

### iOS Simulator (ماك فقط):
```bash
# شغل simulator من command line
open -a Simulator

# أو من Xcode: Xcode → Open Developer Tool → Simulator
```

---

## ✅ Step 9: شغل التطبيق

```bash
# شوف الأجهزة المتاحة
flutter devices

# شغل على أول جهاز
flutter run

# أو اختار جهاز معين
flutter run -d <device_id>
```

---

## 🐛 مشاكل شائعة وحلولها

### المشكلة: "Could not load .env"
**الحل:** تأكد إن `.env` موجود في root المشروع وإنه مضاف في `pubspec.yaml`:
```yaml
flutter:
  assets:
    - .env
```

### المشكلة: "401 Unauthorized" من TMDB
**الحل:** تأكد إن الـ ACCESS_TOKEN مش الـ API_KEY. Bearer token هو الـ v4 token.

### المشكلة: "CocoaPods not installed" (iOS)
**الحل:**
```bash
sudo gem install cocoapods
cd ios && pod install && cd ..
```

### المشكلة: iOS simulator مش بيفتح صورة من TMDB
**الحل:** في `ios/Runner/Info.plist` ضيف:
```xml
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
</dict>
```
(لا: ده للـ development بس، production لازم HTTPS فقط)

### المشكلة: Gradle build بطيء جداً
**الحل:** في `android/gradle.properties` ضيف:
```
org.gradle.jvmargs=-Xmx4096m -XX:MaxPermSize=512m
org.gradle.parallel=true
org.gradle.caching=true
```

---

## 🎯 Debugging في Android Studio

### Breakpoints:
- دوس على اليمين جنب رقم السطر
- شغل Debug mode (Shift+F9)

### Hot Reload vs Hot Restart:
- **Hot Reload** (⌘\): بيحدث الـ UI بدون ما يفقد الـ state
- **Hot Restart** (⌘⇧\): بيعيد تشغيل التطبيق من الأول

### Flutter DevTools:
```bash
flutter pub global activate devtools
dart devtools
```
بيديك:
- Widget Inspector
- Performance profiler
- Memory analyzer
- Network monitor

---

## 📱 التطبيق شغال على الأجهزة الحقيقية

### Android:
1. فعل Developer Options على الموبايل (دوس Build Number 7 مرات)
2. فعل USB Debugging
3. وصله بالـ Mac بـ USB
4. `flutter devices` → شوف موبايلك
5. `flutter run -d <device_id>`

### iPhone:
1. وصل الآيفون بالماك
2. افتح Xcode مرة واحدة → Trust the device
3. في `ios/Runner.xcodeproj/project.pbxproj`: غيّر الـ Team
4. `flutter run -d <device_id>`

---

## 🎉 Success Criteria

لو كل حاجة اشتغلت صح، المفروض تشوف:
- ✅ Splash screen لحظة واحدة
- ✅ Home screen فيه carousel فوق
- ✅ 4 sections من الأفلام (Popular, Top Rated, Now Playing, Upcoming)
- ✅ كل movie card فيها poster + rating + اسم
- ✅ Pull to refresh شغال
- ✅ Dark theme بلون Netflix الأحمر

لو مش شايف الأفلام، افتح الـ terminal اللي فيه `flutter run` وشوف الـ logs — هتلاقي الـ API request والـ response مطبوعين بشكل مرتب (شكراً لـ PrettyDioLogger).
