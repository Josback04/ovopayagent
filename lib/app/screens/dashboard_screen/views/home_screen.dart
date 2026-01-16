import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovopayagent/app/screens/dashboard_screen/controller/home_controller.dart';
import 'package:ovopayagent/app/screens/dashboard_screen/views/widgets/home_screen_appbar.dart';
import 'package:ovopayagent/app/screens/dashboard_screen/views/widgets/home_screen_balance_card.dart';
import 'package:ovopayagent/app/screens/dashboard_screen/views/widgets/home_screen_kyc_status_card.dart';
import 'package:ovopayagent/app/screens/dashboard_screen/views/widgets/home_screen_transaction_list_card.dart';
import 'package:ovopayagent/core/utils/util_exporter.dart';

class HomeScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> dashboardKey;
  const HomeScreen({super.key, required this.dashboardKey});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    final controller = Get.put(HomeController());

    // Fetch initial data
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        controller.initController();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (homeController) {
        return Scaffold(
          appBar: HomePageAppBar(dashboardKey: widget.dashboardKey),
          body: RefreshIndicator(
            color: MyColor.getPrimaryColor(),
            onRefresh: () async {
              homeController.initController();
            },
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              clipBehavior: Clip.none,
              padding: EdgeInsetsDirectional.all(Dimensions.space16.w),
              child: Column(
                children: [
                  //kyc
                  HomeScreenKycStatusCard(),
                  //Balance Card
                  HomeScreenBalanceCard(homeController: homeController),
                  //Transaction
                  spaceDown(Dimensions.space20),
                  HomeScreenTransactionMenuCard(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
