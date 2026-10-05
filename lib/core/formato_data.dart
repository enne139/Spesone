/// Data in cifre, nel formato italiano gg/mm/aaaa.
///
/// Scritta a mano invece di aggiungere `intl`: all'app serve un solo formato e
/// nessuna traduzione. Se un giorno servisse "5 ottobre" o altre lingue, e'
/// qui che va sostituita con `DateFormat`.
String formattaData(DateTime data) {
  final String giorno = data.day.toString().padLeft(2, '0');
  final String mese = data.month.toString().padLeft(2, '0');
  return '$giorno/$mese/${data.year}';
}
