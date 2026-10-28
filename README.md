# burbuja-slack

Burbuja flotante de Slack para Linux (GNOME / X11), estilo "chat head".
Un solo proceso en Python + GTK3 + WebKitGTK que carga Slack web
(`app.slack.com`) en una ventana propia; no usa la app de escritorio.

Proyecto hermano de [burbuja-wa](https://github.com/secamc93/burbuja-wa) (WhatsApp).

## Qué hace

- **Burbuja** morada con el logo de Slack, siempre encima y en todos los escritorios.
  Muestra los no leídos: un número si Slack lo da en el título, si no un punto rojo.
  - Clic: abre Slack / lo trae al frente / lo oculta.
  - Arrastrar: mueve la burbuja (la ventana abierta la sigue).
  - Clic derecho: menú (abrir, siempre encima, recargar, salir).
  - Se oculta sola si la ventana de Slack queda encima de ella (maximizada o en
    pantalla completa) y vuelve al cerrarla, minimizarla o moverla.
- **Ventana** sin bordes del sistema, con esquinas redondeadas y barra propia:
  - Arrastrar la barra: mover. Doble clic: maximizar / restaurar.
  - Bordes y esquinas: redimensionar.
  - Botones: alejar, acercar, recargar, siempre encima, minimizar, maximizar, ocultar.
  - Recuerda posición, tamaño, zoom y "siempre encima".
- Límite de memoria de WebKit (`MEMORIA_MB`, 1 GB): pasado ese uso libera memoria.
- Notificaciones de escritorio, micrófono y cámara, descargas a `~/Descargas`.
- Pegar imágenes con `Ctrl+V` o clic derecho > Pegar imagen (WebKitGTK no lo hace solo).
- Los enlaces de los mensajes se abren en el navegador; el inicio de sesión
  (Google / SSO) se hace dentro de la ventana.

## Atajos

| Tecla | Acción |
|---|---|
| `Super+K` | abrir / ocultar Slack |
| `Ctrl +` / `Ctrl -` / `Ctrl 0` | zoom (0 = 100 %) |
| `Ctrl R` / `F5` | recargar |

## Instalar

```bash
./instalar.sh
burbuja-slack
```

Requiere `python3-gi`, `python3-gi-cairo` y `gir1.2-webkit2-4.1` (Ubuntu 24.04) o `gir1.2-webkit2-4.0` (Ubuntu 22.04).
La primera vez hay que iniciar sesión en el espacio de trabajo.

## Notas

- Slack no acepta WebKit presentado como Safari, así que se presenta como un Chrome
  reciente; la versión se calcula según la fecha para que no quede vieja.
- Las huddles y llamadas pueden funcionar peor que en la app oficial.

## Archivos en tu equipo

- `~/.config/burbuja-slack/estado.json`: posición, tamaño y zoom.
- `~/.local/share/burbuja-slack/`: sesión de Slack (cookies, almacenamiento, caché).

## Ajustes rápidos

Constantes al inicio de `burbuja-slack`: `TAM` (diámetro de la burbuja), `RADIO`
(redondeo), `ZOOM` (zoom por defecto), `CHAT_ANCHO` / `CHAT_ALTO`.

El logo viene de [Simple Icons](https://simpleicons.org/) (CC0). Slack es una
marca de Salesforce; este proyecto no está afiliado.
