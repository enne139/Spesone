# Regole di lavoro su spesone

## Commenti nel codice

Commentare **sempre tutto**. In pratica:

- ogni file, classe, metodo pubblico e campo ha un commento di documentazione
  (`///`) che dice **a cosa serve**, non cosa fa riga per riga;
- dentro i metodi, un commento `//` su ogni passaggio non ovvio: il *perche'*
  di una scelta, un vincolo di Flutter, un calcolo, un caso limite;
- i commenti sono in italiano, come il resto del progetto;
- quando il codice cambia, si aggiorna anche il commento: un commento
  sbagliato e' peggio di nessun commento.

Vale anche per i segnaposto e il codice temporaneo: va scritto cosa manca.

## Registro delle decisioni

Ogni scelta di progettazione va annotata in [DECISIONI.md](DECISIONI.md)
**con la motivazione**, nel formato gia' usato nel file (numero, data,
contesto, decisione, motivazione, alternative scartate).

Vanno registrate: struttura delle cartelle, architettura della navigazione,
gestione dello stato, scelta di un pacchetto esterno, modello dei dati,
decisioni di prodotto (cosa va in quale sezione), e qualunque cosa che fra
sei mesi farebbe chiedere "perche' e' fatto cosi'?".

Non vanno registrate le cose ovvie o leggibili dal codice.

## Modello dei dati: le persone

Le **persone non sono utenti**. Sono solo nomi (un'anagrafica locale) usati
per intestare spese condivise e debiti. Non hanno account, login, profilo.

Conseguenza: **condividere un gruppo** (wifi, bluetooth) e' una funzione
delle **spese**, non delle persone. Sta nella sezione Spese.

## Database

I dati stanno in un solo file SQLite, gestito con `drift`
([lib/core/database/app_database.dart](lib/core/database/app_database.dart)).
Le tabelle si dichiarano accanto alla funzionalita' che le usa, in
`features/<nome>/data/`, e si aggiungono all'elenco del database.

Dopo **ogni** modifica a una tabella o a un DAO:

```
dart run build_runner build
```

e, se le tabelle sono cambiate, aumentare `schemaVersion` di uno e scrivere la
migrazione in `migration`. Senza la migrazione, l'app installata non si apre
piu'.

## Comandi visibili

L'app gira su telefono **e** su computer. Nessuna azione puo' esistere solo
come gesto (scorrimento, pressione prolungata): ci deve sempre essere un
pulsante o una voce di menu che fa la stessa cosa. Voce 018 di
[DECISIONI.md](DECISIONI.md).

## Errori

Un guasto deve **vedersi**, mai diventare un caricamento infinito:

- nelle schermate si usa `VistaDati` al posto di `StreamBuilder`, che gestisce
  attesa, errore e dati;
- ogni scrittura sul database fatta da un gesto dell'utente passa da
  `eseguiSegnalandoErrori`, che mostra un messaggio se fallisce.

Non basta: **"sto leggendo" e "non c'e' niente" vanno distinti**. In uno
`StreamBuilder` il dato e' `null` in tutti e due i casi, e confonderli
trasforma ogni stato vuoto in un caricamento eterno. Quando uno stream puo'
legittimamente non dare niente, la schermata lo dice e offre cosa fare.

Il perche' e' nelle voci 017, 044 e 046 di [DECISIONI.md](DECISIONI.md).

## Denaro e transazioni

Gli importi sono **interi di centesimi**, mai `double`: le conversioni stanno
solo in `lib/core/denaro.dart` (voce 023).

Dentro una `transaction(...)` si legge solo con `get*()`: uno `Stream` o un
`.first` aspetterebbero una notifica che arriva dopo il commit, e l'operazione
resta appesa senza dare errore (voci 014 e 025).

Stessa regola fuori dalle transazioni: **mai uno stream che ne aspetta un
altro** (`asyncMap` con dentro una lettura). Se servono dati da piu' tabelle,
si scrive una query sola — join, sottoquery o `customSelect` (voce 044).

## Colori

I colori delle categorie non si scelgono a occhio: si salva l'**indice** di
una voce di `lib/core/palette_categorie.dart`, che ha un passo per tema. Prima
di toccare quella tavolozza vanno rifatti i conti su distanza percettiva
(OKLab, anche sotto daltonismo) e contrasto. Voce 040 di
[DECISIONI.md](DECISIONI.md).

## Prove

```
flutter analyze
flutter test
```

`test/supporto.dart` tiene l'avvio e la chiusura delle prove con interfaccia.
Ogni prova con interfaccia deve finire con `chiudiApp(tester)` e **non** deve
chiudere il database: il perche' e' nella voce 015 di
[DECISIONI.md](DECISIONI.md).

## Verifiche prima di consegnare

- `flutter analyze` senza segnalazioni;
- `flutter test` verde.
