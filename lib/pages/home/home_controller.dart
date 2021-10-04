import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:menu_core/core/model/category_model.dart';
import 'package:menu_core/core/model/product_model.dart';
import 'package:menu_core/core/model/promotion_model.dart';
import 'package:menu_core/core/priceUtils.dart';

class HomeController {
  final _promotionRef = FirebaseFirestore.instance.collection('promocoes');
  final _categoryRef = FirebaseFirestore.instance.collection('categorias');
  final _productRef = FirebaseFirestore.instance.collection('produtos');

  Future<List<PromotionModel>> getPromotion() async {
    final querySnapshot = await _promotionRef.get();
    return List.generate(
        querySnapshot.docs.length,
        (i) => PromotionModel.fromJson(
            querySnapshot.docs[i].id, querySnapshot.docs[i].data()));
  }

  Future<List<CategoryModel>> getCategory() async {
    final querySnapshot = await _categoryRef.get();
    return List.generate(
        querySnapshot.docs.length,
        (i) => CategoryModel.fromJson(
            querySnapshot.docs[i].id, querySnapshot.docs[i].data()));
  }

  Future<ProductModel> getProductPromotion(PromotionModel promocao) async {
    final querySnapshot =
        await _productRef.where('nome', isEqualTo: promocao.nomeProduto).get();
    final doc = querySnapshot.docs.first;
    final produto = ProductModel.fromJson(doc.id, doc.data());
    final preco =
        promocao.valorOriginalProduto * (1 - (promocao.desconto / 100));
    produto.preco = PriceUtils.numberToPrice(preco.toString());
    return produto;
  }
}
