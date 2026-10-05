# Registro delle decisioni

Ogni scelta di progettazione, con la motivazione. Le voci si aggiungono in
fondo e non si riscrivono: se una decisione cambia, si aggiunge una voce nuova
che dichiara quale supera.

Formato: numero, data, contesto, decisione, motivazione, alternative scartate.

---

## 001 — Struttura delle cartelle per funzionalita'

**Data:** 2026-10-05

**Contesto:** il progetto era un solo `main.dart` con quattro pagine finte.

**Decisione:** `lib/` diviso in `core/` (tema e widget riusabili),
`navigation/` (impalcatura) e `features/<funzionalita>/` (una cartella per
area: spese, lista_spesa, debiti, persone, impostazioni), una pagina per file.

**Motivazione:** gli obiettivi del README sono quattro aree indipendenti.
Tenerle in cartelle separate fa sapere dove scrivere una cosa nuova senza
rileggere il resto, e permette di lavorare su una funzionalita' senza aprire
le altre.

**Alternative scartate:** divisione per tipo tecnico (`pages/`, `widgets/`,
`models/`), che a progetto cresciuto sparge una singola funzionalita' su
quattro cartelle.

---

## 002 — Navigazione a due livelli: barra in basso + drawer

**Data:** 2026-10-05

**Contesto:** serve una barra in basso che scelga la schermata e un drawer il
cui contenuto dipenda dalla schermata attiva.

**Decisione:** due livelli dichiarati in un unico registro
([lib/navigation/sections.dart](lib/navigation/sections.dart)):
`AppSection` = voce della barra in basso, `SectionView` = voce del drawer
interna alla sezione. Il drawer riceve solo la sezione corrente e ne elenca le
viste.

**Motivazione:** la barra in basso tiene poche voci (quattro aree), il drawer
ne tiene molte. Separare i due livelli evita una barra sovraccarica e tiene le
sotto-schermate raggiungibili. Con un registro unico, aggiungere una
schermata e' una voce in una lista: niente `switch` o `if` sparsi.

**Alternative scartate:** drawer con lo stesso contenuto su tutte le sezioni
(duplica la barra in basso e non scala); navigazione con rotte nominate
(`Navigator.pushNamed`), rimandata a quando servira' il deep linking.

---

## 003 — Stato della navigazione: una vista attiva per sezione

**Data:** 2026-10-05

**Contesto:** tornando su una sezione, cosa si vede?

**Decisione:** [AppShell](lib/navigation/app_shell.dart) tiene un indice di
vista **per ogni sezione**, e il corpo e' un `IndexedStack` annidato
(sezioni x viste).

**Motivazione:** chi lascia "Spese > Grafico" per guardare la lista si aspetta
di ritrovare il grafico al ritorno, non la panoramica. L'`IndexedStack`
mantiene vivo lo stato delle pagine aperte (scroll, testo digitato, filtri)
invece di ricostruirle a ogni passaggio.

