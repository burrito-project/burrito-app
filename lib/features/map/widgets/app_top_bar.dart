import 'package:burrito/features/core/providers/responsive_provider.dart';
import 'package:burrito/features/map/providers/bottomsheet_provider.dart';
import 'package:burrito/features/map/widgets/colored_information_bar.dart';
import 'package:burrito/features/notifications/utils.dart';
import 'package:burrito/features/notifications/widgets/notifications_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_tap_detector/multi_tap_detector.dart';
import 'package:burrito/services/dio_client.dart';
import 'package:burrito/data/entities/burrito_status.dart';
import 'package:burrito/features/core/alerts/simple_dialog.dart';
import 'package:burrito/features/map/providers/bus_status_provider.dart';

class BurritoTopAppBar extends ConsumerStatefulWidget {
  const BurritoTopAppBar({super.key});

  @override
  ConsumerState<BurritoTopAppBar> createState() => BurritoTopAppBarState();
}

class BurritoTopAppBarState extends ConsumerState<BurritoTopAppBar>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final burritoState = ref.watch(busStatusProvider);

    return burritoState.when(
      data: (state) => BurritoTopAppBarRender(burritoState: state),
      error: (e, st) => const BurritoTopAppBarRender(burritoState: null),
      loading: () => const BurritoTopAppBarRender(burritoState: null),
    );
  }
}

class BurritoTopAppBarRender extends ConsumerStatefulWidget {
  final BurritoState? burritoState;

  const BurritoTopAppBarRender({
    super.key,
    required this.burritoState,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      BurritoTopAppBarRenderState();
}

class BurritoTopAppBarRenderState extends ConsumerState<BurritoTopAppBarRender>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    // Burrito icon does boing-boing animation like a burrito ROFL
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasLastStop = widget.burritoState?.lastStop != null;
    final pickingUp = widget.burritoState?.lastStop?.hasReached ?? false;
    final isBottomSheetExpanded = ref.watch(isBottomSheetExpandedProvider);
    final isOff = widget.burritoState == null ||
        widget.burritoState?.lastInfo.status == BusServiceStatus.off;
    final wideScreen = ref.watch(wideScreenProvider);
    final today = DateTime.now().toLocal();
    // The burrito is off on weekends
    final isWeekend =
        today.weekday == DateTime.saturday || today.weekday == DateTime.sunday;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8).copyWith(top: wideScreen ? 8 : 0),
          decoration: const BoxDecoration(
            color: Color(0xff470302),
            border: Border(
              bottom: BorderSide(
                color: Color(0xff470302),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4, right: 8),
                child: Image.asset(
                  width: 40,
                  'assets/icons/unmsm_logo.png',
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text(
                  'BURRITO UNMSM',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 227, 214, 213),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              NotificationsButton(
                onNotificationsTap: () {
                  if (isBottomSheetExpanded) {
                    closeModalBottomSheet2(ref);
                  } else {
                    openModalBottomSheet2(ref);
                  }
                },
              ),
            ],
          ),
        ),
        Container(
          height: 90,
          color: const Color.fromARGB(255, 241, 236, 236),
          padding: EdgeInsets.only(left: wideScreen ? 24 : 0),
          child: Row(
            mainAxisAlignment:
                wideScreen ? MainAxisAlignment.start : MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Burrito icon and status badge
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MultiTapDetector(
                    taps: 10,
                    onMultiTap: () async {
                      final info = await kPackageInfo;
                      if (!context.mounted) return;

                      await showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (ctx) {
                          return SimpleAppDialog(
                            title: 'Burrito UNMSM 🚍',
                            content: 'Version: ${info.version}\n'
                                'Build number: ${info.buildNumber}',
                            showAcceptButton: true,
                          );
                        },
                      );
                    },
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return pickingUp || isOff
                            ? Container(child: child)
                            : Transform(
                                alignment: Alignment.bottomCenter,
                                transform: Matrix4.diagonal3Values(
                                  1,
                                  _animation.value,
                                  1,
                                ),
                                child: child,
                              );
                      },
                      child: Image.asset(
                        width: 128,
                        isOff
                            ? 'assets/icons/burrito/burrito_inactive.png'
                            : pickingUp
                                ? 'assets/icons/burrito/burrito_ongoing.png'
                                : 'assets/icons/burrito/burrito_idle.png',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 15),
              // Next stop and Status text
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasLastStop) ...[
                    Text(
                      pickingUp
                          ? 'Recogiendo pasajeros...'
                          : 'Próxima estación (20m)',
                      style: TextStyle(
                        fontSize: 15,
                        color: pickingUp
                            ? const Color.fromARGB(255, 26, 99, 29)
                            : Colors.black,
                      ),
                    ),
                  ],
                  Text(
                    isWeekend || isOff
                        ? 'Fuera de servicio'
                        : hasLastStop
                            ? widget.burritoState!.lastStop!.name
                            : 'Iniciando ruta...',
                    softWrap: false,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        ColoredInformationBar(
          hasLastStop: hasLastStop,
          pickingUp: pickingUp,
          isOff: isOff,
        ),
      ],
    );
  }
}
