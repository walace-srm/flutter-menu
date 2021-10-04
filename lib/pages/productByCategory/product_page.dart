import 'package:flutter/material.dart';
import 'package:menu_core/core/model/product_model.dart';
import 'package:menu_core/widgets/menu_app_bar.dart';
import 'package:menu_core/widgets/toasts/toast_utils.dart';
import 'package:my_place_admin/pages/cart/cart_controller.dart';
import 'package:provider/provider.dart';


class ProductPage extends StatelessWidget {
  ProductPage(this.produto);

  final ProductModel produto;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MenuAppBar(title: Text('Produto')),
      body: Container(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
        alignment: Alignment.center,
        child: Column(
          children: [
            Hero(
              tag: produto.urlImagem,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(produto.urlImagem),
              ),
            ),
            SizedBox(height: 16),
            Text(
              produto.descricao,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 4),
            Text(
              produto.preco,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 24),
            RaisedButton.icon(
              onPressed: () async {
               final cartController = Provider.of<CartController>(context, listen: false);
               await cartController.addProduct(produto);
               showSuccessToast('Produto adicionado ao carrinho');

              },
              icon: Icon(Icons.add_shopping_cart),
              label: Text(
                'Adicionar ao carrinho',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
