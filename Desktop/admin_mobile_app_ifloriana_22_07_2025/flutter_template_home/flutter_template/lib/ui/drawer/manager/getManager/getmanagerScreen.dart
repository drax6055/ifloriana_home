import 'package:flutter/material.dart';
import 'package:flutter_template/network/network_const.dart';
import 'package:flutter_template/ui/drawer/manager/getManager/getmanagerController.dart';
import 'package:flutter_template/utils/colors.dart';
import 'package:flutter_template/wiget/appbar/commen_appbar.dart';
import 'package:get/get.dart';
import 'package:flutter_template/ui/drawer/manager/addManager/managerScreen.dart';
import 'package:flutter_template/wiget/loading.dart';

import '../udpateFromExisting/upgradeFromExistingScreen.dart';

class Getmanagerscreen extends StatelessWidget {
  Getmanagerscreen({super.key});
  final Getmanagercontroller getController = Get.put(Getmanagercontroller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Manager",
      ),
      body: Obx(() {
        return getController.isLoading.value
            ? const Center(child: CustomLoadingAvatar())
            : RefreshIndicator(
                color: primaryColor,
                onRefresh: () async {
                  await getController.getManagers();
                },
                child: getController.managers.isEmpty
                    ? ListView(
                        children: [
                          SizedBox(height: 200),
                          Center(child: Text("No managers found")),
                        ],
                      )
                    : ListView.builder(
                        itemCount: getController.managers.length,
                        itemBuilder: (context, index) {
                          final manager = getController.managers[index];
                          return ExpansionTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey[300],
                              child: manager.image_url.isNotEmpty
                                  ? ClipOval(
                                      child: Image.network(
                                        '${Apis.pdfUrl}${manager.image_url}?v=${DateTime.now().millisecondsSinceEpoch}',
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Icon(Icons.person,
                                              color: Colors.grey[600]);
                                        },
                                      ),
                                    )
                                  : Icon(Icons.person, color: Colors.grey[600]),
                            ),
                            shape: Border.all(color: Colors.transparent),
                            title: Text('${manager.full_name}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${manager.contactNumber}'),
                                // Text('${manager.email}'),
                                // Text('${manager.branchName}'),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit_outlined,
                                      color: primaryColor),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            Managerscreen(manager: manager),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete_outline,
                                      color: primaryColor),
                                  onPressed: () {
                                    getController.deleteManager(manager.id);
                                  },
                                ),
                              ],
                            ),
                            children: [
                              Text('Email: ${manager.email}'),
                              Text('Contact: ${manager.contactNumber}'),
                              Text('Branch: ${manager.branchName}'),
                            ],
                          );
                        },
                      ),
              );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                title: const Text(
                  'Create Manager',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: primaryColor,
                  ),
                ),
                contentPadding:
                    const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Choose how you want to create the manager:',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildOptionButton(
                          icon: Icons.group,
                          label: 'From Staff',
                          color: Colors.orange,
                          onTap: () {
                            Navigator.of(context).pop();
                            Get.to(Upgradefromexistingscreen());
                          },
                        ),
                        _buildOptionButton(
                          icon: Icons.person_add_alt_1,
                          label: 'Create New',
                          color: Colors.blue,
                          onTap: () {
                            Navigator.of(context).pop();
                            Get.to(Managerscreen());
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
                actionsPadding: const EdgeInsets.all(16.0),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(
          Icons.add,
          color: white,
        ),
      ),
    );
  }

  Widget _buildOptionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 30, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
