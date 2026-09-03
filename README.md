# PURE & POWER

## Plateforme web professionnelle de services de proximité

**PURE & POWER** est une plateforme web moderne dédiée à l’aide à domicile et au nettoyage professionnel à **Ajaccio et alentours**.

Le projet est organisé comme un véritable parcours client : découverte de la marque → présentation → choix du service → détail → devis/réservation → espace client.

## 🚀 Live Demo

🌐 **https://pure-powe.netlify.app**

## ✨ Expérience & design

- 🎨 Design premium : bleu nuit, vert sauge et touches champagne
- 🧭 Parcours client clair et découpé en pages
- 🏠 Choix entre **Aide à domicile** et **Nettoyage professionnel**
- 💎 Cartes modernes, ombres douces et effets glassmorphism légers
- ✨ Animations d’apparition et micro-interactions au survol
- 📱 Responsive mobile / tablette / desktop
- ♿ Respect de `prefers-reduced-motion`
- 🔐 Architecture prête pour un espace client et une administration

## 📄 Parcours principal

```text
QR CODE
  ↓
Accueil
  ↓
Présentation
  ↓
Choix du service
  ├── Aide à domicile
  │    ├── Entretien du logement
  │    ├── Tâches ménagères
  │    ├── Aide à la toilette simple
  │    ├── Courses & accompagnement
  │    └── Présence rassurante
  │
  └── Nettoyage professionnel
       ├── Bureaux & locaux
       ├── Magasins & boutiques
       ├── Restaurants
       ├── Airbnb & locations
       └── Vitres & grand nettoyage
             ↓
        Devis / Réservation
             ↓
        Confirmation
             ↓
        Espace client
```

## 📚 Pages

| Page | Fichier |
|---|---|
| Accueil | `index.html` |
| Présentation | `presentation.html` |
| Prestations | `services.html` |
| Engagement | `experience.html` |
| Tarifs & devis | `tarifs.html` |
| Demande de devis / réservation | `booking.html` |
| Contact | `contact.html` |
| Connexion | `login.html` |
| Inscription | `register.html` |
| Tableau de bord | `dashboard.html` |
| Profil | `profile.html` |
| Réservations | `reservations.html` |
| Paiement | `payment.html` |
| Contrat | `contract.html` |
| Administration | `admin/` |

## 🛠️ Technologies

- HTML5
- CSS3
- JavaScript ES6+
- Google Fonts
- Responsive Web Design
- GitHub Pages / Netlify compatible

## 🎨 Design system

**Couleurs principales**

- Bleu nuit — confiance et professionnalisme
- Vert sauge — service, sérénité et proximité
- Champagne — détail premium et élégance
- Blanc cassé — confort visuel

Les styles premium sont regroupés dans :

```text
css/
├── style.css
├── pages.css
├── premium.css
└── services-premium.css
```

## 📁 Structure

```text
Pure-Power/
│
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
│
├── admin/
│   ├── index.html
│   ├── clients.html
│   ├── reservations.html
│   ├── payments.html
│   ├── services.html
│   ├── pricing.html
│   ├── contracts.html
│   ├── calendar.html
│   └── settings.html
│
├── css/
│   ├── style.css
│   ├── pages.css
│   ├── premium.css
│   └── services-premium.css
│
└── js/
    ├── app.js
    ├── app-client.js
    ├── site.js
    └── sanity.js
```

## 🔒 Sécurité

Les clés API, tokens privés et identifiants sensibles ne doivent jamais être exposés dans le JavaScript côté navigateur. Les intégrations nécessitant des secrets doivent passer par un backend sécurisé.

## 📞 Contact

**PURE & POWER**  
Ajaccio et alentours  
Téléphone : **07 58 29 80 26**

## 📌 Repository

https://github.com/ahmedhdhili832-dotcom/Pure-Power

---

© 2026 **PURE & POWER** — Tous droits réservés.
