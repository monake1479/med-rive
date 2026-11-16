import 'package:material_ui/material_ui.dart';

class PhaseLabel extends StatelessWidget {
  const PhaseLabel({super.key, required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
      const SizedBox(width: 8),
      Text(label, style: Theme.of(context).textTheme.bodyMedium),
    ],
  );
}
