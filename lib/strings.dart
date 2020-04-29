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
}
