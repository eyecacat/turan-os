#!/usr/bin/env bash
# TURAN-OS Bozkır Katmanı v0.3 - Gök/Kut/Ötüken
set -u
K='\033[1;36m'; S='\033[0m'; Y='\033[1;33m'; G='\033[1;32m'
adim() { printf "${K}==>${S} %s\n" "$*"; }

yaz() {
  local hedef="$1"
  mkdir -p "$(dirname "$hedef")" || return 1
  cat > "$hedef" || return 1
  echo "  + $hedef"
}
ekle() {
  local hedef="$1"
  mkdir -p "$(dirname "$hedef")" || return 1
  [ -f "$hedef" ] || : > "$hedef"
  cat >> "$hedef" || return 1
  echo "  ~ $hedef"
}

[ -d .git ] || { echo "Depo kökünde çalıştırın."; exit 1; }
[ -f auto/config ] || { echo "Önce kur-turan.sh."; exit 1; }

adim "Ortam: $(pwd)"

adim "Renk paleti: Gok/Kut/Otuken"
yaz config/includes.chroot/etc/skel/.config/gtk-3.0/gtk.css <<'__SON__'
/* TURAN-OS Bozkır Minimalizmi - Renk Paleti */
@define-color gok_mavisi      #00A6FF;
@define-color kut_altini      #D4AF37;
@define-color otuken_yesili   #1B4D3E;
@define-color yurt_komuru     #11141A;
@define-color saman_kemigi    #F5F2EB;

@define-color theme_bg_color       @yurt_komuru;
@define-color theme_fg_color       @saman_kemigi;
@define-color theme_selected_bg_color @gok_mavisi;
@define-color theme_selected_fg_color @yurt_komuru;

