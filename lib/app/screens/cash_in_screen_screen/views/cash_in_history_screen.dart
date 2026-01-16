import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovopayagent/app/components/bottom-sheet/bottom_sheet_header_row.dart';
import 'package:ovopayagent/app/components/bottom-sheet/custom_bottom_sheet_plus.dart';
import 'package:ovopayagent/app/components/card/custom_card.dart';
import 'package:ovopayagent/app/components/card/custom_company_list_tile_card.dart';
import 'package:ovopayagent/app/components/card/my_custom_scaffold.dart';
import 'package:ovopayagent/app/components/column_widget/card_column.dart';
import 'package:ovopayagent/app/components/custom_loader/custom_loader.dart';
import 'package:ovopayagent/app/components/image/my_network_image_widget.dart';
import 'package:ovopayagent/app/components/no_data.dart';
import 'package:ovopayagent/app/components/shimmer/transaction_history_shimmer.dart';
import 'package:ovopayagent/app/screens/cash_in_screen_screen/controller/cash_in_controller.dart';
import 'package:ovopayagent/core/data/models/modules/cash_in/cash_in_history_response_model.dart';
import 'package:ovopayagent/core/data/repositories/modules/cash_in/cash_in_repo.dart';

import '../../../../../core/utils/util_exporter.dart';

class CashInHistoryScreen extends StatefulWidget {
  const CashInHistoryScreen({super.key});

  @override
  State<CashInHistoryScreen> createState() => _CashInHistoryScreenState();
}

class _CashInHistoryScreenState extends State<CashInHistoryScreen> {
  final ScrollController historyScrollController = ScrollController();
  void fetchData() {
    Get.find<CashInController>().getCashInHistoryDataList(forceLoad: false);
  }

  void scrollListener({required bool isReceiver}) {
    if (historyScrollController.position.pixels == historyScrollController.position.maxScrollExtent) {
      if (Get.find<CashInController>().hasNext()) {
        fetchData();
      }
    }
  }

