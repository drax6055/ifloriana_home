import 'dart:async';
import 'package:flutter_template/main.dart';
import 'package:flutter_template/network/network_const.dart';
import 'package:get/get.dart';
import '../../../wiget/custome_snackbar.dart';
import 'staff_payout_model.dart';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart'; // For DateTimeRange

class StatffearningReportcontroller extends GetxController {
  var payouts = <StaffPayout>[].obs;
  var filteredPayouts = <StaffPayout>[].obs;
  var isLoading = true.obs;
  var filterText = ''.obs;
  var searchQuery = ''.obs;
  var startDate = Rxn<DateTime>();
  var endDate = Rxn<DateTime>();
  var selectedDate = Rx<DateTime?>(null);
  var selectedDateRange = Rx<DateTimeRange?>(null);
  var sortOrder = 'desc'.obs;
  var grandTotal = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    getStaffEarningDataReport();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void clearSearchQuery() {
    searchQuery.value = '';
    applyFilters();
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
    selectedDateRange.value = null;
    applyFilters();
  }

  void selectDateRange(DateTimeRange range) {
    selectedDateRange.value = range;
    selectedDate.value = null;
    applyFilters();
  }

  void clearFilters() {
    searchQuery.value = '';
    filterText.value = '';
    selectedDate.value = null;
    selectedDateRange.value = null;
    startDate.value = null;
    endDate.value = null;
    sortOrder.value = 'desc';
    applyFilters();
  }

  void setSortOrder(String order) {
    sortOrder.value = order;
    applyFilters();
  }

  void applyFilters() {
    if (payouts.isEmpty) {
      filteredPayouts.value = [];
      calculateGrandTotal();
      return;
    }

    List<StaffPayout> list = List.from(payouts);

    // Apply staff name filter from the old search field
    if (filterText.value.isNotEmpty) {
      list = list
          .where((p) => p.staffName
              .toLowerCase()
              .contains(filterText.value.toLowerCase()))
          .toList();
    }

    // Apply staff name filter from the AppBar search field
    if (searchQuery.value.isNotEmpty) {
      list = list
          .where((p) => p.staffName
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()))
          .toList();
    }

