#!/bin/bash

CONFIG="/home/howen/Proyectos/ch57x-keyboard-tool/config.yaml"
TOOL="/tmp/ch57x/target/release/ch57x-keyboard-tool"

echo "=== CONFIGURAR TECLADO MACRO 3x1+1 ==="
echo "Deja vacío y presiona Enter si no quieres cambiar una tecla."
echo ""

read -p "Tecla 1 (arriba)     [prev]: " k1
read -p "Tecla 2 (medio)      [play]: " k2
read -p "Tecla 3 (abajo)      [next]: " k3
echo ""
echo "Perilla:"
read -p "  Girar izquierda   [volumedown]: " p1
read -p "  Presionar          [mute]:       " p2
read -p "  Girar derecha     [volumeup]:   " p3

k1=${k1:-prev}
k2=${k2:-play}
k3=${k3:-next}
p1=${p1:-volumedown}
p2=${p2:-mute}
p3=${p3:-volumeup}

cat > "$CONFIG" << EOF
model: ch57x-1
orientation: normal
rows: 3
columns: 1
knobs: 1

layers:
  - buttons:
      - ["$k1"]
      - ["$k2"]
      - ["$k3"]
    knobs:
      - ccw: "$p1"
        press: "$p2"
        cw: "$p3"
EOF

echo ""
echo "Configuración generada:"
echo "  Tecla 1: $k1"
echo "  Tecla 2: $k2"
echo "  Tecla 3: $k3"
echo "  Perilla <: $p1"
echo "  Perilla O: $p2"
echo "  Perilla >: $p3"
echo ""

read -p "¿Subir al teclado? (s/N): " ok
if [ "$ok" = "s" ] || [ "$ok" = "S" ]; then
    sudo "$TOOL" --vendor-id 0x514c --product-id 0x8851 --endpoint-address 2 upload "$CONFIG"
    echo ""
    echo "Listo. Desconecta y reconecta el teclado."
else
    echo "Config guardada en $CONFIG"
fi
