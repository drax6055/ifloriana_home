import 'package:flutter/material.dart';
import 'package:flutter_template/ui/drawer/products/variations/get/variationGetController.dart';
import 'package:get/get.dart';
import '../../../../../route/app_route.dart';
import '../../../../../utils/colors.dart';
import '../update_variation_screen.dart';

class VariationGetscreen extends StatelessWidget {
  VariationGetscreen({super.key});
  final VariationGetcontroller getController =
      Get.put(VariationGetcontroller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Variations'),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: RefreshIndicator(onRefresh: () async {
          getController.getVariation();
        }, child: Obx(() {
          if (getController.variations.isEmpty) {
            return Center(child: Text('No variations found'));
          }
          return ListView.builder(
            itemCount: getController.variations.length,
            itemBuilder: (context, index) {
              final variation = getController.variations[index];
              final branchNames =
                  variation.branchId?.map((b) => b.name).join(', ') ?? '';
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(variation.name ?? ''),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Type: ${variation.type ?? ''}'),
                      Text('Values: ${variation.value?.join(", ") ?? ''}'),
                      Text('Branches: $branchNames'),
                      Text(
                          'Status: ${variation.status == 1 ? 'Active' : 'Inactive'}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Get.to(() => UpdateVariationscreen(
                              variationToEdit: variation));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          getController.deleteVariation(variation.sId ?? '');
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        })),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.addVariationscreen);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
