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
nome, un elenco di **partecipanti** (persone dell'anagrafica, fra cui te) e le
sue voci. Un gruppo si archivia quando il viaggio finisce, come si archivia
una lista della spesa.

Ogni spesa appartiene a un gruppo: non esistono spese "sciolte". Il gruppo su
cui si lavora si sceglie dal menu laterale della sezione Spese, esattamente
come la lista della spesa.

### Spesa

| Campo | |
| --- | --- |
| Descrizione | "Cena al ristorante" |
| Importo | totale pagato, nella valuta in cui si e' pagato |
| Valuta | una fra quelle del gruppo |
| Chi ha pagato | **un** partecipante |
| Per chi | uno o piu' partecipanti, con la **quota** di ciascuno |
| Data | |
| Categoria | facoltativa |

Le quote partono **divise in parti uguali** fra i partecipanti scelti e si
possono correggere a mano: chi non ha preso il dolce, chi ha dormito in camera
singola. La somma delle quote e' sempre uguale al totale — correggendo una
quota, il resto si ridistribuisce fra le altre.

Una **spesa personale** e' semplicemente una spesa dove l'unico partecipante
sei tu: entra nel totale del viaggio, non genera nessun debito.

### Categorie

Le categorie sono un elenco **unico per tutta l'app**, non una cosa per
gruppo: "Cibo", "Alloggio", "Trasporti", "Svago", "Altro" valgono in Grecia
come nella casa di via Verdi. Ognuna ha un nome e un colore, quello con cui
comparira' nel grafico.

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

### Esempio

Grecia, partecipanti: io, Marco, Lucia.

| Voce | Totale | Ha pagato | Per chi |
| --- | --- | --- | --- |
| Cena | 60,00 | io | io, Marco, Lucia (20 ciascuno) |
| Benzina | 45,00 | Marco | io, Marco, Lucia (15 ciascuno) |
| Museo | 12,00 | io | io |

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
  condivisione del gruppo.
- **Niente ricevute, foto o allegati.**

## Come lo costruiamo

1. Gruppi e partecipanti: creare, scegliere dal menu, archiviare.
2. Categorie: elenco, colori, insieme di partenza.
3. Spese con chi ha pagato, per chi, quote e categoria; totale del gruppo e
   quanto hai speso tu.
4. Valute del viaggio e tassi fissi nelle impostazioni del gruppo.
5. Saldi del gruppo e rimborsi.
6. Grafico per categoria e nel tempo.

Le categorie stanno prima delle spese perche' una spesa le usa; le valute
dopo, perche' il caso "tutto in euro" deve funzionare da solo prima di
aggiungere la conversione.
