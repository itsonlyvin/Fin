import 'package:flutter/material.dart';
import 'package:t_store/utils/constants/sizes.dart';

class SpecialColumn extends StatelessWidget {
  const SpecialColumn({
    super.key,
    required this.dark,
    required this.child,
  });

  final bool dark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: TSizes.defaultSpace),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: dark
              ? const Color(0xFF1E1E1E) // Dark card color
              : Colors.white,
          boxShadow: [
            BoxShadow(
              color: dark
                  ? Colors.black.withValues(alpha: 0.5)
                  : Colors.grey.withValues(alpha: 0.3),

              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 4), // softer downward shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: child,
        ),
      ),
    );
  }
}
