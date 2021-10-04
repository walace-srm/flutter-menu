import 'package:flutter/material.dart';
import 'package:menu_core/core/model/UserModel.dart';
import 'package:menu_core/core/model/category_model.dart';
import 'package:menu_core/core/model/promotion_model.dart';
import 'package:menu_core/widgets/menu_app_bar.dart';
import 'package:menu_core/widgets/menu_button_icon.dart';
import 'package:menu_core/widgets/menu_loading.dart';
import 'package:menu_core/widgets/menu_logo.dart';
import 'package:my_place_admin/pages/cart/cart_controller.dart';
import 'package:my_place_admin/pages/cart/cart_page.dart';
import 'package:my_place_admin/pages/home/home_controller.dart';
import 'package:my_place_admin/pages/home/widget/categories.dart';
import 'package:my_place_admin/pages/home/widget/promotions.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = HomeController();

  Future<List<PromotionModel>> futurePromocoes;
  Future<List<CategoryModel>> futureCategorias;

  @override
  void initState() {
    futurePromocoes = _controller.getPromotion();
    futureCategorias = _controller.getCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MenuAppBar(
        title: MenuLogo(
          fontSize: 24,
        ),
        withLeading: false,
        actions: [
          MenuButtonIcon(
            iconData: Icons.shopping_cart,
            onTap: () {
              final usuario = Provider.of<UserModel>(context, listen: false);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => Provider.value(
                    value: Provider.of<CartController>(context),
                    child: CartPage(usuario),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            children: [
              FutureBuilder<List<PromotionModel>>(
                future: futurePromocoes,
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    return Promotions(snapshot.data);
                  } else {
                    return Center(
                      child: MenuLoading(),
                    );
                  }
                },
              ),
              SizedBox(height: 24),
              FutureBuilder<List<CategoryModel>>(
                future: futureCategorias,
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    return Categories(snapshot.data);
                  } else {
                    return Center(
                      child: MenuLoading(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
