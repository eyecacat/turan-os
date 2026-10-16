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
