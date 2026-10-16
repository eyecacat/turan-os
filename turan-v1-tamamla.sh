#!/usr/bin/env bash
# TURAN-OS v1.0 tamamlayıcı katman (v2)
set -u

KIRMIZI='\033[1;31m'; YESIL='\033[1;32m'; SARI='\033[1;33m'; SIFIR='\033[0m'
adim() { printf "${YESIL}==>${SIFIR} %s\n" "$*"; }
hata() { printf "${KIRMIZI}[X]${SIFIR} %s\n" "$*"; }

yaz() {
  local hedef="$1"
  mkdir -p "$(dirname "$hedef")" || { hata "Dizin: $hedef"; return 1; }
  cat > "$hedef" || { hata "Yazma: $hedef"; return 1; }
  echo "  + $hedef"
}

ekle() {
  local hedef="$1"
  mkdir -p "$(dirname "$hedef")" || { hata "Dizin: $hedef"; return 1; }
  [ -f "$hedef" ] || : > "$hedef"
  cat >> "$hedef" || { hata "Ekleme: $hedef"; return 1; }
  echo "  ~ $hedef (eklendi)"
}

if [ ! -d .git ]; then
  hata "Depo kökünde değilsiniz. Şu an: $(pwd)"; exit 1
fi
if [ ! -f auto/config ] || [ ! -d config/package-lists ]; then
  hata "Önce kur-turan.sh çalıştırılmalı."; exit 1
fi
adim "Ortam uygun: $(pwd)"

adim "1/3 Cekirdek parametreleri"
yaz config/includes.chroot/etc/sysctl.d/90-turan.conf <<'__SON__'
vm.swappiness=10
vm.vfs_cache_pressure=50
vm.dirty_ratio=15
vm.dirty_background_ratio=5
net.ipv4.tcp_syncookies=1
net.ipv4.conf.all.rp_filter=1
net.ipv4.conf.default.rp_filter=1
net.ipv4.conf.all.accept_redirects=0
net.ipv4.conf.all.send_redirects=0
net.ipv4.conf.all.accept_source_route=0
net.ipv6.conf.all.accept_redirects=0
net.ipv4.icmp_echo_ignore_broadcasts=1
net.ipv4.conf.all.log_martians=1
kernel.dmesg_restrict=1
kernel.kptr_restrict=2
kernel.yama.ptrace_scope=1
kernel.unprivileged_bpf_disabled=1
net.core.bpf_jit_harden=2
fs.protected_hardlinks=1
fs.protected_symlinks=1
fs.suid_dumpable=0
__SON__

yaz config/includes.chroot/etc/default/grub.d/90-turan.cfg <<'__SON__'
GRUB_DISTRIBUTOR="TURAN-OS"
GRUB_TIMEOUT=5
GRUB_TIMEOUT_STYLE=menu
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash loglevel=3 vt.global_cursor_default=0"
GRUB_CMDLINE_LINUX=""
GRUB_GFXMODE=1920x1080,1024x768,auto
GRUB_GFXPAYLOAD_LINUX=keep
GRUB_DISABLE_OS_PROBER=false
__SON__

adim "Dosya sistemi ince ayari"
yaz config/includes.chroot/etc/systemd/system/turan-fs-tune.service <<'__SON__'
[Unit]
Description=TURAN-OS dosya sistemi ince ayari
After=local-fs.target
ConditionPathExists=/etc/turan-surum

[Service]
Type=oneshot
ExecStart=/usr/local/bin/turan-fs-tune
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
__SON__

yaz config/includes.chroot/usr/local/bin/turan-fs-tune <<'__SON__'
#!/bin/bash
set -e
KOK=$(findmnt -no FSTYPE /)
case "$KOK" in
  ext4)
    if ! grep -q noatime /etc/fstab 2>/dev/null; then
      sed -i 's|\(\s/\s*ext4\s*\)\([^ ]*\)|\1\2,noatime|' /etc/fstab || true
    fi
    systemctl enable fstrim.timer 2>/dev/null || true ;;
  btrfs)
    systemctl enable btrfs-scrub@-.timer 2>/dev/null || true
    systemctl enable btrfs-balance.timer 2>/dev/null || true ;;
esac
exit 0
__SON__
chmod +x config/includes.chroot/usr/local/bin/turan-fs-tune

adim "XFCE panel + kisayollar + GTK CSS"
D=config/includes.chroot/etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml

