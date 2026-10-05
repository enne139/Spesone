# Gruppi di spesa — cosa fanno e cosa non fanno

Documento di riferimento per la funzionalita' "Traccia spesa" del
[README](../README.md). Le motivazioni delle scelte stanno in
[DECISIONI.md](../DECISIONI.md), voci 026-030.

## A cosa serve

Segnare le spese di un viaggio, di una casa condivisa o di qualunque cosa che
duri nel tempo e coinvolga piu' persone, e sapere due cose:

1. **quanto ho speso io**, in tutto;
2. **chi deve dare quanto a chi**, quando qualcuno paga per gli altri.

## Il modello

### Gruppo

Un gruppo e' il contesto di tutto: "Grecia 2026", "Casa di via Verdi". Ha un
nome, un elenco di **partecipanti** e le sue voci.

I partecipanti sono **propri del gruppo** e si scrivono a mano: non arrivano
dall'anagrafica dei debiti, che e' un'altra cosa e vive dentro i Debiti. Ogni
gruppo nasce con un partecipante che sei tu. Un gruppo si archivia quando il viaggio finisce, come si archivia
una lista della spesa.

Ogni spesa appartiene a un gruppo: non esistono spese "sciolte". Il gruppo su
cui si lavora si sceglie dal menu laterale della sezione Spese, esattamente
come la lista della spesa.

### Due tipi di spesa

Una spesa e' **normale** o **condivisa**, e sono due cose diverse fin dal
modulo con cui si registrano.

#### Spesa normale

Una spesa tua e basta: il biglietto del museo, il caffe'.

| Campo | |
| --- | --- |
| Descrizione | "Biglietto del museo" |
| Importo e valuta | quanto hai pagato |
| Data | |
| Categoria | facoltativa |

Non chiede chi ha pagato — sei tu — ne' per chi. Entra nel totale del viaggio
e in "quanto ho speso io", **non tocca i saldi** e non esce dal tuo
dispositivo.

#### Spesa condivisa

Una spesa che riguarda piu' persone: la cena, la benzina, la casa.

| Campo | |
| --- | --- |
| Descrizione | "Cena al ristorante" |
| Importo e valuta | totale pagato |
| Chi ha pagato | **un** partecipante |
| Per chi | uno o piu' partecipanti, con la **quota** di ciascuno |
| Data | |
| Categoria | facoltativa |

Le quote partono **divise in parti uguali** fra i partecipanti scelti e si
possono correggere a mano: chi non ha preso il dolce, chi ha dormito in camera
singola. La somma delle quote e' sempre uguale al totale — correggendo una
quota, il resto si ridistribuisce fra le altre.

Nel totale del viaggio entra tutta; in "quanto ho speso io" entra **solo la
tua quota**.

### Categorie

Le categorie sono un elenco **unico per tutta l'app**, non una cosa per
gruppo: "Cibo", "Alloggio", "Trasporti", "Svago", "Altro" valgono in Grecia
come nella casa di via Verdi. Ognuna ha un nome e un colore, quello con cui
comparira' nel grafico. I colori sono sei, scelti calcolando le distanze
percettive fra tutte le coppie anche sotto daltonismo (DECISIONI.md, voce
040); il nome del colore e' sempre scritto accanto al tondino.

Si possono aggiungere, rinominare, ricolorare ed eliminare. Eliminando una
categoria le spese che la usavano restano **senza categoria**: non si
cancella niente.

La categoria di una spesa e' facoltativa — chiederla come obbligatoria
rallenterebbe l'inserimento, che e' la cosa che si fa cento volte.

### Valute

