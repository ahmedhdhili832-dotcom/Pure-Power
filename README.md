# PURE & POWER

## Plateforme web professionnelle de services

**PURE & POWER** est une plateforme web moderne dédiée à l’aide à domicile et au nettoyage professionnel.

Le projet fonctionne comme un véritable parcours client : découverte → choix du service → devis → demande → validation par l’administration → contrat PDF par email → confirmation client.

## 🚀 SITES LIVE

### 👤 Site client
🌐 **https://pure-powe.netlify.app/**

### 🛡️ Site administration
🌐 **https://pure-powe.netlify.app/admin/**

### 📄 Page de confirmation du contrat
🌐 **https://pure-powe.netlify.app/contract-confirmation.html**

### 💻 Repository GitHub
🌐 **https://github.com/ahmedhdhili832-dotcom/Pure-Power**

> Les liens ci-dessus pointent vers le déploiement Netlify du projet. Après chaque push sur `main`, Netlify peut redéployer automatiquement le site.

## 🔄 WORKFLOW RÉEL

```text
SITE CLIENT
   ↓
Formulaire de demande
   ↓
Calcul du prix estimatif
   ↓
Envoi de la demande
   ↓
SUPABASE — stockage réel
   ↓
ADMIN / DEMANDES
   ↓
✓ Approuver
   ↓
Génération du contrat PDF
   ↓
Email client avec PDF + lien sécurisé
   ↓
CLIENT — contract-confirmation.html
   ↓
✓ Accepter     ✕ Refuser
   ↓
Paiement
```

## 🛡️ Administration

L’espace `/admin/` permet de :

- consulter les demandes enregistrées dans Supabase ;
- voir le client, la prestation, la date, l’horaire, l’adresse et le montant ;
- approuver une demande ;
- refuser une demande ;
- générer automatiquement le contrat PDF ;
- envoyer le PDF au client par email ;
- fournir au client un lien sécurisé de confirmation ;
- suivre les statuts de la demande.

L’administration demande une **clé admin** stockée en variable d’environnement Netlify. La clé Supabase `service_role` reste uniquement côté serveur.

## 👤 Parcours client

Le client peut :

1. choisir une prestation ;
2. obtenir immédiatement une estimation ;
3. envoyer sa demande sans créer de compte ;
4. recevoir le contrat après validation administrative ;
5. ouvrir le lien reçu par email ;
6. accepter ou refuser le contrat ;
7. accéder ensuite à l’étape de paiement.

## 📄 Pages principales

| Page | Fichier |
|---|---|
| Accueil | `index.html` |
| Présentation | `presentation.html` |
| Prestations | `services.html` |
| Engagement | `experience.html` |
| Tarifs | `tarifs.html` |
| Demande / devis | `booking.html` |
| Contact | `contact.html` |
| Connexion | `login.html` |
| Inscription | `register.html` |
| Espace client | `dashboard.html` |
| Réservations client | `reservations.html` |
| Paiement | `payment.html` |
| Contrat | `contract.html` |
| Confirmation contrat | `contract-confirmation.html` |
| Administration | `admin/` |

## ⚙️ Backend production

### Supabase

Le fichier :

```text
database/supabase-schema.sql
```

contient la structure de la table `bookings`, les statuts, les index et les règles RLS.

### Netlify Functions

```text
netlify/functions/
├── create-booking.mjs
├── admin-bookings.mjs
├── admin-booking.mjs
└── contract.mjs
```

### Variables Netlify à configurer

Dans les variables d’environnement du site Netlify :

```text
SUPABASE_URL=...
SUPABASE_SERVICE_ROLE_KEY=...
ADMIN_KEY=...
RESEND_API_KEY=...
MAIL_FROM=...
SITE_URL=https://pure-powe.netlify.app
```

**Ne jamais mettre ces valeurs secrètes dans le JavaScript du navigateur ou dans GitHub.**

## ✉️ Email + contrat PDF

Lorsqu’un administrateur approuve une demande :

- le serveur génère un PDF personnalisé ;
- le PDF est joint à l’email ;
- le client reçoit un lien de confirmation ;
- la décision du client est enregistrée dans Supabase.

Le système utilise Resend pour l’envoi transactionnel et ses pièces jointes. citeturn0search0turn0search6

## 🎨 Design

- Design premium et responsive
- Bleu nuit, vert sauge, champagne et blanc cassé
- Cartes modernes
- Animations et micro-interactions
- Compatible mobile / tablette / desktop
- Respect de `prefers-reduced-motion`

## 🛠️ Technologies

- HTML5
- CSS3
- JavaScript ES6+
- Netlify
- Netlify Functions
- Supabase / PostgreSQL
- Resend
- PDFKit
- Google Fonts

## 📁 Structure

```text
Pure-Power/
├── index.html
├── presentation.html
├── services.html
├── experience.html
├── tarifs.html
├── booking.html
├── contact.html
├── login.html
├── register.html
├── dashboard.html
├── profile.html
├── reservations.html
├── payment.html
├── contract.html
├── contract-confirmation.html
│
├── admin/
│   ├── index.html
│   ├── reservations.html
│   ├── clients.html
│   ├── contracts.html
│   ├── payments.html
│   ├── services.html
│   ├── pricing.html
│   ├── calendar.html
│   └── settings.html
│
├── database/
│   └── supabase-schema.sql
│
├── netlify/
│   └── functions/
│       ├── create-booking.mjs
│       ├── admin-bookings.mjs
│       ├── admin-booking.mjs
│       └── contract.mjs
│
├── css/
└── js/
```

## 🔐 Sécurité

Les données sensibles passent par les fonctions serveur. Le navigateur ne reçoit pas la clé Supabase `service_role`. L’accès à l’administration utilise une clé serveur dédiée.

Pour un déploiement commercial complet, l’étape suivante recommandée est de remplacer cette clé admin par une authentification administrateur complète avec comptes, rôles et sessions sécurisées.

## 📞 Contact

**PURE & POWER**

Téléphone : **07 58 29 80 26**

---

© 2026 **PURE & POWER** — Tous droits réservés.
