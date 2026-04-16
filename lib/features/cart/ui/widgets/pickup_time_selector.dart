import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/pickup_time_bloc.dart';
import '../../bloc/pickup_time_event.dart';
import '../../bloc/pickup_time_state.dart';
import '../../../../l10n/app_localizations.dart';

class PickupTimeSelector extends StatelessWidget {
  const PickupTimeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PickupTimeBloc, PickupTimeState>(
      builder: (context, state) {
        return Column(
          children: [
            _buildOption(
              context,
              title: 'As soon as possible',
              subtitle: state.waitTimeMessage,
              isSelected: state.type == PickupTimeType.asap,
              onTap: () {
                context.read<PickupTimeBloc>().add(
                      PickupTimeTypeChanged(PickupTimeType.asap),
                    );
              },
            ),
            const SizedBox(height: 12),
            _buildOption(
              context,
              title: 'Schedule for later',
              subtitle: state.scheduledTime != null
                  ? '${state.scheduledTime!.hour.toString().padLeft(2, '0')}:${state.scheduledTime!.minute.toString().padLeft(2, '0')}'
                  : 'Select a specific time',
              isSelected: state.type == PickupTimeType.scheduled,
              icon: Icons.access_time_filled_rounded,
              onTap: () => _selectTime(context),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF1E3932) : Colors.transparent,
            width: isSelected ? 1.5 : 0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isSelected ? Colors.black : Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF1E3932),
              )
            else
              Icon(icon ?? Icons.circle_outlined, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1E3932),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E3932),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final now = DateTime.now();
      final scheduled = DateTime(
        now.year,
        now.month,
        now.day,
        picked.hour,
        picked.minute,
      );

      if (scheduled.isBefore(now)) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.selectFutureTime),
              backgroundColor: Colors.red.shade800,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
        return;
      }
      context.read<PickupTimeBloc>().add(ScheduledTimeChanged(scheduled));
    }
  }
}