headerbar, .titlebar {
  background: linear-gradient(180deg, #1a1f2b, @yurt_komuru);
  color: @saman_kemigi;
  border-bottom: 1px solid @otuken_yesili;
}
button.suggested-action {
  background: @gok_mavisi;
  color: @yurt_komuru;
  font-weight: 600;
}
button.destructive-action {
  background: @kut_altini;
  color: @yurt_komuru;
}
progressbar progress {
  background: linear-gradient(90deg, @otuken_yesili, @gok_mavisi);
}
entry:focus, .view:selected {
  border-color: @gok_mavisi;
  box-shadow: 0 0 0 2px alpha(@gok_mavisi, 0.35);
}
tooltip {
  background: @yurt_komuru;
  color: @saman_kemigi;
  border: 1px solid @kut_altini;
}
__SON__

# XFCE panel: Gökmavisi şeritli üst bar
yaz config/includes.chroot/etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml <<'__SON__'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-panel" version="1.0">
  <property name="configver" type="int" value="2"/>
  <property name="panels" type="array">
    <value type="int" value="1"/>
  </property>
  <property name="panel-1" type="empty">
    <property name="position" type="string" value="p=6;x=0;y=0"/>
    <property name="length" type="uint" value="100"/>
    <property name="position-locked" type="bool" value="true"/>
    <property name="size" type="uint" value="34"/>
    <property name="background-style" type="uint" value="1"/>
    <property name="background-rgba" type="array">
      <value type="double" value="0.067"/>
      <value type="double" value="0.078"/>
      <value type="double" value="0.102"/>
      <value type="double" value="0.94"/>
    </property>
    <property name="plugin-ids" type="array">
      <value type="int" value="1"/><value type="int" value="2"/>
      <value type="int" value="3"/><value type="int" value="4"/>
      <value type="int" value="5"/><value type="int" value="6"/>
      <value type="int" value="7"/><value type="int" value="8"/>
      <value type="int" value="9"/><value type="int" value="10"/>
    </property>
  </property>
  <property name="plugin-1" type="string" value="whisker-menu"/>
  <property name="plugin-2" type="string" value="launcher">
    <property name="items" type="array"><value type="string" value="turan-bilge.desktop"/></property>
  </property>
  <property name="plugin-3" type="string" value="tasklist">
    <property name="grouping" type="uint" value="1"/>
    <property name="show-labels" type="bool" value="false"/>
    <property name="flat-buttons" type="bool" value="true"/>
  </property>
  <property name="plugin-4" type="string" value="separator">
    <property name="expand" type="bool" value="true"/>
  </property>
  <property name="plugin-5" type="string" value="genmon">
    <property name="command" type="string" value="asena-panel"/>
    <property name="update-ms" type="int" value="3000"/>
  </property>
  <property name="plugin-6" type="string" value="genmon">
    <property name="command" type="string" value="umay-panel"/>
    <property name="update-ms" type="int" value="2000"/>
  </property>
  <property name="plugin-7" type="string" value="genmon">
    <property name="command" type="string" value="kam-panel"/>
    <property name="update-ms" type="int" value="5000"/>
  </property>
  <property name="plugin-8" type="string" value="systray"/>
  <property name="plugin-9" type="string" value="clock">
    <property name="digital-layout" type="uint" value="3"/>
    <property name="digital-time-format" type="string" value="%H:%M  %d %b"/>
  </property>
  <property name="plugin-10" type="string" value="actions">
    <property name="items" type="array">
      <value type="string" value="+lock-screen"/>
      <value type="string" value="+separator"/>
      <value type="string" value="+restart"/>
      <value type="string" value="+shutdown"/>
    </property>
  </property>
</channel>
__SON__

# GRUB renk teması
yaz config/includes.chroot/etc/default/grub.d/91-turan-bozkir.cfg <<'__SON__'
GRUB_COLOR_NORMAL="light-gray/black"
GRUB_COLOR_HIGHLIGHT="cyan/black"
GRUB_BACKGROUND=""
__SON__

# LightDM giriş ekranı
yaz config/includes.chroot/etc/lightdm/lightdm-gtk-greeter.conf <<'__SON__'
[greeter]
background=/usr/share/backgrounds/turan/turan-os.png
theme-name=Arc-Dark
icon-theme-name=Papirus-Dark
font-name=Inter 11
default-user-image=/usr/share/pixmaps/turan-os.png
indicators=~host;~spacer;~clock;~spacer;~session;~power
position=50%,center
xft-antialias=1
xft-hintstyle=hintslight
xft-rgba=rgb
__SON__

adim "Bozkir duvar kagidi (Gok/Kut/Otuken)"
yaz config/includes.chroot/usr/share/backgrounds/turan/bozkir.svg <<'__SON__'
<svg xmlns="http://www.w3.org/2000/svg" width="1920" height="1080" viewBox="0 0 1920 1080">
  <defs>
    <linearGradient id="gok" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0"   stop-color="#0a0f1c"/>
      <stop offset="0.5" stop-color="#0d1f2e"/>
      <stop offset="1"   stop-color="#11141a"/>
    </linearGradient>
    <radialGradient id="kut" cx="0.75" cy="0.22" r="0.55">
      <stop offset="0" stop-color="#D4AF37" stop-opacity="0.32"/>
      <stop offset="1" stop-color="#D4AF37" stop-opacity="0"/>
    </radialGradient>
    <radialGradient id="gokisik" cx="0.25" cy="0.35" r="0.5">
      <stop offset="0" stop-color="#00A6FF" stop-opacity="0.22"/>
      <stop offset="1" stop-color="#00A6FF" stop-opacity="0"/>
    </radialGradient>
  </defs>

  <rect width="1920" height="1080" fill="url(#gok)"/>
  <rect width="1920" height="1080" fill="url(#kut)"/>
  <rect width="1920" height="1080" fill="url(#gokisik)"/>

  <!-- Ufuk cizgisi -->
  <line x1="0" y1="820" x2="1920" y2="820" stroke="#1B4D3E" stroke-width="1" stroke-opacity="0.6"/>

  <!-- Bozkir silueti -->
  <path d="M0 820 Q240 780 480 800 T960 780 T1440 810 T1920 790 L1920 1080 L0 1080 Z"
        fill="#0a0d14" fill-opacity="0.75"/>
  <path d="M0 860 Q300 830 600 850 T1200 840 T1920 860 L1920 1080 L0 1080 Z"
        fill="#05070a" fill-opacity="0.9"/>

  <!-- Tengri sembolu: gokyuzu cemberi -->
  <circle cx="960" cy="420" r="180" fill="none" stroke="#00A6FF" stroke-opacity="0.16" stroke-width="1.5"/>
  <circle cx="960" cy="420" r="120" fill="none" stroke="#D4AF37" stroke-opacity="0.16" stroke-width="1"/>

  <!-- Gokturk T sembolu filigran -->
  <g transform="translate(960 420)" fill="none" stroke="#F5F2EB" stroke-opacity="0.07" stroke-width="4">
    <path d="M-40 -40 H40 M0 -40 V40"/>
  </g>

  <!-- Yildizlar -->
  <g fill="#F5F2EB" fill-opacity="0.55">
    <circle cx="180" cy="120" r="1.2"/><circle cx="340" cy="90" r="0.9"/>
    <circle cx="520" cy="160" r="1"/><circle cx="700" cy="80" r="1.3"/>
    <circle cx="1180" cy="110" r="1"/><circle cx="1400" cy="150" r="1.1"/>
    <circle cx="1640" cy="90" r="0.9"/><circle cx="1780" cy="200" r="1.2"/>
    <circle cx="240" cy="260" r="0.8"/><circle cx="1520" cy="280" r="1"/>
  </g>

  <!-- Baslik -->
  <text x="120" y="960"
        font-family="Inter, Noto Sans, sans-serif" font-size="72" font-weight="700"
        letter-spacing="10" fill="#F5F2EB" fill-opacity="0.94">TURAN-OS</text>
  <text x="124" y="1004"
        font-family="Noto Sans Old Turkic, Inter, sans-serif" font-size="22"
        letter-spacing="4" fill="#D4AF37" fill-opacity="0.85">𐱅𐰇𐰼𐰚 𐰚𐰀𐰏𐰀𐰣𐰞𐰃𐰚</text>
  <rect x="120" y="1020" width="220" height="4" fill="#00A6FF"/>
</svg>
__SON__

adim "Yeni TURAN-OS logosu (Gok mavisi cember icinde T)"
yaz config/includes.chroot/usr/share/icons/hicolor/scalable/apps/turan-os.svg <<'__SON__'
<svg xmlns="http://www.w3.org/2000/svg" width="256" height="256" viewBox="0 0 256 256">
  <defs>
    <radialGradient id="lg" cx="0.5" cy="0.4" r="0.6">
      <stop offset="0" stop-color="#0d1f2e"/>
      <stop offset="1" stop-color="#11141a"/>
    </radialGradient>
  </defs>
  <rect width="256" height="256" rx="56" fill="url(#lg)" stroke="#00A6FF" stroke-width="3"/>
  <circle cx="128" cy="128" r="88" fill="none" stroke="#D4AF37" stroke-width="2" stroke-opacity="0.7"/>
  <path d="M78 78 H178 V112 H146 V186 H110 V112 H78 Z" fill="#F5F2EB"/>
  <path d="M78 78 H178 V82 H78 Z" fill="#00A6FF"/>
</svg>
__SON__

adim "Asena: ag trafigi ve disari giden soketler"
yaz config/includes.chroot/usr/local/bin/asena <<'__SON__'
#!/bin/bash
# Asena - Gok-Kurt Ag Avcisi
K='\033[1;36m'; S='\033[0m'
echo -e "${K}  ASENA${S}  Gok-Kurt Ag Avcisi"
echo "============================================"
echo "Aktif baglantilar:"
ss -tunp 2>/dev/null | head -25
echo
echo "Disari giden soketler:"
ss -tun state established 2>/dev/null | awk 'NR>1 {print $5}' | sort | uniq -c | sort -rn | head
echo
echo "Dinlenen portlar:"
ss -tlnp 2>/dev/null | head -15
__SON__
chmod +x config/includes.chroot/usr/local/bin/asena

# Panel widget'i (XFCE genmon icin)
yaz config/includes.chroot/usr/local/bin/asena-panel <<'__SON__'
#!/bin/bash
# Panel widget: yukarı ok sayısı + aktif soket sayisi
OUT=$(ss -tun state established 2>/dev/null | tail -n +2 | wc -l)
echo "<txt> 𐰀 $OUT </txt>"
echo "<tool>Aktif baglanti: $OUT</tool>"
__SON__
chmod +x config/includes.chroot/usr/local/bin/asena-panel

adim "Umay: bellek ve onbellek koruyucusu"
yaz config/includes.chroot/usr/local/bin/umay <<'__SON__'
#!/bin/bash
# Umay - Dogurganlik ve Koruma Tanricasi, RAM Yonetimi
K='\033[1;32m'; S='\033[0m'
echo -e "${K}  UMAY${S}  Bellek Koruyucusu"
echo "============================================"
free -h
echo
echo "En cok bellek kullanan 10 surec:"
ps aux --sort=-%mem | head -11 | awk '{printf "%-8s %6s %6s  %s\n",$1,$3,$4,$11}'
echo
echo "Onbellek durumu:"
cat /proc/meminfo | grep -E "^(Cached|Buffers|Dirty|Writeback)"
__SON__
chmod +x config/includes.chroot/usr/local/bin/umay

yaz config/includes.chroot/usr/local/bin/umay-panel <<'__SON__'
#!/bin/bash
# Panel: yesil kubbe ne kadar doluysa o kadar RAM kullanimi
USED=$(free | awk '/^Mem:/ {printf "%d", $3/$2*100}')
BAR=""
for i in $(seq 1 10); do
  if [ $i -le $((USED/10)) ]; then BAR="${BAR}●"; else BAR="${BAR}○"; fi
done
echo "<txt> 𐰆 $BAR ${USED}% </txt>"
echo "<tool>RAM: ${USED}%</tool>"
__SON__
chmod +x config/includes.chroot/usr/local/bin/umay-panel

adim "Tore: guvenlik matrisi ve degismez kurallar"
yaz config/includes.chroot/usr/local/bin/tore <<'__SON__'
#!/bin/bash
# Tore - Degismez Gogebe Kanunlari, Erisim ve Guvenlik
K='\033[1;33m'; S='\033[0m'
echo -e "${K}  TORE${S}  Guvenlik Matrisi"
echo "============================================"
echo "Guvenlik duvari:"
sudo ufw status verbose 2>/dev/null || echo "  (ufw etkin degil)"
echo
echo "AppArmor profilleri:"
sudo aa-status 2>/dev/null | head -15 || echo "  (AppArmor yuklu degil)"
echo
echo "Sudo yetkilileri:"
sudo -l 2>/dev/null | head -10
echo
echo "Son giris denemeleri:"
last -n 5 2>/dev/null
__SON__
chmod +x config/includes.chroot/usr/local/bin/tore

adim "Kam: donanim sagligi ve anomali tespiti"
yaz config/includes.chroot/usr/local/bin/kam <<'__SON__'
#!/bin/bash
# Kam - Saman, Tabiat Gozlemcisi, Donanim Anomali Tespiti
K='\033[1;36m'; S='\033[0m'
echo -e "${K}  KAM${S}  Donanim Sagligi"
echo "============================================"
if command -v sensors >/dev/null 2>&1; then
  echo "Sicakliklar:"
  sensors | grep -E "°C|Core|temp" | head -15
else
  echo "  (lm-sensors kurulu degil)"
fi
echo
echo "SMART disk sagligi:"
sudo smartctl -H /dev/sda 2>/dev/null | grep -E "result|health" || echo "  (smartmontools veya izin yok)"
echo
echo "Pil durumu:"
upower -i $(upower -e 2>/dev/null | grep battery | head -1) 2>/dev/null | grep -E "state|percentage|time" || echo "  (pil yok veya upower yok)"
__SON__
chmod +x config/includes.chroot/usr/local/bin/kam

yaz config/includes.chroot/usr/local/bin/kam-panel <<'__SON__'
#!/bin/bash
# Panel: en yuksek sicaklik
if command -v sensors >/dev/null 2>&1; then
  T=$(sensors 2>/dev/null | grep -oE '[0-9]+\.[0-9]+°C' | sort -rn | head -1)
  [ -z "$T" ] && T="--"
  echo "<txt> 𐰚 $T </txt>"
  echo "<tool>En yuksek sicaklik: $T</tool>"
else
  echo "<txt> 𐰚 -- </txt>"
fi
__SON__
chmod +x config/includes.chroot/usr/local/bin/kam-panel

adim "Bilge: yerel AI iskeleti (llama.cpp icin hazir arayuz)"
yaz config/includes.chroot/usr/local/bin/bilge <<'__SON__'
#!/bin/bash
# Bilge - Bilge Kagan & Tonyukuk, Yerel Sistem Yapay Zekasi
# Bu betik, v0.4'te llama.cpp/ollama ile konusacak. Su an iskelet.
K='\033[1;36m'; S='\033[0m'; Y='\033[1;33m'

yardim() {
  cat <<'EOT'
BILGE - Yerel Yapay Zeka Yardimcisi

Kullanim:
  bilge sor "<soru>"         Soru sor (yerel SLM)
  bilge ozet                 Sistem durumunu ozetler
  bilge morf "<cumle>"       Turkce morfolojik analiz (Zemberek)
  bilge runik "<metin>"      Metni Gokturk Runik'e cevirir
  bilge yardim               Bu ekran

Not: Yerel SLM v0.4'te devreye girecek. Su an ozet/morf/runik calisiyor.
EOT
}

morf() {
  # Basit koke+eke ayirma simulasyonu (v0.4'te Zemberek'e baglanacak)
  echo "Sozcuk                Kok          Ek"
  echo "-------------------------------------"
  for w in "$@"; do
    case "$w" in
      *lar|*ler)   K="${w%???}"; E="${w#$K}" ;;
      *lik|*lik|*luk|*lük) K="${w%???}"; E="${w#$K}" ;;
      *ci|*ci|*cu|*cü)     K="${w%??}";  E="${w#$K}" ;;
      *de|*da|*te|*ta)     K="${w%??}";  E="${w#$K}" ;;
      *) K="$w"; E="-" ;;
    esac
    printf "%-20s  %-12s %s\n" "$w" "$K" "$E"
  done
}