**Alternative scartate:** ricostruire la pagina a ogni cambio (perde scroll e
input a meta'); un `Navigator` annidato per sezione, piu' potente ma troppo
per ora.

**Da rivedere quando:** le pagine diventeranno pesanti — l'`IndexedStack`
costruisce tutte le viste in anticipo.

---

## 004 — Material 3 e `NavigationBar` al posto di una barra fatta a mano

**Data:** 2026-10-05

**Contesto:** la bozza usava un `Container` rosso con una `Row` di
`IconButton`.

**Decisione:** `NavigationBar` e `NavigationDrawer` di Material 3, con tema
generato da un seed verde in [lib/core/app_theme.dart](lib/core/app_theme.dart),
in versione chiara e scura.

**Motivazione:** i widget di sistema danno gratis indicatore di selezione,
etichette, area di tocco corretta, accessibilita' e tema scuro — tutte cose
che a mano vanno riscritte e dimenticate. Il seed unico fa si' che i colori
restino coerenti anche aggiungendo schermate.

**Alternative scartate:** barra personalizzata (da rifare a ogni requisito
nuovo); `BottomNavigationBar` di Material 2 (in via di sostituzione).

---

## 005 — Le persone sono nomi, non utenti

**Data:** 2026-10-05

**Contesto:** il README prevede "creazione di persone condivise tra debiti e
spese" e anche "condividere un gruppo via wifi / bluetooth". Le due cose
sembrano la stessa, ma non lo sono.

**Decisione:** una **persona** e' solo un nome in un'anagrafica locale, usata
per intestare spese condivise e debiti: nessun account, login o profilo.
Di conseguenza **condividere un gruppo di spesa sta nella sezione Spese**, non
in Persone: la pagina e' stata spostata in
[lib/features/spese/condivisione_gruppo_page.dart](lib/features/spese/condivisione_gruppo_page.dart).

**Motivazione:** cio' che si condivide e' il **gruppo di spesa** (le sue spese,
i suoi partecipanti), non la rubrica. Mettere la condivisione sotto Persone
suggerirebbe che una persona sia un account da invitare, e porterebbe a un
modello dei dati sbagliato: identita', autenticazione, sincronizzazione per
utente. Con le persone come semplici nomi, l'app resta locale e il
dispositivo che condivide passa l'intero gruppo.

**Conseguenze:** la sezione Spese ha ora cinque viste (Panoramica, Gruppi,
Categorie, Grafico, Condivisione gruppo); Persone ne ha una sola, e crescera'
con la gestione dell'anagrafica.

---

## 006 — Commentare tutto e tenere questo registro

**Data:** 2026-10-05

**Contesto:** richiesta esplicita all'inizio del lavoro.

**Decisione:** le regole stanno in [CLAUDE.md](CLAUDE.md): commento di
documentazione su ogni file, classe e metodo pubblico, commenti sul *perche'*
dentro i metodi, e una voce qui per ogni scelta di progettazione.

**Motivazione:** il progetto cresce a sessioni distanti fra loro. Senza
motivazioni scritte, una scelta ponderata diventa indistinguibile da un caso,
e si finisce per rifarla o per ribaltarla senza sapere cosa si rompe.

---

## 007 — SQLite con drift come archivio, da subito

**Data:** 2026-10-05

**Contesto:** la lista della spesa e' la prima funzionalita' che deve salvare
dati. Alternative valutate: tutto in memoria con salvataggio dopo,
`shared_preferences` con JSON, oppure un database vero.

**Decisione:** SQLite tramite `drift` (`drift_flutter` per l'apertura del
file), con generazione di codice via `build_runner`. Un solo file di database
per tutta l'app: [lib/core/database/app_database.dart](lib/core/database/app_database.dart).
Le tabelle stanno accanto alla funzionalita' che le usa
(`features/<nome>/data/`), il database dichiara solo quali includere.

**Motivazione:** scelta dell'autore del progetto. Regge cio' che il README
chiede piu' avanti — gruppi, spese, debiti, calcoli per i grafici — senza
dover rifare l'archivio a metrica strada; i tipi delle colonne sono
controllati a compilazione; le letture sono `Stream`, quindi le schermate si
aggiornano da sole dopo ogni scrittura.

**Conseguenze:** dopo ogni modifica alle tabelle va rilanciato
`dart run build_runner build`, e `schemaVersion` va aumentato con la
migrazione corrispondente.

**Alternative scartate:** `shared_preferences` (nessuna query, si ricarica
tutto ogni volta: stretto gia' con i debiti); dati solo in memoria (lavoro da
rifare subito dopo).

---

## 008 — Le liste della spesa sono indipendenti dalle spese

**Data:** 2026-10-05

**Contesto:** la lista della spesa potrebbe appartenere a un gruppo di spesa,
o vivere da se'.

**Decisione:** scelta dell'autore del progetto: nessun legame. Una lista non
ha gruppo, non ha partecipanti e non diventa una spesa registrata.

**Motivazione:** nel README "Lista della spesa" e' un obiettivo separato da
"Traccia spesa". Tenerle separate permette di usare la lista senza aver prima
creato un gruppo, ed e' il caso d'uso piu' frequente: si scrive cosa serve e
si spunta al supermercato.

**Conseguenze:** la tabella `liste` non ha riferimenti ad altre tabelle. Se un
giorno servisse il passaggio "lista finita -> spesa registrata", si aggiunge
un collegamento allora, con una voce nuova in questo registro.

---

## 009 — Una voce ha nome, quantita' e note

**Data:** 2026-10-05

**Contesto:** quanti e quali campi far compilare per ogni cosa da comprare.

**Decisione:** scelta dell'autore del progetto: tre campi, di cui due
facoltativi. La quantita' e' **testo libero** ("2 kg", "una confezione", "3"),
non un numero con unita' di misura. Nessun prezzo.

**Motivazione:** sono i dati che si conoscono mentre si scrive la lista, prima
di entrare al supermercato. Il prezzo si scopre alla cassa e appartiene alla
spesa registrata, non alla lista. Un elenco di unita' di misura da mantenere
non aggiungerebbe nulla: al supermercato si ragiona in pezzi, peso o
confezioni indifferentemente.

**Da rivedere quando:** servisse sommare le quantita' (es. totali per
prodotto): allora il testo libero non basta piu'.

