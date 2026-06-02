# YiyosaGel v3

Flutter tabanli Android ve web uygulamasi icin temiz kod tabani.

## Repo Yapisi

- `apps/yiyosagel_app`: Flutter Android/web uygulamasi.
- `firebase/functions`: Cloud Functions kaynaklari.
- `firebase/firestore.rules`: Firestore guvenlik kurallari.
- `firebase/database.rules.json`: Realtime Database guvenlik kurallari.
- `docs`: mimari, guvenlik ve yol haritasi.

## Hedef

- Native Flutter arayuz: Android ve web.
- Firebase Auth: misafir ve Google girisi.
- Cloud Functions: skor, altin, odul, magaza, limit ve rapor gibi kritik islemler.
- Realtime Database: canli oda, sohbet, presence ve anlik oyun akisi.
- Firestore: profil, envanter, magaza, rapor, admin ve ekonomi verileri.
- Firebase Cloud Messaging: Android bildirimleri.
- Guvenli odeme altyapisi: Google Play Billing ve web odeme saglayicisi.

## Yerel Kurulum

Flutter SDK kurulduktan sonra:

```bash
cd apps/yiyosagel_app
flutter pub get
flutter create . --platforms=android,web
flutter run -d chrome
```

Functions:

```bash
cd firebase/functions
npm install
npm run build
```

## Onemli Firebase Notu

`apps/yiyosagel_app/lib/src/core/firebase/firebase_options.dart` icindeki Android `appId` gecici degerdir. Firebase Console'da Android app eklenince FlutterFire CLI ile dogru config uretilmeli.

Eski React/Firebase projesi Desktop altindaki `yarismafinal` klasorunde incelendi. Bu repo yeni Flutter + web uygulamasinin temiz kod tabani olarak ilerleyecek.
