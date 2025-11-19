#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ===========================
# Validación de argumento
# ===========================
if [[ $# -ne 1 ]]; then
  echo "Uso: $0 <carpeta>"
  exit 1
fi

DIR="$1"

if [[ ! -d "$DIR" ]]; then
  echo "ERROR: '$DIR' no es una carpeta válida."
  exit 1
fi

# ===========================
# Función para convertir bytes a formato legible
# ===========================
human_size() {
  local size=$1
  local units=("B" "KB" "MB" "GB" "TB")
  local i=0
  while (( size > 1024 && i < ${#units[@]}-1 )); do
    size=$(( size / 1024 ))
    i=$(( i + 1 ))
  done
  echo "${size} ${units[$i]}"
}

# ===========================
# Auditoría de la carpeta
# ===========================

# Contar archivos
file_count=$(find "$DIR" -type f | wc -l)

# Contar subcarpetas
folder_count=$(find "$DIR" -type d | wc -l)

# Tamaño total en bytes
total_bytes=$(du -sb "$DIR" | awk '{print $1}')
total_human=$(human_size "$total_bytes")

# Fecha actual
timestamp=$(date '+%Y-%m-%d %H:%M:%S')

# ===========================
# Guardar en log
# ===========================
LOGFILE="/var/log/folders_audit.log"

# Si no tiene permiso, usar log local
if [[ ! -w "$(dirname "$LOGFILE")" ]]; then
  LOGFILE="./folders_audit.log"
fi

echo "[$timestamp] Carpeta: $DIR | Archivos: $file_count | Subcarpetas: $folder_count | Tamaño: $total_human" >> "$LOGFILE"

# ===========================
# Mostrar reporte por pantalla
# ===========================
echo "=== Auditoría de carpeta ==="
echo "Carpeta analizada: $DIR"
echo "Cantidad de archivos: $file_count"
echo "Cantidad de subcarpetas: $folder_count"
echo "Tamaño total: $total_human"
echo "Log guardado en: $LOGFILE"

