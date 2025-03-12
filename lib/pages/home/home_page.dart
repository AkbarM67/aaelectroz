import 'package:aaelectroz_fe/models/product_model.dart';
import 'package:aaelectroz_fe/models/user_model.dart';
import 'package:aaelectroz_fe/providers/auth_provider.dart';
import 'package:aaelectroz_fe/providers/category_provider.dart';
import 'package:aaelectroz_fe/providers/product_provider.dart';
import 'package:aaelectroz_fe/services/product_service.dart';
import 'package:aaelectroz_fe/theme.dart';
import 'package:aaelectroz_fe/widgets/product_card.dart';
import 'package:aaelectroz_fe/widgets/product_tile.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final Function(String) onCategorySelected;
  const HomePage({Key? key, required this.onCategorySelected}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  String? selectedCategory;
  static const _pageSize = 2;
  bool isLoading = false;
  bool showAllProducts = true;

  final PagingController<int, dynamic> _popularProductsController =
      PagingController(firstPageKey: 0);

  final PagingController<int, dynamic> _newArrivalsController =
      PagingController(firstPageKey: 0);

      List<ProductModel> productList = [];
      

  @override
  void initState() {
    super.initState();
    

    

    Future.microtask(() {
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    final productProvider = Provider.of<ProductProvider>(context, listen: false);

    categoryProvider.getCategories(context);
    fetchProducts();
  });

    _popularProductsController.addPageRequestListener((pageKey) {
      _fetchPopularProducts(pageKey);
    });

    _newArrivalsController.addPageRequestListener((pageKey) {
      _fetchNewArrivals(pageKey);
    });
  }

  Future<void> _fetchPopularProducts(int pageKey) async {
    try {
      ProductProvider productProvider =
          Provider.of<ProductProvider>(context, listen: false);

      final products = productProvider.products ?? [];
      final newProducts = products.skip(pageKey).take(_pageSize).toList();
      final isLastPage = newProducts.length < _pageSize;

      if (isLastPage) {
        _popularProductsController.appendLastPage(newProducts);
      } else {
        final nextPageKey = pageKey + newProducts.length;
        _popularProductsController.appendPage(newProducts, nextPageKey);
      }
    } catch (error) {
      _popularProductsController.error = error;
    }
  }

  Future<void> _fetchNewArrivals(int pageKey) async {
    try {
      ProductProvider productProvider =
          Provider.of<ProductProvider>(context, listen: false);

      final products = productProvider.products ?? [];
      final newProducts = products.skip(pageKey).take(_pageSize).toList();
      final isLastPage = newProducts.length < _pageSize;

      if (isLastPage) {
        _newArrivalsController.appendLastPage(newProducts);
      } else {
        final nextPageKey = pageKey + newProducts.length;
        _newArrivalsController.appendPage(newProducts, nextPageKey);
      }
    } catch (error) {
      _newArrivalsController.error = error;
    }
  }

  void fetchCategories() {
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    categoryProvider.getCategories(context);
  }
  void fetchProducts() async {
  setState(() {
    isLoading = true;
  });

  final productProvider = Provider.of<ProductProvider>(context, listen: false);
  await productProvider.getProducts(); // 🔹 Ambil semua produk

  setState(() {
    isLoading = false;
  });
}

  void fetchProductsByCategory(String? categoryName) async {
    setState(() {
      isLoading = true;
      selectedCategory = categoryName;
      showAllProducts = categoryName == null;
    });

    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    if (categoryName == null) {
      await productProvider.getProducts(); // Tampilkan semua produk (popular & new)
    } else {
      await productProvider.getProductsByCategory(categoryName);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    ProductProvider productProvider = Provider.of<ProductProvider>(context);
    CategoryProvider categoryProvider = Provider.of<CategoryProvider>(context);

    UserModel? user = authProvider.user;

    Widget header() {
      if (user == null) {
        return Center(child: CircularProgressIndicator());
      }

      return Container(
        margin: EdgeInsets.only(
          top: defaultMargin,
          left: defaultMargin,
          right: defaultMargin,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hallo, ${user.name}',
                    style: primaryTextStyle.copyWith(
                      fontSize: 24,
                      fontWeight: semiBold,
                    ),
                  ),
                  Text(
                    '@${user.username}',
                    style: subtitleTextStyle.copyWith(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            if (user.profilePhotoUrl != null)
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(
                      user.profilePhotoUrl!,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }



Widget categories() {
      final categoriesList = [
        {'id': null, 'name': 'All Categories'},
        ...categoryProvider.categories.map((c) => {'id': c.id, 'name': c.name})
      ];

      return Container(
        margin: const EdgeInsets.only(left: 16, top: 16),
        height: 50,
        child: categoryProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoriesList.length,
                itemBuilder: (context, index) {
                  final category = categoriesList[index];
                  final isSelected = category['name'] == selectedCategory;

                  return GestureDetector(
                    onTap: () {
                      fetchProductsByCategory((category['id'] == null ? null : category['name']) as String?);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      margin: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isSelected ? Colors.blue : Colors.grey),
                        color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.transparent,
                      ),
                      child: Text(
                        category['name'].toString(),
                        style: primaryTextStyle.copyWith(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
      );
    }

 Widget productsList() {
      return Visibility(
        visible: !showAllProducts,
        child:  Container(
        margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : productProvider.products.isEmpty
                ? const Center(child: Text("Tidak ada produk dalam kategori ini."),)
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: productProvider.products.length,
                    itemBuilder: (context, index) {
                      return ProductCard(productProvider.products[index]);
                    },
                  ),
        )
      );
    }


    Widget popularProductsTitle() {
      return Visibility(
        visible: showAllProducts,
        child : Container(
        margin: EdgeInsets.only(
          top: defaultMargin,
          left: defaultMargin,
          right: defaultMargin,
        ),
        child: Text(
          'Popular Products',
          style: primaryTextStyle.copyWith(
            fontSize: 22,
            fontWeight: semiBold,
          ),
        ),
      )
      );
    }

    Widget popularProducts() {
      return Visibility(
        visible: showAllProducts,
      child:  SizedBox(
        height: 300, // Tetapkan tinggi untuk batasan widget
        child: PagedListView<int, dynamic>(
          pagingController: _popularProductsController,
          scrollDirection: Axis.horizontal,
          builderDelegate: PagedChildBuilderDelegate<dynamic>(
            itemBuilder: (context, product, index) => ProductCard(product),
          ),
        ),
      )
      );
    }

    Widget newArrivalsTitle() {
      return Visibility(
      visible: showAllProducts,
      child: Container(
        margin: EdgeInsets.only(
          top: defaultMargin,
          left: defaultMargin,
          right: defaultMargin,
        ),
        child: Text(
          'New Arrivals',
          style: primaryTextStyle.copyWith(
            fontSize: 22,
            fontWeight: semiBold,
          ),
        ),
      )
      );
    }

    Widget newArrivals() {
      return Visibility(
        visible: showAllProducts,
        child:  SizedBox(
        height: 400, // Tetapkan tinggi untuk batasan widget
        child: PagedListView<int, dynamic>(
          pagingController: _newArrivalsController,
          scrollDirection: Axis.vertical,
          builderDelegate: PagedChildBuilderDelegate<dynamic>(
            itemBuilder: (context, product, index) => ProductTile(product),
          ),
        ),
        )
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header(),
          categories(),
          popularProductsTitle(),
          popularProducts(),
          newArrivalsTitle(),
          newArrivals(),
          productsList()
        ],

      ),
    );
  }

  @override
  void dispose() {
    _popularProductsController.dispose();
    _newArrivalsController.dispose();
    super.dispose();
  }
}
