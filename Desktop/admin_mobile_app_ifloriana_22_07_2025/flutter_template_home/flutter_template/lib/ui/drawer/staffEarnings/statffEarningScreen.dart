import 'package:flutter/material.dart';
import 'package:flutter_template/utils/colors.dart';
import 'package:get/get.dart';

import 'statffEarningController.dart';

class Statffearningscreen extends StatelessWidget {
  Statffearningscreen({super.key});
  final Statffearningcontroller getController =
      Get.put(Statffearningcontroller());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Obx(() {
            if (getController.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Search by Staff Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: getController.updateSearchQuery,
                  ),
                ),
                Expanded(
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
                                CircleAvatar(
                                  backgroundImage: staff['staff_image'] != null
                                      ? NetworkImage(staff['staff_image'])
                                      : null,
                                  child: staff['staff_image'] == null
                                      ? Icon(Icons.person)
                                      : null,
                                ),
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
                                icon: Icon(Icons.payments, color: Colors.green),
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
              ],
            );
          }),
        ),
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
