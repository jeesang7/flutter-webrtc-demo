class Carebox {
  final String systolic;
  final String diastolic;
  final String opened;
  final String result;

  Carebox(
      {required this.systolic,
      required this.diastolic,
      required this.opened,
      required this.result});

  factory Carebox.fromJson(Map<String, dynamic> json) {
    return Carebox(
        systolic: json['systolic'],
        diastolic: json['diastolic'],
        result: json['result'],
        opened: json['opened']);
  }
}
