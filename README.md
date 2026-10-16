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

## Bozkır Katmanı (v0.3)
- Renk paleti: Gök Mavisi #00A6FF · Kut Altını #D4AF37 · Ötüken Yeşili #1B4D3E · Yurt Kömürü #11141A · Şaman Kemiği #F5F2EB
- Göktürk runik destekli MOTD ve duvar kağıdı
- Mitolojik komutlar: `asena` (ağ), `umay` (RAM), `tore` (güvenlik), `kam` (donanım)
- `bilge` yapay zeka iskeleti: `bilge ozet`, `bilge morf`, `bilge runik`
- `tamga` kişisel mühür üretici
- Panel: Asena/Umay/Kam genmon widget'ları

## Bilge Katmanı (v0.4)
- **Bilge AI**: OpenRouter üzerinden gerçek Türkçe yapay zeka
  - `bilge sor "<soru>"` — soru-cevap
  - `bilge sohbet` — interaktif sohbet
  - `bilge-ajan "<görev>"` — doğal dille sistem otomasyonu
- **Şanyrak Launcher**: Dairesel katmanlı uygulama menüsü (Super+Space)
- **Tamga GPG**: Kişisel mühür → kriptografik imza
- **Bozkır Tuvali**: Sanal masaüstleri arası yumuşak geçiş
- **Türkçe morfoloji**: `bilge morf` kök/ek analizi
- **Göktürk runik**: `bilge runik` dönüştürücü

### API Anahtarı Hakkında
`/etc/turan/bilge-ai.conf` dosyasında OpenRouter API anahtarı vardır (mod 600).
Yeniden dağıtım öncesi anahtarı değiştirin.
