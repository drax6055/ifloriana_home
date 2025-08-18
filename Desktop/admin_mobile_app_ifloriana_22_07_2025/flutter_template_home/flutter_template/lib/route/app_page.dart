import 'package:flutter_template/ui/auth/login/login_screen.dart';
import 'package:flutter_template/ui/auth/profile/adminProfileScreen.dart';
import 'package:flutter_template/ui/auth/register_packages/register_packages_screen.dart';
import 'package:flutter_template/ui/auth/register/register_screen.dart';
import 'package:flutter_template/ui/drawer/Branchmembership/add/branchMembershipAddScreen.dart';
import 'package:flutter_template/ui/drawer/Branchmembership/get/branchMembershipListScreen.dart';
import 'package:flutter_template/ui/drawer/branches/post_branches_screena.dart/postBranchesScreen.dart';
import 'package:flutter_template/ui/drawer/branches/post_branches_screena.dart/postBranchescontroller.dart';
import 'package:flutter_template/ui/drawer/coupons/addNewCoupon/addCouponScreen.dart';
import 'package:flutter_template/ui/drawer/coupons/couponsScreen.dart';
import 'package:flutter_template/ui/drawer/customers/addCustomer/addCustomerScreen.dart';
import 'package:flutter_template/ui/drawer/customers/customersScreen.dart';
import 'package:flutter_template/ui/drawer/drawer_screen.dart';
import 'package:flutter_template/ui/drawer/manager/addManager/managerScreen.dart';
import 'package:flutter_template/ui/drawer/manager/getManager/getmanagerScreen.dart';
import 'package:flutter_template/ui/drawer/services/addServices/addservicesScreen.dart';
import 'package:flutter_template/ui/drawer/services/categotys/addNewServicesScreen.dart';
import 'package:flutter_template/ui/drawer/services/subCategory/subCategotySCreen.dart';

import 'package:flutter_template/ui/drawer/staff/addNewStaffScreen.dart';
import 'package:flutter_template/ui/drawer/staff/staffDetailsScreen.dart'
    show Staffdetailsscreen;
import 'package:flutter_template/ui/tax/addNewTaxScreen.dart';
import 'package:get/get.dart';
import '../manager_ui/dashboard/dashboardScreen.dart';
import '../ui/auth/forgot/forgot_screen.dart';
import '../ui/buy_product/buy_product_screen.dart';
import '../ui/drawer/appointment/appointmentScreen.dart';
import '../ui/drawer/branchPackages/getBranchPackagesScreen.dart';
import '../ui/drawer/branches/getBranchesScreen.dart';
import '../ui/drawer/dashboard/dashboard_screen.dart';
import '../ui/drawer/products/allProducts/addProductsScreen.dart';
import '../ui/drawer/products/variations/variationScreen.dart';
import '../ui/drawer/reports/customerPackageReport/customer_package_report_screen.dart';
import '../ui/splash/splash_screen.dart';
import 'app_route.dart';
import 'package:flutter_template/ui/drawer/products/product_list/product_list_screen.dart';
import 'package:flutter_template/ui/drawer/customers/edit_customer/edit_customer_screen.dart';

