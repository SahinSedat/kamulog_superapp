// ── Kullanıcı Türü
enum EmploymentType {
  kamuMemur, // 657 Memur / Sözleşmeli → Mavi Tema
  kamuIsci, // 4D Kamu İşçisi → Turuncu Tema
  ozelSektor, // Özel Sektör → Yeşil Tema
  isArayan, // İş Arıyorum → Gri Tema
  // Eski değerler — geriye uyumluluk için
  memur, // → kamuMemur olarak kullanılır
  isci, // → kamuIsci olarak kullanılır
  sozlesmeli, // → kamuMemur olarak kullanılır
}

// ── Uygulama Tema Modu
enum AppThemeMode { system, light, dark }

// ── Becayiş İlan Durumu
enum BecayisStatus { active, matched, closed }

// ── Danışman Kategorisi
enum ConsultantCategory { hukuk, bordro, psikoloji }

// ── STK Türü
enum StkType { sendika, dernek, vakif, meslekOdasi }

// ── Belge Kategorisi
enum DocumentCategory { cv, stk, kimlik, diger }
