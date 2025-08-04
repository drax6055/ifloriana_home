import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/commen_items/commen_class.dart';
import 'package:flutter_template/ui/drawer/udpate_salon_details/udpateSalon_controller.dart';
import 'package:flutter_template/utils/colors.dart';
import 'package:flutter_template/utils/validation.dart';
import 'package:flutter_template/wiget/Custome_button.dart';
import 'package:flutter_template/wiget/Custome_textfield.dart';
import 'package:flutter_template/wiget/custome_dropdown.dart';
import 'package:get/get.dart';
import 'package:step_progress/step_progress.dart';

class UpdatesalonScreen extends StatelessWidget {
  final bool showAppBar;
  UpdatesalonScreen({super.key, this.showAppBar = true});
  final UdpatesalonController getController = Get.put(UdpatesalonController());

  final _formKey = GlobalKey<FormState>();

  Widget _stepForm(int step, BuildContext context) {
    switch (step) {
      case 0:
        return Case1();

      case 1:
        return Case2();
      case 2:
        return Case3(context);

      default:
        return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  spacing: 30.h,
                  children: [
                    Obx(() => StepProgress(
                          totalSteps: 3,
                          currentStep: getController.currentStep.value,
                          stepSize: 24,
                          nodeTitles: const [
                            "Owner's Info",
                            "Salon's Info",
                            "Extra Infor",
                          ],
                          padding: const EdgeInsets.all(18),
                          theme: const StepProgressThemeData(
                            shape: StepNodeShape.diamond,
                            activeForegroundColor: primaryColor,
                            defaultForegroundColor: secondaryColor,
                            stepLineSpacing: 18,
                            stepLineStyle: StepLineStyle(
                              borderRadius: Radius.circular(4),
                            ),
                            nodeLabelStyle: StepLabelStyle(
                              margin: EdgeInsets.only(bottom: 6),
                            ),
                            stepNodeStyle: StepNodeStyle(
                              activeIcon: null,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(6),
                                ),
                              ),
                            ),
                          ),
                        )),
                    Obx(() =>
                        _stepForm(getController.currentStep.value, context)),
                    Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(width: 5.w),
                            if (getController.currentStep.value > 0)
                              Expanded(
                                child: ElevatedButtonExample(
                                  text: "Back",
                                  onPressed: getController.previousStep,
                                  height: 35.h,
                                ),
                              ),
                            if (getController.currentStep.value > 0)
                              SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButtonExample(
                                height: 35.h,
                                text: getController.currentStep.value == 2
                                    ? 'Update Details'
                                    : 'Next',
                                onPressed: () {
                                  if (getController.currentStep.value < 2) {
                                    getController.nextStep();
                                  } else {
                                    getController.onupdateClick();
                                  }
                                },
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget Case1() {
    return Column(
      spacing: 15.h,
      children: [
        Imagepicker(),
        InputTxtfield_fullName(),
        InputTxtfield_Email(),
      ],
    );
  }

  Widget Case2() {
    return Column(
      spacing: 15.h,
      children: [
        InputTxtfield_Phone(),
        InputTxtfield_add(),
      ],
    );
  }

  Widget Case3(BuildContext context) {
    return Column(
      spacing: 15.h,
      children: [
        InputTxtfield_discription(),
        Row(
          children: [
            Expanded(child: opening_time(context)),
            SizedBox(width: 10.w),
            Expanded(child: closeing_time(context)),
          ],
        ),
        category(),
      ],
    );
  }

  Widget Imagepicker() {
    return Obx(() {
      return GestureDetector(
        onTap: () => pickImage(isMultiple: false),
        child: Container(
          height: 120.h,
          width: 120.w,
          decoration: BoxDecoration(
            border: Border.all(
              color: primaryColor,
              width: 1,
            ),
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
              : Icon(
                  Icons.image_rounded,
                  color: primaryColor,
                  size: 30.sp,
                ),
        ),
      );
    });
  }

  Widget InputTxtfield_fullName() {
    return CustomTextFormField(
      controller: getController.fullnameController,
      labelText: "Name",
      keyboardType: TextInputType.text,
      validator: (value) => Validation.validatename(value),
    );
  }

  Widget InputTxtfield_Email() {
    return CustomTextFormField(
      controller: getController.emailController,
      labelText: "Email",
      keyboardType: TextInputType.emailAddress,
      validator: (value) => Validation.validateEmail(value),
    );
  }

  Widget InputTxtfield_Phone() {
    return CustomTextFormField(
      controller: getController.phoneController,
      labelText: "Contect Number",
      keyboardType: TextInputType.phone,
      validator: (value) => Validation.validatePhone(value),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
    );
  }

  Widget InputTxtfield_add() {
    return CustomTextFormField(
      controller: getController.addressController,
      labelText: 'Address',
      maxLines: 2,
      keyboardType: TextInputType.text,
      validator: (value) => Validation.validateAddress(value),
    );
  }

  Widget InputTxtfield_discription() {
    return CustomTextFormField(
      controller: getController.descriptionController,
      labelText: 'Description',
      maxLines: 2,
      keyboardType: TextInputType.text,
      validator: (value) => Validation.validatedisscription(value),
    );
  }

  Widget opening_time(BuildContext context) {
    return CustomTextFormField(
      controller: getController.opentimeController,
      labelText: 'Opening Time',
      keyboardType: TextInputType.none,
      validator: (value) => Validation.validateTime(value),
      suffixIcon: IconButton(
        onPressed: () async {
          TimeOfDay initialTime = TimeOfDay.now();
          TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: initialTime,
          );
          if (pickedTime != null) {
            String formattedTime = formatTimeToString(pickedTime);
            getController.opentimeController.text = formattedTime;
          }
        },
        icon: Icon(Icons.access_time),
      ),
    );
  }

  Widget closeing_time(BuildContext context) {
    return CustomTextFormField(
      controller: getController.closetimeController,
      labelText: 'Closeing Time',
      keyboardType: TextInputType.none,
      validator: (value) => Validation.validateTime(value),
      suffixIcon: IconButton(
        onPressed: () async {
          TimeOfDay initialTime = TimeOfDay.now();
          TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: initialTime,
          );
          if (pickedTime != null) {
            String formattedTime = formatTimeToString(pickedTime);
            getController.closetimeController.text = formattedTime;
          }
        },
        icon: Icon(Icons.access_time),
      ),
    );
  }

  Widget category() {
    return Obx(() => CustomDropdown<String>(
          value: getController.selectedcategory.value.isEmpty
              ? null
              : getController.selectedcategory.value,
          items: getController.dropdownItems,
          hintText: 'Select an option',
          labelText: 'Category',
          onChanged: (newValue) {
            if (newValue != null) {
              getController.selectedcategory(newValue);
            }
          },
        ));
  }
}
