import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/ui/drawer/staffPayoutRepoer/staffPayoutReoirtController.dart';
import 'package:flutter_template/ui/splash/splash_controller.dart';
import 'package:flutter_template/utils/colors.dart';
import 'package:get/get.dart';
import 'staff_payout_model.dart';
import 'package:intl/intl.dart';

class Staffpayoutreportscreen extends StatelessWidget {
  const Staffpayoutreportscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final StatffearningReportcontroller getController =
        Get.put(StatffearningReportcontroller());

    return Scaffold(
      appBar: AppBar(title: Text('Staff Payout Report')),
      body: Obx(() {
        if (getController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (getController.payouts.isEmpty) {
          return Center(
              child: Text('No payout data available',
                  style: TextStyle(color: Colors.red)));
        }
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        initialDateRange:
                            getController.startDate.value != null &&
                                    getController.endDate.value != null
                                ? DateTimeRange(
                                    start: getController.startDate.value!,
                                    end: getController.endDate.value!)
                                : null,
                      );
                      if (picked != null) {
                        getController.startDate.value = picked.start;
                        getController.endDate.value = picked.end;
                      }
                    },
                    child: Obx(() => InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Select Date Range',
                            border: OutlineInputBorder(),
                          ),
                          child: Text(
                            (getController.startDate.value == null ||
                                    getController.endDate.value == null)
                                ? ''
                                : '${DateFormat('yyyy-MM-dd').format(getController.startDate.value!)} - ${DateFormat('yyyy-MM-dd').format(getController.endDate.value!)}',
                          ),
                        )),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    getController.filterText.value = '';
                    getController.startDate.value = null;
                    getController.endDate.value = null;
                  },
                  child: Text('Clear Filters'),
                ),
              ],
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Filter by Staff Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => getController.filterText.value = value,
                controller:
                    TextEditingController(text: getController.filterText.value),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Payment Date')),
                    DataColumn(label: Text('Staff')),
                    DataColumn(label: Text('Commission Amount')),
                    DataColumn(label: Text('Tips Amount')),
                    DataColumn(label: Text('Payment Type')),
                    DataColumn(label: Text('Total Pay')),
                  ],
                  rows: getController.filteredPayouts.map((payout) {
                    return DataRow(cells: [
                      DataCell(Text(payout.formattedDate)),
                      DataCell(Text(payout.staffName)),
                      DataCell(Text(payout.commissionAmount.toString())),
                      DataCell(Text(payout.tips.toString())),
                      DataCell(Text(payout.paymentType)),
                      DataCell(Text(payout.totalPay.toString())),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
