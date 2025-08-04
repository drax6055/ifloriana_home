import 'package:flutter/material.dart';
import 'package:flutter_template/route/app_route.dart';
import 'package:get/get.dart';
import 'dart:math';

import 'product_list_controller.dart';
import 'product_list_model.dart';
import 'update_stock_sheet.dart';

class ProductListScreen extends StatelessWidget {
  final ProductListController controller = Get.put(ProductListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt, color: Colors.black),
            tooltip: 'Filter by Barcode',
            onPressed: () => controller.filterByBarcode(),
          ),
          IconButton(
            icon: Icon(Icons.clear, color: Colors.black),
            tooltip: 'Clear Filter',
            onPressed: () => controller.resetFilter(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              color: Colors.white,
              child: DataTable(
                columns: _createColumns(),
                rows: _createRows(),
                columnSpacing: 30,
                horizontalMargin: 16,
              ),
            ),
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.addProductScreen);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn(
          label: Text("Product",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
      DataColumn(
          label: Text("Brand",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
      DataColumn(
          label: Text("Category",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
      DataColumn(
          label: Text("Price",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
      DataColumn(
          label: Text("Quantity",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
      DataColumn(
          label: Text("Status",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
      DataColumn(
          label: Text("Action",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
    ];
  }

  List<DataRow> _createRows() {
    return controller.productList
        .map((product) => DataRow(cells: [
              DataCell(_ProductListItem(product: product)._buildProductInfo()),
              DataCell(Text(product.brandId?.name ?? 'N/A',
                  style: TextStyle(color: Colors.black))),
              DataCell(Text(product.categoryId?.name ?? 'N/A',
                  style: TextStyle(color: Colors.black))),
              DataCell(Text(_ProductListItem(product: product).getPrice(),
                  style: TextStyle(color: Colors.black))),
              DataCell(Text(_ProductListItem(product: product).getQuantity(),
                  style: TextStyle(color: Colors.black))),
              DataCell(_ProductListItem(product: product)._buildStatus()),
              DataCell(_buildActionButtons(Get.context!, product)),
            ]))
        .toList();
  }

  Widget _buildActionButtons(BuildContext context, Product product) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            Get.bottomSheet(
              UpdateStockSheet(product: product),
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.brown[400],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text('+ Stock',
                style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
        ),
        IconButton(
          icon: Icon(Icons.edit, color: Colors.blue),
          onPressed: () {
            Get.toNamed(Routes.addProductScreen, arguments: product);
          },
        ),
        IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              controller.deleteProduct(product.id);
            }),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border(bottom: BorderSide(color: Colors.grey[300]!))),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Text("Product",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold))),
          Expanded(
              flex: 2,
              child: Text("Brand",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold))),
          Expanded(
              flex: 2,
              child: Text("Category",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold))),
          Expanded(
              flex: 2,
              child: Text("Price",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold))),
          Expanded(
              flex: 2,
              child: Text("Quantity",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold))),
          Expanded(
              flex: 1,
              child: Text("Status",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold))),
          Expanded(
              flex: 2,
              child: Text("Action",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}

class _ProductListItem extends StatelessWidget {
  final Product product;

  const _ProductListItem({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This widget is now only used for its helper methods.
    // The actual row is built in _createRows.
    return Container();
  }

  Widget _buildProductInfo() {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.amberAccent,
          // backgroundImage: NetworkImage(product.image),
          radius: 20,
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            product.productName,
            style: TextStyle(color: Colors.black),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStatus() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: product.status == 1 ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        product.status == 1 ? 'Active' : 'Inactive',
        style: TextStyle(color: Colors.white, fontSize: 12),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    // This method is now in ProductListScreen
    return Container();
  }

  String getPrice() {
    if (product.hasVariations == 1 && product.variants.isNotEmpty) {
      final prices = product.variants.map((v) => v.price).toList();
      final minPrice = prices.reduce(min);
      final maxPrice = prices.reduce(max);
      if (minPrice == maxPrice) {
        return '₹ $minPrice';
      }
      return '₹ $minPrice - $maxPrice';
    } else {
      return '₹ ${product.price ?? 0}';
    }
  }

  String getQuantity() {
    if (product.hasVariations == 1 && product.variants.isNotEmpty) {
      return product.variants
          .map((v) => v.stock)
          .reduce((a, b) => a + b)
          .toString();
    } else {
      return product.stock?.toString() ?? '0';
    }
  }
}
