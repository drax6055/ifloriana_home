import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

import '../../../main.dart';
import '../../../network/dio.dart';
import '../../../network/network_const.dart';
import '../../../wiget/custome_snackbar.dart';

import '../get/inhouseProduct_controller.dart';

class ManagerPostInhouseController extends GetxController {
  final DioClient dioClient = DioClient();

  RxList branches = [].obs;
  RxList staff = [].obs;
  RxList products = [].obs;
  List<dynamic> _allStaff = []; // Store all staff for filtering
  List<dynamic> _allProducts = []; // Store all products for filtering

  Rxn selectedBranch = Rxn();
  Rxn selectedStaff = Rxn();
  Rxn selectedProduct = Rxn();
  Rxn selectedVariant = Rxn();
  final TextEditingController quantityController = TextEditingController();

  // Cart functionality
  RxList cart = <Map<String, dynamic>>[].obs;
  RxDouble totalAmount = 0.0.obs;
  RxBool isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBranches();
    fetchStaff();
    fetchProducts();
  }

  void fetchBranches() async {
    try {
      final loginUser = await prefs.getManagerUser();
      if (loginUser == null) {
        print("Error: No user found");
        return;
      }

      print("User data: ${loginUser.toJson()}");
      print("Salon ID: ${loginUser.manager?.salonId}");

      if (loginUser.manager?.salonId == null) {
        print("Error: Salon ID is null or empty");
        return;
      }

      final endpoint =
          '${Apis.baseUrl}${Endpoints.getBranchName}${loginUser.manager?.salonId}';
      print("Fetching branches from: $endpoint");

      final data = await dioClient.getData<Map<String, dynamic>>(
          endpoint, (json) => json);

      print("Branches response: $data");

      if (data != null && data['data'] != null) {
        branches.value = data['data'];
        print("Branches loaded: ${branches.length}");
      } else {
        print("No branches data found in response");
        branches.value = [];
      }
    } catch (e) {
      print("Error fetching branches: $e");
      branches.value = [];
    }
  }

  void fetchStaff() async {
    try {
      final loginUser = await prefs.getManagerUser();
      if (loginUser == null) {
        print("Error: No user found");
        return;
      }

      print("User data for staff: ${loginUser.toJson()}");
      print("Salon ID for staff: ${loginUser.manager?.salonId}");

      if (loginUser.manager?.salonId == null ) {
        print("Error: Salon ID is null or empty for staff");
        return;
      }

      final endpoint =
          '${Apis.baseUrl}${Endpoints.getStaffDetails}${loginUser.manager?.salonId}';
      print("Fetching staff from: $endpoint");

      final data = await dioClient.getData<Map<String, dynamic>>(
          endpoint, (json) => json);

      print("Staff response: $data");

      if (data != null && data['data'] != null) {
        staff.value = data['data'];
        _allStaff = data['data'];
        print("Staff loaded: ${staff.length}");
      } else {
        print("No staff data found in response");
        staff.value = [];
        _allStaff = [];
      }
    } catch (e) {
      print("Error fetching staff: $e");
      staff.value = [];
      _allStaff = [];
    }
  }

  void fetchProducts() async {
    try {
      final loginUser = await prefs.getManagerUser();
      if (loginUser == null) {
        print("Error: No user found");
        return;
      }

      print("User data for products: ${loginUser.toJson()}");
      print("Salon ID for products: ${loginUser.manager?.salonId}");

      if (loginUser.manager?.salonId == null ) {
        print("Error: Salon ID is null or empty for products");
        return;
      }

      final endpoint =
          '${Apis.baseUrl}${Endpoints.getProductsName}${loginUser.manager?.salonId}';
      print("Fetching products from: $endpoint");

      final data = await dioClient.getData<List<dynamic>>(
          endpoint, (json) => json as List<dynamic>);

      print("Products response: $data");

      if (data != null) {
        products.value = data;
        _allProducts = data;
        print("Products loaded: ${products.length}");
      } else {
        print("No products data found in response");
        products.value = [];
        _allProducts = [];
      }
    } catch (e) {
      print("Error fetching products: $e");
      products.value = [];
      _allProducts = [];
    }
  }

  // Method to filter staff by branch
  void filterStaffByBranch() {
    if (selectedBranch.value == null) {
      staff.value = _allStaff; // Show all staff if no branch selected
      return;
    }

    final selectedBranchId = selectedBranch.value['_id'];
    final filteredStaff = _allStaff.where((staffMember) {
      // Check if staff member has branch_id and it matches selected branch
      if (staffMember['branch_id'] != null) {
        // Handle both cases: branch_id as string or as object with _id
        if (staffMember['branch_id'] is String) {
          return staffMember['branch_id'] == selectedBranchId;
        } else if (staffMember['branch_id'] is Map) {
          return staffMember['branch_id']['_id'] == selectedBranchId;
        }
      }
      return false;
    }).toList();

    staff.value = filteredStaff;
    // Clear selected staff if it's not in the filtered list
    if (selectedStaff.value != null) {
      final isStillValid =
          filteredStaff.any((s) => s['_id'] == selectedStaff.value['_id']);
      if (!isStillValid) {
        selectedStaff.value = null;
      }
    }
  }

  // Add to cart method
  void addToCart() {
    if (selectedProduct.value == null) {
      CustomSnackbar.showError('Error', 'Please select a product');
      return;
    }

    if (selectedBranch.value == null) {
      CustomSnackbar.showError('Error', 'Please select a branch');
      return;
    }

    if (selectedStaff.value == null) {
      CustomSnackbar.showError('Error', 'Please select a staff');
      return;
    }

    final quantity = int.tryParse(quantityController.text) ?? 0;
    if (quantity <= 0) {
      CustomSnackbar.showError('Error', 'Please enter a valid quantity');
      return;
    }

    // Check if cart already has items with different branch or staff
    if (cart.isNotEmpty) {
      final firstItem = cart.first;
      if (firstItem['branch_id'] != selectedBranch.value['_id']) {
        CustomSnackbar.showError(
            'Error', 'All products must be from the same branch');
        return;
      }
      if (firstItem['staff_id'] != selectedStaff.value['_id']) {
        CustomSnackbar.showError(
            'Error', 'All products must be assigned to the same staff');
        return;
      }
    }

    final product = selectedProduct.value as Map<String, dynamic>;
    final branch = selectedBranch.value as Map<String, dynamic>;
    final staffMember = selectedStaff.value as Map<String, dynamic>;

    // Get product price - handle both main product and variant prices
    double price = 0.0;
    String productName = product['product_name'] ?? 'Unknown Product';
    String variantInfo = '';

    if (selectedVariant.value != null) {
      final variant = selectedVariant.value as Map<String, dynamic>;
      price = double.tryParse(variant['price']?.toString() ?? '0') ?? 0.0;
      variantInfo = variant['combination']
              ?.map((c) => c['variation_value'])
              .join(' - ') ??
          '';
      productName += ' - $variantInfo';
    } else {
      price = double.tryParse(product['price']?.toString() ?? '0') ?? 0.0;
    }

    final total = price * quantity;

    final cartItem = {
      'name': productName,
      'branch': branch['name'] ?? 'Unknown Branch',
      'staff': staffMember['full_name'] ?? 'Unknown Staff',
      'quantity': quantity,
      'price': price,
      'total': total,
      'product_id': product['_id'],
      'variant_id': selectedVariant.value?['_id'],
      'branch_id': branch['_id'],
      'staff_id': staffMember['_id'],
    };

    cart.add(cartItem);
    calculateTotal();

    // Clear product selection and quantity
    clearCurrentProduct();

    CustomSnackbar.showSuccess('Success', 'Product added to cart');
  }

  // Remove from cart method
  void removeFromCart(int index) {
    if (index >= 0 && index < cart.length) {
      cart.removeAt(index);
      calculateTotal();
    }
  }

  // Calculate total amount
  void calculateTotal() {
    totalAmount.value =
        cart.fold(0.0, (sum, item) => sum + (item['total'] as double));
  }

  // Clear current product selection
  void clearCurrentProduct() {
    selectedProduct.value = null;
    selectedVariant.value = null;
    quantityController.text = "";
  }

  // Clear entire cart
  void clearCart() {
    cart.clear();
    totalAmount.value = 0.0;
  }

  // Clear all form controllers
  void clearAllControllers() {
    // Clear selections
    selectedBranch.value = null;
    selectedStaff.value = null;
    selectedProduct.value = null;
    selectedVariant.value = null;

    // Clear text controllers
    quantityController.text = "";

    // Clear cart
    clearCart();

    // Reset staff list to show all staff (in case it was filtered)
    staff.value = _allStaff;
  }

  // Submit cart to API
  Future<bool> submitCart() async {
    try {
      isSubmitting.value = true;
      final loginUser = await prefs.getManagerUser();

      if (loginUser == null) {
        CustomSnackbar.showError('Error', 'User not logged in');
        return false;
      }

      if (cart.isEmpty) {
        CustomSnackbar.showError('Error', 'Cart is empty');
        return false;
      }

      // Get the first item to extract common branch_id and staff_id
      final firstItem = cart.first;

      // Prepare product array for API
      List<Map<String, dynamic>> productArray = cart.map((item) {
        Map<String, dynamic> productData = {
          'product_id': item['product_id'],
          'quantity': item['quantity'],
        };

        // Add variant_id only if it exists
        if (item['variant_id'] != null) {
          productData['variant_id'] = item['variant_id'];
        }

        return productData;
      }).toList();

      // Prepare request data
      Map<String, dynamic> requestData = {
        'salon_id': loginUser.manager?.salonId,
        'branch_id': loginUser.manager?.branchId?.sId,
        'staff_id': firstItem['staff_id'],
        'product': productArray,
      };

      print('Submitting cart data: $requestData');

      final response = await dioClient.postData<Map<String, dynamic>>(
        '${Apis.baseUrl}${Endpoints.inHouseProduct}',
        requestData,
        (json) => json,
      );

      if (response != null) {
        print('Cart submission successful: $response');

        // Clear all controllers after successful submission
        clearAllControllers();

        // Refresh the InhouseproductController data before navigating back
        final inhouseController = Get.find<ManagerInHouseCOntroller>();
        inhouseController.getInhouseProductUseageData();

        return true;
      } else {
        CustomSnackbar.showError('Error', 'Failed to submit products');
        return false;
      }
    } catch (e) {
      print('Error submitting cart: $e');
      CustomSnackbar.showError('Error', 'Failed to submit products: $e');
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> filterByBarcode() async {
    try {
      var result = await BarcodeScanner.scan();
      if (result.type == ResultType.Barcode && result.rawContent.isNotEmpty) {
        final scannedSku = result.rawContent;
        // Filter products by SKU
        final filteredProducts = _allProducts.where((product) {
          // Check main product SKU
          if (product['sku'] == scannedSku) {
            return true;
          }
          // Check variant SKUs if product has variations
          if (product['has_variations'] == 1 && product['variants'] != null) {
            final variants = product['variants'] as List;
            return variants.any((variant) => variant['sku'] == scannedSku);
          }
          return false;
        }).toList();
        if (filteredProducts.isNotEmpty) {
          products.value = filteredProducts;
          // If only one product, select it
          if (filteredProducts.length == 1) {
            selectedProduct.value = filteredProducts.first;
            // If it has variations, auto-select the matching variant
            if (filteredProducts.first['has_variations'] == 1 &&
                filteredProducts.first['variants'] != null) {
              final variants = filteredProducts.first['variants'] as List;
              final matchingVariant = variants
                  .firstWhereOrNull((variant) => variant['sku'] == scannedSku);
              if (matchingVariant != null) {
                selectedVariant.value = matchingVariant;
              } else {
                selectedVariant.value = null;
              }
            } else {
              selectedVariant.value = null;
            }
          }
          Get.snackbar(
            'Success',
            'Found ${filteredProducts.length} product(s) with barcode: $scannedSku',
            backgroundColor: Theme.of(Get.context!).colorScheme.primary,
            colorText: Theme.of(Get.context!).colorScheme.onPrimary,
          );
        } else {
          CustomSnackbar.showError(
            'Not Found',
            'No product found with barcode: $scannedSku',
          );
        }
      }
    } catch (e) {
      CustomSnackbar.showError(
        'Error',
        'Failed to scan barcode: $e',
      );
    }
  }

  void resetProductFilter() {
    products.value = _allProducts;
  }
}
