import 'package:flutter/material.dart';

import 'package:spesone/features/debiti/crediti_page.dart';
import 'package:spesone/features/debiti/debiti_da_pagare_page.dart';
import 'package:spesone/features/debiti/riepilogo_debiti_page.dart';
import 'package:spesone/features/debiti/widgets/fab_aggiungi_movimento.dart';
import 'package:spesone/features/lista_spesa/lista_corrente_page.dart';
import 'package:spesone/features/lista_spesa/liste_archiviate_page.dart';
import 'package:spesone/features/lista_spesa/prodotti_frequenti_page.dart';
import 'package:spesone/features/lista_spesa/widgets/azione_rimuovi_prese.dart';
import 'package:spesone/features/lista_spesa/widgets/fab_aggiungi_voce.dart';
import 'package:spesone/features/lista_spesa/widgets/selettore_liste.dart';
import 'package:spesone/features/lista_spesa/widgets/titolo_lista_corrente.dart';
import 'package:spesone/features/persone/persone_page.dart';
import 'package:spesone/features/persone/widgets/fab_aggiungi_persona.dart';
import 'package:spesone/features/spese/categorie_spese_page.dart';
import 'package:spesone/features/spese/condivisione_gruppo_page.dart';
import 'package:spesone/features/spese/grafico_spese_page.dart';
import 'package:spesone/features/spese/gruppi_spesa_page.dart';
import 'package:spesone/features/spese/panoramica_spese_page.dart';
import 'package:spesone/navigation/app_section.dart';

/// Registro unico della navigazione: aggiungere una voce qui la fa comparire
/// nella barra in basso (sezione) o nel drawer (vista).
final List<AppSection> appSections = <AppSection>[
  AppSection(
    label: 'Spese',
    icon: Icons.receipt_long_outlined,
    selectedIcon: Icons.receipt_long,
    views: <SectionView>[
      SectionView(
        title: 'Panoramica spese',
        icon: Icons.dashboard_outlined,
        builder: (BuildContext context) => const PanoramicaSpesePage(),
      ),
      SectionView(
        title: 'Gruppi di spesa',
        icon: Icons.groups_outlined,
        builder: (BuildContext context) => const GruppiSpesaPage(),
      ),
      SectionView(
        title: 'Categorie',
        icon: Icons.sell_outlined,
        builder: (BuildContext context) => const CategorieSpesePage(),
      ),
      SectionView(
        title: 'Grafico spese',
        icon: Icons.insert_chart_outlined,
        builder: (BuildContext context) => const GraficoSpesePage(),
      ),
      SectionView(
        title: 'Condivisione gruppo',
        icon: Icons.share_outlined,
        builder: (BuildContext context) => const CondivisioneGruppoPage(),
      ),
    ],
  ),
  AppSection(
    label: 'Lista',
    icon: Icons.shopping_cart_outlined,
    selectedIcon: Icons.shopping_cart,
    // Il menu laterale della sezione Lista fa anche scegliere su quale lista
    // lavorare, crearne di nuove e archiviarle o eliminarle.
    drawerExtra: (BuildContext context) => const SelettoreListe(),
    views: <SectionView>[
      SectionView(
        title: 'Lista corrente',
        icon: Icons.checklist_outlined,
        builder: (BuildContext context) => const ListaCorrentePage(),
        // Il titolo e' il nome della lista aperta, non un'etichetta fissa.
        appBarTitle: (BuildContext context) => const TitoloListaCorrente(),
        actions: (BuildContext context) => const <Widget>[AzioneRimuoviPrese()],
        floatingActionButton: (BuildContext context) => const FabAggiungiVoce(),
      ),
      SectionView(
        title: 'Liste archiviate',
        icon: Icons.archive_outlined,
        builder: (BuildContext context) => const ListeArchiviatePage(),
      ),
      SectionView(
        title: 'Prodotti frequenti',
        icon: Icons.replay_outlined,
        builder: (BuildContext context) => const ProdottiFrequentiPage(),
      ),
    ],
  ),
  AppSection(
    label: 'Debiti',
    icon: Icons.account_balance_wallet_outlined,
    selectedIcon: Icons.account_balance_wallet,
    views: <SectionView>[
      SectionView(
        title: 'Riepilogo debiti',
        icon: Icons.balance_outlined,
        builder: (BuildContext context) => const RiepilogoDebitiPage(),
        floatingActionButton: (BuildContext context) =>
            const FabAggiungiMovimento(),
      ),
      SectionView(
        title: 'Da ricevere',
        icon: Icons.call_received_outlined,
        builder: (BuildContext context) => const CreditiPage(),
        floatingActionButton: (BuildContext context) =>
            const FabAggiungiMovimento(),
      ),
      SectionView(
        title: 'Da pagare',
        icon: Icons.call_made_outlined,
        builder: (BuildContext context) => const DebitiDaPagarePage(),
        floatingActionButton: (BuildContext context) =>
            const FabAggiungiMovimento(),
      ),
    ],
  ),
  AppSection(
    label: 'Persone',
    icon: Icons.person_outline,
    selectedIcon: Icons.person,
    views: <SectionView>[
      SectionView(
        title: 'Persone',
        icon: Icons.people_outline,
        builder: (BuildContext context) => const PersonePage(),
        floatingActionButton: (BuildContext context) =>
            const FabAggiungiPersona(),
      ),
    ],
  ),
];