yaz "$D/xfce4-panel.xml" <<'__SON__'
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
    <property name="size" type="uint" value="32"/>
    <property name="background-style" type="uint" value="1"/>
    <property name="background-rgba" type="array">
      <value type="double" value="0.05"/>
      <value type="double" value="0.09"/>
      <value type="double" value="0.16"/>
      <value type="double" value="0.92"/>
    </property>
    <property name="plugin-ids" type="array">
      <value type="int" value="1"/><value type="int" value="2"/>
      <value type="int" value="3"/><value type="int" value="4"/>
      <value type="int" value="5"/><value type="int" value="6"/>
      <value type="int" value="7"/><value type="int" value="8"/>
    </property>
  </property>
  <property name="plugin-1" type="string" value="whisker-menu"/>
  <property name="plugin-2" type="string" value="tasklist">
    <property name="grouping" type="uint" value="1"/>
    <property name="show-labels" type="bool" value="false"/>
    <property name="flat-buttons" type="bool" value="true"/>
  </property>
  <property name="plugin-3" type="string" value="separator">
    <property name="expand" type="bool" value="true"/>
  </property>
  <property name="plugin-4" type="string" value="systray"/>
  <property name="plugin-5" type="string" value="pulseaudio"/>
  <property name="plugin-6" type="string" value="power-manager-plugin"/>
  <property name="plugin-7" type="string" value="clock">
    <property name="digital-layout" type="uint" value="3"/>
    <property name="digital-time-font" type="string" value="Inter Medium 11"/>
    <property name="digital-time-format" type="string" value="%H:%M  %d %b"/>
  </property>
  <property name="plugin-8" type="string" value="actions">
    <property name="items" type="array">
      <value type="string" value="+lock-screen"/>
      <value type="string" value="+switch-user"/>
      <value type="string" value="+separator"/>
      <value type="string" value="+suspend"/>
      <value type="string" value="+restart"/>
      <value type="string" value="+shutdown"/>
    </property>
  </property>
</channel>
__SON__

yaz "$D/xfce4-keyboard-shortcuts.xml" <<'__SON__'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-keyboard-shortcuts" version="1.0">
  <property name="commands" type="empty">
    <property name="custom" type="empty">
      <property name="&lt;Super&gt;Return" type="string" value="xfce4-terminal"/>
      <property name="&lt;Super&gt;e" type="string" value="thunar"/>
      <property name="&lt;Super&gt;f" type="string" value="firefox-esr"/>
      <property name="&lt;Super&gt;l" type="string" value="xflock4"/>
      <property name="Print" type="string" value="xfce4-screenshooter -f"/>
    </property>
  </property>
</channel>
__SON__