Un gruppo ha una **valuta principale** (di solito l'euro): e' quella in cui
sono espressi il totale del viaggio, quanto hai speso tu e tutti i saldi.

Nelle **impostazioni del viaggio** si elencano le altre valute usate, ognuna
con il suo **tasso di cambio fisso**: "in questo viaggio 1 USD = 0,92 €".

Il tasso e' **congelato**: non si aggiorna da solo e non cambia da un giorno
all'altro: vale per tutto il viaggio. Si scrive a mano e si puo' correggere a
mano quando serve.

Una spesa si registra **nella valuta in cui si e' pagato**, e l'app la
converte con il tasso del gruppo. La conversione avviene una volta sola per
spesa, e le quote convertite sommano sempre al totale convertito: i saldi
restano esatti al centesimo.

> **Attenzione:** correggere un tasso ricalcola **tutto il viaggio**, anche le
> spese gia' registrate. E' il prezzo di avere un cambio solo per viaggio
> invece di uno per spesa, e di solito e' quello che si vuole: si sistema il
> tasso una volta e i conti tornano tutti.

### Rimborso

Quando qualcuno restituisce dei soldi, si registra un **rimborso**: da una
persona a un'altra, un importo, una data. Non e' una spesa — non entra in
"quanto ho speso" — ma sposta i saldi.

Senza i rimborsi un gruppo non si potrebbe mai chiudere, perche' i saldi
nascono dalle spese e niente li riporterebbe a zero.

### Saldi

Per ogni partecipante:

```
saldo = (quanto ha anticipato) - (somma delle sue quote) + (rimborsi ricevuti e dati)
```

Positivo: ha messo piu' del dovuto, deve ricevere. Negativo: deve dare.
La somma dei saldi di un gruppo fa sempre zero.

### Cosa viene condiviso

Le spese condivise sono fatte per uscire dal dispositivo: quando si condivide
un gruppo, via bluetooth o tramite il backend, viaggiano **il gruppo con le
sue impostazioni** (partecipanti, valuta principale, tassi) e **le sue spese
condivise**, in tutte e due le direzioni.

Le **spese normali restano dove sono scritte**. Quanto hai speso al bar non
riguarda nessun altro, e nessuno deve riceverlo per sbaglio insieme al conto
della cena.

Questo ha una conseguenza che vale **da subito**, molto prima di scrivere la
condivisione: tutto cio' che un giorno viaggera' — gruppi, partecipanti, spese
condivise, rimborsi — nasce con un **identificativo stabile**, uguale su ogni
dispositivo. Aggiungerlo dopo significherebbe riscrivere i dati gia' salvati
(voce 035).

### Esempio

Grecia, partecipanti: io, Marco, Lucia.

| Voce | Totale | Ha pagato | Per chi |
| --- | --- | --- | --- |
| Cena *(condivisa)* | 60,00 | io | io, Marco, Lucia (20 ciascuno) |
| Benzina *(condivisa)* | 45,00 | Marco | io, Marco, Lucia (15 ciascuno) |
| Museo *(normale)* | 12,00 | io | — |

- **Ho speso io**: 20 + 15 + 12 = **47,00**
- **Saldi**: io 60 + 12 − 47 = **+25**, Marco 45 − 35 = **+10**, Lucia 0 − 35 = **−35**
- Lucia deve 25 a te e 10 a Marco; con un rimborso di 25 a te il tuo conto si chiude.

## Le schermate

| Vista | Cosa mostra |
| --- | --- |
| **Panoramica** | totale del gruppo, quanto hai speso tu, il tuo saldo, ultime voci |
| **Gruppi di spesa** | elenco dei gruppi, creazione, archiviazione (anche dal menu laterale) |
| **Saldi** | chi deve dare quanto a chi, con i rimborsi suggeriti |
| **Categorie** | le categorie con cui classificare una spesa, con i colori |
| **Impostazioni del viaggio** | valuta principale, valute usate e loro tassi, partecipanti |
| **Grafico** | spesa per categoria e nel tempo |
| **Condivisione** | passare il gruppo a un altro dispositivo (piu' avanti) |

## I paletti — cosa resta fuori

- **Niente collegamento con la sezione Debiti.** I saldi di un gruppo e i
  prestiti segnati a mano sono due conti separati, che non si sommano e non si
  travasano (voce 028).
- **Un tasso per valuta per viaggio**, non uno per spesa: correggerlo
  ricalcola tutte le spese di quel viaggio.
- **Nessun tasso preso da internet**: si scrive a mano. Quando ci sara' un
  backend potra' essere proposto e poi congelato, ma la decisione resta di chi
  registra.
- **Tutte le valute hanno due decimali.** Lo yen e il dinaro, che non ne hanno
  due, non sono gestiti correttamente.
- **I debiti segnati a mano restano in euro**: le valute sono una cosa dei
  gruppi (voce 032).
- **Niente quote in percentuale**: solo parti uguali e importi corretti a mano.
- **Chi ha pagato e' una persona sola.** Una spesa pagata a meta' da due
  persone si registra come due spese.
- **Niente sincronizzazione fra dispositivi** finche' non si fa la
  condivisione del gruppo. Quando si fara', viaggeranno solo le spese
  condivise: le spese normali non escono dal dispositivo su cui sono scritte
  (voce 034).
- **Niente ricevute, foto o allegati.**

## Come lo costruiamo

1. ~~Gruppi e partecipanti: creare, scegliere dal menu, archiviare.~~ **fatto**
2. ~~Categorie: elenco, colori, insieme di partenza.~~ **fatto**
3. ~~Spese normali: le tue, con categoria. Totale del viaggio e quanto hai
   speso tu.~~ **fatto**
4. ~~Spese condivise: chi ha pagato, per chi, quote.~~ **fatto**
5. ~~Valute del viaggio e tassi fissi nelle impostazioni del gruppo.~~ **fatto**
6. ~~Saldi del gruppo e rimborsi.~~ **fatto**
7. ~~Grafico per categoria e nel tempo.~~ **fatto**
8. Condivisione del gruppo via bluetooth e via backend.

Le categorie stanno prima delle spese perche' una spesa le usa. Le spese
normali prima di quelle condivise, perche' sono la meta' piu' semplice dello
stesso modulo. Le valute dopo, perche' il caso "tutto in euro" deve
funzionare da solo prima di aggiungere la conversione: altrimenti, quando i
conti non tornano, non si sa quale dei due pezzi e' rotto.
