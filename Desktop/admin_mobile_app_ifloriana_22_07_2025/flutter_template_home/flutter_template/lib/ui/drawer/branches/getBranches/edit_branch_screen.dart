import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../network/model/branch_model.dart';
import 'getBranchesController.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../network/network_const.dart';

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
  File? _pickedImage;

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
    _selectedPaymentMethods = List.from(widget.branch.paymentMethods);
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
        imageFile: _pickedImage,
      );
      Get.back();
    }
  }

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    await _handlePickedFile(picked);
  }

  Future<void> _pickImageFromCamera() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);
    await _handlePickedFile(picked);
  }

  Future<void> _handlePickedFile(XFile? pickedFile) async {
    const maxSizeInBytes = 150 * 1024; // 150 KB
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final lower = pickedFile.path.toLowerCase();
      final isAllowed = lower.endsWith('.jpg') || lower.endsWith('.jpeg') || lower.endsWith('.png');
      if (!isAllowed) {
        Get.snackbar('Invalid Image', 'Only JPG, JPEG, PNG images are allowed!');
        return;
      }
      if (await file.length() < maxSizeInBytes) {
        setState(() {
          _pickedImage = file;
        });
      } else {
        Get.snackbar('Error', 'Image size must be less than 150KB');
      }
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
              _imagePickerTile(),
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

  Widget _imagePickerTile() {
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Choose from Gallery'),
                  onTap: () async {
                    Get.back();
                    await _pickImageFromGallery();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Take Photo'),
                  onTap: () async {
                    Get.back();
                    await _pickImageFromCamera();
                  },
                ),
              ],
            ),
          ),
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
        );
      },
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(10.r),
        ),
        alignment: Alignment.center,
        child: _pickedImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Image.file(
                  _pickedImage!,
                  fit: BoxFit.cover,
                  height: 120,
                  width: double.infinity,
                ),
              )
            : widget.branch.imageUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Image.network(
                      '${Apis.pdfUrl}${widget.branch.imageUrl}?v=${DateTime.now().millisecondsSinceEpoch}',
                      fit: BoxFit.cover,
                      height: 120,
                      width: double.infinity,
                    ),
                  )
                : const Icon(Icons.image, size: 40),
      ),
    );
  }
}