    if (selectedDate.value != null) {
      list = list.where((p) {
        final date = DateTime.tryParse(p.paymentDate);
        final filterDate = selectedDate.value!;
        return date != null &&
            date.year == filterDate.year &&
            date.month == filterDate.month &&
            date.day == filterDate.day;
      }).toList();
    }
    if (selectedDateRange.value != null) {
      list = list.where((p) {
        final date = DateTime.tryParse(p.paymentDate);
        final range = selectedDateRange.value!;
        return date != null &&
            !date.isBefore(range.start) &&
            !date.isAfter(range.end);
      }).toList();
    }
    // Sort by date
    list.sort((a, b) {
      final dateA = DateTime.tryParse(a.paymentDate);
      final dateB = DateTime.tryParse(b.paymentDate);
      if (dateA == null && dateB == null) return 0;
      if (dateA == null) return 1;
      if (dateB == null) return -1;
      if (sortOrder.value == 'asc') {
        return dateA.compareTo(dateB);
      } else {
        return dateB.compareTo(dateA);
      }
    });
    filteredPayouts.value = list;
    calculateGrandTotal();
  }

  void calculateGrandTotal() {
    double total = 0;
    if (filteredPayouts.isNotEmpty) {
      for (var payout in filteredPayouts) {
        total += payout.totalPay ?? 0;
      }
    }
    grandTotal.value = total;
  }

  Future<void> getStaffEarningDataReport() async {
    try {
      isLoading.value = true;
      final loginUser = await prefs.getUser();
      print('Fetching staff payout data for salon: ${loginUser?.salonId}');

      // Try the staff-payouts endpoint first, fallback to revenue-commissions if it fails
      String endpoint =
          '${Apis.baseUrl}/staff-payouts?salon_id=${loginUser!.salonId}';
      print('Trying endpoint: $endpoint');

      final response = await dioClient.getData(
        endpoint,
        (json) => json,
      );

      print('Response received: ${response.toString()}');

      if (response['success'] == true && response['data'] != null) {
        payouts.value = List<StaffPayout>.from(
          response['data'].map((x) => StaffPayout.fromJson(x)),
        );
        filteredPayouts.value = payouts;
        calculateGrandTotal();
        print('Successfully loaded ${payouts.length} payouts');
      } else {
        print('No data or success false, trying revenue-commissions endpoint');
        // Fallback to revenue-commissions endpoint
        try {
          final fallbackResponse = await dioClient.getData(
            '${Apis.baseUrl}${Endpoints.getcommition}${loginUser.salonId}',
            (json) => json,
          );

          if (fallbackResponse['success'] == true &&
              fallbackResponse['data'] != null) {
            // Transform revenue-commissions data to StaffPayout format
            payouts.value = List<StaffPayout>.from(
              fallbackResponse['data'].map((x) => StaffPayout.fromJson(x)),
            );
            filteredPayouts.value = payouts;
            calculateGrandTotal();
            print(
                'Successfully loaded ${payouts.length} payouts from fallback endpoint');
          } else {
            payouts.clear();
            filteredPayouts.clear();
            calculateGrandTotal();
            print('No data from fallback endpoint either');
          }
        } catch (fallbackError) {
          print('Fallback endpoint also failed: $fallbackError');
          payouts.clear();
          filteredPayouts.clear();
          calculateGrandTotal();
        }
      }
    } catch (e) {
      print('Error fetching staff payout data: $e');
      CustomSnackbar.showError(
          'Error', 'Failed to fetch staff payout data: $e');
      payouts.clear();
      filteredPayouts.clear();
      calculateGrandTotal();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> exportToExcel() async {
    try {
      final excel = Excel.createExcel();
      if (excel.sheets.containsKey('Sheet1')) {
        excel.delete('Sheet1');
      }
      final sheet = excel['Staff Payout Reports'];
      final headers = [
        'Payment Date',
        'Staff',
        'Commission Amount',
        'Tips Amount',
        'Payment Type',
        'Total Pay',
      ];
      for (int i = 0; i < headers.length; i++) {
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
          ..value = headers[i]
          ..cellStyle = CellStyle(
            bold: true,
            horizontalAlign: HorizontalAlign.Center,
            backgroundColorHex: '#E0E0E0',
          );
      }
      final dataToExport =
          filteredPayouts.isNotEmpty ? filteredPayouts : payouts;
      for (int i = 0; i < dataToExport.length; i++) {
        final payout = dataToExport[i];
        final row = i + 1;
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
          ..value = payout.formattedDate;
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
          ..value = payout.staffName;
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row))
          ..value = "₹${payout.commissionAmount.toString()}";
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
          ..value = "₹${payout.tips.toString()}";
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
          ..value = payout.paymentType;
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row))
          ..value ="₹${payout.totalPay.toString()}";
      }
      final totalRow = dataToExport.length + 1;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: totalRow))
        ..value = 'Grand Total'
        ..cellStyle = CellStyle(bold: true);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: totalRow))
        ..value = "₹${grandTotal.value.toStringAsFixed(2)}"
        ..cellStyle = CellStyle(bold: true);
      excel.setDefaultSheet('Staff Payout Reports');
      final directory = await getApplicationDocumentsDirectory();
      final fileName =
          'staff_payout_reports_${DateTime.now().millisecondsSinceEpoch}.xlsx';
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(excel.encode()!);
      await OpenFile.open(file.path);
      CustomSnackbar.showSuccess(
          'Success', 'Excel file exported successfully!');
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to export Excel: $e');
    }
  }

  Future<void> exportToPdf() async {
    try {
      final pdf = pw.Document();
      final fontData =
          await rootBundle.load("assets/fonts/NotoSans-Regular.ttf");
      final ttf = pw.Font.ttf(fontData);
      final dataToExport =
          filteredPayouts.isNotEmpty ? filteredPayouts : payouts;
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4.portrait,
          theme: pw.ThemeData.withFont(
            base: ttf,
            bold: ttf,
          ),
          build: (pw.Context context) {
            return [
              pw.Header(
                level: 0,
                child: pw.Text(
                  'Staff Payout Reports',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                context: context,
                data: <List<String>>[
                  [
                    'Payment Date',
                    'Staff',
                    'Commission Amount',
                    'Tips Amount',
                    'Payment Type',
                    'Total Pay',
                  ],
                  ...dataToExport.map((payout) => [
                        payout.formattedDate,
                        payout.staffName,
                        "₹${payout.commissionAmount.toString()}",
                        "₹${payout.tips.toString()}",
                        payout.paymentType,
                        "₹${payout.totalPay.toString()}",
                      ]),
                  [
                    'Grand Total',
                    '',
                    '',
                    '',
                    '',
                    "₹${grandTotal.value.toStringAsFixed(2)}",
                  ],
                ],
                cellHeight: 30,
                cellAlignment: pw.Alignment.center,
                border: pw.TableBorder.all(),
              ),
            ];
          },
        ),
      );
      final directory = await getApplicationDocumentsDirectory();
      final fileName =
          'staff_payout_reports_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(await pdf.save());
      await OpenFile.open(file.path);
      CustomSnackbar.showSuccess('Success', 'PDF file exported successfully!');
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to export PDF: $e');
    }
  }
}
