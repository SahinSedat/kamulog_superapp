// ── Kullanıcı Türü (Spec 01 + 03)
enum EmploymentType {
  memur, // 4A/4B/4C -> Mavi Tema (#5D8AA8)
  isci, // 4D -> Toprak/Turuncu Tema (#C19A6B)
  sozlesmeli, // 4B -> Mavi veya özel
}

// ── Uygulama Tema Modu
enum AppThemeMode { system, light, dark }

// ── Becayiş İlan Durumu (Spec 04)
enum BecayisStatus {
  active, // Aktif ilan
  matched, // Eşleşme bulundu
  closed, // Kapatıldı
}

// ── Danışman Kategorisi (Spec 04)
enum ConsultantCategory {
  hukuk, // Avukat
  bordro, // Mutemet / Bordro uzmanı
  psikoloji, // Psikolog
}
