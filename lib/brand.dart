class Brand_p {
  String name;
  String logourl;

  Brand_p({required this.name, required this.logourl});

  factory Brand_p.fromJson(Map<String, dynamic> json) {
    return Brand_p(name: json['name'], logourl: json['logourl']);
  }
}
