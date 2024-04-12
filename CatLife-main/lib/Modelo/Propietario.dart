class Propietario {
  String foto;
  String correo;
  String nombreApellido;
  int celular;
  String pais;
  String direccion;
  String contrasena;

  Propietario({
    this.correo,
    this.nombreApellido,
    this.celular,
    this.pais,
    this.direccion,
    this.contrasena,
    this.foto, // Se agrega el parámetro 'foto' al constructor
  });
}
