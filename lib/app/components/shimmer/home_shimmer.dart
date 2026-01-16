import 'package:flutter/material.dart';
import 'package:ovopayagent/app/components/card/custom_card.dart';
import 'package:ovopayagent/core/utils/util_exporter.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.zone(
      enabled: true,
      child: Column(
        children: [
          CustomAppCard(
            child: Padding(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: Dimensions.space12.w,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Wallet
                      Bone.circle(size: Dimensions.space24.h),
                      spaceSide(Dimensions.space8),
                      Expanded(child: Bone.text()),
                      //Qr Code
                      Bone.circle(size: Dimensions.space40.h),
                    ],
                  ),
                  spaceDown(Dimensions.space25),
                  Bone.text(style: TextStyle(fontSize: 35)),
                  spaceDown(Dimensions.space25),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Bone.circle(size: Dimensions.space50.h),
                      Bone.circle(size: Dimensions.space50.h),
                      Bone.circle(size: Dimensions.space50.h),
                      Bone.circle(size: Dimensions.space50.h),
                      Bone.circle(size: Dimensions.space50.h),
                    ],
                  ),
                ],
              ),
            ),
          ),
          spaceDown(Dimensions.space10),

          // Expanded(child: CustomAppCard(child: TransactionHistoryShimmer()))
        ],
      ),
    );
  }
}
