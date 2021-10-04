import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:menu_core/core/model/category_model.dart';
import 'package:my_place_admin/pages/cart/cart_controller.dart';
import 'package:my_place_admin/pages/productByCategory/product_by_category_page.dart';
import 'package:provider/provider.dart';

class Categories extends StatelessWidget {
  const Categories(this.categorias, {Key key}) : super(key: key);

  final List<CategoryModel> categorias;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Categorias',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        CarouselSlider(
          items: categorias
              .map(
                (categoria) => GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => Provider.value(
                        value: Provider.of<CartController>(context),
                        child: ProductByCategory(categoria),
                      ),
                    ));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: [
                        Image.network(
                          categoria.urlImagem,
                          fit: BoxFit.cover,
                          width: double.maxFinite,
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                              ),
                              color: Theme.of(context).colorScheme.surface,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              categoria.nome,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
          options: CarouselOptions(
            disableCenter: true,
            enableInfiniteScroll: false,
            enlargeCenterPage: true,
            height: 200,
          ),
        ),
      ],
    );
  }
}
