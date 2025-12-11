import 'package:flutter/material.dart';
import 'package:openarms/common/widgets/custom_shapes/containers/primary_header_container.dart';

class AuthTemplate extends StatelessWidget {
  const AuthTemplate({
    super.key,
    required this.logo,
    required this.color1,
    required this.color2,
    required this.title,
    required this.fields,
    required this.primaryButton,
    this.secondaryActions = const [],
    this.heroTag,
    this.formKey,
    this.divider,
  });

  final String logo;
  final Color color1;
  final Color color2;
  final String title;
  final List<Widget> fields;
  final Widget primaryButton;
  final List<Widget> secondaryActions;
  final String? heroTag;
  final GlobalKey<FormState>? formKey;
  final Widget? divider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            // Header with Hero animation
            Hero(
              tag: heroTag ?? logo,
              child: TPrimaryHeaderContainer(
                logo: logo,
                color1: color1,
                color2: color2,
              ),
            ),

            // FIX 2: Wrap SingleChildScrollView in Expanded
            // This ensures the form takes the remaining space and doesn't overflow
            Expanded(
              child: SingleChildScrollView(
                physics:
                    const ClampingScrollPhysics(), // Smoother scrolling behavior
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Page Title
                        Text(
                          title,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 16),

                        // Input Fields
                        ...fields,
                        const SizedBox(height: 24),

                        // Primary Action Button
                        primaryButton,
                        const SizedBox(height: 24),

                        // Optional Divider
                        if (divider != null) ...[
                          divider!,
                          const SizedBox(height: 24),
                        ],

                        if (secondaryActions.isNotEmpty)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: secondaryActions,
                          ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
