import 'package:flutter/material.dart';
import 'package:mapsforge_flutter/core.dart';

class HiddenContextMenuBuilder extends ContextMenuBuilder {
  @override
  Widget buildContextMenu(
      BuildContext context,
      MapModel mapModel,
      ViewModel viewModel,
      MapViewPosition position,
      Dimension screen,
      TapEvent event) {
    return const SizedBox();
  }

  const HiddenContextMenuBuilder();
}