---

## 010 — Il database si raggiunge con un InheritedWidget

**Data:** 2026-10-05

**Contesto:** le schermate devono leggere e scrivere sul database senza che
venga passato di widget in widget, e senza aggiungere un pacchetto per la
gestione dello stato.

**Decisione:** [DatabaseScope](lib/core/database/database_scope.dart), un
`InheritedWidget` messo dalla radice dell'app;
`DatabaseScope.of(context)` lo restituisce. Lo stato delle schermate e' gia'
nei `Stream` di drift, letti con `StreamBuilder`.

**Motivazione:** drift notifica da solo chi legge dopo ogni scrittura, quindi
non serve un secondo meccanismo (provider, Riverpod, BLoC) che faccia la
stessa cosa. L'`InheritedWidget` e' Flutter puro: zero dipendenze, e nei test
si inserisce un database in memoria sopra l'albero senza che le schermate
sappiano da dove arriva.

**Alternative scartate:** una variabile globale (non sostituibile nei test);
un pacchetto di gestione dello stato (altra dipendenza, nessun vantaggio
finche' le letture sono stream del database).

---

## 011 — La lista su cui lavorare si scegle dal menu laterale

**Data:** 2026-10-05

**Contesto:** le liste sono tante. Serve scegliere su quale lavorare, crearne,
archiviarle, eliminarle e rivedere quelle archiviate.

**Decisione:** richiesta dell'autore del progetto. Il menu laterale della
sezione Lista mostra, sopra alle viste, l'elenco delle liste attive
([SelettoreListe](lib/features/lista_spesa/widgets/selettore_liste.dart)): si
tocca una lista per lavorarci, "Nuova lista" per crearne una, e il menu di
ogni riga rinomina, archivia o elimina. Le archiviate hanno una vista propria,
da cui si ripristinano.

Archiviare ed eliminare restano due cose diverse: archiviare toglie la lista
dal menu ma la conserva (annullabile dal messaggio che compare), eliminare
cancella anche le voci e chiede conferma.

**Motivazione:** la scelta della lista accompagna tutte le viste della
sezione, quindi sta nel menu e non in una schermata: si cambia lista restando
dove si era. Due azioni separate perche' una spesa finita e' qualcosa che si
vuole togliere di mezzo ma spesso rivedere, mentre la cancellazione serve solo
per le liste create per sbaglio.

**Conseguenze:** il flag `corrente` sulla tabella `liste` indica la lista
aperta; esiste sempre una lista corrente, e archiviare o eliminare quella in
uso fa passare il lavoro alla piu' recente fra le altre (creandone una se non
ne resta nessuna).

---

## 012 — Le voci prese scendono in fondo e restano visibili

**Data:** 2026-10-05

**Contesto:** cosa fare di una voce appena spuntata.

**Decisione:** richiesta dell'autore del progetto: la voce scende in fondo
alla lista, sotto l'intestazione "Nel carrello", barrata e sbiadita ma
leggibile. L'ordinamento e' nella query
([ListeDao.osservaVoci](lib/features/lista_spesa/data/liste_dao.dart)), non
nella schermata.

