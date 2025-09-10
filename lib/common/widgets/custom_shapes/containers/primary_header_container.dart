import 'dart:math';
import 'package:flutter/material.dart';
import 'package:t_store/common/widgets/custom_shapes/containers/circular_container.dart';
import 'package:t_store/common/widgets/custom_shapes/curved_edges/curved_edges_widgets.dart';
import 'package:t_store/utils/constants/colors.dart';
import 'package:t_store/utils/constants/sizes.dart';

class TPrimaryHeaderContainer extends StatefulWidget {
  const TPrimaryHeaderContainer({
    super.key,
    this.showDesignContainer = false,
    required this.logo,
    required this.color1,
    required this.color2,
  });
  final String logo;
  final Color color1;
  final Color color2;

  final bool showDesignContainer;

  @override
  State<TPrimaryHeaderContainer> createState() =>
      _TPrimaryHeaderContainerState();
}

class _TPrimaryHeaderContainerState extends State<TPrimaryHeaderContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat(); // infinite rotation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Alignment _getAlignment(double angle) {
    // convert angle to circular motion on unit circle
    return Alignment(cos(angle), sin(angle));
  }

  @override
  Widget build(BuildContext context) {
    return TCurvedEdgesWidget(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final angle = _controller.value * 2 * pi; // 0 → 2π loop
          final begin = _getAlignment(angle);
          final end = _getAlignment(angle + pi); // opposite side

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [widget.color1, widget.color2],
                //stops: [0.4, 0.8],
                begin: begin,
                end: end,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -150,
                  right: -250,
                  child: widget.showDesignContainer
                      ? TCircularContainer(
                          backgroundColor:
                              TColors.textWhite.withAlpha((255 * 0.1).toInt()),
                        )
                      : const SizedBox(),
                ),
                Positioned(
                  top: 100,
                  right: -300,
                  child: widget.showDesignContainer
                      ? TCircularContainer(
                          backgroundColor:
                              TColors.textWhite.withAlpha((255 * 0.1).toInt()),
                        )
                      : const SizedBox(),
                ),
                Padding(
                  padding: const EdgeInsets.all(
                    TSizes.spaceBtwSections,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image(
                          height: 150,
                          image: AssetImage(widget.logo),
                        ),
                        // Text(
                        //   TTexts.loginTitle,
                        //   style: Theme.of(context).textTheme.headlineMedium,
                        // ),
                        // const SizedBox(height: TSizes.sm),
                        // Text(
                        //   TTexts.loginSubTitle,
                        //   style: Theme.of(context).textTheme.bodyMedium,
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
