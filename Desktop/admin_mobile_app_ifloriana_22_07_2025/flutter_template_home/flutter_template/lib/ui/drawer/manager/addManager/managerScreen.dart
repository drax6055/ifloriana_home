import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/ui/drawer/manager/addManager/managerController.dart';
import 'package:flutter_template/utils/validation.dart';
import 'package:flutter_template/wiget/Custome_button.dart';
import 'package:flutter_template/wiget/Custome_textfield.dart';
import 'package:flutter_template/wiget/appbar/commen_appbar.dart';
import 'package:flutter_template/wiget/custome_dropdown.dart';
import 'package:flutter_template/wiget/custome_snackbar.dart';
import 'package:get/get.dart';
import 'package:flutter_template/ui/drawer/manager/getManager/getmanagerController.dart';

import '../../../../utils/colors.dart';

class Managerscreen extends StatelessWidget {
  final Manager? manager;
  Managerscreen({super.key, this.manager});
  final Managercontroller getController = Get.put(Managercontroller());

  void prefillFields() {
    if (manager != null) {
      getController.fullNameController.text = manager!.full_name;
      // getController.lastNameController.text = manager!.lastName;
      getController.emailController.text = manager!.email;
      getController.contactNumberController.text = manager!.contactNumber;
      getController.passwordController.text = manager!.password;
      getController.confirmPasswordController.text = manager!.password;
      // No gender field in Manager model, so skip gender prefill
      // Branch prefill can be handled after branchList is loaded
      if (manager!.branchId != null) {
        ever(getController.branchList, (_) {
          final branch = getController.branchList
              .firstWhereOrNull((b) => b.id == manager!.branchId);
          if (branch != null) {
            getController.selectedBranch.value = branch;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    prefillFields();
    return Scaffold(
        appBar: CustomAppBar(
          title: "done",
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                spacing: 10,
                children: [
                  SizedBox(
                    height: 1.h,
                  ),
                  InputTxtfield_firstName(),
                  InputTxtfield_Email(),
                  InputTxtfield_Phone(),
                  InputTxtfield_password(),
                  InputTxtfield_confirmPassword(),
                  Gender(),
                  branchDropdown(),
                  Btn_saveManager(context),
                ],
              )),
        ));
  }

  Widget Gender() {
    return Obx(() => CustomDropdown<String>(
          value: getController.selectedGender.value.isEmpty
              ? null
              : getController.selectedGender.value,
          items: getController.dropdownItems,
          hintText: 'Gender',
          labelText: 'Gender',
          onChanged: (newValue) {
            if (newValue != null) {
              getController.selectedGender(newValue);
            }
          },
        ));
  }

  Widget InputTxtfield_firstName() {
    return CustomTextFormField(
      controller: getController.fullNameController,
      labelText: "Full Name",
      keyboardType: TextInputType.text,
      validator: (value) => Validation.validatename(value),
    );
  }

  Widget InputTxtfield_lastName() {
    return CustomTextFormField(
      controller: getController.lastNameController,
      labelText: "Last Name",
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
      controller: getController.contactNumberController,
      labelText: "Contact Number",
      keyboardType: TextInputType.phone,
      validator: (value) => Validation.validatePhone(value),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
    );
  }

  Widget InputTxtfield_password() {
    return Obx(() => CustomTextFormField(
          controller: getController.passwordController,
          labelText: 'Password',
          obscureText: !getController.showPassword.value,
          suffixIcon: IconButton(
            onPressed: () {
              getController.toggleShowPassword();
            },
            icon: Icon(
              getController.showPassword.value
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: grey,
            ),
          ),
          validator: (value) => Validation.validatePassword(value),
        ));
  }

  Widget InputTxtfield_confirmPassword() {
    return Obx(() => CustomTextFormField(
          controller: getController.confirmPasswordController,
          labelText: 'Confirm Password',
          obscureText: !getController.showConfirmPassword.value,
          suffixIcon: IconButton(
            onPressed: () {
              getController.toggleShowConfirmPass();
            },
            icon: Icon(
              getController.showConfirmPassword.value
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: grey,
            ),
          ),
          validator: (value) => Validation.validatePassword(value),
        ));
  }

  Widget branchDropdown() {
    return Obx(() {
      return DropdownButton<Branch>(
        value: getController.selectedBranch.value,
        hint: Text("Select Branch"),
        items: getController.branchList.map((Branch branch) {
          return DropdownMenuItem<Branch>(
            value: branch,
            child: Text(branch.name ?? ''),
          );
        }).toList(),
        onChanged: (Branch? newValue) {
          if (newValue != null) {
            getController.selectedBranch.value = newValue;

            CustomSnackbar.showSuccess(
              'Branch Selected',
              'ID: ${newValue.id}',
            );
          }
        },
      );
    });
  }
// Widget branchDropdown() {
//     return Obx(() {
//       return DropdownButtonFormField<Branch>(
//         value: getController.selectedBranch.value,
//         decoration: InputDecoration(
//           labelText: "Select Branch",
//           border: OutlineInputBorder(),
//         ),
//         items: getController.branchList.map((Branch branch) {
//           return DropdownMenuItem<Branch>(
//             value: branch,
//             child: Text(branch.name ?? ''),
//           );
//         }).toList(),
//         onChanged: (Branch? newValue) {
//           if (newValue != null) {
//             getController.selectedBranch.value = newValue;

//             CustomSnackbar.showSuccess(
//               'Branch Selected',
//               'ID: ${newValue.id}',
//             );
//           }
//         },
//       );
//     });
//   }

  Widget Btn_saveManager(BuildContext context) {
    return ElevatedButtonExample(
      text: manager == null ? "Add Manager" : "Save Changes",
      onPressed: () async {
        if (manager == null) {
          await getController.onManagerAdd();
        } else {
          await getController.updateManager(manager!.id);
        }
        Navigator.of(context).pop();
      },
    );
  }
}
