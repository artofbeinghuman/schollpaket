class Strings {
  static const title = 'Schollheim Pakete';
  static const yourName = 'Dein Name:';
  static const enterYourName = 'Tippe deinen Namen ein';
  static const noParcels = 'Es gibt keine Pakete für dich im Moment.';
  static String parcels(int count) {
    if (count == 1)
      return 'Es liegt ein Paket für dich bei der Verwaltung.';
    else
      return 'Es liegen $count Pakete für dich bei der Verwaltung.';
  }

  static const info =
      'Diese App zeigt dir, ob gelieferte Pakete bei der Verwaltung auf dich warten. Gebe dafür deinen Namen in das Feld ein. Du musst mit deinem Handy im WLAN des Schollheims sein. Zum aktualisieren, scrolle nach unten. Viel Spaß! \n- Marvin';
}
