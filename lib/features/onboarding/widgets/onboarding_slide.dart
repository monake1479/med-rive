import 'package:material_ui/material_ui.dart';

class OnboardingSlide extends StatelessWidget {
  const OnboardingSlide({
    super.key,
    required this.upperTitle,
    required this.title,
    required this.description,
  });

  final String upperTitle;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TODO(Daniel): Replace this SizedBox with real Rive animation.
          const SizedBox(height: 304, width: double.infinity),
          const SizedBox(height: 24),
          Text(
            upperTitle,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(title, style: theme.textTheme.headlineLarge),
          const SizedBox(height: 16),
          Text(
            description,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