class AppPages {
  static const initial = Routes.splashScreen;
  static final routes = [
    GetPage(
        name: Routes.productListScreen,
        page: () => ProductListScreen(),
        transition: Transition.rightToLeft),
    GetPage(
        name: Routes.splashScreen,
        page: () => SplashScreen(),
        transition: Transition.rightToLeft),
    GetPage(
        name: Routes.loginScreen,
        page: () => LoginScreen(),
        transition: Transition.rightToLeft),
    GetPage(
        name: Routes.drawerScreen,
        page: () => DrawerScreen(),
        transition: Transition.rightToLeft),
    GetPage(
        name: Routes.registerScreen,
        page: () => RegisterScreen(),
        transition: Transition.rightToLeft),
    GetPage(
        name: Routes.packagesScreen,
        page: () => PackagesScreen(),
        transition: Transition.rightToLeft),
    GetPage(
        name: Routes.dashboardScreen,
        page: () => DashboardScreen(),
        transition: Transition.rightToLeft),
    GetPage(
        name: Routes.forgotScreen,
        page: () => ForgotScreen(),
        transition: Transition.rightToLeft),
    GetPage(
        name: Routes.appointment,
        page: () => Appointmentscreen(),
        transition: Transition.rightToLeft),
    GetPage(
      name: Routes.adminprofilescreen,
      page: () => Adminprofilescreen(),
    ),
    GetPage(
        name: Routes.addNewStaff,
        page: () => Addnewstaffscreen(),
        transition: Transition.rightToLeft),
    GetPage(
        name: Routes.addNewCategotyScreen,
        page: () => AddNewCategotyScreen(),
        transition: Transition.rightToLeft),
    GetPage(
        name: Routes.addService,
        page: () => AddNewService(),
        transition: Transition.rightToLeft),
    GetPage(
        name: Routes.gerStaff,
        page: () => Staffdetailsscreen(),
        transition: Transition.rightToLeft),
    GetPage(
        name: Routes.addtex,
        page: () => Addnewtaxscreen(),
        transition: Transition.rightToLeft),
    GetPage(
        name: Routes.getCoupons,
        page: () => CouponsScreen(),
        transition: Transition.rightToLeft),
    GetPage(
        name: Routes.addCoupon,
        page: () => AddCouponScreen(),
        transition: Transition.rightToLeft),
    GetPage(
        name: Routes.addSubcategory,
        page: () => Subcategotyscreen(),
        transition: Transition.rightToLeft),
    GetPage(
        name: Routes.postBranchs,
        page: () => Postbranchesscreen(),
        binding: BindingsBuilder(() {
          Get.lazyPut<Postbranchescontroller>(() => Postbranchescontroller());
        }),
        transition: Transition.rightToLeft),
    GetPage(
        name: Routes.getBranches,
        page: () => GetBranchesScreen(),
        transition: Transition.rightToLeft),
    GetPage(
        name: Routes.managerScreen,
        page: () => Managerscreen(),
        transition: Transition.rightToLeft),
    GetPage(
        name: Routes.getManager,
        page: () => Getmanagerscreen(),
        transition: Transition.rightToLeft),
    GetPage(
        name: Routes.customersScreen,
        page: () => CustomersScreen(),
        transition: Transition.rightToLeft),
    GetPage(
        name: Routes.addCustomer,
        page: () => Addcustomerscreen(),
        transition: Transition.rightToLeft),
    GetPage(
        name: Routes.addBranchMembership,
        page: () => BranchMembershipListScreen(),
        transition: Transition.rightToLeft),
    GetPage(
        name: Routes.addVariationscreen,
        page: () => Variationscreen(),
        transition: Transition.rightToLeft),
    GetPage(
        name: Routes.branchmembershipaddscreen,
        page: () => Branchmembershipaddscreen(),
        transition: Transition.rightToLeft),
    GetPage(
        name: Routes.placeOrder,
        page: () => BuyProductScreen(),
        transition: Transition.rightToLeft),
    GetPage(
        name: Routes.editCustomer,
        page: () => EditCustomerScreen(),
        transition: Transition.rightToLeft),
    GetPage(
        name: Routes.addProductScreen,
        page: () => AddProductScreen(),
        transition: Transition.rightToLeft),
    GetPage(
        name: Routes.managerDashboard,
        page: () => ManagerDashboard(),
        transition: Transition.rightToLeft),

         GetPage(
        name: Routes.GetBranchPackagesScreen,
        page: () => GetBranchPackagesScreen(),
        transition: Transition.rightToLeft),

           GetPage(
        name: Routes.CustomerPackageReportScreen,
        page: () => CustomerPackageReportScreen(),
        transition: Transition.rightToLeft),
  ];
}
