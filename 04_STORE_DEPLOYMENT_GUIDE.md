{\rtf1\ansi\ansicpg1254\cocoartf2868
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;\f1\froman\fcharset0 Times-Roman;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;}
{\*\expandedcolortbl;;\cssrgb\c0\c0\c0;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 CREATE TABLE becayis_ads (\
    id UUID PRIMARY KEY,\
    owner_id UUID REFERENCES users(id),\
    source_city VARCHAR(50),\
    target_city VARCHAR(50),\
    profession VARCHAR(50), -- E\uc0\u351 le\u351 me i\'e7in kritik\
    description TEXT,\
    status ENUM('active', 'matched', 'closed'),\
    is_premium BOOLEAN DEFAULT FALSE\
);\
\
\
CREATE TABLE consultants (\
    id UUID PRIMARY KEY,\
    user_id UUID REFERENCES users(id),\
    category ENUM('hukuk', 'bordro', 'psikoloji'),\
    hourly_rate DECIMAL,\
    rating FLOAT,\
    is_online BOOLEAN\
);\
\
\pard\pardeftab720\partightenfactor0

\f1 \cf0 \expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 PRODUCTS TABLE (E-Commerce)\
CREATE TABLE products (\
    id UUID PRIMARY KEY,\
    name VARCHAR(100),\
    price DECIMAL,\
    image_url TEXT,\
    stock INT\
);\
\
--- ### Dosya 4: `04_STORE_DEPLOYMENT_GUIDE.md` *(Buras\uc0\u305  \'e7ok \'f6nemli. Ma\u287 azaya y\'fcklerken sorun ya\u351 amaman i\'e7in gereken teknik ayarlar)* ```markdown # KAMULOG \'97 APP STORE & PLAY STORE DEPLOYMENT CONFIGURATION ## 1. IOS CONFIGURATION (Apple App Store) *Apple'\u305 n kat\u305  kurallar\u305 na uyum sa\u287 lamak i\'e7in a\u351 a\u287 \u305 daki ayarlar\u305  `Info.plist` ve proje ayarlar\u305 na ekle.* ### A. Permissions (\u304 zinler) Uygulama Dan\u305 \u351 manl\u305 k mod\'fcl\'fcnde kamera/mikrofon, profil i\'e7in galeri kullanaca\u287 \u305  i\'e7in \u351 u izin a\'e7\u305 klamalar\u305  **ZORUNLUDUR** (Red yememek i\'e7in): - `NSPhotoLibraryUsageDescription`: "Profil foto\u287 raf\u305 n\u305 z\u305  y\'fcklemek ve dan\u305 \u351 manlara belge g\'f6ndermek i\'e7in galeriye eri\u351 im izni gereklidir." - `NSCameraUsageDescription`: "G\'f6r\'fcnt\'fcl\'fc dan\u305 \u351 manl\u305 k g\'f6r\'fc\u351 meleri ve belge tarama i\'e7in kamera izni gereklidir." - `NSMicrophoneUsageDescription`: "G\'f6r\'fcnt\'fcl\'fc ve sesli g\'f6r\'fc\u351 meler i\'e7in mikrofon izni gereklidir." ### B. Privacy Manifest (Yeni Kural) iOS 17+ i\'e7in `PrivacyInfo.xcprivacy` dosyas\u305  olu\u351 turulmal\u305 . Kullan\u305 lan 3. parti SDK'lar\u305 n (Firebase, Realm vb.) veri toplama politikalar\u305  burada beyan edilmeli. ### C. Signing - Otomatik imzalama (Automatically Manage Signing) a\'e7\u305 k olmal\u305 . - Bundle ID: `com.kamulog.app` (\'d6rnek). --- ## 2. ANDROID CONFIGURATION (Google Play Store) ### A. Gradle Ayarlar\u305  (`android/app/build.gradle`) - `minSdkVersion`: 24 (Android 7.0 - Kamu \'e7al\u305 \u351 anlar\u305 n\u305 n eski telefonlar\u305  olabilece\u287 i i\'e7in 21 yerine 24 ideal). - `targetSdkVersion`: 34 (En g\'fcncel Android API). - `compileSdkVersion`: 34. ### B. ProGuard & R8 (G\'fcvenlik ve K\'fc\'e7\'fcltme) Uygulaman\u305 n tersine m\'fchendislik (reverse engineering) ile k\u305 r\u305 lmas\u305 n\u305  zorla\u351 t\u305 rmak ve boyutunu k\'fc\'e7\'fcltmek i\'e7in `release` modunda \u351 unlar\u305  aktif et: ```gradle buildTypes \{ release \{ signingConfig signingConfigs.release minifyEnabled true // Kod kar\u305 \u351 t\u305 rma A\'c7IK shrinkResources true // Gereksiz kaynaklar\u305  silme A\'c7IK proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro' \} \}}