runik() {
  # UTF-8 -> Gokturk Runik (basit harf eslemesi, tam fonetik degil)
  python3 - "$@" <<'PY'
import sys
m = {
  'a':'𐰀','b':'𐰋','c':'𐰲','d':'𐰑','e':'𐰅','f':'𐰉','g':'𐰍','ğ':'𐰍',
  'h':'𐰍','ı':'𐰃','i':'𐰄','j':'𐰲','k':'𐰚','l':'𐰞','m':'𐰢','n':'𐰣',
  'o':'𐰆','ö':'𐰈','p':'𐰯','r':'𐰻','s':'𐰽','ş':'𐱁','t':'𐱅','u':'𐰆',
  'ü':'𐰈','v':'𐰉','y':'𐰘','z':'𐰔',' ':' '
}
metin = " ".join(sys.argv[1:]).lower()
print("Orjinal : " + metin)
print("Runik   : " + "".join(m.get(c, c) for c in metin))
PY
}

ozet() {
  echo -e "${K}  BILGE${S} Sistem Ozeti"
  echo "================================"
  echo "Surum    : $(cat /etc/turan-surum 2>/dev/null || echo ?)"
  echo "Cekirdek : $(uname -r)"
  echo "Makine   : $(uname -m)"
  echo "Uptime   : $(uptime -p)"
  echo
  echo "Bellek:"
  free -h | head -2
  echo
  echo "Disk (kok):"
  df -h / | tail -1
  echo
  echo "Yuklu paket sayisi: $(dpkg -l 2>/dev/null | grep -c '^ii')"
  echo "Aktif servis      : $(systemctl list-units --type=service --state=running --no-legend 2>/dev/null | wc -l)"
}

