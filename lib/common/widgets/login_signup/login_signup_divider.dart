import 'package:flutter/material.dart';

class TFormDivider extends StatelessWidget {
  const TFormDivider({
    super.key,
    required this.dividerText1,
    this.dividerText2 = "",
    this.isSecond = false,
  });

  final String dividerText1;
  final String dividerText2;
  final bool isSecond;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left Divider
        const Expanded(
          child: Divider(thickness: 0.5, endIndent: 10),
        ),

        // First text
        Text(
          dividerText1,
          style: Theme.of(context).textTheme.labelMedium,
        ),

        // Optional second text + divider
        if (isSecond) ...[
          const SizedBox(width: 8),
          Text(
            "|",
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(width: 8),
          Text(
            dividerText2,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],

        // Right Divider
        const Expanded(
          child: Divider(thickness: 0.5, indent: 10),
        ),
      ],
    );
  }
}
