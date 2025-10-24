import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart';
import 'package:sozzle/core/enums/rive_enums.dart';
import 'package:sozzle/core/res/media.dart';
import 'package:sozzle/src/theme/cubit/theme_cubit.dart';

class Scorecard extends StatefulWidget {
  const Scorecard({
    required this.level,
    required this.failedAttempts,
    super.key,
  });

  final int level;
  final String failedAttempts;

  @override
  State<Scorecard> createState() => _ScorecardState();
}

class _ScorecardState extends State<Scorecard> {
  File? _riveFile;

  late RiveWidgetController controller;
  late ViewModelInstance viewModelInstance;

  ViewModelInstanceNumber? _levelValue;
  ViewModelInstanceString? _failedAttemptsValue;
  ViewModelInstanceBoolean? _isDarkMode;
  ViewModelInstanceEnum? _levelAlignment;
  ViewModelInstanceEnum? _failedAttemptsAlignment;
  ViewModelInstanceEnum? _boardLayout;
  ViewModelInstanceEnum? _cardLayoutAlignment;
  ViewModelInstanceEnum? _scoreSectionHeightScale;

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
    _isDarkMode?.dispose();
    _levelValue?.dispose();
    _failedAttemptsValue?.dispose();
    _levelAlignment?.dispose();
    _failedAttemptsAlignment?.dispose();
    _boardLayout?.dispose();
    _cardLayoutAlignment?.dispose();
    _scoreSectionHeightScale?.dispose();
    super.dispose();
  }

  Future<void> _preload() async {
    _riveFile = await File.asset(
      Media.scorecard,
      riveFactory: Factory.rive,
    );

    controller = RiveWidgetController(
      _riveFile!,
      artboardSelector: ArtboardSelector.byName('Scorecard'),
    );
    _onInit();
    setState(() {});
  }

  void _onInit() {
    viewModelInstance = controller.dataBind(DataBind.auto());

    _levelValue = viewModelInstance.number('levelValue');
    _levelValue?.value = widget.level.toDouble();

    _failedAttemptsValue = viewModelInstance.string('failedAttemptsValue');
    _failedAttemptsValue?.value = widget.failedAttempts;

    _isDarkMode = viewModelInstance.boolean('isDarkMode');
    _isDarkMode?.value = context.read<ThemeCubit>().state is ThemeStateDark;

    _boardLayout = viewModelInstance.enumerator('scoreSectionLayout');

    _levelAlignment = viewModelInstance.enumerator('levelAlignment');

    _failedAttemptsAlignment = viewModelInstance.enumerator(
      'failedAttemptsAlignment',
    );

    _cardLayoutAlignment = viewModelInstance.enumerator(
      'cardLayoutAlignment',
    );

    _scoreSectionHeightScale = viewModelInstance.enumerator(
      'scoreSectionHeightScale',
    );
  }

  void renderLayout({required bool isNarrow}) {
    if (isNarrow) {
      _boardLayout?.value = LayoutDirection.column.value;
      _failedAttemptsAlignment?.value = AlignmentType.topLeft.value;
      _levelAlignment?.value = AlignmentType.bottomLeft.value;
      _cardLayoutAlignment?.value = AlignmentType.bottomCenter.value;
      _scoreSectionHeightScale?.value = LayoutScale.fill.value;
    } else {
      _boardLayout?.value = LayoutDirection.row.value;
      _levelAlignment?.value = AlignmentType.center.value;
      _failedAttemptsAlignment?.value = AlignmentType.center.value;
      _cardLayoutAlignment?.value = AlignmentType.centerLeft.value;
      _scoreSectionHeightScale?.value = LayoutScale.hug.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_riveFile == null) return const SizedBox.shrink();
    return LayoutBuilder(
      builder: (_, constraints) {
        renderLayout(isNarrow: constraints.maxWidth < 330);
        return BlocListener<ThemeCubit, ThemeState>(
          listener: (context, state) {
            _isDarkMode?.value = state is ThemeStateDark;
          },
          child: SizedBox(
            height: 100,
            child: RiveWidget(
              controller: controller,
              alignment: Alignment.centerLeft,
              fit: Fit.layout,
            ),
          ),
        );
      },
    );
  }
}
