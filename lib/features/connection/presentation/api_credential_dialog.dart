import 'package:flutter/material.dart';

import '../../../data/api/receiving_api.dart';

class ApiCredentialDialog extends StatefulWidget {
  const ApiCredentialDialog({super.key, required this.credentialProvider});

  final InstallationCredentialProvider credentialProvider;

  @override
  State<ApiCredentialDialog> createState() => _ApiCredentialDialogState();
}

class _ApiCredentialDialogState extends State<ApiCredentialDialog> {
  final _controller = TextEditingController();
  bool _obscure = true;
  bool _saving = false;
  String? _message;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final value = _controller.text.trim();
    if (value.isEmpty) {
      setState(() => _message = 'Enter the deployment credential.');
      return;
    }
    setState(() {
      _saving = true;
      _message = null;
    });
    try {
      await widget.credentialProvider.writeCredential(value);
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) {
        setState(() {
          _saving = false;
          _message = 'The credential could not be stored securely.';
        });
      }
    }
  }

  Future<void> _clear() async {
    await widget.credentialProvider.clear();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Receiving service credential'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'The credential is stored in secure device storage and is never shown in sync status or logs.',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              obscureText: _obscure,
              autocorrect: false,
              enableSuggestions: false,
              decoration: InputDecoration(
                labelText: 'Installation credential',
                suffixIcon: IconButton(
                  tooltip: _obscure ? 'Show credential' : 'Hide credential',
                  onPressed: () => setState(() => _obscure = !_obscure),
                  icon: Icon(
                    _obscure ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
              ),
            ),
            if (_message != null) ...[
              const SizedBox(height: 8),
              Text(
                _message!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : _clear,
          child: const Text('Clear'),
        ),
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save securely'),
        ),
      ],
    );
  }
}
