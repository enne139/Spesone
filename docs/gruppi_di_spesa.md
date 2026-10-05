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
| Importo | totale pagato |
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
| **Categorie** | le categorie con cui classificare una spesa |
| **Grafico** | spesa per categoria e nel tempo |
| **Condivisione** | passare il gruppo a un altro dispositivo (piu' avanti) |

## I paletti — cosa resta fuori

- **Niente collegamento con la sezione Debiti.** I saldi di un gruppo e i
  prestiti segnati a mano sono due conti separati, che non si sommano e non si
  travasano (voce 028).
- **Solo euro.** Nessuna conversione di valuta (voce 023).
- **Niente quote in percentuale**: solo parti uguali e importi corretti a mano.
- **Chi ha pagato e' una persona sola.** Una spesa pagata a meta' da due
  persone si registra come due spese.
- **Niente sincronizzazione fra dispositivi** finche' non si fa la
  condivisione del gruppo.
- **Niente ricevute, foto o allegati.**

## Come lo costruiamo

1. Gruppi e partecipanti: creare, scegliere dal menu, archiviare.
2. Spese con chi ha pagato, per chi e le quote; totale del gruppo e quanto hai
   speso tu.
3. Saldi del gruppo e rimborsi.
4. Categorie.
5. Grafico.
