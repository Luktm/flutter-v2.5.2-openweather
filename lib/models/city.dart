class City {
  final String city;
  final double lat;
  final double lng;
  final String iso2;
  final String adminName;
  final String capital;
  final int population;
  final int populationProper;

  City({
    this.city,
    this.lat,
    this.adminName,
    this.capital,
    this.population,
    this.populationProper,
    this.iso2,
    this.lng,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      city: json["city"],
      lat: json["lat"].toDouble(),
      adminName: json["admin_name"],
      capital: json["capital"],
      population: json["population"],
      populationProper: json["population_proper"],
      iso2: json["iso2"],
      lng: json["lng"].toDouble(),
    );
  } 
  
}