komut="${1:-yardim}"; shift 2>/dev/null || true
case "$komut" in
  sor)
    echo -e "${Y}[!]${S} Yerel SLM henuz devrede degil (v0.4)."
    echo "    Sorunuz kaydedildi: $*"
    echo "    Simdilik 'bilge ozet' ve 'bilge morf <cumle>' calisiyor." ;;
  ozet) ozet ;;
  morf) morf "$@" ;;
  runik) runik "$@" ;;
  yardim|-h|--help|"") yardim ;;
  *) echo "Bilinmeyen komut: $komut"; yardim; exit 1 ;;
esac
__SON__
chmod +x config/includes.chroot/usr/local/bin/bilge

# Bilge icin masaustu kisayolu
yaz config/includes.chroot/usr/share/applications/turan-bilge.desktop <<'__SON__'
[Desktop Entry]
Type=Application
Name=Bilge AI
Comment=Yerel Yapay Zeka Yardimcisi
Exec=xfce4-terminal -e "bilge yardim" --title=Bilge
Icon=turan-os
Terminal=false
Categories=Utility;System;
Keywords=AI;Yapay;Zeka;Bilge;
__SON__

adim "Tamga: kisisel kabile muhru uretici"
yaz config/includes.chroot/usr/local/bin/tamga <<'__SON__'
#!/bin/bash
# Tamga - Kisisel Gokturk Muhru Uretici
# Kullanim: tamga "isminiz" [boyut] [renk]
K='\033[1;33m'; S='\033[0m'
ISIM="${1:-turan}"
BOY="${2:-256}"
RENK="${3:-#D4AF37}"
CIKIS="$HOME/tamga-$ISIM.svg"

