import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovopayagent/app/screens/transaction_history/controller/transaction_history_controller.dart';
import 'package:ovopayagent/app/screens/transaction_history/views/transaction_history_screen.dart';
import 'package:ovopayagent/core/data/models/transaction_history/transaction_history_model.dart';
import '../../../components/bottom-sheet/bottom_sheet_header_row.dart';
import '../../../components/bottom-sheet/custom_bottom_sheet_plus.dart';
import '../../../components/buttons/custom_elevated_button.dart';
import '../../../components/card/custom_card.dart';
import '../../../components/card/my_custom_scaffold.dart';
import '../../../components/divider/custom_divider.dart';
import '../../../components/drop_down/my_drop_down_widget.dart';
import '../../../components/image/my_asset_widget.dart';
import '../../../components/text-field/rounded_text_field.dart';
import '../../../components/text/header_text.dart';
import 'widgets/notification_tab_widget.dart';

import '../../../../core/utils/util_exporter.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key, this.isTransaction = true, this.onItemTapped});
  final bool isTransaction;
  final Function(int index)? onItemTapped;
  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.isTransaction ? 0 : 1;
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: _selectedIndex,
    );

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _selectedIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyCustomScaffold(
      pageTitle: MyStrings.inbox,
      onBackButtonTap: (widget.onItemTapped != null)
          ? () {
              widget.onItemTapped!(0);
            }
          : null,
      actionButton: [
        AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          child: _selectedIndex == 0
              ? CustomAppCard(
                  onPressed: () {
                    CustomBottomSheetPlus(
                      child: SafeArea(child: buildFilterSection()),
                    ).show(context);
                  },
                  width: Dimensions.space40.w,
                  height: Dimensions.space40.w,
                  padding: EdgeInsetsDirectional.all(Dimensions.space8.w),
                  radius: Dimensions.largeRadius.r,
                  borderColor: MyColor.getPrimaryColor(),
                  child: MyAssetImageWidget(
                    isSvg: true,
                    assetPath: MyIcons.filterIcon,
                    width: Dimensions.space24.w,
                    height: Dimensions.space24.w,
                    color: MyColor.getPrimaryColor(),
                  ),
                )
              : SizedBox.shrink(),
        ),
        spaceSide(Dimensions.space16.w),
      ],
      body: CustomAppCard(
        padding: EdgeInsets.zero,
        width: double.infinity,
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              // Custom Tab Bar
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildAnimatedTab(0, MyStrings.transaction.tr),
                    spaceSide(Dimensions.space10),
                    _buildAnimatedTab(1, MyStrings.notification.tr),
                  ],
                ),
              ),
              //Border
              CustomDivider(
                color: MyColor.getBorderColor(),
                space: 0,
                thickness: 1,
              ),

              // TabBarView Content
              Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                    TransactionHistoryScreen(),
                    NotificationTabWidget(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedTab(int index, String label) {
    bool isSelected = _selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          _tabController.animateTo(index);
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(
            vertical: Dimensions.space15.h,
            horizontal: Dimensions.space10.w,
          ),
          decoration: BoxDecoration(
            color: isSelected ? MyColor.getPrimaryColor().withValues(alpha: 0.25) : MyColor.getScreenBgColor(),
            borderRadius: BorderRadius.circular(Dimensions.largeRadius.r),
          ),
          child: HeaderText(
            text: label,
            textAlign: TextAlign.center,
            textStyle: MyTextStyle.sectionTitle.copyWith(
              color: MyColor.getBodyTextColor(),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFilterSection() {
    return GetBuilder<TransactionHistoryController>(
      builder: (transactionHistoryController) {
        return StatefulBuilder(
          builder: (context, setEr) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  BottomSheetHeaderRow(header: MyStrings.filter),
                  spaceDown(Dimensions.space20),
                  AppDropdownWidget<TransactionsRemark>(
                    items: transactionHistoryController.transactionHistoryRemarkList,
                    itemToString: (value) {
                      return transactionHistoryController.getRemarkText(
                        value.remark ?? "",
                      );
                    },
                    onItemSelected: (v) {
                      transactionHistoryController.onSelectRemarkChanges(v);
                    },
                    selectedItem: transactionHistoryController.selectedRemark,
                    child: RoundedTextField(
                      readOnly: true,
                      labelText: MyStrings.remark.tr,
                      hintText: '',
                      controller: TextEditingController(
                        text: transactionHistoryController.getRemarkText(
                          transactionHistoryController.selectedRemark?.remark,
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.phone,
                      onTap: () {},
                      suffixIcon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: MyColor.getDarkColor(),
                      ),
                    ),
                  ),
                  spaceDown(Dimensions.space20),
                  AppDropdownWidget<String>(
                    items: transactionHistoryController.dropdownItemsOrderBy,
                    onItemSelected: (v) {
                      transactionHistoryController.onSelectOrderByChanges(v);
                    },
                    selectedItem: transactionHistoryController.selectOrderBy,
                    child: RoundedTextField(
                      readOnly: true,
                      labelText: MyStrings.orderBy.tr,
                      hintText: '',
                      controller: TextEditingController(
                        text: "${transactionHistoryController.selectOrderBy}",
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.phone,
                      onTap: () {},
                      suffixIcon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: MyColor.getDarkColor(),
                      ),
                    ),
                  ),
                  spaceDown(Dimensions.space20),
                  AppDropdownWidget(
                    items: transactionHistoryController.dropdownItemsTrxType,
                    onItemSelected: (v) {
                      transactionHistoryController.onSelectTrxTypeChanges(v);
                    },
                    selectedItem: transactionHistoryController.selectTrxType,
                    child: RoundedTextField(
                      readOnly: true,
                      labelText: MyStrings.trxType.tr,
                      hintText: '',
                      controller: TextEditingController(
                        text: "${transactionHistoryController.selectTrxType}",
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.phone,
                      onTap: () {},
                      suffixIcon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: MyColor.getDarkColor(),
                      ),
                    ),
                  ),
                  spaceDown(Dimensions.space20),
                  RoundedTextField(
                    labelText: MyStrings.trxId.tr,
                    hintText: MyStrings.searchByTrxId.tr,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    controller: transactionHistoryController.searchTrxNoController,
                  ),
                  spaceDown(Dimensions.space20),
                  Row(
                    children: [
                      Expanded(
                        child: CustomElevatedBtn(
                          radius: Dimensions.largeRadius.r,
                          textColor: MyColor.getDarkColor(),
                          bgColor: MyColor.getWhiteColor(),
                          borderColor: MyColor.getBorderColor(),
                          text: MyStrings.reset,
                          onTap: () {
                            transactionHistoryController.resetFilter();
                            Get.back();
                          },
                        ),
                      ),
                      spaceSide(Dimensions.space15),
                      Expanded(
                        child: CustomElevatedBtn(
                          isLoading: transactionHistoryController.isHistoryLoading,
                          radius: Dimensions.largeRadius.r,
                          bgColor: MyColor.getPrimaryColor(),
                          text: MyStrings.filter,
                          onTap: () async {
                            await transactionHistoryController.initialHistoryData().whenComplete(() {
                              Get.back();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  spaceDown(Dimensions.space20),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