yaz config/includes.chroot/etc/skel/.config/gtk-3.0/gtk.css <<'__SON__'
@define-color turan_red #e30a17;
@define-color turan_dark #0a0f1c;
headerbar, .titlebar { background: linear-gradient(180deg, #141f36, #0a0f1c); color: #fff; }
button.suggested-action { background: @turan_red; color: #fff; }
progressbar progress { background: @turan_red; }
__SON__

adim "Guvenlik: AppArmor, parola, sudo"
yaz config/hooks/live/0400-turan-guvenlik.hook.chroot <<'__SON__'
#!/bin/sh
set -e
systemctl enable apparmor 2>/dev/null || true
mkdir -p /etc/security/pwquality.conf.d
cat > /etc/security/pwquality.conf.d/turan.conf <<'EOT'
minlen = 8
minclass = 3
maxrepeat = 3
EOT
cat > /etc/sudoers.d/90-turan <<'EOT'
Defaults timestamp_timeout=10
Defaults env_reset, secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
EOT
chmod 440 /etc/sudoers.d/90-turan
systemctl enable turan-fs-tune.service 2>/dev/null || true
systemctl enable earlyoom 2>/dev/null || true
systemctl enable irqbalance 2>/dev/null || true
systemctl enable systemd-coredump 2>/dev/null || true
exit 0
__SON__
chmod +x config/hooks/live/0400-turan-guvenlik.hook.chroot

adim "Ag: resolved + hosts"
yaz config/includes.chroot/etc/NetworkManager/conf.d/10-turan-dns.conf <<'__SON__'
[main]
dns=systemd-resolved
systemd-resolved=true
__SON__

yaz config/includes.chroot/etc/hosts <<'__SON__'
127.0.0.1   localhost
127.0.1.1   turan-os
::1         localhost ip6-localhost ip6-loopback
ff02::1     ip6-allnodes
ff02::2     ip6-allrouters
__SON__

adim "Daemon: journald + haftalik bakim"
yaz config/includes.chroot/etc/systemd/journald.conf.d/90-turan.conf <<'__SON__'
[Journal]
Storage=persistent
SystemMaxUse=500M
SystemMaxFileSize=50M
MaxRetentionSec=1month
ForwardToSyslog=no
Compress=yes
__SON__

yaz config/includes.chroot/etc/systemd/system/turan-bakim.service <<'__SON__'
[Unit]
Description=TURAN-OS haftalik bakim
After=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/turan-bakim
__SON__

yaz config/includes.chroot/etc/systemd/system/turan-bakim.timer <<'__SON__'
[Unit]
Description=Haftalik TURAN-OS bakimi
Requires=turan-bakim.service

[Timer]
OnCalendar=Sun *-*-* 03:00:00
Persistent=true

[Install]
WantedBy=timers.target
__SON__

yaz config/includes.chroot/usr/local/bin/turan-bakim <<'__SON__'
#!/bin/bash
set -e
apt-get update -qq || true
apt-get autoremove --purge -y || true
apt-get clean
flatpak uninstall --unused -y 2>/dev/null || true
journalctl --vacuum-time=14d || true
exit 0
__SON__
chmod +x config/includes.chroot/usr/local/bin/turan-bakim

adim "Kurtarma: coredump"
yaz config/includes.chroot/etc/systemd/coredump.conf.d/90-turan.conf <<'__SON__'
[Coredump]
Storage=external
ProcessSizeMax=1G
__SON__

adim "Ek uygulamalar (append)"
ekle config/package-lists/turan-uygulama.list.chroot <<'__SON__'

# v1.0 eklemeleri
galculator
xfce4-screenshooter
xfce4-taskmanager
xfce4-clipman-plugin
xfce4-notifyd
xfce4-power-manager
xfce4-settings
light-locker
numlockx
mugshot
orage
catfish
menulibre
gdebi
tumbler
ffmpegthumbnailer
__SON__

ekle config/package-lists/turan.list.chroot <<'__SON__'

# v1.0 sistem eklemeleri
apparmor
apparmor-utils
apparmor-profiles
earlyoom
irqbalance
systemd-coredump
needrestart
apt-listchanges
locales
console-setup
keyboard-configuration
man-db
fonts-liberation2
fonts-dejavu
fonts-noto-color-emoji
gtk2-engines-murrine
gnome-keyring
libpam-gnome-keyring
inxi
smartmontools
lm-sensors
x11-utils
x11-xserver-utils
policykit-1-gnome
__SON__

adim "Turkce locale + MOTD"
yaz config/hooks/live/0500-turan-turkce.hook.chroot <<'__SON__'
#!/bin/sh
set -e
sed -i 's/^# *tr_TR.UTF-8/tr_TR.UTF-8/' /etc/locale.gen
sed -i 's/^# *en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
locale-gen
cat > /etc/default/locale <<'EOT'
LANG=tr_TR.UTF-8
LANGUAGE=tr_TR:tr
LC_MESSAGES=tr_TR.UTF-8
LC_TIME=tr_TR.UTF-8
LC_MONETARY=tr_TR.UTF-8
LC_PAPER=tr_TR.UTF-8
LC_NAME=tr_TR.UTF-8
LC_ADDRESS=tr_TR.UTF-8
LC_TELEPHONE=tr_TR.UTF-8
LC_MEASUREMENT=tr_TR.UTF-8
LC_IDENTIFICATION=tr_TR.UTF-8
EOT
ln -sf /usr/share/zoneinfo/Europe/Istanbul /etc/localtime
echo "Europe/Istanbul" > /etc/timezone
cat > /etc/default/keyboard <<'EOT'
XKBMODEL="pc105"
XKBLAYOUT="tr"
XKBVARIANT=""
XKBOPTIONS=""
BACKSPACE="guess"
EOT
mkdir -p /etc/update-motd.d
cat > /etc/update-motd.d/00-turan <<'EOT'
#!/bin/sh
SURUM="$(cat /etc/turan-surum 2>/dev/null || echo '?')"
printf '\n\033[1;31m  TURAN-OS\033[0m %s\n' "$SURUM"
printf '  Turkce Linux - https://github.com/eyecacat/turan-os\n'
printf '  Yardim: turan yardim\n\n'
EOT
chmod +x /etc/update-motd.d/00-turan
exit 0
__SON__
chmod +x config/hooks/live/0500-turan-turkce.hook.chroot

adim "Ek uygulamalar (append)"
ekle config/package-lists/turan-uygulama.list.chroot <<'__SON__'

# v1.0 eklemeleri
galculator
xfce4-screenshooter
xfce4-taskmanager
xfce4-clipman-plugin
xfce4-notifyd
xfce4-power-manager
xfce4-settings
light-locker
numlockx
mugshot
orage
catfish
menulibre
gdebi
tumbler
ffmpegthumbnailer
__SON__

ekle config/package-lists/turan.list.chroot <<'__SON__'

# v1.0 sistem eklemeleri
apparmor
apparmor-utils
apparmor-profiles
earlyoom
irqbalance
systemd-coredump
needrestart
apt-listchanges
locales
console-setup
keyboard-configuration
man-db
fonts-liberation2
fonts-dejavu
fonts-noto-color-emoji
gtk2-engines-murrine
gnome-keyring
libpam-gnome-keyring
inxi
smartmontools
lm-sensors
x11-utils
x11-xserver-utils
policykit-1-gnome
__SON__

adim "Turkce locale + MOTD"
yaz config/hooks/live/0500-turan-turkce.hook.chroot <<'__SON__'
#!/bin/sh
set -e
sed -i 's/^# *tr_TR.UTF-8/tr_TR.UTF-8/' /etc/locale.gen
sed -i 's/^# *en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
locale-gen
cat > /etc/default/locale <<'EOT'
LANG=tr_TR.UTF-8
LANGUAGE=tr_TR:tr
LC_MESSAGES=tr_TR.UTF-8
LC_TIME=tr_TR.UTF-8
LC_MONETARY=tr_TR.UTF-8
LC_PAPER=tr_TR.UTF-8
LC_NAME=tr_TR.UTF-8
LC_ADDRESS=tr_TR.UTF-8
LC_TELEPHONE=tr_TR.UTF-8
LC_MEASUREMENT=tr_TR.UTF-8
LC_IDENTIFICATION=tr_TR.UTF-8
EOT
ln -sf /usr/share/zoneinfo/Europe/Istanbul /etc/localtime
echo "Europe/Istanbul" > /etc/timezone
cat > /etc/default/keyboard <<'EOT'
XKBMODEL="pc105"
XKBLAYOUT="tr"
XKBVARIANT=""
XKBOPTIONS=""
BACKSPACE="guess"
EOT
mkdir -p /etc/update-motd.d
cat > /etc/update-motd.d/00-turan <<'EOT'
#!/bin/sh
SURUM="$(cat /etc/turan-surum 2>/dev/null || echo '?')"
printf '\n\033[1;31m  TURAN-OS\033[0m %s\n' "$SURUM"
printf '  Turkce Linux - https://github.com/eyecacat/turan-os\n'
printf '  Yardim: turan yardim\n\n'
EOT
chmod +x /etc/update-motd.d/00-turan
exit 0
__SON__
chmod +x config/hooks/live/0500-turan-turkce.hook.chroot

adim "fastfetch kimligi"
yaz config/includes.chroot/etc/skel/.config/fastfetch/config.jsonc <<'__SON__'
{
  "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
  "logo": { "source": "/usr/share/pixmaps/turan-os.png", "width": 24 },
  "display": { "separator": " -> ", "color": { "keys": "red" } },
  "modules": [
    "title", "separator",
    "os", "kernel", "uptime", "packages", "shell", "wm", "de", "theme", "icons",
    "terminal", "cpu", "gpu", "memory", "swap", "disk", "localip", "battery", "locale", "break"
  ]
}
__SON__

adim "Calamares markasi + LUKS"
yaz config/includes.chroot/etc/calamares/branding/turan/branding.desc <<'__SON__'
---
componentName: turan
strings:
    productName:         "TURAN-OS"
    shortProductName:    "TURAN"
    version:             "1.0"
    shortVersion:        "1.0"
    versionedName:       "TURAN-OS 1.0"
    shortVersionedName:  "TURAN 1.0"
    bootloaderEntryName: "TURAN-OS"
    productUrl:          "https://github.com/eyecacat/turan-os"
    supportUrl:          "https://github.com/eyecacat/turan-os/issues"
style:
   sidebarBackground:    "#0a0f1c"
   sidebarText:          "#FFFFFF"
   sidebarTextSelect:    "#e30a17"
   sidebarTextHighlight: "#e30a17"
__SON__

yaz config/includes.chroot/etc/calamares/modules/partition.conf <<'__SON__'
---
efiSystemPartition:     "/boot/efi"
efiSystemPartitionSize: 300M
userSwapChoices:
    - none
    - small
    - suspend
    - file
initialSwapChoice: none
defaultFileSystemType:  "ext4"
availableFileSystemTypes: ["ext4","btrfs","xfs"]
enableLuksAutomaticPartitioning: true
drawNestedPartitions: false
alwaysShowPartitionLabels: true
allowManualPartitioning: true
confirmReuse: false
__SON__

adim "turan komut genisletme"
yaz config/includes.chroot/usr/local/bin/turan-ek <<'__SON__'
#!/bin/bash
case "$1" in
  wifi)      nmcli device wifi list ;;
  bt)        bluetoothctl show 2>/dev/null; bluetoothctl devices 2>/dev/null ;;
  sicaklik)  sensors 2>/dev/null | head -30 ;;
  gpu)       lspci | grep -Ei 'vga|3d|display' ;;
  kernel)    uname -r; echo; ls /boot/vmlinuz-* 2>/dev/null ;;
  servis)    systemctl list-units --type=service --state=running --no-pager | head -30 ;;
  gunluk)    journalctl -p 3 -b --no-pager -n 30 ;;
  kurtarma)  echo "Yeniden baslatip GRUB'da 'Advanced options' secin." ;;
  *)         echo "Bilinmeyen ek komut: $1"; exit 1 ;;
