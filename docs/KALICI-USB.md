# Canlı USB'de kalıcı depolama

TURAN-OS ISO'su `persistence` parametresiyle açılır. USB belleğe yazdıktan sonra, kalan boş alana
bir kalıcı bölüm eklerseniz dosyalarınız ve ayarlarınız yeniden başlatınca korunur.

1. ISO'yu USB belleğe Rufus (DD modu) veya balenaEtcher ile yazın.
2. Linux'ta (canlı oturumda veya başka bir makinede) USB'deki boş alanda yeni bir ext4 bölüm oluşturun:
   etiketi **persistence** olsun.
3. Bölümü bağlayıp içine `persistence.conf` dosyası koyun, içeriği tek satır: `/ union`
4. USB'den yeniden başlatın. Ayarlarınız artık kalıcıdır.

Not: Rufus bazı sürümlerde Debian canlı ISO'ları için kalıcı bölüm kaydırıcısı sunar; çıkarsa 2-3. adımları o yapar.
Kalıcı USB, diske kurulumun yerini tutmaz; sürekli kullanım için Calamares ile kurulum önerilir.
