import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ovopayagent/app/components/column_widget/card_column.dart';

import '../../../core/utils/util_exporter.dart';

class AmountDetailsCard extends StatelessWidget {
  final String? amount, amountBody, charge, total, totalBody;
  final String? firstTitle;
  final String? centerTitle;
  final String? endTitle;

  const AmountDetailsCard({
    super.key,
    this.amount,
    this.amountBody,
    this.charge,
    this.total,
    this.totalBody,
    this.firstTitle,
    this.endTitle,
    this.centerTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (amount != null) ...[
          Expanded(
            flex: 4,
            child: CardColumn(
              headerTextStyle: MyTextStyle.caption1Style.copyWith(
                color: MyColor.getBodyTextColor(),
              ),
              header: firstTitle ?? MyStrings.amount.tr,
              body: amount ?? "",
              subBody: amountBody,
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
        ],
        if (charge != null) ...[
          Expanded(
            flex: 4,
            child: CardColumn(
              headerTextStyle: MyTextStyle.caption1Style.copyWith(
                color: MyColor.getBodyTextColor(),
              ),
              header: centerTitle ?? MyStrings.charge.tr,
              body: charge ?? "",
              space: 5,
              crossAxisAlignment: CrossAxisAlignment.center,
              // bodyTextStyle: boldMediumLarge.copyWith(fontSize: 16),
            ),
          ),
          Container(
            height: Dimensions.space50,
            width: 1,
            color: MyColor.getBorderColor(),
            margin: const EdgeInsets.symmetric(horizontal: 5),
          ),
        ],
        if (total != null) ...[
          Expanded(
            flex: 4,
            child: CardColumn(
              headerTextStyle: MyTextStyle.caption1Style.copyWith(
                color: MyColor.getBodyTextColor(),
              ),
              header: endTitle ?? MyStrings.total.tr,
              body: total ?? "",
              subBody: totalBody,
              space: 5,
              crossAxisAlignment: CrossAxisAlignment.end,
            ),
          ),
        ],
      ],
    );
  }
}
