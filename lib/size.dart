class Size_P {
  String name;
  String number;
  bool selected;

  Size_P({required this.name, required this.number, required this.selected});

  factory Size_P.fromJson(Map<String, dynamic> json) {
    return Size_P(
        name: json['name'], number: json['number'], selected: json['selected']);
  }
}
