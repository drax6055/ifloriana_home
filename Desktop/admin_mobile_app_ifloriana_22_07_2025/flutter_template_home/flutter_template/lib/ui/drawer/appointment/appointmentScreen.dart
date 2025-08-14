import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/ui/drawer/appointment/appointmentController.dart';
import 'package:flutter_template/utils/colors.dart';
import 'package:get/get.dart';

import '../../../wiget/appbar/commen_appbar.dart';
import '../../../wiget/loading.dart';

class Appointmentscreen extends StatelessWidget {
  Appointmentscreen({super.key});
  final AppointmentController getController = Get.put(AppointmentController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: 'Appointments'),
        body: Container(
          child: Obx(() {
            if (getController.isLoading.value) {
              return Center(child: CustomLoadingAvatar());
            }
            if (getController.appointments.isEmpty) {
              return Center(
                  child: Text('No appointments found',
                      style: TextStyle(color: Colors.black)));
            }
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    // headingRowColor: MaterialStateProperty.all(secondaryColor),
                    columns: const [
                      DataColumn(
                          label: Text('Date & Time',
                              style: TextStyle(color: Colors.black))),
                      DataColumn(
                          label: Text('Client',
                              style: TextStyle(color: Colors.black))),
                      DataColumn(
                          label: Text('Amount',
                              style: TextStyle(color: Colors.black))),
                      DataColumn(
                          label: Text('Staff Name',
                              style: TextStyle(color: Colors.black))),
                      DataColumn(
                          label: Text('Services',
                              style: TextStyle(color: Colors.black))),
                      DataColumn(
                          label: Text('Membership',
                              style: TextStyle(color: Colors.black))),
                      DataColumn(
                          label: Text('Package',
                              style: TextStyle(color: Colors.black))),
                      DataColumn(
                          label: Text('Status',
                              style: TextStyle(color: Colors.black))),
                      DataColumn(
                          label: Text('Payment Status',
                              style: TextStyle(color: Colors.black))),
                      DataColumn(
                          label: Text('Action',
                              style: TextStyle(color: Colors.black))),
                    ],
                    rows: getController.appointments.map((a) {
                      return DataRow(cells: [
                        DataCell(Text('${a.date} - ${a.time}',
                            style: TextStyle(color: Colors.black))),
                        DataCell(Row(
                          children: [
                            // CircleAvatar(
                            //   backgroundImage: a.clientImage != null &&
                            //           a.clientImage!.isNotEmpty
                            //       ? NetworkImage(a.clientImage!)
                            //       : null,
                            //   child: (a.clientImage == null ||
                            //           a.clientImage!.isEmpty)
                            //       ? Icon(Icons.person, color: Colors.black)
                            //       : null,
                            // ),
                            // SizedBox(width: 8),
                            Flexible(
                                child: Text(a.clientName,
                                    style: TextStyle(color: Colors.black))),
                          ],
                        )),
                        DataCell(Text('₹ ${a.amount}',
                            style: TextStyle(color: Colors.black))),
                        DataCell(Row(
                          children: [
                            // CircleAvatar(
                            //   backgroundImage: a.staffImage != null &&
                            //           a.staffImage!.isNotEmpty
                            //       ? NetworkImage(a.staffImage!)
                            //       : null,
                            //   child: (a.staffImage == null ||
                            //           a.staffImage!.isEmpty)
                            //       ? Icon(Icons.person, color: Colors.black)
                            //       : null,
                            // ),
                            // SizedBox(width: 8),
                            Flexible(
                                child: Text(a.staffName,
                                    style: TextStyle(color: Colors.black))),
                          ],
                        )),
                        DataCell(Text(a.serviceName,
                            style: TextStyle(color: Colors.black))),
                        DataCell(a.membership == '-'
                            ? Text('-', style: TextStyle(color: Colors.black))
                            : Chip(
                                label: Text(
                                  'Yes',
                                  style: TextStyle(color: white),
                                ),
                                backgroundColor: Colors.grey[700],
                                labelStyle: TextStyle(color: Colors.black))),
                        DataCell(a.package == '-'
                            ? Text('-', style: TextStyle(color: Colors.black))
                            : Chip(
                                label: Text(
                                  'Yes',
                                  style: TextStyle(color: white),
                                ),
                                backgroundColor: Colors.grey[700],
                                labelStyle: TextStyle(color: Colors.black))),
                        DataCell(
                          GestureDetector(
                              onTap: () {
                                if (a.status.toLowerCase() == 'upcoming' ||
                                    a.status.toLowerCase() == 'check in')
                                  _showCancelAppointmentDialog(context, a);
                              },
                              child: Chip(
                                label: Text(
                                  a.status.toLowerCase() == 'upcoming'
                                      ? 'Upcoming'
                                      : a.status.toLowerCase() == 'cancelled'
                                          ? 'Cancelled'
                                          : a.status.toLowerCase() == 'check in'
                                              ? 'Check In'
                                              : 'Check-out',
                                  style: TextStyle(color: Colors.black),
                                ),
                                backgroundColor: a.status.toLowerCase() ==
                                        'upcoming'
                                    ? const Color.fromARGB(255, 166, 94, 179)
                                    : a.status.toLowerCase() == 'cancelled'
                                        ? const Color.fromARGB(255, 243, 88, 77)
                                        : a.status.toLowerCase() == 'check in'
                                            ? Colors.yellow
                                            : Colors.green,
                              )),
                        ),
                        DataCell(
                          GestureDetector(
                            onTap: a.paymentStatus != 'Paid'
                                ? () {
                                    final controller = getController;
                                    // Set initial values for the payment summary state
                                    controller.paymentSummaryState.tips.value =
                                        '0';
                                    controller.paymentSummaryState.paymentMethod
                                        .value = 'UPI';
                                    controller.paymentSummaryState.selectedTax
                                            .value =
                                        controller.taxes.isNotEmpty
                                            ? controller.taxes.first
                                            : null;
                                    controller.paymentSummaryState.couponCode
                                        .value = '';
                                    controller.paymentSummaryState.appliedCoupon
                                        .value = null;
                                    controller.paymentSummaryState
                                        .addAdditionalDiscount.value = false;
                                    controller.paymentSummaryState.discountType
                                        .value = 'percentage';
                                    controller.paymentSummaryState.discountValue
                                        .value = '0';
                                    // Calculate initial grand total
                                    controller.calculateGrandTotal(
                                      servicePrice: a.amount.toDouble(),
                                      memberDiscount:
                                          a.branchMembershipDiscount ?? 0.0,
                                      taxValue: controller.taxes.isNotEmpty
                                          ? controller.taxes.first.value *
                                              a.amount /
                                              100
                                          : 0.0,
                                      tip: 0.0,
                                    );
                                    Get.bottomSheet(
                                      Obx(() {
                                        final state =
                                            controller.paymentSummaryState;
                                        final selectedTax =
                                            state.selectedTax.value;
                                        final tips =
                                            double.tryParse(state.tips.value) ??
                                                0.0;
                                        final paymentMethod =
                                            state.paymentMethod.value;
                                        final coupon =
                                            state.appliedCoupon.value;
                                        final couponDiscount = coupon != null
                                            ? (coupon.discountType ==
                                                    'percentage'
                                                ? a.amount *
                                                    coupon.discountAmount /
                                                    100
                                                : coupon.discountAmount)
                                            : 0.0;
                                        final addAdditionalDiscount =
                                            state.addAdditionalDiscount.value;
                                        final discountType =
                                            state.discountType.value;
                                        final discountValue = double.tryParse(
                                                state.discountValue.value) ??
                                            0.0;
                                        final memberDiscount =
                                            a.branchMembershipDiscount ?? 0.0;
                                        final taxValue = selectedTax != null
                                            ? selectedTax.value * a.amount / 100
                                            : 0.0;
                                        // Recalculate grand total on every rebuild
                                        controller.calculateGrandTotal(
                                          servicePrice: a.amount.toDouble(),
                                          memberDiscount: memberDiscount,
                                          taxValue: taxValue,
                                          tip: tips,
                                          couponDiscount: couponDiscount,
                                          additionalDiscount:
                                              addAdditionalDiscount
                                                  ? discountValue
                                                  : 0.0,
                                          discountType: discountType,
                                        );
                                        return Container(
                                          padding: EdgeInsets.all(24),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[900],
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(24)),
                                          ),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('Payment Summary',
                                                    style: TextStyle(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Colors.brown[100])),
                                                SizedBox(height: 16),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text('Date: ${a.date}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                    Text(
                                                        'Customer: ${a.clientName} - ${a.clientPhone ?? ''}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                  ],
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                    'Service Amount: ₹ ${a.amount}',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                Divider(
                                                    height: 32,
                                                    color: Colors.grey[700]),
                                                Text('Billing Details',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                        fontSize: 18)),
                                                SizedBox(height: 12),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child:
                                                          DropdownButtonFormField<
                                                              TaxModel>(
                                                        value: selectedTax,
                                                        items: controller.taxes
                                                            .map((tax) =>
                                                                DropdownMenuItem(
                                                                  value: tax,
                                                                  child: Text(
                                                                      '${tax.title} (${tax.value}%)',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.black)),
                                                                ))
                                                            .toList(),
                                                        onChanged: (val) {
                                                          state.selectedTax
                                                              .value = val;
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          labelText: 'Tax',
                                                          filled: true,
                                                          fillColor:
                                                              Colors.white,
                                                        ),
                                                        dropdownColor:
                                                            Colors.white,
                                                      ),
                                                    ),
                                                    SizedBox(width: 12),
                                                    Expanded(
                                                      child: TextFormField(
                                                        initialValue:
                                                            state.tips.value,
                                                        onChanged: (val) =>
                                                            state.tips.value =
                                                                val,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText: 'Tips',
                                                          filled: true,
                                                          fillColor:
                                                              Colors.white,
                                                        ),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                    SizedBox(width: 12),
                                                    Expanded(
                                                      child:
                                                          DropdownButtonFormField<
                                                              String>(
                                                        value: paymentMethod,
                                                        items: [
                                                          'UPI',
                                                          'Cash',
                                                          'Card'
                                                        ]
                                                            .map((method) =>
                                                                DropdownMenuItem(
                                                                  value: method,
                                                                  child: Text(
                                                                      method,
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.black)),
                                                                ))
                                                            .toList(),
                                                        onChanged: (val) {
                                                          if (val != null)
                                                            state.paymentMethod
                                                                .value = val;
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              'Payment Method',
                                                          filled: true,
                                                          fillColor:
                                                              Colors.white,
                                                        ),
                                                        dropdownColor:
                                                            Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Divider(
                                                    height: 32,
                                                    color: Colors.grey[700]),
                                                Text('Discounts',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.amber,
                                                        fontSize: 18)),
                                                SizedBox(height: 12),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: TextFormField(
                                                        initialValue: state
                                                            .couponCode.value,
                                                        onChanged: (val) =>
                                                            state.couponCode
                                                                .value = val,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              'Coupon Code',
                                                          filled: true,
                                                          fillColor:
                                                              Colors.white,
                                                        ),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                    SizedBox(width: 8),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        controller.applyCoupon(
                                                            state.couponCode
                                                                .value);
                                                      },
                                                      child: Text('Apply'),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 8),
                                                Row(
                                                  children: [
                                                    Checkbox(
                                                      value:
                                                          addAdditionalDiscount,
                                                      onChanged: (val) {
                                                        state.addAdditionalDiscount
                                                                .value =
                                                            val ?? false;
                                                      },
                                                      activeColor: Colors.amber,
                                                    ),
                                                    Text(
                                                        'Want to add additional discount?',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                    Spacer(),
                                                    if (a.branchMembershipDiscount ==
                                                            null ||
                                                        a.branchMembershipDiscount ==
                                                            0)
                                                      Text(
                                                          'Customer has no membership',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.amber,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                  ],
                                                ),
                                                if (addAdditionalDiscount)
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child:
                                                            DropdownButtonFormField<
                                                                String>(
                                                          value: discountType,
                                                          items: [
                                                            DropdownMenuItem(
                                                                value:
                                                                    'percentage',
                                                                child: Text(
                                                                    'Percentage (%)',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black))),
                                                            DropdownMenuItem(
                                                                value: 'amount',
                                                                child: Text(
                                                                    'Amount',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black))),
                                                          ],
                                                          onChanged: (val) {
                                                            if (val != null)
                                                              state.discountType
                                                                  .value = val;
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                            labelText:
                                                                'Discount Type',
                                                            filled: true,
                                                            fillColor:
                                                                Colors.white,
                                                          ),
                                                          dropdownColor:
                                                              Colors.white,
                                                        ),
                                                      ),
                                                      SizedBox(width: 12),
                                                      Expanded(
                                                        child: TextFormField(
                                                          initialValue: state
                                                              .discountValue
                                                              .value,
                                                          onChanged: (val) =>
                                                              state
                                                                  .discountValue
                                                                  .value = val,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          decoration:
                                                              InputDecoration(
                                                            labelText:
                                                                'Discount Value',
                                                            filled: true,
                                                            fillColor:
                                                                Colors.white,
                                                          ),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                Divider(
                                                    height: 32,
                                                    color: Colors.grey[700]),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text('Grand Total',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                            fontSize: 18)),
                                                    Text(
                                                        '₹ ${state.grandTotal.value.toStringAsFixed(2)}',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .greenAccent,
                                                            fontSize: 22)),
                                                  ],
                                                ),
                                                SizedBox(height: 24),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Get.back(),
                                                      child: Text('Cancel',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .redAccent)),
                                                    ),
                                                    SizedBox(width: 16),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                       
                                                        Get.back();
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.brown[300],
                                                      ),
                                                      child:
                                                          Text('Generate Bill'),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                      isScrollControlled: true,
                                    );
                                  }
                                : null,
                            child: Chip(
                              label: Text(a.paymentStatus,
                                  style: TextStyle(color: Colors.black)),
                              backgroundColor: a.paymentStatus == 'Paid'
                                  ? Colors.green
                                  : Colors.yellow,
                            ),
                          ),
                        ),
                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.receipt,
                                  color: a.paymentStatus == 'Paid'
                                      ? primaryColor
                                      : Colors.grey),
                              onPressed: a.paymentStatus == 'Paid'
                                  ? () {
                                      print('===> paid');
                                    }
                                  : null,
                            ),
                            // IconButton(
                            //   icon: Icon(Icons.edit_outlined,
                            //       color: primaryColor),
                            //   onPressed: () {},
                            // ),
                            // Show cancel button only for upcoming or check in appointments
                            // if (a.status.toLowerCase() == 'upcoming' ||
                            //     a.status.toLowerCase() == 'check in')
                            //   IconButton(
                            //     icon: Icon(Icons.cancel_outlined,
                            //         color: Colors.red),
                            //     onPressed: () {
                            //       _showCancelAppointmentDialog(context, a);
                            //     },
                            //   ),
                            IconButton(
                              icon: Icon(Icons.delete_outline,
                                  color: primaryColor),
                              onPressed: () {},
                            ),
                          ],
                        )),
                      ]);
                    }).toList(),
                  )),
            );
          }),
        ),
      ),
    );
  }

  void _showCancelAppointmentDialog(
      BuildContext context, Appointment appointment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancel Appointment'),
          content: Text(
              'Are you sure you want to cancel the appointment for ${appointment.clientName} on ${appointment.date} at ${appointment.time}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('No', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await getController
                    .cancelAppointment(appointment.appointmentId);
              },
              child: Text('Yes, Cancel', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
