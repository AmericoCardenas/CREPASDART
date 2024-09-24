
class Producto{
final String? documentId;
final String? nombre;
final double? costo;
final int? idestatus;


 Producto({this.documentId,this.nombre,this.costo,this.idestatus});


factory Producto.fromJson(Map jsonMap, String documentId) {
  return Producto(
    documentId: documentId,
    nombre : jsonMap['nombre'],
    costo  : jsonMap['costo'],
    idestatus : jsonMap['idestatus']
    );
  }

}