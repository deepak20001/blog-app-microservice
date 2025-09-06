import 'package:blog_client/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

enum SnackbarType { success, error, warning, info, custom }

class SnackbarUtils {
  static void showSnackbar({
    required BuildContext context,
    required String message,
    SnackbarType type = SnackbarType.custom,
    Color? backgroundColor,
    Color? textColor,
    IconData? icon,
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
    bool showProgressIndicator = true,
    VoidCallback? onTap,
    VoidCallback? onDismiss,
  }) {
    final overlay = Overlay.of(context);
    final theme = Theme.of(context);
    OverlayEntry? entry;

    // Get colors based on type
    final config = _getSnackbarConfig(type, backgroundColor, textColor, icon);

    entry = OverlayEntry(
      builder: (context) {
        final mediaQuery = MediaQuery.of(context);
        final size = mediaQuery.size;
        final padding = mediaQuery.padding;
        final isDark = theme.brightness == Brightness.dark;

        return Positioned(
          top: padding.top + 60,
          width: size.width,
          child: AnimatedSnackbar(
            message: message,
            config: config,
            duration: duration,
            showProgressIndicator: showProgressIndicator,
            onDismiss: () {
              entry?.remove();
              onDismiss?.call();
            },
            onTap: onTap,
            action: action,
            isDark: isDark,
          ),
        );
      },
    );

    overlay.insert(entry);

    Future.delayed(duration, () {
      if (entry?.mounted ?? false) {
        entry?.remove();
        onDismiss?.call();
      }
    });
  }

  static SnackbarConfig _getSnackbarConfig(
    SnackbarType type,
    Color? backgroundColor,
    Color? textColor,
    IconData? icon,
  ) {
    switch (type) {
      case SnackbarType.success:
        return SnackbarConfig(
          backgroundColor: AppPallete.successColor,
          textColor: Colors.white,
          icon: Icons.check_circle_rounded,
          gradient: LinearGradient(
            colors: [
              AppPallete.successColor,
              AppPallete.successColor.withValues(alpha: 0.8),
            ],
          ),
        );
      case SnackbarType.error:
        return SnackbarConfig(
          backgroundColor: AppPallete.errorColor,
          textColor: Colors.white,
          icon: Icons.error_rounded,
          gradient: LinearGradient(
            colors: [
              AppPallete.errorColor,
              AppPallete.errorColor.withValues(alpha: 0.8),
            ],
          ),
        );
      case SnackbarType.warning:
        return SnackbarConfig(
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          icon: Icons.warning_rounded,
          gradient: LinearGradient(
            colors: [Colors.orange, Colors.orange.withValues(alpha: 0.8)],
          ),
        );
      case SnackbarType.info:
        return SnackbarConfig(
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          icon: Icons.info_rounded,
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.blue.withValues(alpha: 0.8)],
          ),
        );
      case SnackbarType.custom:
        return SnackbarConfig(
          backgroundColor: backgroundColor ?? AppPallete.blackColor,
          textColor: textColor ?? AppPallete.whiteColor,
          icon: icon,
        );
    }
  }

  // Convenience methods
  static void showSuccess({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
  }) {
    showSnackbar(
      context: context,
      message: message,
      type: SnackbarType.success,
      duration: duration,
      onTap: onTap,
    );
  }

  static void showError({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onTap,
  }) {
    showSnackbar(
      context: context,
      message: message,
      type: SnackbarType.error,
      duration: duration,
      onTap: onTap,
    );
  }

  static void showWarning({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
  }) {
    showSnackbar(
      context: context,
      message: message,
      type: SnackbarType.warning,
      duration: duration,
      onTap: onTap,
    );
  }

  static void showInfo({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
  }) {
    showSnackbar(
      context: context,
      message: message,
      type: SnackbarType.info,
      duration: duration,
      onTap: onTap,
    );
  }
}

class SnackbarConfig {
  SnackbarConfig({
    required this.backgroundColor,
    required this.textColor,
    this.icon,
    this.gradient,
  });
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
  final Gradient? gradient;
}

class AnimatedSnackbar extends StatefulWidget {
  final String message;
  final SnackbarConfig config;
  final Duration duration;
  final bool showProgressIndicator;
  final VoidCallback onDismiss;
  final VoidCallback? onTap;
  final SnackBarAction? action;
  final bool isDark;

  const AnimatedSnackbar({
    Key? key,
    required this.message,
    required this.config,
    required this.duration,
    required this.showProgressIndicator,
    required this.onDismiss,
    this.onTap,
    this.action,
    required this.isDark,
  }) : super(key: key);

  @override
  State<AnimatedSnackbar> createState() => _AnimatedSnackbarState();
}

class _AnimatedSnackbarState extends State<AnimatedSnackbar>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _progressController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _progressController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
        );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.linear),
    );

    _slideController.forward();
    if (widget.showProgressIndicator) {
      _progressController.forward();
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void _dismiss() {
    _slideController.reverse().then((_) {
      widget.onDismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SlideTransition(
      position: _slideAnimation,
      child: Material(
        color: Colors.transparent,
        child: Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.up,
          onDismissed: (_) => _dismiss(),
          child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: size.width * 0.05),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: widget.config.gradient,
                color: widget.config.gradient == null
                    ? widget.config.backgroundColor
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: widget.config.backgroundColor.withValues(alpha: 0.3),
                    offset: const Offset(0, 8),
                    blurRadius: 20,
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    offset: const Offset(0, 2),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    // Content
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          if (widget.config.icon != null) ...[
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                widget.config.icon,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                          ],
                          Expanded(
                            child: Text(
                              widget.message,
                              style: TextStyle(
                                color: widget.config.textColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                height: 1.4,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (widget.action != null) ...[
                            const SizedBox(width: 12),
                            widget.action!,
                          ],
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: _dismiss,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                Icons.close_rounded,
                                color: Colors.white.withValues(alpha: 0.8),
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Perfect progress indicator
                    if (widget.showProgressIndicator)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: AnimatedBuilder(
                          animation: _progressAnimation,
                          builder: (context, child) {
                            return Container(
                              height: 4,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                                color: Colors.white.withValues(alpha: 0.2),
                              ),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: 1 - _progressAnimation.value,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