  @override
  void initState() {
    super.initState();

    Get.put(CashInRepo());
    final controller = Get.put(CashInController(cashInRepo: Get.find()));

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
    return GetBuilder<CashInController>(
      builder: (controller) {
        return MyCustomScaffold(
          pageTitle: MyStrings.cashInHistory,
          body: CustomAppCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: controller.isHistoryLoading
                      ? TransactionHistoryShimmer()
                      : (controller.cashInHistoryList.isEmpty)
                          ? SingleChildScrollView(
                              child: NoDataWidget(
                                text: MyStrings.noTransactionsToShow.tr,
                              ),
                            )
                          : RefreshIndicator(
                              color: MyColor.getPrimaryColor(),
                              onRefresh: () async {
                                controller.initialHistoryData();
                              },
                              child: ListView.builder(
                                physics: ClampingScrollPhysics(
                                  parent: AlwaysScrollableScrollPhysics(),
                                ),
                                controller: historyScrollController,
                                itemCount: controller.cashInHistoryList.length + 1,
                                itemBuilder: (context, index) {
                                  if (controller.cashInHistoryList.length == index) {
                                    return controller.hasNext() ? const CustomLoader(isPagination: true) : const SizedBox();
                                  }
                                  var item = controller.cashInHistoryList[index];
                                  bool isLastIndex = index == controller.cashInHistoryList.length - 1;
                                  return CustomCompanyListTileCard(
                                    leading: MyNetworkImageWidget(
                                      width: Dimensions.space40.w,
                                      height: Dimensions.space40.w,
                                      radius: Dimensions.radiusProMax.r,
                                      isProfile: true,
                                      imageUrl: item.receiverUser?.getUserImageUrl() ?? "",
                                      imageAlt: item.receiverUser?.getFullName(),
                                    ),
                                    imagePath: item.receiverUser?.getUserImageUrl(),
                                    title: item.receiverUser?.getFullName(),
                                    subtitle: MyStrings.cashInMessage.tr.rKv({
                                      "amount": MyUtils.getUserAmount(
                                        item.amount ?? "",
                                      ),
                                      "date": DateConverter.estimatedDateOrTime(
                                        item.createdAt ?? "",
                                        customFormat: "dd-MM-yyyy",
                                      ),
                                    }),
                                    titleStyle: MyTextStyle.sectionSubTitle1.copyWith(fontWeight: FontWeight.w600),
                                    subtitleStyle: MyTextStyle.caption2Style.copyWith(
                                      color: MyColor.getBodyTextColor(),
                                    ),
                                    showBorder: !isLastIndex,
                                    onPressed: () {
                                      CustomBottomSheetPlus(
                                        child: SafeArea(
                                          child: buildDetailsSectionSheet(
                                            item: item,
                                            context: context,
                                          ),
                                        ),
                                      ).show(context);
                                    },
                                  );
                                },
                              ),
                            ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildDetailsSectionSheet({
    required LatestCashInHistoryData item,
    required BuildContext context,
  }) {
    return SingleChildScrollView(
      child: Column(
        children: [
          BottomSheetHeaderRow(header: MyStrings.details),
          spaceDown(Dimensions.space10),
          CustomCompanyListTileCard(
            leading: MyNetworkImageWidget(
              width: Dimensions.space40.w,
              height: Dimensions.space40.w,
              imageAlt: "${item.receiverUser?.getFullName()}",
              isProfile: true,
              imageUrl: item.receiverUser?.getUserImageUrl() ?? "",
            ),
            showBorder: false,
            imagePath: item.receiverUser?.getUserImageUrl() ?? "",
            title: "${item.receiverUser?.getFullName()}",
            subtitle: "+${item.receiverUser?.getUserMobileNo(withCountryCode: true) ?? ""}",
          ),
          spaceDown(Dimensions.space10),
          Container(
            height: 1,
            width: double.infinity,
            color: MyColor.getBorderColor(),
            margin: const EdgeInsets.symmetric(horizontal: 0),
          ),
          spaceDown(Dimensions.space10),
          //Number and time
          Row(
            children: [
              Expanded(
                child: CardColumn(
                  headerTextStyle: MyTextStyle.caption1Style.copyWith(
                    color: MyColor.getBodyTextColor(),
                  ),
                  bodyTextStyle: MyTextStyle.sectionTitle3.copyWith(
                    fontSize: Dimensions.fontLarge,
                    color: MyColor.getHeaderTextColor(),
                  ),
                  header: MyStrings.phoneNumber.tr,
                  body: "+${item.receiverUser?.getUserMobileNo(withCountryCode: true) ?? ""}",
                  space: 5,
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ),
              Container(
                height: Dimensions.space50,
                width: 1,
                color: MyColor.getBorderColor(),
                margin: const EdgeInsets.symmetric(horizontal: 10),
              ),
              Expanded(
                child: CardColumn(
                  headerTextStyle: MyTextStyle.caption1Style.copyWith(
                    color: MyColor.getBodyTextColor(),
                  ),
                  bodyTextStyle: MyTextStyle.sectionTitle3.copyWith(
                    fontSize: Dimensions.fontLarge,
                    color: MyColor.getHeaderTextColor(),
                  ),
                  header: MyStrings.time,
                  body: DateConverter.estimatedDateOrTime(
                    item.createdAt ?? "0",
                  ),
                  isBodyEllipsis: false,
                  space: 5,
                  crossAxisAlignment: CrossAxisAlignment.end,
                ),
              ),
            ],
          ),
          spaceDown(Dimensions.space10),
          Container(
            height: 1,
            width: double.infinity,
            color: MyColor.getBorderColor(),
            margin: const EdgeInsets.symmetric(horizontal: 0),
          ),
          spaceDown(Dimensions.space10),
          //amount and charge
          Row(
            children: [
              Expanded(
                child: CardColumn(
                  headerTextStyle: MyTextStyle.caption1Style.copyWith(
                    color: MyColor.getBodyTextColor(),
                  ),
                  bodyTextStyle: MyTextStyle.sectionTitle3.copyWith(
                    fontSize: Dimensions.fontLarge,
                    color: MyColor.getHeaderTextColor(),
                  ),
                  header: MyStrings.amount.tr,
                  body: MyUtils.getUserAmount(item.amount ?? ""),
                  space: 5,
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ),
              Container(
                height: Dimensions.space50,
                width: 1,
                color: MyColor.getBorderColor(),
                margin: const EdgeInsets.symmetric(horizontal: 10),
              ),
              Expanded(
                child: CardColumn(
                  headerTextStyle: MyTextStyle.caption1Style.copyWith(
                    color: MyColor.getBodyTextColor(),
                  ),
                  bodyTextStyle: MyTextStyle.sectionTitle3.copyWith(
                    fontSize: Dimensions.fontLarge,
                    color: MyColor.getHeaderTextColor(),
                  ),
                  header: MyStrings.commission,
                  body: MyUtils.getUserAmount(item.commission ?? ""),
                  space: 5,
                  crossAxisAlignment: CrossAxisAlignment.end,
                ),
              ),
            ],
          ),
          spaceDown(Dimensions.space10),
          Container(
            height: 1,
            width: double.infinity,
            color: MyColor.getBorderColor(),
            margin: const EdgeInsets.symmetric(horizontal: 0),
          ),
          spaceDown(Dimensions.space10),
          //note  and status
          Row(
            children: [
              Expanded(
                child: CardColumn(
                  headerTextStyle: MyTextStyle.caption1Style.copyWith(
                    color: MyColor.getBodyTextColor(),
                  ),
                  bodyTextStyle: MyTextStyle.sectionTitle3.copyWith(
                    fontSize: Dimensions.fontLarge,
                    color: MyColor.getHeaderTextColor(),
                  ),
                  header: MyStrings.total.tr,
                  body: MyUtils.getUserAmount(item.amount ?? ""),
                  space: 5,
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ),
              Container(
                height: Dimensions.space50,
                width: 1,
                color: MyColor.getBorderColor(),
                margin: const EdgeInsets.symmetric(horizontal: 10),
              ),
              Expanded(
                child: CardColumn(
                  headerTextStyle: MyTextStyle.caption1Style.copyWith(
                    color: MyColor.getBodyTextColor(),
                  ),
                  bodyTextStyle: MyTextStyle.sectionTitle3.copyWith(
                    fontSize: Dimensions.fontLarge,
                    color: MyColor.getHeaderTextColor(),
                  ),
                  header: MyStrings.transactionId,
                  body: item.trx ?? "---",
                  space: 5,
                  isCopyable: true,
                  crossAxisAlignment: CrossAxisAlignment.end,
                ),
              ),
            ],
          ),
          spaceDown(Dimensions.space10),
          Container(
            height: 1,
            width: double.infinity,
            color: MyColor.getBorderColor(),
            margin: const EdgeInsets.symmetric(horizontal: 0),
          ),
        ],
      ),
    );
  }
}
