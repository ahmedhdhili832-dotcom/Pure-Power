# PURE & POWER

## Plateforme web professionnelle de services

**PURE & POWER** est une plateforme web moderne dédiée à l’aide à domicile et au nettoyage professionnel.

Le projet suit un parcours client complet : découverte → choix du service → devis → demande → validation par l’administration → contrat PDF → confirmation client → paiement.

## 🚀 SITES

### 👤 Site client
https://pure-powe.netlify.app/

### 🛡️ Administration
https://pure-powe.netlify.app/admin/

### 📄 Confirmation de contrat
https://pure-powe.netlify.app/contract-confirmation.html

### 💻 Repository
https://github.com/ahmedhdhili832-dotcom/Pure-Power

## 🧱 Architecture du projet

Le code est organisé par responsabilité afin d’éviter un gros fichier unique et de faciliter les évolutions.

```text
Pure-Power/
│
├── *.html                     # Pages publiques et espace client
│
├── admin/                     # Interface d’administration
│   ├── *.html
│   ├── admin.css
│   └── admin.js
│
├── css/                       # Système visuel
│   ├── style.css              # Base historique / styles globaux
│   ├── premium.css             # Couche premium + imports des modules
│   ├── components.css          # Composants réutilisables
│   ├── utilities.css           # Classes utilitaires et responsive
│   ├── pages.css               # Styles spécifiques aux pages
│   └── services-premium.css    # Styles spécifiques aux prestations
│
├── js/                        # JavaScript côté navigateur
│   ├── app.js                 # Bootstrap de l’application
│   ├── site.js                # Logique historique du site / espace client
│   ├── app-client.js          # Initialisation client
│   ├── booking-production.js   # Flux de demande de prestation
│   └── modules/               # Modules JS indépendants
│       ├── navigation.js
│       ├── header.js
│       ├── reveal.js
│       ├── media.js
│       ├── forms.js
│       └── site-meta.js
│
├── database/
│   └── supabase-schema.sql    # Schéma PostgreSQL / Supabase
│
├── netlify/
│   └── functions/              # API serveur sécurisée
│       ├── create-booking.mjs
│       ├── admin-bookings.mjs
│       ├── admin-booking.mjs
│       ├── contract.mjs
│       └── send-contract.js
│
├── package.json
└── netlify.toml
```

## 🎯 Principes de développement

- **HTML** : contenu et structure des pages uniquement.
- **CSS** : design system, composants, responsive et styles de page.
- **JavaScript** : comportement, navigation, validation et interactions.
- **Backend** : logique sensible uniquement côté Netlify Functions.
- **Base de données** : réservations et statuts dans Supabase.

Cette séparation permet de modifier une fonctionnalité sans devoir réécrire toute l’application.

## 🔄 Workflow

```text
SITE CLIENT
   ↓
Formulaire de demande
   ↓
Calcul du prix estimatif
   ↓
Envoi de la demande
   ↓
SUPABASE
   ↓
ADMIN / DEMANDES
   ↓
✓ Approuver
   ↓
Contrat PDF + email
   ↓
CLIENT / confirmation sécurisée
   ↓
✓ Accepter     ✕ Refuser
   ↓
Paiement
```

## 🛡️ Administration

L’espace `/admin/` est destiné à la gestion des demandes, clients, contrats, paiements, services, tarifs, calendrier et paramètres.

Les clés sensibles restent côté serveur. La clé Supabase `service_role` ne doit jamais être exposée dans le navigateur.

## ⚙️ Backend

### Supabase

Le schéma se trouve dans :

```text
database/supabase-schema.sql
```

### Netlify Functions

Les fonctions serveur gèrent notamment la création des demandes, leur traitement administratif et le workflow de contrat.

Variables d’environnement prévues :

```text
SUPABASE_URL=...
SUPABASE_SERVICE_ROLE_KEY=...
ADMIN_KEY=...
RESEND_API_KEY=...
MAIL_FROM=...
SITE_URL=https://pure-powe.netlify.app
```

## 🎨 Design system

La direction visuelle utilise une identité premium :

- bleu nuit ;
- vert sauge ;
- champagne ;
- blanc cassé ;
- cartes et boutons cohérents ;
- responsive mobile / tablette / desktop ;
- animations et micro-interactions ;
- prise en charge de `prefers-reduced-motion`.

## 📈 Évolution prévue

La base actuelle peut évoluer vers :

- espace client complet ;
- planning des interventions ;
- gestion des intervenants ;
- paiement en ligne ;
- facturation ;
- notifications et rappels ;
- statistiques commerciales ;
- rôles et authentification administrateur complète.

## 📞 Contact

**PURE & POWER**

Téléphone : **07 58 29 80 26**

---

© 2026 **PURE & POWER** — Tous droits réservés.
