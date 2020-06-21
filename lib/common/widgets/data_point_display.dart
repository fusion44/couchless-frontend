import 'package:flutter/material.dart';

class DataPointDisplay extends StatelessWidget {
  final IconData iconData;
  final String text;
  final String postfix;
  final String tooltip;
  final Color color;

  const DataPointDisplay({
    Key key,
    this.iconData,
    this.text,
    this.postfix = '',
    this.tooltip = '',
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    if (tooltip != null && tooltip.isNotEmpty) {
      return Tooltip(message: tooltip, child: _buildBody(theme));
    }

    return _buildBody(theme);
  }

  Widget _buildBody(ThemeData theme) {
    return Row(
      children: <Widget>[
        if (iconData != null)
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: Icon(iconData, color: color),
          )
        else
          Container(),
        Text(
          (postfix != null && postfix.isNotEmpty) ? text + postfix : text,
          style: theme.textTheme.headline5.copyWith(color: color),
        )
      ],
    );
  }
}
