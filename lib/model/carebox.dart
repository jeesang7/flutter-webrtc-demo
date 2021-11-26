class Carebox {
  final String systolic;
  final String diastolic;
  final String opened;

  Carebox({required this.systolic, required this.diastolic, required this.opened});

  factory Carebox.fromJson(Map<String, dynamic> json) {
    return Carebox(
        systolic: json['systolic'],
        diastolic: json['diastolic'],
        opened: json['opened']);
  }
}
