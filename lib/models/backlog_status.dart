enum BacklogStatus {
  wantToPlay('ingin_main', 'Ingin main'),
  playing('sedang_main', 'Sedang main'),
  done('selesai', 'Selesai');

  const BacklogStatus(this.value, this.label);

  final String value;

  final String label;

  static BacklogStatus fromValue(String? value) {
    return BacklogStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => BacklogStatus.wantToPlay,
    );
  }
}
