import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/commen_items/commen_class.dart';
import 'package:flutter_template/ui/drawer/coupons/addNewCoupon/addCouponController.dart';
import 'package:flutter_template/utils/colors.dart';
import 'package:flutter_template/utils/custom_text_styles.dart';
import 'package:flutter_template/utils/validation.dart';
import 'package:flutter_template/wiget/Custome_button.dart';
import 'package:flutter_template/wiget/Custome_textfield.dart';
import 'package:flutter_template/wiget/custome_dropdown.dart';
import 'package:flutter_template/wiget/custome_text.dart';
import 'package:get/get.dart';

class AddCouponScreen extends StatelessWidget {
  AddCouponScreen({super.key});
  final Addcouponcontroller getController = Get.put(Addcouponcontroller());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          spacing: 10,
          children: [
            CustomTextFormField(
              controller: getController.nameController,
              labelText: 'Name',
              keyboardType: TextInputType.text,
              validator: (value) => Validation.validatename(value),
            ),
            CustomTextFormField(
              controller: getController.descriptionController,
              labelText: 'Description',
              maxLines: 2,
              keyboardType: TextInputType.text,
              validator: (value) => Validation.validatedisscription(value),
            ),
            Row(
              children: [
                Expanded(child: coupon_type()),
                SizedBox(
                  width: 5,
                ),
                Expanded(child: discount_type()),
              ],
            ),
            Row(
              children: [
                Expanded(child: startTime(context)),
                SizedBox(
                  width: 5,
                ),
                Expanded(child: endTime(context)),
              ],
            ),
            branchChips(),
            CustomTextFormField(
              controller: getController.coponCodeController,
              labelText: 'Coupon Code',
              keyboardType: TextInputType.text,
              validator: (value) => Validation.validateisBlanck(value),
            ),
            CustomTextFormField(
              controller: getController.discountAmtController,
              labelText: 'Discount Amount',
              keyboardType: TextInputType.number,
              validator: (value) => Validation.validateisBlanck(value),
            ),
            CustomTextFormField(
              controller: getController.userLimitController,
              labelText: 'Use Limit',
              keyboardType: TextInputType.number,
              validator: (value) => Validation.validateisBlanck(value),
            ),
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextWidget(
                      text: 'Status',
                      textStyle: CustomTextStyles.textFontRegular(size: 14.sp),
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
            Btn_Coupons(),
          ],
        ),
      ),
    ));
  }

  Widget coupon_type() {
    return Obx(() => CustomDropdown<String>(
          value: getController.selectedCouponType.value.isEmpty
              ? null
              : getController.selectedCouponType.value,
          items: getController.dropdownCouponTypeItem,
          hintText: 'Coupon type',
          labelText: 'Coupon type',
          onChanged: (newValue) {
            if (newValue != null) {
              getController.selectedCouponType(newValue);
            }
          },
        ));
  }

  Widget discount_type() {
    return Obx(() => CustomDropdown<String>(
          value: getController.selectedDiscountType.value.isEmpty
              ? null
              : getController.selectedDiscountType.value,
          items: getController.dropdownDiscountTypeItem,
          hintText: 'Discount Type',
          labelText: 'Discount Type',
          onChanged: (newValue) {
            if (newValue != null) {
              getController.selectedDiscountType(newValue);
            }
          },
        ));
  }

  Widget startTime(BuildContext context) {
    return CustomTextFormField(
      controller: getController.StarttimeController,
      labelText: 'Start Time',
      keyboardType: TextInputType.none,
      validator: (value) => Validation.validateTime(value),
      suffixIcon: IconButton(
        onPressed: () async {
          await pickAndSetDate(
            context: context,
            controller: getController.StarttimeController,
          );
        },
        icon: Icon(Icons.calendar_today),
      ),
    );
  }

  Widget endTime(BuildContext context) {
    return CustomTextFormField(
      controller: getController.EndtimeController,
      labelText: 'End Time',
      keyboardType: TextInputType.none,
      validator: (value) => Validation.validateTime(value),
      suffixIcon: IconButton(
        onPressed: () async {
          await pickAndSetDate(
            context: context,
            controller: getController.EndtimeController,
          );
        },
        icon: Icon(Icons.calendar_today),
      ),
    );
  }

  Widget branchChips() {
    return Obx(() {
      return Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: [
          FilterChip(
            label:
                Text(getController.allSelected ? 'Deselect All' : 'Select All'),
            selected: getController.allSelected,
            onSelected: (selected) {
              if (selected) {
                getController.selectedBranches
                    .assignAll(getController.branchList);
              } else {
                getController.selectedBranches.clear();
              }
            },
            selectedColor: primaryColor.withOpacity(0.2),
          ),
          ...getController.branchList.map((branch) {
            final isSelected =
                getController.selectedBranches.any((b) => b.id == branch.id);
            return FilterChip(
              label: Text(branch.name ?? ''),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  if (!getController.selectedBranches
                      .any((b) => b.id == branch.id)) {
                    getController.selectedBranches.add(branch);
                  }
                } else {
                  getController.selectedBranches
                      .removeWhere((b) => b.id == branch.id);
                }
              },
              selectedColor: primaryColor.withOpacity(0.2),
            );
          }).toList(),
        ],
      );
    });
  }

  Widget Btn_Coupons() {
    return ElevatedButtonExample(
      text: "Add Coupons",
      onPressed: () {
        getController.onCoupons();
      },
    );
  }
}
