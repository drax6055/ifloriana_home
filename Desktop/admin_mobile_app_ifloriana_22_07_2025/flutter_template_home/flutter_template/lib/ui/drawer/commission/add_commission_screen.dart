import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../wiget/custome_snackbar.dart';
import 'add_commission_controller.dart';
import 'package:flutter_template/network/model/branch_model.dart';

class AddCommissionScreen extends StatelessWidget {
  final AddCommissionController controller = Get.put(AddCommissionController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            title: Text(controller.editingId != null
                ? 'Edit Commission'
                : 'Add Commission'),
          ),
          body: controller.isLoading.value
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        return DropdownButtonFormField<BranchModel>(
                          value: controller.selectedBranch.value,
                          decoration: InputDecoration(
                            labelText: "Select Branch",
                            border: OutlineInputBorder(),
                          ),
                          items:
                              controller.branchList.map((BranchModel branch) {
                            return DropdownMenuItem<BranchModel>(
                              value: branch,
                              child: Text(branch.name),
                            );
                          }).toList(),
                          onChanged: (BranchModel? newValue) {
                            if (newValue != null) {
                              controller.selectedBranch.value = newValue;
                              CustomSnackbar.showSuccess(
                                'Branch Selected',
                                'ID: ${newValue.id}',
                              );
                            }
                          },
                        );
                      }),
                      SizedBox(height: 16),
                      // Commission Name
                      TextFormField(
                        controller: controller.commissionNameController,
                        decoration:
                            InputDecoration(labelText: 'Commission Name *'),
                      ),
                      SizedBox(height: 16),
                      // Commission Type Dropdown
                      DropdownButtonFormField<String>(
                        value: controller.commissionType.value.isEmpty
                            ? null
                            : controller.commissionType.value,
                        items: controller.commissionTypeOptions
                            .map((type) => DropdownMenuItem(
                                value: type, child: Text(type)))
                            .toList(),
                        onChanged: (val) =>
                            controller.commissionType.value = val ?? '',
                        decoration:
                            InputDecoration(labelText: 'Commission Type *'),
                      ),
                      SizedBox(height: 24),
                      Text('Slots',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      ...List.generate(controller.slots.length, (index) {
                        final slot = controller.slots[index];
                        return Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                initialValue: slot.slot,
                                decoration: InputDecoration(
                                    labelText: 'Slot *',
                                    hintText: 'Ex: 1000-1999'),
                                onChanged: (val) => slot.slot = val,
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                initialValue: slot.amount,
                                decoration: InputDecoration(
                                    labelText: 'Amount *', hintText: 'Ex: 5'),
                                onChanged: (val) => slot.amount = val,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => controller.removeSlot(index),
                            ),
                          ],
                        );
                      }),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: controller.addSlot,
                        child: Text('+ Add Slot'),
                      ),
                      SizedBox(height: 24),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: controller.postCommission,
                            child: Text(controller.editingId != null
                                ? 'Update Commission'
                                : 'Add Commission'),
                          ),
                          SizedBox(width: 16),
                          
                        ],
                      ),
                    ],
                  ),
                ),
        ));
  }
}
