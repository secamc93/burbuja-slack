#!/usr/bin/env bash
# Instala la burbuja: enlace en ~/.local/bin, inicio automático y atajo Super+K.
set -euo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"

sudo_falta=()
if ! python3 -c 'import gi; gi.require_version("WebKit2", "4.1")' 2>/dev/null &&
   ! python3 -c 'import gi; gi.require_version("WebKit2", "4.0")' 2>/dev/null; then
  if apt-cache show gir1.2-webkit2-4.1 >/dev/null 2>&1; then sudo_falta+=(gir1.2-webkit2-4.1); else sudo_falta+=(gir1.2-webkit2-4.0); fi
fi
python3 -c 'import cairo' 2>/dev/null || sudo_falta+=(python3-gi-cairo)
if ((${#sudo_falta[@]})); then
  echo "Instalando dependencias: ${sudo_falta[*]}"
  sudo apt install -y "${sudo_falta[@]}"
fi

mkdir -p ~/.local/bin ~/.config/autostart ~/.local/share/applications
ln -sf "$DIR/burbuja-slack" ~/.local/bin/burbuja-slack

cat > ~/.config/autostart/burbuja-slack.desktop <<DESK
[Desktop Entry]
Type=Application
Name=Burbuja Slack
Comment=Burbuja flotante con Slack web propio
Exec=$HOME/.local/bin/burbuja-slack
Icon=$DIR/assets/slack-icono.svg
X-GNOME-Autostart-enabled=true
X-GNOME-Autostart-Delay=3
DESK

# lanzador en el menú de aplicaciones y en el dock
cat > ~/.local/share/applications/burbuja-slack.desktop <<DESK
[Desktop Entry]
Type=Application
Name=Burbuja Slack
Comment=Burbuja flotante con Slack web propio
Exec=$HOME/.local/bin/burbuja-slack --toggle
Icon=$DIR/assets/slack-icono.svg
StartupWMClass=BurbujaSlack
Categories=Network;InstantMessaging;
Terminal=false
DESK
FAV=$(gsettings get org.gnome.shell favorite-apps)
if [[ $FAV != *"burbuja-slack.desktop"* ]]; then
  if [[ $FAV == "@as []" || $FAV == "[]" ]]; then FAV="['burbuja-slack.desktop']"; else FAV="${FAV%]}, 'burbuja-slack.desktop']"; fi
  gsettings set org.gnome.shell favorite-apps "$FAV"
fi

# atajo Super+K -> burbuja-slack --toggle
BASE=org.gnome.settings-daemon.plugins.media-keys
RUTA=/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/burbuja-slack/
LISTA=$(gsettings get $BASE custom-keybindings)
# si ya hay un atajo con Super+K, se reutiliza en vez de crear otro que choque
for r in $(grep -o "'[^']*'" <<<"$LISTA" | tr -d "'"); do
  [[ $(gsettings get $BASE.custom-keybinding:$r binding) == "'<Super>k'" ]] && RUTA=$r
done
if [[ $LISTA != *"$RUTA"* ]]; then
  if [[ $LISTA == "@as []" || $LISTA == "[]" ]]; then LISTA="['$RUTA']"; else LISTA="${LISTA%]}, '$RUTA']"; fi
  gsettings set $BASE custom-keybindings "$LISTA"
fi
gsettings set $BASE.custom-keybinding:$RUTA name "Burbuja Slack"
gsettings set $BASE.custom-keybinding:$RUTA command "$HOME/.local/bin/burbuja-slack --toggle"
gsettings set $BASE.custom-keybinding:$RUTA binding "<Super>k"

echo "Listo. Ejecuta: burbuja-slack"
