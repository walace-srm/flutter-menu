import 'package:flutter/material.dart';
import 'package:menu_core/core/model/UserModel.dart';
import 'package:menu_core/core/model/product_model.dart';
import 'package:menu_core/widgets/menu_app_bar.dart';
import 'package:menu_core/widgets/menu_button_icon.dart';
import 'package:menu_core/widgets/menu_list_tile.dart';
import 'package:menu_core/widgets/menu_loading.dart';
import 'package:menu_core/widgets/toasts/toast_utils.dart';
import 'package:my_place_admin/pages/cart/cart_controller.dart';
import 'package:my_place_admin/pages/cart/widgts/cart_total_orders.dart';
import 'package:provider/provider.dart';

//import 'cart_controller.dart';

class CartPage extends StatefulWidget {
  CartPage(this.usuario, {Key key}) : super(key: key);

  final UserModel usuario;

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  CartController _controller;
  Future<List<ProductModel>> futureCarrinho;

  @override
  void didChangeDependencies() {
    _controller = Provider.of<CartController>(context);
    futureCarrinho = _controller.getProductCart();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MenuAppBar(title: Text('Seu Pedido')),
      body: FutureBuilder<List<ProductModel>>(
          future: futureCarrinho,
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              final produtosCarrinho = snapshot.data;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (_, i) => MenuListTile(
                          title: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(produtosCarrinho[i].nome),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      produtosCarrinho[i].preco,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                            width: 40,
                                            height: 30,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Theme.of(context)
                                                    .primaryColorLight,
                                              ),
                                            ),
                                            child: Text(produtosCarrinho[i]
                                                    .quantidade
                                                    ?.toString() ??
                                                '0')),
                                        SizedBox(width: 8),
                                        MenuButtonIcon(
                                          iconData: Icons.remove,
                                          iconColor:
                                              Theme.of(context).primaryColor,
                                          withBackgroundColor: true,
                                          size: 30,
                                          onTap: () async {
                                            await _controller.removeProduct(
                                                produtosCarrinho[i]);
                                            futureCarrinho =
                                                _controller.getProductCart();
                                            setState(() {});
                                          },
                                        ),
                                        SizedBox(width: 4),
                                        MenuButtonIcon(
                                          iconData: Icons.add,
                                          iconColor:
                                              Theme.of(context).primaryColor,
                                          withBackgroundColor: true,
                                          size: 30,
                                          onTap: () async {
                                            await _controller.addProduct(
                                                produtosCarrinho[i]);
                                            futureCarrinho =
                                                _controller.getProductCart();
                                            setState(() {});
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        separatorBuilder: (context, i) => Divider(height: 1),
                        itemCount: produtosCarrinho.length,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Column(
                        children: [
                          SizedBox(height: 12),
                          TotalCartOrders(produtosCarrinho),
                          SizedBox(height: 12),
                          TextFormField(
                            onChanged: _controller.onChangeObservation,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Observação'),
                            minLines: 3,
                            maxLines: 6,
                          ),
                          SizedBox(height: 24),
                          RaisedButton.icon(
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 18),
                            icon: Icon(Icons.done, size: 32),
                            label: Text(
                              'Finalizar o Pedido',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            onPressed: () async {
                              final pedidoFoiConcluido =
                                  await _controller.finalizeOrder();
                              if (pedidoFoiConcluido) {
                                showSuccessToast(
                                    'Pedido finalizado com sucesso!');
                                Navigator.of(context).pop();
                              } else {
                                showWarningToast('Carrinho está vazio!');
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: MenuLoading(),
              );
            }
          }),
    );
  }
}
