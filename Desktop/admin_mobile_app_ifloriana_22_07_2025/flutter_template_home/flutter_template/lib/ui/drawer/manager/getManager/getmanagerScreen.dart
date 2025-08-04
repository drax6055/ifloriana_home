import 'package:flutter/material.dart';
import 'package:flutter_template/ui/drawer/manager/getManager/getmanagerController.dart';
import 'package:flutter_template/wiget/appbar/commen_appbar.dart';
import 'package:get/get.dart';
import 'package:flutter_template/ui/drawer/manager/addManager/managerScreen.dart';

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
        return RefreshIndicator(
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
                      shape: Border.all(color: Colors.transparent),
                      title: Text('${manager.full_name}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
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
                            icon: Icon(Icons.delete, color: Colors.red),
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
        onPressed: () {
          showDialog(
            context: Get.context!,
            builder: (context) {
              return AlertDialog(
                title: Text('Create Manager'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Get.to(Upgradefromexistingscreen());
                      },
                      child: Text('From existing staff'),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Get.to(Managerscreen());
                      },
                      child: Text('Create new'),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
