import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class TransparentAppBar extends StatefulWidget {
  final List<IconButton>? actionsIcons;
  final Color iconColor;
  final SystemUiOverlayStyle statusIconsColor;
  const TransparentAppBar({super.key, this.actionsIcons, required this.iconColor, required this.statusIconsColor});

  @override
  State<TransparentAppBar> createState() => _TransparentAppBarState();
}

class _TransparentAppBarState extends State<TransparentAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: widget.statusIconsColor,
      backgroundColor: const Color.fromARGB(0, 206, 58, 58),
      elevation: 0,
      titleSpacing: 0,
      leading: IconButton(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        onPressed: () {
          setState(() {});
          Navigator.pop(context);
        },
        icon: Icon(
          TablerIcons.arrow_left,
          size: 40,
          color: widget.iconColor,
        ),
      ),
      actions: widget.actionsIcons,
    );
  }
}
