import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:sozzle/core/res/media.dart';

class Scorecard extends StatefulWidget {
  const Scorecard({
    required this.level,
    required this.failedAttempts,
    this.headerColour,
    this.failedAttemptsColour,
    this.levelColour,
    super.key,
  });

  final int level;
  final String failedAttempts;
  final Color? headerColour;
  final Color? failedAttemptsColour;
  final Color? levelColour;

  @override
  State<Scorecard> createState() => _ScorecardState();
}

class _ScorecardState extends State<Scorecard> {
  File? _riveFile;

  late RiveWidgetController controller;
  late ViewModelInstance viewModelInstance;

  bool clicked = false;

  @override
  void initState() {
    super.initState();
    _preload();
  }

  @override
  void dispose() {
    controller.dispose();
    viewModelInstance.dispose();
    super.dispose();
  }

  Future<void> _preload() async {
    final data = await rootBundle.load(Media.scorecard);
    _riveFile = await File.decode(
      data.buffer.asUint8List(),
      riveFactory: Factory.rive,
    );

    controller = RiveWidgetController(
      _riveFile!,
      artboardSelector: ArtboardSelector.byName('Scorecard'),
    );
    _onInit();
    setState(() {});
    log('Card initialised', name: 'Scorecard');
  }

  void _onInit() {
    viewModelInstance = controller.dataBind(DataBind.auto());

    viewModelInstance.number('levelValue')?.value = widget.level.toDouble();
    viewModelInstance.string('failedAttemptsValue')?.value =
        widget.failedAttempts;

    if (widget.headerColour != null) {
      viewModelInstance.color('cardHeaderColour')?.value = widget.headerColour!;
    }

    if (widget.failedAttemptsColour != null) {
      viewModelInstance.color('failedAttemptsValueColour')?.value =
          widget.failedAttemptsColour!;
    }

    if (widget.levelColour != null) {
      viewModelInstance.color('levelValueColour')?.value = widget.levelColour!;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_riveFile == null) return const SizedBox.shrink();
    return SizedBox(
      height: 100,
      child: RiveWidget(
        controller: controller,
        alignment: Alignment.centerLeft,
        fit: Fit.layout,
      ),
    );
  }
}