**Motivazione:** mentre si fa la spesa serve sapere sia cosa manca sia cosa si
e' gia' preso (per non comprarlo due volte, e per controllare alla cassa).
Farle sparire perderebbe la seconda informazione. In fondo invece di in mezzo
perche' la parte alta dello schermo deve mostrare cosa resta da fare.

**Conseguenze:** le liste lunghe accumulano voci prese; per questo la barra ha
il pulsante "Rimuovi le voci prese", che chiede conferma.

---

## 013 — Titolo, azioni e pulsante flottante li fornisce la vista

**Data:** 2026-10-05

**Contesto:** la AppBar e il pulsante flottante appartengono allo `Scaffold`
dello shell, ma il loro contenuto dipende dalla vista aperta: il titolo della
vista "Lista corrente" e' il nome della lista, e serve un pulsante per
aggiungere una voce.

**Decisione:** [SectionView](lib/navigation/app_section.dart) ha tre campi
facoltativi in piu' — `appBarTitle`, `actions`, `floatingActionButton` — che
lo shell costruisce al posto dei propri. I widget che ne derivano leggono da
soli la lista corrente dal database
([ListaCorrenteBuilder](lib/features/lista_spesa/widgets/lista_corrente_builder.dart)).

**Motivazione:** cosi' barra e pagina non si scambiano stato: nessun callback
dalla pagina verso lo shell, nessun `setState` durante la costruzione della
AppBar. Chi deve agire sulla lista aperta la chiede al database, che e' l'unica
fonte di verita'.

**Alternative scartate:** una `AppBar` dentro ogni pagina (due barre
sovrapposte, e il pulsante del menu andrebbe ricollegato a mano); un notifier
che la pagina riempie durante il build (marcherebbe la AppBar come da
ricostruire mentre si costruisce, errore a runtime).

---

## 014 — Le transazioni non si annidano

**Data:** 2026-10-05

**Contesto:** `archiviaLista` e `eliminaLista` devono, nella stessa
operazione, cambiare una lista e rimettere a posto quale e' la lista corrente.
La prima stesura riusava il metodo pubblico `assicuraListaCorrente()`, che
apre una transazione per conto proprio.

**Decisione:** i metodi pubblici del DAO aprono la transazione; le parti
riusabili sono metodi privati (`_apri`, `_garantisciCorrente`) che
presuppongono di essere gia' dentro una transazione.

**Motivazione:** una `transaction` aperta dentro un'altra aspetta il proprio
turno su una coda che non si libera, e l'operazione che la contiene resta
appesa per sempre. Il sintomo non e' un errore ma un'azione che non succede:
nel caso reale, "Archivia" dal menu non faceva niente.

**Come accorgersene:** se un'azione non ha effetto e non compare nessun
errore, cercare una `transaction` chiamata dentro un'altra.

---

## 015 — Prove con interfaccia: smontare dentro il test, non chiudere il database

**Data:** 2026-10-05

**Contesto:** le prove con interfaccia (`testWidgets`) avviano l'app vera con
un database SQLite in memoria. Due comportamenti bloccavano le prove.

**Decisione:** [test/supporto.dart](test/supporto.dart) raccoglie l'avvio e la
chiusura delle prove. Ogni prova con interfaccia finisce con `chiudiApp`, che
smonta l'albero **dentro** il test; il database non si chiude.

**Motivazione:** cancellare gli abbonamenti ai `Stream` di drift mette in coda
un timer a durata zero. Se l'albero viene smontato dal framework dopo la fine
del test, quel timer risulta pendente e la prova fallisce con "Pending
timers". E `close()` attende una coda che l'orologio finto di `testWidgets`
non fa avanzare: il test resta appeso senza errori ne' output. Il database in
memoria muore comunque con il processo, quindi non chiuderlo non lascia
niente in giro. Nelle prove senza interfaccia (`test/liste_dao_test.dart`)
l'orologio e' quello vero e `close()` va chiamata normalmente.

---

