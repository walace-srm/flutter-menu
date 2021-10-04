import 'package:flutter/material.dart';
import 'package:menu_core/core/model/product_model.dart';
import 'package:menu_core/core/priceUtils.dart';
// import 'package:menu_core/core/priceUtils.dart';
// import 'package:my_place_core/core/model/produto_model.dart';
// import 'package:my_place_core/core/preco_utils.dart';

class TotalCartOrders extends StatelessWidget {
  TotalCartOrders(this.produtos);

  final List<ProductModel> produtos;

  double getTotalCart() {
    double total = 0;
    produtos.forEach((produto) {
      total += produto.quantidade *
          double.parse(PriceUtils.cleanStringPrice(produto.preco));
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).primaryColor.withOpacity(.1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Total: ',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(width: 8),
            Text(
              PriceUtils.numberToPrice(getTotalCart().toString()),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
