import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:menu_core/core/model/category_model.dart';
import 'package:menu_core/core/model/product_model.dart';

class ProductByCategoryController {
  final _produtosRef = FirebaseFirestore.instance.collection('produtos');

  Future<List<ProductModel>> getProdutosPorCategoria(
      CategoryModel categoria) async {
    final query = _produtosRef.where('categoria', isEqualTo: categoria.nome);
    final querySnapshot = await query.get();
    return querySnapshot.docs
        .map((doc) => ProductModel.fromJson(doc.id, doc.data()))
        .toList();
  }
}