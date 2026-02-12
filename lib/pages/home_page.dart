import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:footware_page/controller/cart_provider.dart';
import 'package:footware_page/controller/home_controller.dart';
import 'package:footware_page/pages/login_page.dart';
import 'package:footware_page/pages/product_description_pages.dart';
import 'package:footware_page/wigdets/drop_down_btn.dart';
import 'package:footware_page/wigdets/multi_select_drop_down.dart';
import 'package:footware_page/wigdets/product_card.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:footware_page/screens/cart_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController homeController = Get.put(HomeController());
  String selectedSort = "Sort";

  @override
  void initState() {
    super.initState();
    homeController.fetchData().then((_) {
      homeController.sortProducts(selectedSort);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (ctrl) {
      return RefreshIndicator(
        onRefresh: () async {
          ctrl.fetchProducts();
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Footwear Store',
              style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 184, 6, 80)),
            ),
            actions: [
              Consumer<CartProvider>(
                builder: (context, cartProvider, child) {
                  return badges.Badge(
                    position: badges.BadgePosition.topEnd(top: 0, end: 3),
                    badgeAnimation: const badges.BadgeAnimation.scale(),
                    showBadge: cartProvider.cart.isNotEmpty,
                    badgeContent: Text(
                      cartProvider.cart.length.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.shopping_cart),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CartScreen(cart: [],),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              IconButton(
                onPressed: () {
                  GetStorage box = GetStorage();
                  box.erase();
                  Get.offAll(const LoginPage());
                },
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // ✅ Category Chips
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: ctrl.productsCategories.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          ctrl.filterByCategory(ctrl.productsCategories[index].name ?? '');
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Chip(
                            label: Text(ctrl.productsCategories[index].name ?? 'Error'),
                            backgroundColor: const Color.fromARGB(255, 217, 223, 228),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // ✅ Sorting & Multi-Select Dropdown
                Row(
                  children: [
                    DropDownBtn(
                      items: ['Low to High', 'High to Low'],
                      selectedItemText: selectedSort,
                      onSelected: (selected) {
                        setState(() {
                          selectedSort = selected!;
                          homeController.sortProducts(selectedSort);
                        });
                      },
                      onSelectionChanged: (selectedItems) {},
                    ),
                    const SizedBox(width: 16),
                    Flexible(
                      child: MultiSelectDropDown(
                        items: ['Puma', 'Adidas', 'Sketchers'],
                        onSelectionChanged: (selectedItems) {
                          ctrl.filterByMultipleCategories(selectedItems);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // ✅ Product Grid
                Expanded(
                  child: ctrl.productShowInUi.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : GridView.builder(
                          itemCount: ctrl.productShowInUi.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                            childAspectRatio: 0.75,
                          ),
                          itemBuilder: (context, index) {
                            if (index >= ctrl.productShowInUi.length) {
                              return const SizedBox();
                            }
                            return ProductCard(
                              title: ctrl.productShowInUi[index].name ?? 'No Name',
                              name: ctrl.productShowInUi[index],
                              imageUrl: ctrl.productShowInUi[index].image ?? 'https://via.placeholder.com/150',
                              price: (ctrl.productShowInUi[index].price ?? 0.0).toDouble(),
                              offerTag: '30% OFF',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDescriptionPage(
                                      title: ctrl.productShowInUi[index].name ?? 'No Name',
                                      imageUrl: ctrl.productShowInUi[index].image ?? 'https://via.placeholder.com/150',
                                      price: (ctrl.productShowInUi[index].price ?? 0.0).toDouble(),
                                      offerTag: '30% OFF',
                                      sizes: [],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
