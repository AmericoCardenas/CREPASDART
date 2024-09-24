import 'package:app_crepas/clases/cproductos.dart';
import 'package:app_crepas/clases/cusuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future <List<Usuario>> login(String? usuario,String? password) async {
List<Usuario> result = [];
CollectionReference collectionReferenceUsuario=db.collection('usuarios');
QuerySnapshot queryUsuario= await collectionReferenceUsuario.where('usuario',isEqualTo: usuario).where('password',isEqualTo: password).get();

  result = queryUsuario.docs.map((DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Usuario(
      nombre: data['nombre'],
      apellidop: data['apellidop'],
      apellidom: data['apellidom'],
      usuario: data['usuario'],
      password: data['password']
    );
  }).toList();

return result;

}

Future <List<Producto>> getProductos() async {
List<Producto> result = [];
CollectionReference collectref=db.collection('productos');
QuerySnapshot query= await collectref.where('idestatus',isEqualTo: 1).get();

  result = query.docs.map((DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Producto(
      documentId: doc.id,
      nombre: data['nombre'],
      costo: data['costo'],
      idestatus: data['idestatus']
          );
  }).toList();

return result;

}

Future <String> postProducto(String? nombre,double? costo) async {

  if(nombre=='' || nombre==null){
  return 'Debe asignar un nombre';
  }
  else if(costo!.isNaN==true){
    return 'Debe asignar un costo al producto';
  }
  else{
  FirebaseFirestore.instance.collection('productos')
  .add({
  'nombre':nombre,
  'costo':costo,
  'idestatus':1
  });

  return 'Ok';
}


}

Future <String> updateProducto(String? nombre,double? costo,String? docid) async {
    if(nombre=='' || nombre==null){
  return 'Debe asignar un nombre';
  }
  else if(double.tryParse(costo.toString())==null){
    return 'el costo es incorrecto';
  }
  else if(costo.toString()==''){
    return 'debe agregar un costo al producto';
  }
  else if(docid=='' || docid==null){
    return 'no se envio el docid del producto';
  }
  else{
  FirebaseFirestore.instance.collection('productos').doc(docid)
  .update({
  'nombre':nombre,
  'costo':costo,
  'idestatus':1
  });

  return 'Ok';
}
}