## 016 — Ordinamenti sempre deterministici

**Data:** 2026-10-05

**Contesto:** l'elenco delle liste nel menu era ordinato per data di
creazione. Due liste create nello stesso secondo comparivano in ordine
casuale, e una prova archiviava la lista sbagliata.

**Decisione:** ogni `ORDER BY` ha un criterio finale che non ammette
pareggi — l'id. Vale per l'elenco delle liste e per le voci di una lista.

**Motivazione:** le date salvate da SQLite hanno risoluzione al secondo,
quindi "per data" non e' un ordine totale: a parita' di data l'ordine e'
quello che capita, e puo' cambiare fra due letture. Un elenco che si riordina
da solo sotto le dita e' un difetto visibile, e rende le prove inaffidabili.

---

## 017 — Un guasto si vede, non diventa un'attesa

**Data:** 2026-10-05

**Contesto:** segnalazione dall'uso reale: "continua a caricare, non mostra
liste e non fa creare liste". Le schermate controllavano solo se i dati erano
arrivati (`snapshot.data == null`) e mostravano la rotella di caricamento in
tutti gli altri casi; la creazione della prima lista era una chiamata lasciata
a se stessa (`unawaited`). Risultato: **qualunque** errore del database — file
bloccato da un'altra istanza dell'app, disco pieno, permessi — si presentava
come un caricamento infinito, un menu senza liste e pulsanti che non facevano
niente. Nessun messaggio, da nessuna parte.

**Decisione:** tre pezzi riusabili, e nessuna eccezione alla regola.

- [VistaDati](lib/core/widgets/vista_dati.dart): sostituisce `StreamBuilder`
  nelle schermate e tratta tutti e tre gli stati — attesa, errore, dati.
- [ErroreView](lib/core/widgets/errore_view.dart): prende il posto della
  schermata, dice cos'e' successo e offre "Riprova".
- [eseguiSegnalandoErrori](lib/core/errori.dart): avvolge ogni **scrittura**
  fatta da un gesto dell'utente e, se fallisce, lo dice con un messaggio.

Dove il risultato serve (il conteggio di "rimuovi voci prese") l'errore si
gestisce sul posto, ma si gestisce.

**Motivazione:** un'attesa infinita e' il peggior modo di fallire: non dice
cosa e' andato storto, non dice se aspettare, e fa sembrare rotta l'app anche
quando il problema e' fuori (un'altra finestra aperta sullo stesso database).
Un messaggio, anche tecnico, permette a chi lo legge di agire.

**Regola che ne deriva:** nessun `StreamBuilder` scritto a mano nelle
schermate, e nessuna scrittura sul database senza gestione dell'errore. Se
un'operazione non puo' fallire visibilmente, va spiegato nel commento perche'.

---

## 018 — Ogni azione ha un comando visibile, non solo un gesto

**Data:** 2026-10-05

**Contesto:** domanda dall'uso reale: "come rimuovo le cose della lista?".
Eliminare una voce si poteva fare solo scorrendo la riga verso sinistra.

**Decisione:** ogni riga della lista ha un menu (⋮) con **Modifica** ed
**Elimina**. Lo scorrimento resta, come scorciatoia per chi usa il telefono.

**Motivazione:** l'app gira anche su computer, dove non esiste il gesto dello
scorrimento: col mouse si puo' trascinare, ma nessuno lo indovina, e una
funzione che non si trova e' una funzione che non c'e'. Il gesto va bene come
scorciatoia, mai come unico modo di fare una cosa.

**Regola che ne deriva:** prima di affidare un'azione a un gesto
(scorrimento, pressione prolungata, trascinamento), ci deve essere un comando
visibile che fa la stessa cosa.

---

## 019 — Identita' dell'app: nome, pacchetto, icona

**Data:** 2026-10-05

**Contesto:** il progetto nasceva con i segnaposto di Flutter (`spesone`,
`com.example.spesone`, icona predefinita) e va pubblicato.

