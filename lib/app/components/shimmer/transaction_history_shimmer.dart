import 'package:flutter/material.dart';
import 'package:ovopayagent/app/screens/transaction_history/views/widgets/custom_main_transactions_list_tile_card.dart';
import 'package:ovopayagent/core/utils/my_color.dart';
import 'package:ovopayagent/core/utils/text_style.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TransactionHistoryShimmer extends StatelessWidget {
  const TransactionHistoryShimmer({super.key, this.showTitle = false});
  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      enableSwitchAnimation: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showTitle) ...[Bone.text()],
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return CustomMainTransactionListTileCard(
                  leading: Container(
                    width: 40,
                    height: 40,
                    color: MyColor.accent1,
                  ),
                  title: "Jacob Jones",
                  subtitle: "Completed",
                  subtitleStyle: MyTextStyle.sectionSubTitle1,
                  balance: "\$56.00",
                  date: "12-10-2024 6:45",
                  onPressed: () {},
                  remark: "1",
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
