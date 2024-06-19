// coverage:ignore-file
// TODO(Test): Rive causes this to fail, so, restore this test after the next
//  Rive major update when the issue is fixed
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:sozzle/core/extensions/rive_extensions.dart';
import 'package:sozzle/core/res/media.dart';

class GameButton extends StatefulWidget {
  const GameButton({required this.text, this.onPressed, super.key});

  final String text;
  final VoidCallback? onPressed;

  @override
  State<GameButton> createState() => _GameButtonState();
}

class _GameButtonState extends State<GameButton> {
  RiveFile? _riveFile;

  StateMachineController? controller;

  bool clicked = false;

  @override
  void initState() {
    super.initState();
    _preload();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _preload() {
    rootBundle.load(Media.gameButton).then((data) {
      setState(() {
        _riveFile = RiveFile.import(data);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_riveFile == null) return const SizedBox.shrink();
    return Center(
      child: SizedBox(
        width: 200,
        height: 50,
        child: RiveAnimation.direct(
          _riveFile!,
          fit: BoxFit.cover,
          stateMachines: const ['Button Animation'],
          onInit: (artboard) {
            artboard.textRun('buttonText')!.text = widget.text;
            controller = StateMachineController.fromArtboard(
              artboard,
              'Button Animation',
              onStateChange: (stateMachine, stateName) {
                if (stateName == 'Click') {
                  clicked = true;
                } else if (stateName == 'Rest' && clicked) {
                  clicked = false;
                  widget.onPressed?.call();
                }
              },
            );
            artboard.addController(controller!);
          },
        ),
      ),
    );
  }
}
