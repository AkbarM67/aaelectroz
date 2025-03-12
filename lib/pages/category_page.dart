import 'package:aaelectroz_fe/models/user_model.dart';
import 'package:aaelectroz_fe/providers/auth_provider.dart';
import 'package:aaelectroz_fe/providers/category_provider.dart';
import 'package:aaelectroz_fe/providers/product_provider.dart';
import 'package:aaelectroz_fe/theme.dart';
import 'package:aaelectroz_fe/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatefulWidget {
  final String category;

  const CategoryPage({Key? key, required this.category}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  String? selectedCategory; // Tambahkan state untuk kategori yang dipilih
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  void fetchCategories() {
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    categoryProvider.getCategories(context);
  }

  void fetchProductsByCategory(String? categoryName) async {
    setState(() {
      isLoading = true;
      selectedCategory = categoryName;
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
      return Container(
        margin: EdgeInsets.only(top: defaultMargin, left: defaultMargin, right: defaultMargin),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hallo, ${user?.name ?? "User"}',
                    style: primaryTextStyle.copyWith(fontSize: 24, fontWeight: semiBold),
                  ),
                  Text(
                    '@${user?.username ?? "Username"}',
                    style: subtitleTextStyle.copyWith(fontSize: 16),
                  ),
                ],
              ),
            ),
            if (user?.profilePhotoUrl != null)
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(user!.profilePhotoUrl!),
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

    Widget popularProducts() {
      return selectedCategory == null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: defaultMargin, vertical: 10),
                  child: Text(
                    'Popular Products',
                    style: primaryTextStyle.copyWith(fontSize: 22, fontWeight: semiBold),
                  ),
                ),
                productProvider.isLoading
                    ? Center(child: CircularProgressIndicator())
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
              ],
            )
          : SizedBox();
    }

    Widget productsList() {
      return Container(
        margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : productProvider.products.isEmpty
                ? const Center(child: Text("Tidak ada produk dalam kategori ini."))
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
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor1,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(),
            categories(),
            popularProducts(),
            productsList(),
          ],
        ),
      ),
    );
  }
}
