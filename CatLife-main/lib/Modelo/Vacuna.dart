class Vacuna {
  String nombre;
  String fechaAplicacion;
  String nombreVeterinario;
  String proximAplicacion;
  int dosis;
  int codigoVet;

  Vacuna(
      {this.nombre,
      this.fechaAplicacion,
      this.nombreVeterinario,
      this.proximAplicacion,
      this.dosis,
      this.codigoVet});

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'fechaAplicacion': fechaAplicacion,
      'nombreVeterinario': nombreVeterinario,
      'proximAplicacion': proximAplicacion,
      'dosis': dosis,
      'codigoVet': codigoVet
    };
  }
}
