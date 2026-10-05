# spesone

## Caratteristiche 
Compatibile con apple, android, web

## Obbiettivi 

 - [x] Traccia debiti
 - [x] Lista della spesa
 - [ ] Traccia spesa — i paletti sono in [docs/gruppi_di_spesa.md](docs/gruppi_di_spesa.md)
    - [x] creare più Gruppi di spesa
    - [ ] condividere gruppo via wifi (backend)
    - [ ] condividere gruppo via bt
    - [x] aggiungere spese singole 
    - [x] aggiungere spese condivise
    - [x] categoria spesa e data
    - [ ] grafico spese
    - [x] calcolo dei debiti intelligente
 - [x] creazione di persone (anagrafica dei debiti; i gruppi di spesa hanno i propri partecipanti, scritti a mano)


## L'app

- **Nome:** Spesone
- **Pacchetto Android:** `spesone.maratuck.com`
- **Piattaforme:** Android, iOS, web, Linux, Windows, macOS

Il codice e' diviso per funzionalita' in `lib/features/`, la navigazione sta in
`lib/navigation/`, i dati in SQLite tramite drift. Le regole di lavoro sono in
[CLAUDE.md](CLAUDE.md), il perche' di ogni scelta in [DECISIONI.md](DECISIONI.md).

## Installazione su Android con Obtainium

[Obtainium](https://github.com/ImranR98/Obtainium) installa e aggiorna l'app
direttamente da questo repository, senza passare da uno store.

1. Installa Obtainium.
2. **Aggiungi app** e incolla l'indirizzo di questo repository.
3. Obtainium trova l'ultima release, installa `Spesone-vX.Y.Z.apk` e da li' in
   avanti avvisa a ogni versione nuova.

L'APK e' unico per tutte le architetture, quindi non c'e' niente da scegliere.

## Pubblicare una versione

```sh
git tag v1.0.0
git push origin v1.0.0
```

Il flusso [.github/workflows/apk.yml](.github/workflows/apk.yml) analizza il
codice, lancia le prove, costruisce l'APK e crea la release con l'APK allegato.
Dalla scheda **Actions** si puo' anche lanciare a mano: in quel caso l'APK
resta fra gli artefatti dell'esecuzione e non viene pubblicata nessuna release.

### Chiave di firma (una volta sola)

Senza una chiave propria l'APK viene firmato con quella di debug, che su ogni
macchina e' diversa: Android rifiuta l'aggiornamento con "firma non
corrispondente" e Obtainium si blocca alla prima versione nuova.

```sh
keytool -genkey -v -keystore spesone.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias spesone
base64 -w0 spesone.jks     # il testo da incollare nel segreto
```

Su GitHub, **Settings - Secrets and variables - Actions**, aggiungi:

| Segreto | Contenuto |
| --- | --- |
| `ANDROID_KEYSTORE_BASE64` | l'uscita di `base64 -w0 spesone.jks` |
| `ANDROID_KEYSTORE_PASSWORD` | la password dell'archivio |
| `ANDROID_KEY_ALIAS` | `spesone` |
| `ANDROID_KEY_PASSWORD` | la password della chiave |

Conserva `spesone.jks` **fuori** dal repository e non perderlo: senza quella
chiave non si puo' piu' aggiornare l'app gia' installata.

Per compilare una release firmata sul proprio computer, crea
`android/key.properties` (ignorato da git):

```properties
storeFile=/percorso/assoluto/spesone.jks
storePassword=...
keyAlias=spesone
keyPassword=...
```

## Sviluppo

```sh
flutter pub get
dart run build_runner build   # dopo ogni modifica alle tabelle drift
flutter run
flutter analyze && flutter test
```

L'icona si modifica negli SVG in `assets/icona/` e si rigenera con
`tool/genera_icone.sh`.
