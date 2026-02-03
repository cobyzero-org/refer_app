import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:refer_app/core/constants/colors.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class PointDetail extends StatelessWidget {
  const PointDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 170,
            width: 170,
            child: SfRadialGauge(
              axes: <RadialAxis>[
                RadialAxis(
                  startAngle: 120,
                  endAngle: 60,
                  showLabels: false,
                  showTicks: false,
                  canScaleToFit: true,
                  radiusFactor: 0.7,
                  minimum: 0,
                  maximum: 15,
                  axisLineStyle: AxisLineStyle(
                    thickness: 0.1,
                    color: AppColors.proggressBarDarkGreen.withOpacity(0.5),
                    thicknessUnit: GaugeSizeUnit.factor,
                    cornerStyle: CornerStyle.bothFlat,
                  ),
                  pointers: const <GaugePointer>[
                    RangePointer(
                      value: 6,
                      width: 0.2,
                      sizeUnit: GaugeSizeUnit.factor,
                      enableAnimation: true,
                      animationDuration: 100,
                      color: AppColors.proggressBarDarkGreen,
                      animationType: AnimationType.linear,
                      cornerStyle: CornerStyle.bothFlat,
                      pointerOffset: -0.05,
                    ),
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                      widget: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/coffee_cup.svg',
                                  height: 60,
                                  width: 60,
                                  alignment: Alignment.center,
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 6.0),
                                  child: Text(
                                    '6/15',
                                    style: TextStyle(
                                      color: AppColors.darkGreen,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icon/u_star.svg',
                    height: 30,
                    width: 30,
                    color: AppColors.gold,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      '0',
                      style: TextStyle(
                        color: AppColors.dark,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const Text(
                'Yıldız bakiyesi',
                style: TextStyle(
                  color: AppColors.dark,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icon/u_cup.svg',
                    height: 30,
                    width: 30,
                    color: AppColors.darkGreen,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      '0',
                      style: TextStyle(
                        color: AppColors.dark,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const Text(
                'İkram içecek',
                style: TextStyle(
                  color: AppColors.dark,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
