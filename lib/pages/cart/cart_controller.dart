import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:menu_core/core/model/UserModel.dart';
import 'package:menu_core/core/model/orders_model.dart';
import 'package:menu_core/core/model/product_model.dart';
import 'package:menu_core/core/priceUtils.dart';

class CartController {
  CartController(this.usuario);

  OrdersModel pedido = OrdersModel();
  final UserModel usuario;
  final _cartRef = FirebaseFirestore.instance.collection('carrinhos');
  final _pedidosPendentesRef =
  FirebaseFirestore.instance.collection('pedidos_pendentes');
  // final _pedidosFinalizadosRef =
  // FirebaseFirestore.instance.collection('pedidos_finalizados');

  Future<void> addProduct(ProductModel produto) async {
    final doc = _cartRef.doc(usuario.id).collection('produtos').doc(produto.id);
    final docSnapshot = await doc.get();
    if (docSnapshot.exists) {
      final quantidade = docSnapshot.data()['quantidade'] ?? 0;
      doc.set({
        ...produto.toJson(),
        'quantidade': quantidade + 1,
      });
    } else {
      doc.set({
        ...produto.toJson(),
        'quantidade': 1,
      });
    }
  }

  Future<void> removeProduct(ProductModel produto) async {
    final doc =
    _cartRef.doc(usuario.id).collection('produtos').doc(produto.id);
    final docSnapshot = await doc.get();
    final quantidade = docSnapshot.data()['quantidade'] ?? 0;
    if (quantidade == 0) {
      return;
    } else if (quantidade == 1) {
      await doc.delete();
    } else {
      doc.set({
        ...produto.toJson(),
        'quantidade': quantidade - 1,
      });
    }
  }

  Future<List<ProductModel>> getProductCart() async {
    final querySnapshot =
    await _cartRef.doc(usuario.id).collection('produtos').get();
    return querySnapshot.docs
        .map((doc) => ProductModel.fromJson(doc.id, doc.data()))
        .toList();
  }

  void onChangeObservation(String observacao) {
    pedido.observacao = observacao;
  }

  double getValueTotalOrders(List<ProductModel> produtos) {
    double total = 0;
    produtos.forEach((produto) {
      total += produto.quantidade *
          double.parse(PriceUtils.cleanStringPrice(produto.preco));
    });
    return total;
  }

  Future<bool> finalizeOrder() async {
    final produtosCarrinho = await getProductCart();
    if (produtosCarrinho.isNotEmpty) {
      final valorPedido = getValueTotalOrders(produtosCarrinho);
      pedido.produtos = produtosCarrinho;
      pedido.valorPedido = valorPedido;
      pedido.usuarioId = usuario.id;
      pedido.nomeUsuario = usuario.nome;
      pedido.dataPedido = DateTime.now();

      await deleteCart();
      await _pedidosPendentesRef.add(pedido.toJson());
      return true;
    }
    return false;
  }

  Future<void> deleteCart() async {
    await _cartRef.doc(usuario.id).delete();
    final produtosCarrinho =
    await _cartRef.doc(usuario.id).collection('produtos').get();
    produtosCarrinho.docs.forEach((doc) {
      _cartRef.doc(usuario.id).collection('produtos').doc(doc.id).delete();
    });
  }
}