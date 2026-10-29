#!/usr/bin/env bash
# Backup della home con rsync su un volume montato.
#
#   backup/backup.sh /mnt/backup            anteprima (dry-run)
#   backup/backup.sh /mnt/backup --run      esegue
#   opzioni: --with-data   include osm.pbf/pmtiles/mbtiles
#   BWLIMIT=40000 backup.sh ...   limita la velocità (KiB/s), utile con dischi USB fragili
#
# Il volume di destinazione deve essere ext4 (permessi, symlink, ACL).
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="${1:?uso: backup.sh <destinazione> [--run] [--with-data]}"
shift

RUN=0
DATA=0
for a in "$@"; do
  case "$a" in
    --run) RUN=1 ;;
    --with-data) DATA=1 ;;
    *) echo "opzione sconosciuta: $a" >&2; exit 1 ;;
  esac
done

if ! findmnt -n -T "$DEST" -o FSTYPE | grep -qx ext4; then
  echo "$DEST non è su ext4: rifiuto di continuare" >&2
  exit 1
fi

# keep.local (non versionato, vedi keep.example) va per primo: in rsync vince la
# prima regola che corrisponde
args=(-aHAX --numeric-ids --info=stats2,progress2 --partial)
[ -f "$HERE/keep.local" ] && args+=(--filter=". $HERE/keep.local")
args+=(--exclude-from="$HERE/excludes.txt")
[ "$DATA" = 0 ] && args+=(--exclude-from="$HERE/data-excludes.txt")
[ "$RUN" = 0 ] && args+=(--dry-run)
[ -n "${BWLIMIT:-}" ] && args+=(--bwlimit="$BWLIMIT")

mkdir -p "$DEST/home" "$DEST/manifest"
"$HERE/manifest.sh" "$DEST/manifest"
rsync "${args[@]}" "$HOME/" "$DEST/home/"

[ "$RUN" = 0 ] && echo "Questo era un dry-run: aggiungi --run per copiare davvero."
