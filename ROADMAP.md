# TURAN-OS Yol Haritası

## 1.0.0 için kabul ölçütleri
- [ ] ISO, VirtualBox (EFI) ve en az 2 farklı gerçek bilgisayarda açılıyor
- [ ] Calamares ile diske kurulum tamamlanıyor, yeniden başlatınca TURAN-OS açılıyor
- [ ] Kurulum sonrası Türkçe dil/klavye, ağ, ses, Bluetooth, yazıcı çalışıyor
- [ ] Wi-Fi: Intel, Realtek, Atheros kartlarda test edildi
- [ ] Güncelleme (`turan guncelle`) ve yazılım merkezi sorunsuz
- [ ] Duvar kağıdı, tema, giriş ekranı, açılış ekranı doğru görünüyor
- [ ] Kurulu sistemde "Diske Kur" simgesi yok
- [ ] README ve kullanıcı belgeleri tamam

## Sonraki sürümler
- Özel XFCE panel düzeni ve dock ayarları
- Özel GRUB teması ve Plymouth animasyonu
- Kendi APT deposu ve `.deb` paketleri
- Hoş geldin uygulaması (ilk açılış sihirbazı)
- Legacy BIOS kurulum desteği

## v1.0.0-rc2 ile eklenenler
- [x] sysctl sertlestirme + performans
- [x] AppArmor, parola politikasi, sudoers sikilastirma
- [x] XFCE panel duzeni ve klavye kisayollari
- [x] GTK CSS ile TURAN kirmizisi vurgular
- [x] GRUB sessiz acilis ayarlari
- [x] journald kalici + boyut limiti
- [x] Haftalik bakim timer
- [x] Calamares markasi ve LUKS otomatik bolumleme
- [x] Turkce locale/keyboard/timezone tam
- [x] MOTD + fastfetch kimligi
- [x] Ilk acilis karsilama sihirbazi
- [x] Ek uygulamalar

## Hala eksik (v1.0 final oncesi)
- [ ] VirtualBox EFI testi
- [ ] 2 farkli gercek makinede acilis testi
- [ ] Wi-Fi/ses/Bluetooth saha testi
- [ ] Ozel Plymouth animasyonu
- [ ] Ozel GRUB gorsel temasi
- [ ] LICENSE dosyasi

## Bozkır Katmanı (v0.3) - tamamlandi
- [x] Gök/Kut/Ötüken renk paleti
- [x] Bozkır duvar kağıdı ve yeni logo
- [x] Mitolojik komutlar: asena, umay, tore, kam
- [x] bilge AI iskeleti (ozet, morf, runik)
- [x] tamga üretici
- [x] Panel widget'ları

## v0.4 - Yerel AI ve Türkçe morfoloji
- [ ] llama.cpp + Phi-3-mini veya Qwen2-1.5B INT4
- [ ] Zemberek servisi (Türkçe morfolojik analiz)
- [ ] bilge sor: gerçek yerel SLM cevabı
- [ ] Runik dönüşümü: hover ile canlı

## v0.5 - Şanyrak Shell
- [ ] Dairesel launcher (Python + Qt veya GTK)
- [ ] Katmanlı masaüstü (Üst/Orta/Alt Dünya)
- [ ] Sonsuz Bozkır tuvali

## v1.0 ve sonrası
- [ ] Tamga tabanlı GPG imza entegrasyonu
- [ ] Kendi APT deposu
- [ ] (Uzun vade) Rust mikroçekirdek araştırması - Redox OS fork

## v0.4 - Bilge Katmani (tamamlandi)
- [x] Bilge AI (OpenRouter, ücretsiz modeller)
- [x] Bilge Sohbet (interaktif)
- [x] Bilge Ajan (doğal dil → komut)
- [x] Şanyrak Launcher (GTK dairesel)
- [x] Tamga GPG entegrasyonu
- [x] Bozkır Tuvali (workspace geçişleri)
- [x] Türkçe morfoloji (basit FST)
- [x] Göktürk runik dönüştürücü
- [x] Panel widget'ları (Asena/Umay/Kam/Bilge)

## v0.5 - Sıradaki
- [ ] Şanyrak Shell v0.2 (daha akıcı animasyonlar)
- [ ] Sonsuz Bozkır tuvali (procedural duvar kağıdı)
- [ ] Zemberek tam entegrasyon
- [ ] Yerel SLM (llama.cpp + Phi-3-mini) — çevrimdışı mod
- [ ] ASR/TTS (sesli asistan)

## v1.0 ve sonrası
- [ ] GPG imzalı git commit'ler otomatik
- [ ] Kendi APT deposu (turan-apt)
- [ ] Orkhon Sans yazı tipi
- [ ] (Uzun vade) Redox OS fork araştırması
