import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/ui/drawer/products/brand/getBrandsController.dart';
import 'package:flutter_template/utils/colors.dart';
import 'package:get/get.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import '../../../../../commen_items/commen_class.dart';
import '../../../../../utils/custom_text_styles.dart';
import '../../../../../utils/validation.dart';
import '../../../../../wiget/Custome_button.dart';
import '../../../../../wiget/Custome_textfield.dart';
import '../../../../../wiget/custome_text.dart';
import '../../../../network/network_const.dart';
import '../../../../wiget/appbar/commen_appbar.dart';
import '../../../../wiget/loading.dart';
import '../../../../network/model/brand.dart';

class Getbrandsscreen extends StatelessWidget {
  Getbrandsscreen({super.key});
  final Getbrandscontroller getController = Get.put(Getbrandscontroller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Brands',
      ),
      body: Container(
          child: RefreshIndicator(
              onRefresh: () async {
                getController.getBrands();
              },
              child: Obx(
                () => getController.isLoading.value
                    ? const Center(child: CustomLoadingAvatar())
                    : ListView.builder(
                        itemCount: getController.brands.length,
                        itemBuilder: (context, index) {
                          final brand = getController.brands[index];
                          return Container(
                            // decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(10),
                            //     border: Border(
                            //         right: BorderSide(
                            //             color: secondaryColor, width: 3))),
                            // margin: const EdgeInsets.symmetric(
                            //     horizontal: 16, vertical: 8),
                            child: ListTile(
                              leading: brand.image.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network( 
                                        '${Apis.pdfUrl}${brand.image}',
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: const Icon(
                                                Icons.image_not_supported),
                                          );
                                        },
                                      ),
                                    )
                                  : Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child:
                                          const Icon(Icons.image_not_supported),
                                    ),
                              title: Text(
                                brand.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text(
                                'Branches: ${brand.branchId.length}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      icon: const Icon(Icons.edit_outlined,
                                          color: primaryColor),
                                      onPressed: () {
                                        showEditBrandSheet(context, brand);
                                      }),
                                  IconButton(
                                      icon: const Icon(Icons.delete_outline),
                                      color: primaryColor,
                                      onPressed: () =>
                                          getController.deleteBrand(brand.id)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddCategorySheet(context);
        },
        child: Icon(Icons.add, color: white),
        backgroundColor: primaryColor,
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
                  Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: Imagepicker(),
                      ),
                      Expanded(
                        flex: 3,
                        child: CustomTextFormField(
                          controller: getController.nameController,
                          labelText: 'Name',
                          keyboardType: TextInputType.text,
                          validator: (value) => Validation.validatename(value),
                        ),
                      )
                    ],
                  ),
                  branchDropdown(),
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
                  Btn_BranchesAdd(),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        });
  }

  void showEditBrandSheet(BuildContext context, Brand brand) async {
    getController.nameController.text = brand.name;
    getController.isActive.value = brand.status == 1;
    final selectedBranches = getController.branchList
        .where((b) => brand.branchId.any((cb) => cb.id == b.id))
        .toList();
    getController.selectedBranches.value = selectedBranches;
    getController.branchController.clearAll();

    // Reset image selection for editing
    singleImage.value = null;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getController.branchController
          .selectWhere((item) => selectedBranches.contains(item.value));
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
                  Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: Imagepicker(),
                      ),
                      Expanded(
                        flex: 3,
                        child: CustomTextFormField(
                          controller: getController.nameController,
                          labelText: 'Name',
                          keyboardType: TextInputType.text,
                          validator: (value) => Validation.validatename(value),
                        ),
                      )
                    ],
                  ),
                  branchDropdown(),
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
                  ElevatedButtonExample(
                    text: "Update Brand",
                    onPressed: () {
                      getController.updateBrand(brand.id);
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

  Widget Imagepicker() {
    return Obx(() {
      return GestureDetector(
        onTap: () => pickImage(isMultiple: false),
        child: Container(
          height: 51.h,
          decoration: BoxDecoration(
            border: Border.all(color: primaryColor),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10.r),
            color: secondaryColor.withOpacity(0.2),
          ),
          child: singleImage.value != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: Image.file(
                    singleImage.value!,
                    fit: BoxFit.cover,
                  ),
                )
              : Icon(Icons.image_rounded, color: primaryColor, size: 30.sp),
        ),
      );
    });
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

  Widget Btn_BranchesAdd() {
    return ElevatedButtonExample(
      text: "Add Brand",
      onPressed: () {
        getController.onAddBranch();
      },
    );
  }
}
