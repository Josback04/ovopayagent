import 'package:flutter/material.dart';
import 'package:ovopayagent/app/components/card/custom_card.dart';
import 'package:ovopayagent/core/utils/util_exporter.dart';

class AppDropdownWidget<T> extends StatefulWidget {
  final List<T> items;
  final ValueChanged<T> onItemSelected;
  final T? selectedItem;
  final double maxHeight;
  final Widget child;
  final String Function(T)? itemToString; // itemToString is now optional

  const AppDropdownWidget({
    super.key,
    required this.items,
    required this.onItemSelected,
    this.selectedItem,
    this.maxHeight = 250.0,
    required this.child,
    this.itemToString, // Accepting itemToString function as optional
  });

  @override
  State<AppDropdownWidget> createState() => _AppDropdownWidgetState<T>();
}

class _AppDropdownWidgetState<T> extends State<AppDropdownWidget<T>> {
  final GlobalKey _buttonKey = GlobalKey();
  OverlayEntry? _dropdownOverlay;

  void toggleDropdown() {
    if (_dropdownOverlay == null) {
      _showDropdownOverlay();
    } else {
      _hideDropdownOverlay();
    }
  }

  void _showDropdownOverlay() {
    final renderBox = _buttonKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    final screenHeight = MediaQuery.of(context).size.height;
    final buttonHeight = renderBox.size.height;
    final dropdownHeight = widget.maxHeight;

    double availableSpaceBelow = screenHeight - position.dy - (buttonHeight);
    double availableSpaceAbove = position.dy;

    double topPosition = position.dy + (buttonHeight + 5);

    if (availableSpaceBelow < dropdownHeight) {
      if (availableSpaceAbove >= dropdownHeight) {
        topPosition = position.dy - 100;
        // topPosition = position.dy - dropdownHeight;
      } else {
        topPosition = position.dy;
      }
    }

    _dropdownOverlay = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _hideDropdownOverlay();
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: position.dx,
              top: topPosition,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: widget.maxHeight),
                child: Material(
                  clipBehavior: Clip.none,
                  color: Colors.transparent,
                  child: CustomAppCard(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.space10.w,
                      vertical: Dimensions.space5.w,
                    ),
                    width: renderBox.size.width,
                    child: ListView.builder(
                      // Replaced with ListView.builder
                      shrinkWrap: true, // Important to prevent unbounded height
                      itemCount: widget.items.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        final item = widget.items[index];
                        return Material(
                          type: MaterialType.transparency,
                          child: ListTile(
                            title: Text(
                              (widget.itemToString != null)
                                  ? widget.itemToString!(
                                      item,
                                    ) // Use provided itemToString function
                                  : item.toString(), // Default to toString()
                            ),
                            onTap: () {
                              widget.onItemSelected(item);
                              _hideDropdownOverlay();
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_dropdownOverlay!);
  }

  void _hideDropdownOverlay() {
    _dropdownOverlay?.remove();
    _dropdownOverlay = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _buttonKey,
      onTap: toggleDropdown,
      child: Container(
        color: MyColor.transparentColor,
        child: IgnorePointer(child: widget.child),
      ),
    );
  }
}
