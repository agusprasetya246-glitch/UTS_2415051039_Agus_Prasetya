import 'package:flutter/material.dart';

enum _StateKind { loading, error, empty }

class StateView extends StatelessWidget {
  const StateView.loading({Key? key, String? message, bool compact = false})
    : this._(_StateKind.loading, key: key, message: message, compact: compact);

  const StateView.error({
    Key? key,
    String title = 'Terjadi kesalahan',
    required String message,
    VoidCallback? onRetry,
    bool compact = false,
  }) : this._(
         _StateKind.error,
         key: key,
         icon: Icons.cloud_off_outlined,
         title: title,
         message: message,
         actionLabel: 'Coba lagi',
         actionIcon: Icons.refresh,
         onAction: onRetry,
         compact: compact,
       );

  const StateView.empty({
    Key? key,
    required IconData icon,
    required String title,
    String? message,
    String? actionLabel,
    IconData? actionIcon,
    VoidCallback? onAction,
    bool prominentAction = false,
  }) : this._(
         _StateKind.empty,
         key: key,
         icon: icon,
         title: title,
         message: message,
         actionLabel: actionLabel,
         actionIcon: actionIcon,
         onAction: onAction,
         prominentAction: prominentAction,
       );

  const StateView._(
    this._kind, {
    super.key,
    this.icon,
    this.title,
    this.message,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
    this.compact = false,
    this.prominentAction = false,
  });

  final _StateKind _kind;
  final IconData? icon;
  final String? title;
  final String? message;
  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onAction;

  final bool compact;

  final bool prominentAction;

  bool get _isError => _kind == _StateKind.error;
  bool get _hasAction => actionLabel != null && onAction != null;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _compactContent(context),
        ),
      );
    }

    final content = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: _fullContent(context),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (!constraints.hasBoundedHeight) {
          return Padding(
            padding: const EdgeInsets.all(32),
            child: Center(child: content),
          );
        }

        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 24,
                ),
                child: content,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _fullContent(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final muted = textTheme.bodyMedium?.copyWith(
      color: colorScheme.onSurfaceVariant,
    );

    if (_kind == _StateKind.loading) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(strokeWidth: 4),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(message!, textAlign: TextAlign.center, style: muted),
          ],
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: _isError
                ? colorScheme.errorContainer
                : colorScheme.surfaceContainerHigh,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 32,
            color: _isError ? colorScheme.error : colorScheme.onSurfaceVariant,
          ),
        ),
        if (title != null) ...[
          const SizedBox(height: 16),
          Text(
            title!,
            textAlign: TextAlign.center,
            style: textTheme.titleMedium?.copyWith(fontSize: 18),
          ),
        ],
        if (message != null) ...[
          const SizedBox(height: 4),
          Text(message!, textAlign: TextAlign.center, style: muted),
        ],
        if (_hasAction) ...[const SizedBox(height: 20), _actionButton()],
      ],
    );
  }

  Widget _actionButton() {
    final label = Text(actionLabel!);
    final iconData = actionIcon;

    if (prominentAction) {
      return iconData == null
          ? FilledButton(onPressed: onAction, child: label)
          : FilledButton.icon(
              onPressed: onAction,
              icon: Icon(iconData),
              label: label,
            );
    }
    return iconData == null
        ? FilledButton.tonal(onPressed: onAction, child: label)
        : FilledButton.tonalIcon(
            onPressed: onAction,
            icon: Icon(iconData),
            label: label,
          );
  }

  Widget _compactContent(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (_kind == _StateKind.loading) {
      return const CircularProgressIndicator();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: _isError ? colorScheme.error : colorScheme.onSurfaceVariant,
        ),
        const SizedBox(height: 8),
        Text(
          message ?? title ?? '',
          textAlign: TextAlign.center,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
        if (_hasAction)
          TextButton.icon(
            onPressed: onAction,
            icon: Icon(actionIcon ?? Icons.refresh, size: 18),
            label: Text(actionLabel!),
          ),
      ],
    );
  }
}
