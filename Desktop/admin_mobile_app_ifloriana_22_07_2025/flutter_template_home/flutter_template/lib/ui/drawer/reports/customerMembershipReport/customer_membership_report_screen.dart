import 'package:flutter/material.dart';
import 'package:flutter_template/ui/drawer/reports/customerMembershipReport/customer_membership_report_controller.dart';
import 'package:get/get.dart';

import '../../../../wiget/appbar/commen_appbar.dart';

class CustomerScreen extends StatefulWidget {
  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final CustomerController controller = Get.put(CustomerController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.getCustomers();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        if (controller.hasMore.value && !controller.isLoading.value) {
          controller.getCustomers(loadMore: true);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Customers  Membership"),
      body: Obx(() {
        if (controller.customers.isEmpty && controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          controller: _scrollController,
          itemCount:
              controller.customers.length + (controller.hasMore.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < controller.customers.length) {
              final c = controller.customers[index];
              return ListTile(
                // leading: CircleAvatar(child: Text(c.fullName[0])),
                title: Text(c.fullName),
                subtitle: Text("${c.membershipName}"),
                trailing: Text(
                  c.membershipValidTill != null
                      ? "Valid till: ${c.membershipValidTill!.split('T').first}"
                      : "",
                  style: TextStyle(
                    color: DateTime.tryParse(c.membershipValidTill ?? "")
                                ?.isBefore(DateTime.now()) ==
                            true
                        ? Colors.red
                        : Colors.green,
                  ),
                ),
              );
            } else {
              return Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ));
            }
          },
        );
      }),
    );
  }
}
