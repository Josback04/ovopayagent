import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovopayagent/app/screens/transaction_history/views/widgets/custom_main_transactions_list_tile_card.dart';
import 'package:ovopayagent/app/components/custom_loader/custom_loader.dart';
import 'package:ovopayagent/app/components/no_data.dart';
import 'package:ovopayagent/app/components/shimmer/transaction_history_shimmer.dart';
import 'package:ovopayagent/app/screens/transaction_history/controller/transaction_history_controller.dart';
import 'package:ovopayagent/core/data/repositories/transaction_history/transaction_history_repo.dart';

import '../../../../../../core/utils/util_exporter.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key, this.onItemTapped});
  final Function(int index)? onItemTapped;
  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final ScrollController historyScrollController = ScrollController();
  void fetchData() {
    Get.find<TransactionHistoryController>().getTransactionHistoryDataList(
      forceLoad: false,
    );
  }

  void scrollListener({required bool isReceiver}) {
    if (historyScrollController.position.pixels == historyScrollController.position.maxScrollExtent) {
      if (Get.find<TransactionHistoryController>().hasNext()) {
        fetchData();
      }
    }
  }

  @override
  void initState() {
    super.initState();

    Get.put(TransactionHistoryRepo());
    final controller = Get.put(
      TransactionHistoryController(transactionHistoryRepo: Get.find()),
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
    return GetBuilder<TransactionHistoryController>(
      builder: (controller) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.space16.w),
          child: controller.isHistoryLoading
              ? TransactionHistoryShimmer()
              : (controller.transactionHistoryList.isEmpty)
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
                        itemCount: controller.transactionHistoryList.length + 1,
                        itemBuilder: (context, index) {
                          if (controller.transactionHistoryList.length == index) {
                            return controller.hasNext() ? const CustomLoader(isPagination: true) : const SizedBox();
                          }
                          var item = controller.transactionHistoryList[index];
                          bool isLastIndex = index == controller.transactionHistoryList.length - 1;

                          return CustomMainTransactionListTileCard(
                            item: item,
                            title: controller.getRemarkText("${item.remark}"),
                            showBorder: !isLastIndex,
                            balance: MyUtils.getUserAmount(item.amount ?? ""),
                            trxType: "${item.trxType}",
                            date: DateConverter.estimatedDateOrTime(
                              item.createdAt ?? "",
                              customFormat: "dd/MM/yyyy hh:mm aa",
                            ),
                            onPressed: () {},
                            remark: "${item.remark}",
                          );
                        },
                      ),
                    ),
        );
      },
    );
  }
}