esac
__SON__
chmod +x config/includes.chroot/usr/local/bin/turan-ek

adim "Ilk acilis karsilama"
yaz config/includes.chroot/usr/local/bin/turan-karsilama <<'__SON__'
#!/bin/bash
ISARET="$HOME/.config/turan/karsilama-tamam"
[ -f "$ISARET" ] && exit 0
mkdir -p "$(dirname "$ISARET")"
zenity --info --title="TURAN-OS'a Hos Geldiniz" --width=520 \
  --text="<b>TURAN-OS 1.0</b>\n\nTurkce oncelikli, Debian tabanli isletim sisteminiz hazir.\n\n- <b>turan yardim</b> ile komut aracini kesfedin\n- <b>turan guncelle</b> ile sistemi guncelleyin\n\nIyi calismalar!" 2>/dev/null || true
touch "$ISARET"
__SON__
chmod +x config/includes.chroot/usr/local/bin/turan-karsilama

yaz config/includes.chroot/etc/skel/.config/autostart/turan-karsilama.desktop <<'__SON__'
[Desktop Entry]
Type=Application
Name=TURAN-OS Karsilama
Exec=/usr/local/bin/turan-karsilama
X-GNOME-Autostart-enabled=true
OnlyShowIn=XFCE;
__SON__

