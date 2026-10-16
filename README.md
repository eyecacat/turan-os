# TURAN-OS

Türkçe öncelikli, Debian 13 (trixie) tabanlı, masaüstü kullanıcıları için hazırlanmış Linux dağıtımı.
Masaüstü: XFCE (Arc-Dark teması, Papirus simgeleri, Inter yazı tipi). Kurulum: Calamares ile diske.

## Özellikler
- Türkçe dil, Türkçe klavye ve İstanbul saat dilimi varsayılan
- Calamares ile SSD/HDD'ye kalıcı kurulum (UEFI, Secure Boot uyumlu önyükleyici)
- Firefox, Thunderbird, LibreOffice, VLC, yazılım merkezi (Flathub dahil)
- Güvenlik duvarı (ufw) açık, otomatik güvenlik güncellemeleri
- Pil ömrü (TLP) ve bellek sıkıştırma (zram)
- `turan` komut satırı aracı: `turan yardim`
- Canlı USB'de kalıcı depolama desteği: [docs/KALICI-USB.md](docs/KALICI-USB.md)

## ISO nasıl elde edilir
1. **Actions** sekmesinden son başarılı "TURAN-OS ISO derle" çalışmasını açın, `turan-os-iso` dosyasını indirin.
2. Ya da bir sürüm etiketi (`v1.0.0` gibi) atıldığında **Releases** sayfasından parçaları indirip birleştirin.

## Deneme
VirtualBox: 4 GB bellek, 2 çekirdek, 128 MB video belleği, **EFI etkin**. Canlı oturumda masaüstündeki
"TURAN-OS'u Diske Kur" simgesiyle kurulum başlar.

## Geliştirme
Her şey metin dosyasıdır; `main`'e push edilince ISO otomatik derlenir.
- `auto/config`: live-build ayarları
- `config/package-lists/`: paket listeleri
- `config/includes.chroot/`: ISO'ya doğrudan kopyalanan dosyalar
- `config/hooks/live/`: derleme sırasında çalışan betikler
- `config/includes.chroot/etc/turan-surum`: sürüm numarası (tek kaynak)

## Lisans
Bu depodaki yapılandırma dosyaları için lisans dosyası (LICENSE) eklenmelidir. Dağıtıma dahil edilen yazılımlar kendi lisanslarına tabidir.
