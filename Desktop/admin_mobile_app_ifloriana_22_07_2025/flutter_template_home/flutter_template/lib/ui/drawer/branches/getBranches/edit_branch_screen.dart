import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../network/model/branch_model.dart';
import 'getBranchesController.dart';

class EditBranchScreen extends StatefulWidget {
  final BranchModel branch;

  const EditBranchScreen({
    Key? key,
    required this.branch,
  }) : super(key: key);

  @override
  State<EditBranchScreen> createState() => _EditBranchScreenState();
}

class _EditBranchScreenState extends State<EditBranchScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _countryController;
  late TextEditingController _postalCodeController;
  late TextEditingController _contactNumberController;
  late TextEditingController _contactEmailController;
  late TextEditingController _descriptionController;
  late TextEditingController _landmarkController;
  // late TextEditingController _latitudeController;
  // late TextEditingController _longitudeController;
  final List<String> _paymentMethods = ['cash', 'upi'];
  List<String> _selectedPaymentMethods = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.branch.name);
    _addressController = TextEditingController(text: widget.branch.address);
    _cityController = TextEditingController(text: widget.branch.city);
    _stateController = TextEditingController(text: widget.branch.state);
    _countryController = TextEditingController(text: widget.branch.country);
    _postalCodeController =
        TextEditingController(text: widget.branch.postalCode);
    _contactNumberController =
        TextEditingController(text: widget.branch.contactNumber);
    _contactEmailController =
        TextEditingController(text: widget.branch.contactEmail);
    _descriptionController =
        TextEditingController(text: widget.branch.description);
    _landmarkController = TextEditingController(text: widget.branch.landmark);
    // _latitudeController =
    //     TextEditingController(text: widget.branch.latitude.toString());
    // _longitudeController =
    //     TextEditingController(text: widget.branch.longitude.toString());
    _selectedPaymentMethods = List.from(widget.branch.paymentMethod);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _postalCodeController.dispose();
    _contactNumberController.dispose();
    _contactEmailController.dispose();
    _descriptionController.dispose();
    _landmarkController.dispose();
    // _latitudeController.dispose();
    // _longitudeController.dispose();
    super.dispose();
  }

  void _updateBranch() {
    if (_formKey.currentState!.validate()) {
      final controller = Get.find<Getbranchescontroller>();
      controller.updateBranch(
        branchId: widget.branch.id,
        name: _nameController.text,
        address: _addressController.text,
        city: _cityController.text,
        state: _stateController.text,
        country: _countryController.text,
        postalCode: _postalCodeController.text,
        contactNumber: _contactNumberController.text,
        contactEmail: _contactEmailController.text,
        description: _descriptionController.text,
        landmark: _landmarkController.text,
        // latitude: double.parse(_latitudeController.text),
        // longitude: double.parse(_longitudeController.text),
        paymentMethod: _selectedPaymentMethods,
      );
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                controller: _nameController,
                label: 'Branch Name',
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter branch name' : null,
              ),
              SizedBox(height: 16.h),
              _buildTextField(
                controller: _addressController,
                label: 'Address',
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter address' : null,
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _cityController,
                      label: 'City',
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Please enter city' : null,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: _buildTextField(
                      controller: _stateController,
                      label: 'State',
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Please enter state' : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _countryController,
                      label: 'Country',
                      validator: (value) => value?.isEmpty ?? true
                          ? 'Please enter country'
                          : null,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: _buildTextField(
                      controller: _postalCodeController,
                      label: 'Postal Code',
                      validator: (value) => value?.isEmpty ?? true
                          ? 'Please enter postal code'
                          : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              _buildTextField(
                controller: _contactNumberController,
                label: 'Contact Number',
                validator: (value) => value?.isEmpty ?? true
                    ? 'Please enter contact number'
                    : null,
              ),
              SizedBox(height: 16.h),
              _buildTextField(
                controller: _contactEmailController,
                label: 'Contact Email',
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Please enter email';
                  if (!GetUtils.isEmail(value!))
                    return 'Please enter valid email';
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                maxLines: 3,
              ),
              SizedBox(height: 16.h),
              _buildTextField(
                controller: _landmarkController,
                label: 'Landmark',
              ),
              // SizedBox(height: 16.h),
              // Row(
              //   children: [
              //     Expanded(
              //       child: _buildTextField(
              //         controller: _latitudeController,
              //         label: 'Latitude',
              //         keyboardType: TextInputType.number,
              //         validator: (value) {
              //           if (value?.isEmpty ?? true)
              //             return 'Please enter latitude';
              //           if (double.tryParse(value!) == null)
              //             return 'Please enter valid latitude';
              //           return null;
              //         },
              //       ),
              //     ),
              //     SizedBox(width: 16.w),
              //     Expanded(
              //       child: _buildTextField(
              //         controller: _longitudeController,
              //         label: 'Longitude',
              //         keyboardType: TextInputType.number,
              //         validator: (value) {
              //           if (value?.isEmpty ?? true)
              //             return 'Please enter longitude';
              //           if (double.tryParse(value!) == null)
              //             return 'Please enter valid longitude';
              //           return null;
              //         },
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(height: 24.h),
              Text(
                'Payment Methods',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Wrap(
                spacing: 8.w,
                children: _paymentMethods.map((method) {
                  return FilterChip(
                    label: Text(method.toUpperCase()),
                    selected: _selectedPaymentMethods.contains(method),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedPaymentMethods.add(method);
                        } else {
                          _selectedPaymentMethods.remove(method);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 32.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updateBranch,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                  ),
                  child: Text(
                    'Update Branch',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}
