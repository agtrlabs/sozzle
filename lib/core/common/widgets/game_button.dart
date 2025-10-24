// coverage:ignore-file
// TODO(Test): Rive causes this to fail, so, restore this test after the next
//  Rive major update when the issue is fixed
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:sozzle/core/res/media.dart';

class GameButton extends StatefulWidget {
  const GameButton({required this.text, this.onPressed, super.key});

  final String text;
  final VoidCallback? onPressed;

  @override
  State<GameButton> createState() => _GameButtonState();
}

class _GameButtonState extends State<GameButton> {
  File? _riveFile;

  late RiveWidgetController controller;
  late ViewModelInstance viewModelInstance;
  ViewModelInstanceString? currentState;

  bool clicked = false;

  @override
  void initState() {
    super.initState();
    _preload();
  }

  @override
  void dispose() {
    controller.dispose();
    currentState?.clearListeners();
    viewModelInstance.dispose();
    super.dispose();
  }

  Future<void> _preload() async {
    final data = await rootBundle.load(Media.gameButton);
    _riveFile = await File.decode(
      data.buffer.asUint8List(),
      riveFactory: Factory.rive,
    );
    controller = RiveWidgetController(_riveFile!);
    _onInit(controller.artboard);
    setState(() {});
  }

  void _onInit(Artboard artboard) {
    viewModelInstance = controller.dataBind(DataBind.auto());

    viewModelInstance.string('buttonText')?.value = widget.text;

    currentState = viewModelInstance.string('currentState');
    currentState?.addListener((value) {
      if (value == 'click') {
        clicked = true;
      } else if (value == 'rest' && clicked) {
        clicked = false;
        widget.onPressed?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_riveFile == null) return const SizedBox.shrink();
    return Center(
      child: SizedBox(
        width: 200,
        height: 50,
        child: RiveWidget(
          controller: controller,
          fit: Fit.cover,
          cursor: SystemMouseCursors.click,
          // stateMachines: const ['Button Animation'],
        ),
      ),
    );
  }
}
