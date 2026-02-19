{\rtf1\ansi\ansicpg1254\cocoartf2868
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 # KAMULOG \'97 UI/UX & DESIGN SYSTEM\
\
## 1. TASARIM V\uc0\u304 ZYONU\
Uygulama, devlet ciddiyetini modern bir startup esnekli\uc0\u287 iyle birle\u351 tirmeli.\
**Anahtar Kelimeler:** Serenity (Huzur), Trust (G\'fcven), Clarity (Berrakl\uc0\u305 k).\
\
---\
\
## 2. RENK PALET\uc0\u304  VE TEMA Y\'d6NET\u304 M\u304 \
\
### Dinamik Tema Sistemi\
Kullan\uc0\u305 c\u305 n\u305 n stat\'fcs\'fcne g\'f6re uygulama rengi `ThemeExtension` ile de\u287 i\u351 meli:\
\
1.  **Memur Modu (Official Blue):**\
    -   Primary: `#5D8AA8` (Air Force Blue)\
    -   Secondary: `#B0C4DE` (Light Steel Blue)\
    -   Accent: `#FFFFFF` (Beyaz Kartlar)\
\
2.  **\uc0\u304 \u351 \'e7i Modu (Warm Earth):**\
    -   Primary: `#C19A6B` (Desert Sand)\
    -   Secondary: `#E6CCB2` (Almond)\
    -   Accent: `#1F2933` (Koyu Metinler)\
\
### Genel Renkler\
-   **Background:** `#F4F6F8` (G\'f6z yormayan gri-beyaz)\
-   **Success:** `#27AE60` (Onaylar i\'e7in)\
-   **Error:** `#EB5757` (Hatalar i\'e7in)\
-   **Text:** Google Fonts 'Inter' veya 'Roboto'.\
\
---\
\
## 3. KOMPONENTLER (WIDGETS)\
\
-   **Glassmorphism Cards:** Kartlar\uc0\u305 n arka plan\u305 nda hafif bir `BackdropFilter` ve beyaz opakl\u305 k (`Colors.white.withOpacity(0.8)`) kullan\u305 lmal\u305 .\
-   **Animated Bottom Bar:** Sayfa ge\'e7i\uc0\u351 lerinde ikonlar hafif\'e7e b\'fcy\'fcmeli ve renk de\u287 i\u351 tirmeli.\
-   **Skeleton Loading:** Veriler y\'fcklenirken d\'f6nen \'e7ark yerine, i\'e7eri\uc0\u287 in \u351 eklini alan gri kutucuklar (shimmer effect) kullan\u305 lmal\u305 .\
\
---\
\
## 4. EKRAN \'d6ZEL \uc0\u304 STEKLER\u304 \
-   **Giri\uc0\u351  Ekran\u305 :** Sadece telefon numaras\u305  isteyen, temiz, ill\'fcstrasyon destekli bir ekran.\
-   **Dashboard:** Widget bazl\uc0\u305  (Hava durumu gibi) mod\'fcler ana sayfa. "Size \'d6zel \u304 lanlar", "G\'fcn\'fcn Haberleri" bloklar\u305 .}