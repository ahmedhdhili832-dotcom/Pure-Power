# Pure & Power — Admin Flutter App

Application Android destinée à l'administration de Pure & Power.

## Architecture

```text
admin_app/
├── lib/
│   ├── main.dart
│   ├── models/
│   │   └── booking.dart
│   ├── services/
│   │   └── admin_api.dart
│   ├── screens/
│   │   ├── login_screen.dart
│   │   └── dashboard_screen.dart
│   └── theme/
│       └── app_theme.dart
└── pubspec.yaml
```

## Fonctionnalités

- Connexion administrateur par clé protégée dans le stockage sécurisé Android.
- Dashboard avec réservations, demandes en attente, clients et chiffre estimé.
- Liste des réservations.
- Fiche détaillée d'une demande.
- Approbation / refus depuis l'application.
- Rafraîchissement des données depuis l'API Netlify.
- Design Material 3 adapté à l'identité Pure & Power.

## API

L'application appelle uniquement les fonctions Netlify publiques :

```text
GET  /.netlify/functions/admin-bookings
POST /.netlify/functions/admin-booking
```

La `SUPABASE_SERVICE_ROLE_KEY` reste exclusivement côté serveur.

> La clé `ADMIN_KEY` n'est pas enregistrée dans le dépôt GitHub. Elle est saisie par l'administrateur dans l'application et stockée localement via `flutter_secure_storage`.

## Générer l'APK

Depuis le dossier `admin_app` :

```bash
flutter pub get
flutter build apk --release
```

Le fichier final sera généré dans :

```text
build/app/outputs/flutter-apk/app-release.apk
```
