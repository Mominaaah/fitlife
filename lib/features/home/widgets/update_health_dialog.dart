import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';


class UpdateHealthDialog extends StatefulWidget {
  final String type;
  final String currentValue;
  final Function(String) onUpdate;

  const UpdateHealthDialog({
    Key? key,
    required this.type,
    required this.currentValue,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<UpdateHealthDialog> createState() => _UpdateHealthDialogState();
}

class _UpdateHealthDialogState extends State<UpdateHealthDialog> {
  late TextEditingController _controller;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getTitle() {
    switch (widget.type) {
      case 'heart':
        return 'Update Heart Rate';
      case 'steps':
        return 'Update Steps';
      case 'water':
        return 'Update Water Intake';
      case 'sleep':
        return 'Update Sleep (minutes)';
      default:
        return 'Update';
    }
  }

  String _getHint() {
    switch (widget.type) {
      case 'heart':
        return 'Enter heart rate (bpm)';
      case 'steps':
        return 'Enter steps count';
      case 'water':
        return 'Enter water (cups)';
      case 'sleep':
        return 'Enter sleep duration (minutes)';
      default:
        return 'Enter value';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_getTitle()),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: _getHint(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primaryOrange, width: 2),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading
              ? null
              : () async {
                  setState(() => _isLoading = true);
                  await widget.onUpdate(_controller.text);
                  setState(() => _isLoading = false);
                  if (mounted) Navigator.pop(context);
                },
          child: _isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text('Update'),
        ),
      ],
    );
  }
}
