#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# -----------------------
# Utilidades
# -----------------------
bytes_to_human() {
  # Convierte bytes (entero) a formato legible: B, KiB, MiB, GiB...
  local b=${1:-0}
  local s=0
  local units=("B" "KiB" "MiB" "GiB" "TiB")
  while (( b > 1024 && s < ${#units[@]}-1 )); do
    b=$(( b / 1024 ))
    s=$(( s + 1 ))
  done
  printf "%s %s" "$b" "${units[$s]}"
}

# Suma rx y tx de todas las interfaces (excluye loopback) desde /proc/net/dev
read_net_counters() {
  awk '
    NR>2 {
      iface=$1
      gsub(":", "", iface)
      if (iface == "lo") next
      rx += $2
      tx += $10
    }
    END { print rx, tx }
  ' /proc/net/dev
}

# -----------------------
# Datos básicos del sistema
# -----------------------
echo "=== STATUS DEL SISTEMA ==="
echo "Fecha y hora:  $(date '+%Y-%m-%d %H:%M:%S')"
echo "Usuario actual: $(whoami)"

# Obtener IP local preferida (IPv4) de la máquina
local_ip="$(ip -4 addr show scope global 2>/dev/null | awk '/inet /{print $2}' | cut -d/ -f1 | head -n1 || true)"
if [[ -z "$local_ip" ]]; then
  # alternativa robusta
  local_ip=$(hostname -I 2>/dev/null | awk '{print $1}' || echo "N/A")
fi
echo "IP local:       $local_ip"

# -----------------------
# Top 5 procesos por CPU
# -----------------------
echo
echo "Top 5 procesos por CPU (PID,USER,%CPU,%MEM,COMANDO):"
# ps -eo ... ordena por %CPU descendente. La primera línea es header y luego tomamos 5 procesos.
ps -eo pid,user,pcpu,pmem,comm --sort=-pcpu | awk 'NR==1{next} NR<=6{printf "%-8s %-10s %-6s %-6s %s\n",$1,$2,$3,$4,$5}'

# -----------------------
# Memoria
# -----------------------
echo
# Usamos "free" para mostrar memoria; preferimos la columna "available" si existe.
if free -h 2>/dev/null | head -n1 | grep -qi available; then
  # Sistemas con columna 'available' (la mayoría de linux modernos)
  awk '/^Mem:/ { printf "RAM disponible: %s (de %s total)\n", $7, $2 }' <(free -h)
else
  # Fallback si no hay columna 'available'
  awk '/^Mem:/ { printf "RAM libre: %s (de %s total)\n", $4, $2 }' <(free -h)
fi

# -----------------------
# Disco (raíz / por defecto)
# -----------------------
echo
root="/"
df -h --output=target,avail,size,pcent "${root}" 2>/dev/null | awk 'NR==1{next} {printf "Disco (%s): %s disponibles de %s (%s)\n",$1,$2,$3,$4}'

# -----------------------
# Uptime
# -----------------------
echo
# uptime -p da una versión "pretty" (e.g., up 2 hours, 5 minutes)
echo "Uptime: $(uptime -p 2>/dev/null || awk '{print int($1/3600) \"h \" int(($1%3600)/60) \"m\"}' /proc/uptime)"

# -----------------------
# Uso de red actual (mide bytes/s en 1 segundo)
# -----------------------
echo
echo "Medición de uso de red (durante 1s)..."
IFS=$' \t\n' read rx1 tx1 < <(read_net_counters)
sleep 1
IFS=$' \t\n' read rx2 tx2 < <(read_net_counters)

drx=$(( ${rx2:-0} - ${rx1:-0} ))
dtx=$(( ${tx2:-0} - ${tx1:-0} ))

# Convertir a legible usando la función (usa bytes /s)
human_rx=$(bytes_to_human $drx)
human_tx=$(bytes_to_human $dtx)

echo "RX: ${human_rx}/s    TX: ${human_tx}/s"

echo
echo "=== FIN ==="