# Isimden deterministik tohum
SEED=$(printf '%s' "$ISIM" | md5sum | cut -c1-8)
N=$((16#$SEED))

# 4 ceyrek icin rastgele ama deterministik parcalar
A=$(( N % 4 )); B=$(( (N/7) % 4 )); C=$(( (N/13) % 4 )); D=$(( (N/29) % 4 ))

cat > "$CIKIS" <<EOF
<svg xmlns="http://www.w3.org/2000/svg" width="$BOY" height="$BOY" viewBox="0 0 100 100">
  <defs>
    <circle id="c" cx="50" cy="50" r="42" fill="none" stroke="$RENK" stroke-width="1.5"/>
    <circle id="ci" cx="50" cy="50" r="34" fill="none" stroke="$RENK" stroke-width="0.8"/>
  </defs>
  <use href="#c"/><use href="#ci"/>
  <g stroke="$RENK" stroke-width="3" stroke-linecap="round" fill="none">
    <path d="M50 8 V26 $([ $A -eq 0 ] && echo 'M50 26 l-8 -6' || [ $A -eq 1 ] && echo 'M50 26 l8 -6' || [ $A -eq 2 ] && echo 'M50 26 l0 6' || echo 'M50 26 l-6 6')"/>
    <path d="M50 92 V74 $([ $B -eq 0 ] && echo 'M50 74 l-8 6' || [ $B -eq 1 ] && echo 'M50 74 l8 6' || [ $B -eq 2 ] && echo 'M50 74 l0 -6' || echo 'M50 74 l6 -6')"/>
    <path d="M8 50 H26 $([ $C -eq 0 ] && echo 'M26 50 l-6 -8' || [ $C -eq 1 ] && echo 'M26 50 l-6 8' || [ $C -eq 2 ] && echo 'M26 50 l6 0' || echo 'M26 50 l0 -6')"/>
    <path d="M92 50 H74 $([ $D -eq 0 ] && echo 'M74 50 l6 -8' || [ $D -eq 1 ] && echo 'M74 50 l6 8' || [ $D -eq 2 ] && echo 'M74 50 l-6 0' || echo 'M74 50 l0 -6')"/>
  </g>
  <path d="M42 40 H58 M50 40 V68" stroke="$RENK" stroke-width="4" stroke-linecap="round"/>
  <circle cx="50" cy="72" r="2" fill="$RENK"/>
</svg>
EOF

echo -e "${K}  TAMGA${S} uretildi: $CIKIS"
echo "  Isim: $ISIM   Boyut: ${BOY}px   Renk: $RENK"
echo "  Tohum: $SEED"
if command -v rsvg-convert >/dev/null 2>&1; then
  rsvg-convert -w "$BOY" -h "$BOY" "$CIKIS" -o "${CIKIS%.svg}.png"
  echo "  PNG : ${CIKIS%.svg}.png"
fi
__SON__
chmod +x config/includes.chroot/usr/local/bin/tamga

adim "Bozkir paket listesi"
yaz config/package-lists/turan-bozkir.list.chroot <<'__SON__'
# Bozkır Katmanı v0.3
conky-all
xfce4-genmon-plugin
fonts-noto-core
fonts-noto-extra
noto-fonts-color-emoji
rsvg-convert
cairo-5c
python3-cairo
python3-gi
gir1.2-gtk-3.0
zenity
espeak-ng
libnotify-bin
ss
iproute2
upower
acpi
__SON__

adim "Bozkir derleme hook"
yaz config/hooks/live/0700-turan-bozkir.hook.chroot <<'__SON__'
#!/bin/sh
set -e
# Bozkır duvar kağıdını PNG'ye çevir
if [ -f /usr/share/backgrounds/turan/bozkir.svg ]; then
  rsvg-convert -w 1920 -h 1080 /usr/share/backgrounds/turan/bozkir.svg \
    -o /usr/share/backgrounds/turan/bozkir.png
  rsvg-convert -w 3840 -h 2160 /usr/share/backgrounds/turan/bozkir.svg \
    -o /usr/share/backgrounds/turan/bozkir-4k.png
fi

# Yeni logoyu PNG'ye çevir
if [ -f /usr/share/icons/hicolor/scalable/apps/turan-os.svg ]; then
  rsvg-convert -w 256 -h 256 /usr/share/icons/hicolor/scalable/apps/turan-os.svg \
    -o /usr/share/pixmaps/turan-os.png
fi

# LightDM: yeni duvar kağıdı
sed -i 's|background=.*|background=/usr/share/backgrounds/turan/bozkir.png|' \
  /etc/lightdm/lightdm-gtk-greeter.conf 2>/dev/null || true

# MOTD'ye runik satır ekle
if [ -f /etc/update-motd.d/00-turan ]; then
  cat > /etc/update-motd.d/00-turan <<'EOT'
#!/bin/sh
SURUM="$(cat /etc/turan-surum 2>/dev/null || echo '?')"
printf '\n\033[1;36m  TURAN-OS\033[0m %s\n' "$SURUM"
printf '  \033[1;33m𐱅𐰇𐰼𐰚 𐰚𐰀𐰏𐰀𐰣𐰞𐰃𐰚\033[0m  -  Bozkir Katmani\n'
printf '  https://github.com/eyecacat/turan-os\n'
printf '  Yardim: \033[1mturan yardim\033[0m  |  Yapay Zeka: \033[1mbilge yardim\033[0m\n\n'
EOT
  chmod +x /etc/update-motd.d/00-turan
fi

# Masaüstü simgesi: Bilge kısayolu
mkdir -p /etc/skel/Desktop
cp /usr/share/applications/turan-bilge.desktop /etc/skel/Desktop/ 2>/dev/null || true
chmod +x /etc/skel/Desktop/*.desktop 2>/dev/null || true
exit 0
__SON__
chmod +x config/hooks/live/0700-turan-bozkir.hook.chroot

adim "README ve ROADMAP guncelleme"
ekle README.md <<'__SON__'

## Bozkır Katmanı (v0.3)
- Renk paleti: Gök Mavisi #00A6FF · Kut Altını #D4AF37 · Ötüken Yeşili #1B4D3E · Yurt Kömürü #11141A · Şaman Kemiği #F5F2EB
- Göktürk runik destekli MOTD ve duvar kağıdı
- Mitolojik komutlar: `asena` (ağ), `umay` (RAM), `tore` (güvenlik), `kam` (donanım)
- `bilge` yapay zeka iskeleti: `bilge ozet`, `bilge morf`, `bilge runik`
- `tamga` kişisel mühür üretici
- Panel: Asena/Umay/Kam genmon widget'ları
__SON__

ekle ROADMAP.md <<'__SON__'

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
__SON__

echo
echo "======================================"
echo "  BOZKIR KATMANI TAMAM"
echo "======================================"
echo
echo "Simdi:"
echo "  git add -A"
echo "  git commit -m 'Bozkir Katmani v0.3: renk paleti, mitolojik komutlar, bilge'"
echo "  git push"
