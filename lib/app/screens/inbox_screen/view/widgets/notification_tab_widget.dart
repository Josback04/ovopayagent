import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovopayagent/app/components/custom_loader/custom_loader.dart';
import 'package:ovopayagent/app/components/no_data.dart';
import 'package:ovopayagent/app/components/shimmer/transaction_history_shimmer.dart';
import 'package:ovopayagent/app/screens/inbox_screen/controller/notification_history_controller.dart';
import 'package:ovopayagent/core/data/repositories/notification/notification_history_repo.dart';
import '../../../../components/text/default_text.dart';
import '../../../../components/text/header_text.dart';

import '../../../../../core/utils/util_exporter.dart';

class NotificationTabWidget extends StatefulWidget {
  const NotificationTabWidget({super.key});

  @override
  State<NotificationTabWidget> createState() => _NotificationTabWidgetState();
}

class _NotificationTabWidgetState extends State<NotificationTabWidget> {
  final ScrollController historyScrollController = ScrollController();
  void fetchData() {
    Get.find<NotificationHistoryController>().getNotificationHistoryDataList(
      forceLoad: false,
    );
  }

  void scrollListener({required bool isReceiver}) {
    if (historyScrollController.position.pixels == historyScrollController.position.maxScrollExtent) {
      if (Get.find<NotificationHistoryController>().hasNext()) {
        fetchData();
      }
    }
  }

  @override
  void initState() {
    super.initState();

    Get.put(NotificationRepo());
    final controller = Get.put(
      NotificationHistoryController(notificationRepo: Get.find()),
    );

    // Fetch initial data
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        controller.initialHistoryData(); // Receiver if index is 0, Sender otherwise

        // Add scroll listeners
        historyScrollController.addListener(
          () => scrollListener(isReceiver: true),
        );
      }
    });
  }

  @override
  void dispose() {
    historyScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationHistoryController>(
      builder: (controller) {
        return controller.isHistoryLoading
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.space16.w),
                child: TransactionHistoryShimmer(),
              )
            : (controller.notificationHistoryList.isEmpty)
                ? SingleChildScrollView(
                    child: NoDataWidget(
                      text: MyStrings.noSupportNotificationToShow.tr,
                    ),
                  )
                : RefreshIndicator(
                    color: MyColor.getPrimaryColor(),
                    onRefresh: () async {
                      controller.initialHistoryData();
                    },
                    child: ListView.builder(
                      controller: historyScrollController,
                      itemCount: controller.notificationHistoryList.length + 1,
                      itemBuilder: (context, index) {
                        if (controller.notificationHistoryList.length == index) {
                          return controller.hasNext() ? const CustomLoader(isPagination: true) : const SizedBox();
                        }
                        var item = controller.notificationHistoryList[index];
                        bool isLastIndex = index == controller.notificationHistoryList.length - 1;
                        return Container(
                          padding: EdgeInsets.symmetric(
                            vertical: Dimensions.space8.h,
                            horizontal: Dimensions.space16.w,
                          ),
                          decoration: BoxDecoration(
                            // color: item.userRead =="0" ? MyColor.getScreenBgColor():MyColor.getTransparentColor(),
                            border: isLastIndex == true
                                ? null
                                : Border(
                                    bottom: BorderSide(
                                      color: MyColor.getBorderColor(),
                                    ),
                                  ),
                          ),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateConverter.estimatedDateOrTime(
                                      item.createdAt ?? "",
                                      customFormat: "dd-MM-yyyy hh:mm aa",
                                    ),
                                    style: MyTextStyle.sectionSubTitle1.copyWith(
                                      color: MyColor.getBodyTextColor(),
                                    ),
                                  ),
                                  spaceDown(Dimensions.space8),
                                  HeaderText(
                                    text: item.subject ?? "",
                                    // textStyle: MyTextStyle.sectionSubTitle1.copyWith(color: MyColor.getBodyTextColor()),
                                  ),
                                  spaceDown(Dimensions.space8),
                                  DefaultText(
                                    text: item.message ?? "",
                                    textStyle: MyTextStyle.sectionSubTitle1.copyWith(
                                      color: MyColor.getBodyTextColor(),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
      },
    );
  }
}