adim "Son hook"
yaz config/hooks/live/0600-turan-son.hook.chroot <<'__SON__'
#!/bin/sh
set -e
systemctl daemon-reload 2>/dev/null || true
systemctl enable turan-bakim.timer 2>/dev/null || true
systemctl enable fstrim.timer 2>/dev/null || true
chmod +x /etc/skel/Desktop/*.desktop 2>/dev/null || true
chmod +x /usr/local/bin/turan* 2>/dev/null || true
gtk-update-icon-cache -f /usr/share/icons/hicolor 2>/dev/null || true
update-desktop-database 2>/dev/null || true
exit 0
__SON__
chmod +x config/hooks/live/0600-turan-son.hook.chroot

adim "ROADMAP guncelleme"
ekle ROADMAP.md <<'__SON__'

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
__SON__

adim "Actions sozdizimi kontrolu guncellemesi"
if [ -f .github/workflows/build-iso.yml ]; then
  if ! grep -q turan-fs-tune .github/workflows/build-iso.yml; then
    sed -i 's|          for f in auto/config|          bash -n config/includes.chroot/usr/local/bin/turan-fs-tune\n          bash -n config/includes.chroot/usr/local/bin/turan-bakim\n          bash -n config/includes.chroot/usr/local/bin/turan-karsilama\n          bash -n config/includes.chroot/usr/local/bin/turan-ek\n          for f in auto/config|' .github/workflows/build-iso.yml
    echo "  ~ Actions guncellendi"
  else
    echo "  = Actions zaten guncel"
  fi
fi

echo
echo "======================================"
echo "  TAMAM. Tum dosyalar yazildi."
echo "======================================"
echo
echo "Simdi sirayla:"
echo "  git add -A"
echo "  git status --short"
echo "  git commit -m 'TURAN-OS 1.0.0-rc2: 9 bilesen tamamlandi'"
echo "  git push"
