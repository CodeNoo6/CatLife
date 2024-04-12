class Gato {
  String foto;
  String nombre;
  String especie;
  String fechaNacimiento;
  String raza;
  String color;
  String genero;
  bool microchip;
  String peso;
  bool esterilizado;
  String edadMeses;
  String felinoId;

  Gato(
      {this.foto,
      this.nombre,
      this.especie,
      this.fechaNacimiento,
      this.raza,
      this.color,
      this.genero,
      this.microchip,
      this.peso,
      this.esterilizado,
      this.edadMeses,
      this.felinoId});

  factory Gato.fromMap(Map<String, dynamic> map) {
    return Gato(
      felinoId: map['FelinoId'],
      foto: map['Foto'],
      nombre: map['Nombre'],
      especie: map['Especie'],
      fechaNacimiento: map['FechaNacimiento'],
      raza: map['Raza'],
      color: map['Color'],
      genero: map['Genero'],
      microchip: map['Microchip'],
      peso: map['Peso'],
      esterilizado: map['Esterilizado'],
      edadMeses: map['EdadMeses'],
    );
  }
}
