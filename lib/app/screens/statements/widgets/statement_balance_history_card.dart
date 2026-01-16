import 'package:flutter/material.dart';
import 'package:ovopayagent/app/components/card/custom_card.dart';
import 'package:ovopayagent/app/components/card/custom_list_tile_card.dart';
import 'package:ovopayagent/app/components/text/default_text.dart';
import 'package:ovopayagent/app/components/text/header_text_smaller.dart';
import 'package:ovopayagent/app/screens/statements/controller/statement_history_controller.dart';

import '../../../../../core/utils/util_exporter.dart';
import '../../../../core/data/services/service_exporter.dart';

class StatementBalanceHistoryCard extends StatelessWidget {
  const StatementBalanceHistoryCard({super.key, required this.controller});
  final StatementHistoryController controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomAppCard(
          child: Column(
            children: [
              buildHistoryLIstTile(
                title: MyStrings.startingBalance,
                subTitle: "${SharedPreferenceService.getCurrencySymbol()}${AppConverter.formatNumber(controller.statementsData?.startingBalance ?? "0")}",
              ),
              buildHistoryLIstTile(
                title: MyStrings.monthlyTransaction,
                subTitle: "${SharedPreferenceService.getCurrencySymbol()}${AppConverter.formatNumber(controller.statementsData?.totalTransactionAmount ?? "0")}",
              ),
              buildHistoryLIstTile(
                title: MyStrings.numberOfTransaction,
                subTitle: (controller.statementsData?.totalTransactionCount ?? "0"),
                showBorder: false,
              ),
            ],
          ),
        ),
        spaceDown(Dimensions.space20),
        CustomAppCard(
          showBorder: controller.isStatementLoading,
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.space16,
            vertical: Dimensions.space18.h,
          ),
          backgroundColor: controller.isStatementLoading ? MyColor.getWhiteColor() : MyColor.getPrimaryColor(),
          child: CustomListTileCard(
            padding: EdgeInsets.zero,
            showBorder: false,
            leading: Icon(
              Icons.wallet_giftcard_outlined,
              color: MyColor.getWhiteColor(),
            ),
            title: MyStrings.commission,
            titleStyle: MyTextStyle.sectionBodyBoldTextStyle.copyWith(
              color: MyColor.getWhiteColor(),
            ),
            trailing: HeaderTextSmaller(
              text: "${SharedPreferenceService.getCurrencySymbol()}${AppConverter.formatNumber(controller.statementsData?.totalCommission ?? "0")}",
              textAlign: TextAlign.end,
              textStyle: MyTextStyle.sectionBodyBoldTextStyle.copyWith(
                color: MyColor.getWhiteColor(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildHistoryLIstTile({
    required String title,
    required String subTitle,
    bool showBorder = true,
  }) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(vertical: Dimensions.space10.h),
      decoration: BoxDecoration(
        border: showBorder == false ? null : Border(bottom: BorderSide(color: MyColor.getBorderColor())),
      ),
      child: Row(
        children: [
          Expanded(
            child: DefaultText(
              text: title,
              textStyle: MyTextStyle.sectionBodyTextStyle.copyWith(
                color: MyColor.getBodyTextColor(),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: HeaderTextSmaller(
              text: subTitle,
              textAlign: TextAlign.end,
              textStyle: MyTextStyle.sectionBodyBoldTextStyle.copyWith(
                color: MyColor.getBodyTextColor(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
