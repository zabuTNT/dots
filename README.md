# dots

Configurazioni per Fedora + Sway, con gli script per il post-installazione.
Niente segreti: nome, email, chiavi e token si usano i file `*.local`.

## Contenuto

| Cartella | Cosa fa |
|----------|---------|
| `sway/` | Config Sway e script: screenshot, night light, avvio sessione |
| `waybar/` | Barra di stato  |
| `mako/`, `fuzzel/` | Notifiche e launcher |
| `kanshi/` | Profili monitor |
| `kitty/` | Terminale |
| `bash/` | `.bashrc` modulare (`rc.d/NN-*.sh`) e `.profile` |
| `git/` | `.gitconfig` senza identità (vedi sotto) |
| `mise/` | Versioni di node, python, go, rust, java e CLI di lavoro |
| `tools/` | ranger, btop, htop, k9s |
| `system/` | Pacchetti dnf, flatpak e `post-install.sh` |

## Su una macchina nuova

```sh
git clone https://github.com/<utente>/dots ~/Progetti/dots
cd ~/Progetti/dots

./system/post-install.sh        # repo, pacchetti, flatpak, mise, servizi (usa sudo)
./install.sh                    # collega le config nella home
$EDITOR ~/.gitconfig.local      # nome, email, chiave di firma
```

`DRY_RUN=1 ./install.sh` mostra cosa verrebbe collegato senza toccare nulla. I file
già presenti vengono spostati in `<file>.bak-<data>`, non sovrascritti.
Si può installare un solo modulo: `./install.sh sway waybar`.

Per ripristinare da un backup (`backup/backup.sh`) vedi [RESTORE.md](RESTORE.md).

## Versioni dei linguaggi (mise)

`mise/config.toml` fissa i default globali. Nei progetti basta un `mise.toml`
o i file classici (`.nvmrc`, `.python-version`, `.go-version`, `.tool-versions`):

```sh
mise use node@22     # nel progetto
mise ls              # cosa è attivo e da dove
```

## Segreti

- `~/.gitconfig.local`: identità e firma dei commit
- `~/.config/secrets/github_token`: letto da `.profile` come `GITHUB_TOKEN`
- `~/.bashrc.local`: alias e percorsi della singola macchina

## Da verificare dopo il primo avvio

- `kanshi/config`: scala e posizioni dei monitor non sono testate
- `assign` in `sway/config`: gli `app_id` delle app vanno controllati con `swaymsg -t get_tree`
- nomi dei pacchetti in `system/packages-dnf.txt`: lo script elenca quelli non trovati
