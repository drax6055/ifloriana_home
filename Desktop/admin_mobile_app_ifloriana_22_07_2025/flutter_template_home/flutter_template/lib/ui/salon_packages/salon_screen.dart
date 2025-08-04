// import 'package:flutter/material.dart';
// import 'package:flutter_template/ui/salon_packages/salon_controller.dart'
//     show SalonPackagesController;
// import 'package:get/get.dart';

// class SalonPackagesScreen extends StatelessWidget {
//   final SalonPackagesController controller = Get.put(SalonPackagesController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Dynamic TextFields")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 ElevatedButton(
//                   onPressed: controller.addTextField,
//                   child: Text("Add TextField"),
//                 ),
//                 SizedBox(width: 16),
//                 ElevatedButton(
//                   onPressed: () {
//                     final texts = controller.getTextValues();
//                     Get.defaultDialog(
//                       title: "Entered Texts",
//                       content: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisSize: MainAxisSize.min,
//                         children: texts.map((text) => Text(text)).toList(),
//                       ),
//                     );
//                   },
//                   child: Text("Show Texts"),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             Expanded(
//               child: Obx(() {
//                 return ListView.builder(
//                   itemCount: controller.controllers.length,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 8.0),
//                       child: TextField(
//                         controller: controller.controllers[index],
//                         decoration: InputDecoration(
//                           labelText: 'Input ${index + 1}',
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
