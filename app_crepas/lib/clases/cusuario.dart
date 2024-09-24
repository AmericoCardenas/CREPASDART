
class Usuario{
final String? id;
final String? nombre;
final String? apellidop;
final String? apellidom;
final String? usuario;
final String? password;

 Usuario({this.id,this.nombre,this.apellidop,this.apellidom,this.usuario,this.password});


factory Usuario.fromJson(Map jsonMap) {
  return Usuario(
    nombre : jsonMap['nombre'],
    apellidop  : jsonMap['apellidop'],
    apellidom : jsonMap['apellidom'],
    usuario : jsonMap['usuario'],
    password : jsonMap['password']
    );
  }

}