**Decisione:** richiesta dell'autore del progetto. Nome **Spesone**,
identificativo del pacchetto **`spesone.maratuck.com`** su tutte le
piattaforme, icona a carrello scuro su fondo giallo (`#FFC400`), disegnata in
SVG in `assets/icona/` e rigenerata con `tool/genera_icone.sh`.

**Motivazione:** il carrello e' lo stesso simbolo che la barra in basso usa
per la sezione Lista, quindi icona e app parlano la stessa lingua; su Android
l'icona e' adattiva, cosi' ogni telefono la ritaglia nella forma che usa. Gli
SVG restano la sorgente: i PNG non si modificano a mano.

**Nota sulla convenzione:** gli identificativi di pacchetto si scrivono di
solito al contrario, dal dominio al nome (`com.maratuck.spesone`);
`spesone.maratuck.com` e' valido e funziona, ma e' l'ordine inverso di quello
abituale. Cambiarlo dopo la prima pubblicazione obbliga chi ha gia' installato
l'app a disinstallarla e reinstallarla, perche' per Android sarebbe un'altra
app: se va cambiato, va fatto prima della prima release.

---

## 020 — Distribuzione con GitHub Releases e Obtainium

**Data:** 2026-10-05

**Contesto:** l'app va installata e aggiornata sul telefono senza passare da
uno store.

**Decisione:** richiesta dell'autore del progetto.
[.github/workflows/apk.yml](.github/workflows/apk.yml) si avvia sui tag `v*`,
analizza il codice, lancia le prove, costruisce **un solo APK** per tutte le
architetture e crea la release con l'APK allegato. Obtainium segue il
repository e propone l'aggiornamento a ogni release.

La firma usa una chiave propria, presa dai segreti del repository; se i
segreti mancano il flusso costruisce lo stesso ma **avvisa**.

**Motivazione:** la firma e' il punto critico. Android identifica un'app dalla
coppia pacchetto + chiave: se ogni release fosse firmata con la chiave di
debug del runner, che e' diversa ogni volta, l'aggiornamento verrebbe rifiutato
e Obtainium resterebbe fermo alla prima versione. L'APK unico evita invece di
far scegliere l'architettura a chi installa.

Il numero di build e' `github.run_number`, che cresce a ogni esecuzione:
Android si accorge che c'e' un aggiornamento solo se quel numero sale.

**Conseguenze:** l'archivio `spesone.jks` va conservato fuori dal repository e
non va perso: senza, l'app installata non si puo' piu' aggiornare. Le
istruzioni sono nel [README](README.md).

---

## 021 — Icona: libro blu con carrello giallo

**Data:** 2026-10-05

**Contesto:** richiesta dell'autore del progetto. Supera la parte sull'icona
della voce 019, che descriveva un carrello scuro su fondo giallo.

**Decisione:** un libro visto di fronte, copertina blu, con il carrello giallo
al centro. Tre blu distinti — fondo blu notte, copertina, dorso — e le pagine
chiare che sporgono a destra.

**Motivazione:** il libro dice "lista, qualcosa che si scrive e si tiene", il
carrello dice "spesa": insieme raccontano l'app meglio del solo carrello. I
tre blu servono alla leggibilita': a 48 pixel un libro tutto dello stesso blu
diventa un rettangolo qualunque, e sono il dorso scuro e le pagine chiare a
farlo riconoscere come libro.

**Conseguenze:** cambia anche il colore di fondo dell'icona adattiva Android e
quello della pagina web (`#0A2050`). Il carrello giallo resta lo stesso
simbolo della sezione Lista nella barra in basso.

---

## 022 — I debiti sono un registro di movimenti, non voci da saldare

**Data:** 2026-10-05

**Contesto:** come rappresentare un debito e cosa succede quando viene
ripagato.

**Decisione:** scelta dell'autore del progetto. Ogni riga e' un **movimento**
con un importo **con segno**: positivo se quella persona deve a te, negativo
se tu devi a lei. Il saldo verso una persona e' la somma dei suoi movimenti.
Non esiste uno stato "saldato": restituire dei soldi aggiunge la riga opposta,
e "Salda il conto" e' solo la scorciatoia che aggiunge il movimento che porta
il saldo a zero.

