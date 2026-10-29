# Ripristino su una macchina nuova

Sequenza per passare da un backup fatto con `backup/backup.sh` a un sistema funzionante.
Il backup contiene la home (meno le esclusioni di `backup/excludes.txt`) in `home/`
e gli elenchi dei pacchetti installati in `manifest/`.

**Non cancellare né riutilizzare il disco di backup finché il ripristino non è
verificato** e non ha vissuto qualche settimana d'uso.

## 0. Prima di formattare la macchina vecchia

- Aprire il volume da una live USB e vedere `home/`: è l'unica prova che la passphrase
  e il backup funzionano fuori dal sistema originale.
- La passphrase LUKS deve stare in un password manager che non risieda sulla macchina.
- Annotare cosa il backup **non** contiene (vedi l'ultima sezione).

## 1. Installare Fedora

Fedora Workstation oppure la spin Sway. Creare lo stesso utente. Poi aggiornare:

```sh
sudo dnf upgrade --refresh
```

Su Workstation, Sway si installa con `post-install.sh` e si sceglie dal selettore di
sessione di GDM (ingranaggio in basso a destra del login).

## 2. Montare il disco di backup

```sh
lsblk -f                                   # trovare la partizione crypto_LUKS (es. sda1)
sudo cryptsetup open /dev/sda1 backup      # chiede la passphrase
sudo mkdir -p /mnt/backup
sudo mount /dev/mapper/backup /mnt/backup
ls /mnt/backup                             # home/  manifest/  lost+found/
```

Se il disco si disconnette durante le scritture o letture lunghe, collegarlo tramite un
**hub USB alimentato**: con l'alimentazione della sola porta del portatile cadeva.
Per forzare `usb-storage` al posto di UAS si legge l'ID del disco con `lsusb`
(`VID:PID`) e si scrive
`echo 'options usb-storage quirks=VID:PID:u' | sudo tee /etc/modprobe.d/disable-uas.conf`,
poi si riconnette il disco.

## 3. Ripristinare la home

L'UID dell'utente può essere diverso da quello del backup (Ubuntu parte da 1001 se
esiste già un altro utente, Fedora dal 1000), quindi **niente `--numeric-ids`** e si
assegna la proprietà in ricezione:

```sh
rsync -aHAX --info=progress2 --chown="$USER:$USER" /mnt/backup/home/ "$HOME"/
```

Prima un'anteprima con `-n`. Non usare `--delete`.

Fedora usa SELinux: i file copiati non hanno le etichette giuste, quindi subito dopo:

```sh
restorecon -R ~
chmod 700 ~/.ssh
```

Verifiche rapide, senza modificare nulla:

```sh
ssh -T git@github.com
kubectl config get-contexts
aws sts get-caller-identity
```

## 4. Software e configurazioni

Il repo è già in `~/Progetti/dotfiles` grazie al passo precedente.

```sh
cd ~/Progetti/dotfiles
./system/post-install.sh      # repo, pacchetti dnf, flatpak, mise, servizi (usa sudo)
DRY_RUN=1 ./install.sh        # anteprima
./install.sh                  # collega le config nella home
```

`install.sh` non sovrascrive: sposta i file esistenti in `<file>.bak-<data>`. Il
ripristino della home ha riportato i vecchi `.bashrc`, `.profile`, `.gitconfig`: finiscono
in `.bak-*` e li sostituiscono i link al repo.

Poi, a mano:

- **Identità git**: copiare nome, email e `signingkey` dal vecchio `~/.gitconfig.bak-*` in
  `~/.gitconfig.local`.
- **Token GitHub**: il vecchio `.profile` lo leggeva da `~/Documenti/github_token`; ora
  il percorso è `~/.config/secrets/github_token`. Se il token è scaduto, rigenerarlo.
- **WireGuard dalla barra**: il click in waybar usa `sudo -n wg-quick`. Serve una regola
  sudoers `NOPASSWD` per `wg-quick up/down wg0`, altrimenti chiederà la password.
- **Monitor**: `swaymsg -t get_outputs`, poi regolare `kanshi/config` (scala e posizioni
  non sono mai state provate).
- **Finestre assegnate ai workspace**: controllare gli `app_id` con
  `swaymsg -t get_tree | grep -E 'app_id|class'` e correggere le regole `assign`.
- **Versioni dei linguaggi**: `mise ls` per vedere cosa è attivo e da dove.

## 5. Cosa NON è nel backup

Da rifare o riscaricare:

| Cosa | Come |
|------|------|
| Toolchain (`.nvm`, `.goenv`, `.sdkman`, `.rustup`, `uv`, `pnpm`) | `mise install` |
| Android SDK, Android Studio, IDEA | reinstallare; l'SDK si riscarica dall'IDE |
| Estensioni di Chrome | si ripristinano con la sincronizzazione dell'account Google |
| Configurazione di pgAdmin e ClickUp | rifare a mano |
| Cache, `snap/`, `.wine*`, `node_modules`, `target`, `.venv` | si rigenerano |

L'elenco di ciò che era installato è in `/mnt/backup/manifest/` (`apt-manual.txt`,
`flatpak.txt`, `npm-global.txt`, `uv-tools.txt`, `cargo.txt`, `vscode-extensions.txt`,
`crontab.txt`, `dconf.ini`). I nomi dei pacchetti apt non coincidono sempre con quelli di
dnf: servono come promemoria, non da incollare.
