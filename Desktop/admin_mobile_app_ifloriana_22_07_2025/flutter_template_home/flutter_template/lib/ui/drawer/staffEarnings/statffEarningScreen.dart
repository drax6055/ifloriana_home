import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/utils/colors.dart';
import 'package:get/get.dart';

import '../../../wiget/appbar/commen_appbar.dart';
import '../../../wiget/loading.dart';
import 'statffEarningController.dart';

class Statffearningscreen extends StatelessWidget {
  Statffearningscreen({super.key});
  final Statffearningcontroller getController =
      Get.put(Statffearningcontroller());

  final RxBool isSearching = false.obs;
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.h),
          child: Obx(() {
            return CustomAppBar(
              title: isSearching.value ? '' : 'Staff Earning',
              actions: [
                if (isSearching.value)
                  SizedBox(
                    width: 270.w,
                    child: Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: TextField(
                        controller: searchController,
                        autofocus: true,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Search by Staff Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          hintStyle: TextStyle(color: grey),
                        ),
                        style: TextStyle(color: Colors.black, fontSize: 18),
                        onSubmitted: (value) {
                          getController.updateSearchQuery(value);
                          isSearching.value = false;
                        },
                      ),
                    ),
                  ),
                IconButton(
                  icon: Icon(isSearching.value ? Icons.close : Icons.search,
                      color: Colors.white),
                  onPressed: () {
                    if (isSearching.value) {
                      isSearching.value = false;
                      searchController.clear();
                      getController.updateSearchQuery('');
                    } else {
                      isSearching.value = true;
                    }
                  },
                ),
              ],
            );
          }),
        ),
        body: Obx(() {
          if (getController.isLoading.value) {
            return Center(child: CustomLoadingAvatar());
          }
          return Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  color: primaryColor,
                  onRefresh: getController.getStaffEarningData,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Total Booking')),
                        DataColumn(label: Text('Service Amount')),
                        DataColumn(label: Text('Commission Earning')),
                        DataColumn(label: Text('Tip Earning')),
                        DataColumn(label: Text('Staff Earning')),
                        DataColumn(label: Text('Action')),
                      ],
                      rows: getController.filteredStaffEarnings
                          .map<DataRow>((staff) {
                        return DataRow(
                          cells: [
                            DataCell(Row(
                              children: [
                                // CircleAvatar(
                                //   backgroundImage: staff['staff_image'] != null
                                //       ? NetworkImage(staff['staff_image'])
                                //       : null,
                                //   child: staff['staff_image'] == null
                                //       ? Icon(Icons.person)
                                //       : null,
                                // ),
                                SizedBox(width: 8),
                                Text(staff['staff_name'] ?? ''),
                              ],
                            )),
                            DataCell(Text('${staff['total_booking']}')),
                            DataCell(Text('₹ ${staff['service_amount']}')),
                            DataCell(Text('₹ ${staff['commission_earning']}')),
                            DataCell(Text('₹ ${staff['tip_earning']}')),
                            DataCell(Text('₹ ${staff['staff_earning']}')),
                            DataCell(
                              IconButton(
                                icon: Icon(Icons.payments, color: primaryColor),
                                onPressed: () {
                                  _showPayoutSheet(
                                      context, staff, getController);
                                },
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  void _showPayoutSheet(
      BuildContext context, Map staff, Statffearningcontroller controller) {
    final RxString paymentMethod = 'cash'.obs;
    final TextEditingController descController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: staff['staff_image'] != null
                        ? NetworkImage(staff['staff_image'])
                        : null,
                    child: staff['staff_image'] == null
                        ? Icon(Icons.person)
                        : null,
                  ),
                  SizedBox(width: 12),
                  Text(staff['staff_name'] ?? '',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Select Method *'),
              ),
              Obx(() => DropdownButtonFormField<String>(
                    value: paymentMethod.value,
                    items: [
                      DropdownMenuItem(value: 'cash', child: Text('Cash')),
                      DropdownMenuItem(value: 'upi', child: Text('Upi')),
                    ],
                    onChanged: (v) => paymentMethod.value = v ?? 'cash',
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  )),
              SizedBox(height: 16),
              TextField(
                controller: descController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Commission Earn: ₹ ${staff['commission_earning']}'),
                    Text('Tip Earn: ₹ ${staff['tip_earning']}'),
                    Text('Salary: ₹ ${staff['staff_earning']}'),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    'Total Pay : ₹ ${staff['staff_earning'] + staff['tip_earning']}'),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    controller.payoutStaff(
                      staffId: staff['staff_id'],
                      paymentMethod: paymentMethod.value,
                      description: descController.text,
                    );
                  },
                  child: Text('Payout'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