Di un movimento si registrano persona, importo, motivo (facoltativo) e data.

**Motivazione:** il saldo diventa una somma, non una somma condizionata: meno
occasioni di sbagliare il conto, e la compensazione fra dare e avere e'
automatica — se Marco ti deve 20 e tu devi 5 a Marco, c'e' una riga sola da
+15. E' il "calcolo intelligente" chiesto nel README. Lo storico resta sempre
completo: niente sparisce, nemmeno quando il conto si chiude.

**Conseguenze:** un singolo prestito non si puo' marcare come "restituito"
senza registrare il movimento di ritorno — ed e' giusto cosi', perche' quel
movimento e' successo davvero. I pagamenti parziali sono semplicemente
movimenti piu' piccoli.

---

## 023 — Gli importi si tengono in centesimi interi

**Data:** 2026-10-05

**Contesto:** come salvare e calcolare il denaro.

**Decisione:** `int` di centesimi in tutto il programma. Le uniche conversioni
da e verso il testo stanno in [lib/core/denaro.dart](lib/core/denaro.dart), e
l'arrotondamento avviene una volta sola, quando si legge cio' che l'utente ha
scritto.

**Motivazione:** un `double` non rappresenta esattamente 0,10. Sommando
abbastanza importi il totale si sposta di qualche centesimo, e su un conto fra
persone un centesimo che non torna e' una discussione. Con gli interi la somma
e' esatta per definizione.

