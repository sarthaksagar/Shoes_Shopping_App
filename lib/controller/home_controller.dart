import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:footware_page/model/product/product.dart';
import 'package:footware_page/model/product_category/product_category.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference categoryCollection;
  late CollectionReference productCollection;

  List<Product> products = [];
  List<Product> productShowInUi = [];
  List<ProductCategory> productsCategories = [];

  // ✅ Controllers for form fields
  TextEditingController productNameCtrl = TextEditingController();
  TextEditingController productDescriptionCtrl = TextEditingController();
  TextEditingController productPriceCtrl = TextEditingController();
  TextEditingController productImgCtrl = TextEditingController();

  // ✅ Variables for dropdowns or selections
  String category = 'Default Category';
  String brand = 'Default Brand';

  @override
  void onInit() {
    super.onInit();
    productCollection = firestore.collection('products');
    categoryCollection = firestore.collection('category');
    fetchData(); // ✅ Calls both `fetchProducts` and `fetchCategory`
  }

  Future<void> fetchData() async {
    await fetchCategory();
    await fetchProducts();
  }

  Future<void> fetchProducts() async {
  try {
    QuerySnapshot productSnapshot = await productCollection.get();

    if (productSnapshot.docs.isEmpty) {
      Get.snackbar('Info', 'No products available.',
          backgroundColor: Colors.blue, colorText: Colors.white);
      return;
    }

    products.clear();
    products = productSnapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      print("Fetched Product: ${data}"); // ✅ Print to debug
      return Product.fromJson(data);
    }).toList();

    productShowInUi.assignAll(products);
    update();
  } catch (e) {
    Get.snackbar('Error', 'Failed to fetch products: $e',
        backgroundColor: Colors.red, colorText: Colors.white);
  }
}
void filterByMultipleCategories(List<String> selectedBrands) {
  print("Selected Brands: $selectedBrands"); // ✅ Debugging

  if (selectedBrands.isEmpty) {
    productShowInUi.assignAll(products);
  } else {
    productShowInUi.assignAll(
      products.where((product) {
        bool matches = selectedBrands
            .map((b) => b.toLowerCase()) // Convert selection to lowercase
            .contains(product.brand?.toLowerCase()); // Compare lowercase brands
        print("Checking: ${product.name}, Brand: ${product.brand}, Matches: $matches");
        return matches;
      }).toList(),
    );
  }

  print("Filtered Products: ${productShowInUi.map((p) => p.name).toList()}"); // ✅ Debug Output
  update();
}

  Future<void> fetchCategory() async {
    try {
      QuerySnapshot categorySnapshot = await categoryCollection.get();

      if (categorySnapshot.docs.isEmpty) {
        Get.snackbar('Info', 'No categories available.',
            backgroundColor: Colors.blue, colorText: Colors.white);
        return;
      }

      productsCategories = categorySnapshot.docs.map((doc) {
        return ProductCategory.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      update(); //  ✅ Notify UI to refresh
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch categories: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // ✅ Filter by Single Category
  void filterByCategory(String selectedCategory) {
    if (selectedCategory == 'All') {
      productShowInUi.assignAll(products);
    } else {
      productShowInUi.clear();
      productShowInUi.assignAll(
        products.where((product) => product.category == selectedCategory).toList(),
      );
    }
    update();
  }

  // ✅ Filter by Multiple Categories
  


  // ✅ Sorting Function
  void sortProducts(String sortOrder) {
    if (sortOrder == 'Low to High') {
      productShowInUi.sort((a, b) => (a.price ?? 0.0).compareTo(b.price ?? 0.0));
    } else if (sortOrder == 'High to Low') {
      productShowInUi.sort((a, b) => (b.price ?? 0.0).compareTo(a.price ?? 0.0));
    }
    update();
  }

  Future<void> addProduct() async {
    try {
      DocumentReference doc = productCollection.doc();

      Product product = Product(
        id: doc.id,
        name: productNameCtrl.text,
        category: category,
        description: productDescriptionCtrl.text,
        price: double.tryParse(productPriceCtrl.text) ?? 0.0,
        brand: brand,
        image: productImgCtrl.text,
        offer: false,
      );

      await doc.set(product.toJson());

      Get.snackbar('Success', 'Product added successfully!',
          backgroundColor: Colors.greenAccent, colorText: Colors.white);

      fetchProducts(); // ✅ Refresh product list
      setValuesDefault();
    } catch (e) {
      Get.snackbar('Error', 'Failed to add product: ${e.toString()}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void setValuesDefault() {
    productNameCtrl.clear();
    productDescriptionCtrl.clear();
    productPriceCtrl.clear();
    productImgCtrl.clear();
    category = 'Default Category';
    brand = 'Default Brand';
    update();
  }

  @override
  void onClose() {
    productNameCtrl.dispose();
    productDescriptionCtrl.dispose();
    productPriceCtrl.dispose();
    productImgCtrl.dispose();
    super.onClose();
  }
}
