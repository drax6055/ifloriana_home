import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/ui/drawer/branches/post_branches_screena.dart/postBranchescontroller.dart';
import 'package:flutter_template/utils/colors.dart';
import 'package:flutter_template/utils/custom_text_styles.dart';
import 'package:flutter_template/utils/validation.dart';
import 'package:flutter_template/wiget/Custome_button.dart';
import 'package:flutter_template/wiget/Custome_textfield.dart';
import 'package:flutter_template/wiget/appbar/commen_appbar.dart';
import 'package:flutter_template/wiget/custome_dropdown.dart';
import 'package:flutter_template/wiget/custome_text.dart';
import 'package:get/get.dart';

class Postbranchesscreen extends StatelessWidget {
  Postbranchesscreen({super.key});
  final Postbranchescontroller getController =
      Get.put(Postbranchescontroller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "title"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 10,
            children: [
              SizedBox(
                height: 1.h,
              ),
              CustomTextFormField(
                controller: getController.nameController,
                labelText: 'Name',
                keyboardType: TextInputType.text,
                validator: (value) => Validation.validatename(value),
              ),
              Category(),
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
              CustomTextFormField(
                controller: getController.contactEmailController,
                labelText: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) => Validation.validateEmail(value),
              ),
              CustomTextFormField(
                controller: getController.contactNumberController,
                labelText: 'Number',
                keyboardType: TextInputType.number,
                validator: (value) => Validation.validatePhone(value),
              ),
              paymentMethodChipView(),
              serviceDropdown(),
              CustomTextFormField(
                controller: getController.addressController,
                labelText: 'Address',
                maxLines: 2,
                keyboardType: TextInputType.text,
                validator: (value) => Validation.validateAddress(value),
              ),
              CustomTextFormField(
                controller: getController.discriptionController,
                labelText: 'Discription',
                maxLines: 2,
                keyboardType: TextInputType.text,
                validator: (value) => Validation.validatedisscription(value),
              ),
              CustomTextFormField(
                controller: getController.landmarkController,
                labelText: 'Landmark',
                keyboardType: TextInputType.text,
              ),
              CustomTextFormField(
                controller: getController.countryController,
                labelText: 'Country',
                keyboardType: TextInputType.text,
              ),
              CustomTextFormField(
                controller: getController.stateController,
                labelText: 'State',
                keyboardType: TextInputType.text,
              ),
              CustomTextFormField(
                controller: getController.cityController,
                labelText: 'City',
                keyboardType: TextInputType.text,
              ),
              CustomTextFormField(
                controller: getController.postalCodeController,
                labelText: 'Postal Code',
                keyboardType: TextInputType.text,
              ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: Obx(() => CustomTextFormField(
              //             controller: getController.latController
              //               ..text = getController.latitude.value,
              //             labelText: 'Latitude',
              //             suffixIcon: IconButton(
              //               icon: Icon(Icons.gps_fixed),
              //               onPressed: () async {
              //                 await getController.fetchLocation();
              //               },
              //             ),
              //           )),
              //     ),
              //     SizedBox(
              //       width: 5.w,
              //     ),
              //     Expanded(
              //       child: Obx(() => CustomTextFormField(
              //             controller: getController.lngController
              //               ..text = getController.longitude.value,
              //             labelText: 'Longitude',
              //             suffixIcon: IconButton(
              //               icon: Icon(Icons.gps_fixed),
              //               onPressed: () async {
              //                 await getController.fetchLocation();
              //               },
              //             ),
              //           )),
              //     ),
              //   ],
              // ),
              Btn_addBranch()
            ],
          ),
        ),
      ),
    );
  }

  Widget Category() {
    return Obx(() => CustomDropdown<String>(
          value: getController.selectedCategory.value.isEmpty
              ? null
              : getController.selectedCategory.value,
          items: getController.dropdownItemSelectedCategory,
          hintText: 'Category',
          labelText: 'Category',
          onChanged: (newValue) {
            if (newValue != null) {
              getController.selectedCategory(newValue);
            }
          },
        ));
  }

  Widget serviceDropdown() {
    return Obx(() {
      final allSelected = getController.selectedServices.length ==
              getController.serviceList.length &&
          getController.serviceList.isNotEmpty;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints:
                BoxConstraints(maxHeight: 120, minWidth: double.infinity),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: [
                    // Select All / Deselect All Chip
                    FilterChip(
                      label: Text(allSelected ? 'Deselect All' : 'Select All'),
                      selected: allSelected,
                      onSelected: (selected) {
                        if (selected) {
                          getController.selectedServices
                              .assignAll(getController.serviceList);
                        } else {
                          getController.selectedServices.clear();
                        }
                      },
                      disabledColor: secondaryColor.withOpacity(0.2),
                      selectedColor: primaryColor.withOpacity(0.2),
                      checkmarkColor: primaryColor,
                    ),

                    // Service Chips
                    ...getController.serviceList.map((service) {
                      final isSelected =
                          getController.selectedServices.contains(service);
                      return FilterChip(
                        label: Text(service.name ?? ''),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            getController.selectedServices.add(service);
                          } else {
                            getController.selectedServices.remove(service);
                          }
                        },
                        selectedColor: primaryColor.withOpacity(0.2),
                        checkmarkColor: primaryColor,
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget Btn_addBranch() {
    return ElevatedButtonExample(
      text: "Add Branch",
      onPressed: () {
        getController.onBranchAdd();
      },
    );
  }

  Widget paymentMethodChipView() {
    return Obx(() {
      final allSelected = getController.selectedPaymentMethod.length ==
          getController.dropdownItemPaymentMethod.length;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints:
                BoxConstraints(maxHeight: 120, minWidth: double.infinity),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: [
                    // Select All chip
                    FilterChip(
                      label: Text(allSelected ? 'Deselect All' : 'Select All'),
                      selected: allSelected,
                      onSelected: (selected) {
                        if (selected) {
                          getController.selectedPaymentMethod.assignAll(
                              getController.dropdownItemPaymentMethod);
                        } else {
                          getController.selectedPaymentMethod.clear();
                        }
                      },
                      selectedColor: secondaryColor.withOpacity(0.2),
                      disabledColor: Colors.grey[200],
                      checkmarkColor: primaryColor,
                    ),

                    // Payment method chips
                    ...getController.dropdownItemPaymentMethod.map((category) {
                      final isSelected = getController.selectedPaymentMethod
                          .contains(category);
                      return FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            getController.selectedPaymentMethod.add(category);
                          } else {
                            getController.selectedPaymentMethod
                                .remove(category);
                          }
                        },
                        selectedColor: secondaryColor.withOpacity(0.2),
                        checkmarkColor: primaryColor,
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