**Conseguenze:** niente valute diverse dall'euro per ora; aggiungerle
significherebbe affiancare un campo valuta e decidere come si sommano saldi in
valute diverse (cioe' non si sommano).

---

## 024 — L'app parla italiano anche nei widget di sistema

**Data:** 2026-10-05

**Contesto:** il modulo di un movimento usa il calendario di Material, che
senza traduzioni resta in inglese.

**Decisione:** `flutter_localizations` con `locale: it`, dichiarato in
[lib/app.dart](lib/app.dart).

**Motivazione:** mesi e pulsanti in inglese in mezzo a un'app italiana sono una
crepa visibile, e il formato delle date cambia significato fra lingue
(05/10 non e' il 10 maggio).

**Conseguenza sulle prove — importante:** le etichette dei widget di sistema
ora sono tradotte, quindi **le prove non possono cercarli per etichetta**. Il
pulsante del menu laterale si apre chiedendolo allo `Scaffold`
(`apriDrawer` in [test/supporto.dart](test/supporto.dart)), non toccando un
pulsante trovato per nome.

---

## 025 — Niente stream dentro una transazione

**Data:** 2026-10-05

**Contesto:** "Salda il conto" leggeva il saldo con `osservaSaldo(...).first`
dentro la transazione che poi scriveva il movimento di chiusura. Nelle prove
dirette funzionava, nell'app restava appeso e il conto non si saldava.

**Decisione:** dentro una transazione si leggono i dati con una query secca
(`getSingleOrNull`), mai con uno `Stream`.

**Motivazione:** uno stream di drift emette quando il database notifica un
cambiamento, e la notifica arriva solo *dopo* il commit: aspettarlo dentro la
transazione significa aspettare qualcosa che per definizione non puo'
succedere. E' lo stesso inganno delle transazioni annidate (voce 014), e come
quello non da' errore: l'operazione semplicemente non finisce.

**Regola che ne deriva:** dentro `transaction(...)` solo `get*()`, mai
`watch*()` ne' `.first` su uno stream.

---

## 026 — Ogni spesa vive in un gruppo

**Data:** 2026-10-05

**Contesto:** l'app deve servire a segnare le spese di un viaggio o di una
casa condivisa, con le proprie spese e quelle pagate per altri.

**Decisione:** il **gruppo** e' il contesto di tutto: ha un nome, dei
partecipanti presi dall'anagrafica e le sue voci. Non esistono spese fuori da
un gruppo. Quello su cui si lavora si sceglie dal menu laterale della sezione
Spese, e si archivia quando il viaggio finisce — le stesse azioni, negli
stessi posti, della lista della spesa (voce 011).

**Motivazione:** le domande a cui l'app deve rispondere ("quanto ho speso",
"chi deve a chi") hanno senso solo dentro un perimetro: il viaggio, la casa,
il mese. Senza gruppo quelle risposte sarebbero somme di cose non confrontabili.
Riusare la forma della lista della spesa fa si' che la seconda funzionalita'
non vada imparata da capo.

---

## 027 — Parti uguali, correggibili a mano

**Data:** 2026-10-05

**Contesto:** come si divide una spesa pagata per piu' persone.

**Decisione:** scelta dell'autore del progetto. Le quote partono divise in
parti uguali fra i partecipanti scelti e si possono correggere una per una; il
resto si ridistribuisce fra le altre, cosi' la somma delle quote e' **sempre**
uguale al totale. Niente percentuali, niente "quote doppie".

**Motivazione:** in un viaggio quasi tutto si divide in parti uguali, quindi
quello dev'essere il caso da zero tocchi; le eccezioni esistono pero' davvero
(chi non ha preso il dolce, la camera singola) e un'app che non le accetta
costringe a tenere i conti a parte. Le percentuali sarebbero un terzo modo di
dire la stessa cosa, con una schermata piu' complicata per tutti.

**Conseguenza:** il vincolo "somma delle quote = totale" e' la regola che
tiene in piedi i saldi, e va verificata nelle prove.

---

## 028 — I saldi dei gruppi e i debiti a mano restano separati

**Data:** 2026-10-05

**Contesto:** una spesa condivisa crea un dare/avere, e un dare/avere esiste
gia' nella sezione Debiti (voce 022). Si potevano unire.

**Decisione:** scelta esplicita dell'autore del progetto: **completamente
separati**. Un gruppo calcola i propri saldi dalle proprie voci; la sezione
Debiti resta per i prestiti segnati a mano. Nessuna generazione automatica,
nessun travaso alla chiusura del gruppo.

**Motivazione:** le voci di un gruppo e i prestiti sciolti rispondono a due
domande diverse — "come stiamo messi in questo viaggio" e "quanto ci dobbiamo
in generale" — e tenerli separati evita che modificare una spesa riscriva
movimenti altrove, che e' la parte piu' facile da sbagliare.

**Conseguenza, accettata:** "quanto mi deve Marco in tutto" non ha una
risposta unica nell'app: si guardano i saldi del gruppo e i debiti, e si
somma a mente. Se un giorno dara' fastidio, la voce da superare e' questa.

---

## 029 — "Io" e' una persona dell'anagrafica

**Data:** 2026-10-05

**Contesto:** una spesa ha bisogno di sapere chi ha pagato, e fra i
partecipanti ci sei anche tu; anche i debiti parlano implicitamente di "me".

**Decisione:** l'anagrafica contiene una persona segnata come **sei tu**,
creata al primo avvio e rinominabile ma non eliminabile. Nei moduli compare
come qualunque altro partecipante.

**Motivazione:** cosi' "chi ha pagato" e "per chi" sono un elenco solo, senza
casi speciali: le quote, i saldi e i totali si calcolano con la stessa
formula per tutti, e "quanto ho speso io" diventa "la somma delle quote di
quella persona". Un "io" implicito avrebbe richiesto di trattarlo a parte in
ogni calcolo.

---

## 030 — Dentro un gruppo ci sono spese e rimborsi

**Data:** 2026-10-05

**Contesto:** se i saldi di un gruppo nascono solo dalle spese, non tornano
mai a zero: manca il momento in cui qualcuno restituisce i soldi.

**Decisione:** un gruppo contiene due tipi di voce. La **spesa** (chi ha
pagato, per chi, quote) e il **rimborso** (da una persona a un'altra, un
importo). Il rimborso sposta i saldi ma non entra in "quanto ho speso".

**Motivazione:** segue necessariamente dalla voce 028: se i saldi del gruppo
non si travasano nei debiti, il gruppo deve avere al proprio interno il modo
di chiudersi. Tenere separati i due tipi evita che un rimborso gonfi il totale
del viaggio, che e' l'errore classico di chi li registra come spese.
