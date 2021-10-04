import 'package:flutter/material.dart';
import 'package:menu_core/core/model/category_model.dart';
import 'package:menu_core/core/model/product_model.dart';
import 'package:menu_core/widgets/menu_app_bar.dart';
import 'package:menu_core/widgets/menu_list_tile.dart';
import 'package:menu_core/widgets/menu_loading.dart';
import 'package:my_place_admin/pages/cart/cart_controller.dart';
import 'package:my_place_admin/pages/productByCategory/product_by_category_controller.dart';
import 'package:my_place_admin/pages/productByCategory/product_page.dart';
import 'package:provider/provider.dart';

class ProductByCategory extends StatefulWidget {
  ProductByCategory(this.categoria, {Key key}) : super(key: key);

  final CategoryModel categoria;

  @override
  _ProductByCategoryState createState() => _ProductByCategoryState();
}

class _ProductByCategoryState extends State<ProductByCategory> {
  ProductByCategoryController _controller = ProductByCategoryController();
  Future<List<ProductModel>> futureProdutos;

  @override
  void initState() {
    futureProdutos = _controller.getProdutosPorCategoria(widget.categoria);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MenuAppBar(
        title: Text('Produtos da categoria: ${widget.categoria.nome}'),
      ),
      body: FutureBuilder<List<ProductModel>>(
          future: futureProdutos,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final produtos = snapshot.data;
              return ListView.builder(
                  itemBuilder: (_, i) => MenuListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => Provider.value(
                              value: Provider.of<CartController>(context),
                              child: ProductPage(produtos[i]),
                            ),
                          ));
                        },
                        leading: Hero(
                          tag: produtos[i].urlImagem,
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(produtos[i].urlImagem),
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              produtos[i].preco.toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.green,
                              ),
                            ),
                            Container(
                                width: 16, child: Icon(Icons.chevron_right)),
                          ],
                        ),
                        title: Text(produtos[i].nome),
                      ),
                  itemCount: produtos.length);
            } else {
              return Center(
                child: MenuLoading(),
              );
            }
          }),
    );
  }
}
