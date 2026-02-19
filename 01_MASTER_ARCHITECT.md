{\rtf1\ansi\ansicpg1254\cocoartf2868
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 # KAMULOG \'97 MASTER ARCHITECTURE & LOGIC PROMPT\
\
## 1. PROJE K\uc0\u304 ML\u304 \u286 \u304  VE ROL\'dcN\
**Rol\'fcn:** Senior Flutter Engineer & Mobile Architect.\
**Proje:** "Kamulog" - Kamu ve \'f6zel sekt\'f6r \'e7al\uc0\u305 \u351 anlar\u305  i\'e7in "Super App".\
**Hedef:** iOS ve Android ma\uc0\u287 azalar\u305 na uygun, y\'fcksek performansl\u305 , mod\'fcler ve \'f6l\'e7eklenebilir bir uygulama.\
\
---\
\
## 2. TEKNOLOJ\uc0\u304  STACK (FLUTTER ECOSYSTEM)\
Bu projede a\uc0\u351 a\u287 \u305 daki k\'fct\'fcphanelerin **en g\'fcncel ve stabil** versiyonlar\u305 n\u305  kullanacaks\u305 n:\
\
-   **Core:** Flutter (Latest Stable), Dart (Latest).\
-   **Architecture:** Clean Architecture (Feature-First) + MVVM.\
-   **State Management:** Riverpod (Code Generation ile `flutter_riverpod`, `riverpod_annotation`).\
-   **Navigation:** GoRouter (Derin linkleme ve type-safe rotalar i\'e7in).\
-   **Local Database (Offline-First):** Drift (SQLite) veya Hive. *Her mod\'fcl\'fcn verisi cihazda da tutulmal\uc0\u305 .*\
-   **Networking:** Dio (Interceptor ve Retry mekanizmal\uc0\u305 ).\
-   **Dependency Injection:** Riverpod (Service Locator olarak).\
-   **UI Components:** Flutter Material 3 & Cupertino Widgets.\
\
---\
\
## 3. MOD\'dcLLER VE \uc0\u304 \u350  KURALLARI\
\
### A. Authentication (Giri\uc0\u351  Sistemi)\
-   **Y\'f6ntem:** WhatsApp tarz\uc0\u305  sadece Telefon Numaras\u305  + OTP.\
-   **Servis:** Firebase Auth.\
-   **Kritik Kural:** Kullan\uc0\u305 c\u305  giri\u351  yapt\u305 ktan sonra zorunlu "Profil Tamamlama" ekran\u305  gelir:\
    -   *Se\'e7enek 1:* Memur (4A/4B/4C) -> Mavi Tema aktifle\uc0\u351 ir.\
    -   *Se\'e7enek 2:* \uc0\u304 \u351 \'e7i/S\'f6zle\u351 meli (4D) -> Toprak/Turuncu Tema aktifle\u351 ir.\
\
### B. Becayi\uc0\u351  (Swap) Mod\'fcl\'fc\
-   **Mant\uc0\u305 k:** Yer de\u287 i\u351 tirme e\u351 le\u351 tirmesi.\
-   **Veritaban\uc0\u305  Ayr\u305 m\u305 :** Memur ilanlar\u305  ve \u304 \u351 \'e7i ilanlar\u305  veritaban\u305 nda ayr\u305  tablolarda veya `type` s\'fctunu ile kesin olarak ayr\u305 lmal\u305 .\
-   **Filtreleme:** Hem\uc0\u351 ire girdi\u287 i zaman sadece sa\u287 l\u305 k bakanl\u305 \u287 \u305  ilanlar\u305 n\u305  g\'f6rmeli.\
-   **AI E\uc0\u351 le\u351 me:** Kullan\u305 c\u305 n\u305 n hedefledi\u287 i ilde, onun iline gelmek isteyen biri varsa "E\u351 le\u351 me Var" bildirimi gitmeli.\
\
### C. Kamulog Kariyer (Job Finder)\
-   **Entegrasyon:** `kamulogkariyer.com` verileri \'e7ekilecek.\
-   **Ki\uc0\u351 iselle\u351 tirme:** Kullan\u305 c\u305 n\u305 n mesle\u287 ine g\'f6re (\'d6rn: G\'fcvenlik G\'f6revlisi) i\u351  ilanlar\u305  ana ekrana d\'fc\u351 meli.\
\
### D. Dan\uc0\u305 \u351 manl\u305 k (Consulting)\
-   **Marketplace:** Avukat, Mutemet, Psikolog gibi uzmanlar listelenir.\
-   **Randevu ve \'d6deme:** Iyzico/PayTR altyap\uc0\u305 s\u305  (mockup) ile \'f6deme al\u305 n\u305 r, takvimden slot se\'e7ilir.\
-   **Video/Chat:** Dan\uc0\u305 \u351 manl\u305 k hizmeti uygulama i\'e7i mesajla\u351 ma veya video g\'f6r\'fc\u351 me (Agora/Jitsi entegrasyon tasla\u287 \u305 ) ile verilir.\
\
### E. STK & Topluluk\
-   Sendika ve derneklerin kendi sayfalar\uc0\u305 n\u305  y\'f6netebildi\u287 i, \'fcyelere \'f6zel duyuru ge\'e7ebildi\u287 i sosyal ak\u305 \u351  alan\u305 .\
\
### F. Mini E-Ticaret\
-   Kurumsal \'fcr\'fcnlerin sat\uc0\u305 ld\u305 \u287 \u305  basit bir ma\u287 aza mod\'fcl\'fc. Sepet ve sipari\u351  takibi i\'e7erir.\
\
---\
\
## 4. KODLAMA STANDARTLARI\
-   T\'fcm stringler `l10n` (Localization) dosyalar\uc0\u305 ndan gelmeli (Hardcoded text yasak).\
-   Her `Repository` mutlaka bir `Interface` kullanmal\uc0\u305 .\
-   Hata y\'f6netimi i\'e7in `Either<Failure, Success>` yap\uc0\u305 s\u305  (fpdart paketi) kullan\u305 lmal\u305 .}