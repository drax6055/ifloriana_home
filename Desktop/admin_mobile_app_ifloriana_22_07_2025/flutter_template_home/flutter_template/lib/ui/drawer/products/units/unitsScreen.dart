import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/ui/drawer/products/units/unitsController.dart';
import 'package:get/get.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import '../../../../utils/colors.dart';
import '../../../../utils/custom_text_styles.dart';
import '../../../../utils/validation.dart';
import '../../../../wiget/Custome_button.dart';
import '../../../../wiget/Custome_textfield.dart';
import '../../../../wiget/custome_text.dart';

class Unitsscreen extends StatelessWidget {
  Unitsscreen({super.key});
  final Unitscontroller getController = Get.put(Unitscontroller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (getController.unitsList.isEmpty) {
          return Center(child: Text('No units found.'));
        }
        return ListView.builder(
          itemCount: getController.unitsList.length,
          itemBuilder: (context, index) {
            final unit = getController.unitsList[index];
            final branchNames = unit.branches.map((b) => b.name).join(', ');
            return ListTile(
              title: Text(unit.name ?? ''),
              subtitle: Text('Branches: ' + branchNames),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(unit.status == 1 ? 'Active' : 'Inactive'),
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      showEditUnitSheet(context, unit);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      getController.deleteUnit(unit.id!);
                    },
                  ),
                ],
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddCategorySheet(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void showAddCategorySheet(BuildContext context) {
    getController.nameController.clear();
    getController.isActive.value = true;
    getController.selectedBranches.clear();
    getController.branchController.clearAll();
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        builder: (context) {
          return Padding(
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                spacing: 10,
                children: [
                  CustomTextFormField(
                    controller: getController.nameController,
                    labelText: 'Name',
                    keyboardType: TextInputType.text,
                    validator: (value) => Validation.validatename(value),
                  ),
                  Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextWidget(
                            text: 'Status',
                            textStyle:
                                CustomTextStyles.textFontRegular(size: 14.sp),
                          ),
                          Switch(
                            value: getController.isActive.value,
                            onChanged: (value) {
                              getController.isActive.value = value;
                            },
                            activeColor: primaryColor,
                          ),
                        ],
                      )),
                  branchDropdown(),
                  Btn_SubCategoryAdd(),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        });
  }

  void showEditUnitSheet(BuildContext context, UnitModel unit) async {
    getController.nameController.text = unit.name ?? '';
    getController.isActive.value = unit.status == 1;
    final selected = getController.branchList
        .where((b) => unit.branches.any((ub) => ub.id == b.id))
        .toList();
    getController.selectedBranches.value = selected;
    getController.branchController.clearAll();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getController.branchController
          .selectWhere((item) => selected.contains(item.value));
    });
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        builder: (context) {
          return Padding(
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                spacing: 10,
                children: [
                  CustomTextFormField(
                    controller: getController.nameController,
                    labelText: 'Name',
                    keyboardType: TextInputType.text,
                    validator: (value) => Validation.validatename(value),
                  ),
                  Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextWidget(
                            text: 'Status',
                            textStyle:
                                CustomTextStyles.textFontRegular(size: 14.sp),
                          ),
                          Switch(
                            value: getController.isActive.value,
                            onChanged: (value) {
                              getController.isActive.value = value;
                            },
                            activeColor: primaryColor,
                          ),
                        ],
                      )),
                  branchDropdown(),
                  ElevatedButtonExample(
                    text: "Update Unit",
                    onPressed: () {
                      getController.updateUnit(unit.id!);
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        });
  }

  Widget Btn_SubCategoryAdd() {
    return ElevatedButtonExample(
      text: "Add Units",
      onPressed: () {
        getController.onUniteAdd();
      },
    );
  }

  Widget branchDropdown() {
    return Obx(() {
      return MultiDropdown<Branch1>(
        items: getController.branchList
            .map((branch) => DropdownItem(
                  label: branch.name ?? '',
                  value: branch,
                ))
            .toList(),
        controller: getController.branchController,
        enabled: true,
        searchEnabled: true,
        chipDecoration: const ChipDecoration(
          backgroundColor: secondaryColor,
          wrap: true,
          runSpacing: 2,
          spacing: 10,
        ),
        fieldDecoration: FieldDecoration(
          hintText: 'Select Branches',
          hintStyle: const TextStyle(color: Colors.grey),
          showClearIcon: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: secondaryColor,
            ),
          ),
        ),
        dropdownItemDecoration: DropdownItemDecoration(
          selectedIcon: const Icon(Icons.check_box, color: primaryColor),
          disabledIcon: Icon(Icons.lock, color: Colors.grey.shade300),
        ),
        onSelectionChange: (selectedItems) {
          getController.selectedBranches.value = selectedItems;
        },
      );
    });
  }
}
