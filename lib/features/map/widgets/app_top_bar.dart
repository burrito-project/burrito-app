import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:burrito/services/dio_client.dart';
import 'package:burrito/data/entities/burrito_status.dart';
import 'package:burrito/data/entities/last_stop_info.dart';
import 'package:burrito/features/map/widgets/burrito_status_badge.dart';
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

class BurritoTopAppBarRender extends StatefulWidget {
  final BurritoState? burritoState;

  const BurritoTopAppBarRender({
    super.key,
    required this.burritoState,
  });

  @override
  State<StatefulWidget> createState() => BurritoTopAppBarRenderState();
}

class BurritoTopAppBarRenderState extends State<BurritoTopAppBarRender>
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
    final isOff = widget.burritoState == null ||
        widget.burritoState?.lastInfo.status == BusServiceStatus.off;

    return Column(
      children: [
        Container(
          height: 90,
          color: Theme.of(context).colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Burrito icon and status badge
              Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 44, width: 48),
                      BurritoStatusBadge(
                        status: widget.burritoState != null
                            ? widget.burritoState!.lastInfo.status
                            : BusServiceStatus.off,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
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
                          height: 48,
                          width: 48,
                          'assets/icons/real_burrito_icon.png',
                        ),
                      ),
                      const SizedBox(
                          height: 2 + BurritoStatusBadge.badgeHeight),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 15),
              // Next stop and Status text
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hasLastStop) ...[
                      Text(
                        pickingUp
                            ? 'Recogiendo pasajeros...'
                            : 'Próxima estación (${widget.burritoState!.lastStop!.distanceMeters})',
                        style: TextStyle(
                          fontSize: 15,
                          color: pickingUp
                              ? const Color.fromARGB(255, 97, 221, 101)
                              : Colors.white,
                        ),
                      ),
                    ],
                    Text(
                      isOff
                          ? 'Fuera de servicio'
                          : hasLastStop
                              ? widget.burritoState!.lastStop!.name
                              : 'Iniciando ruta...',
                      softWrap: false,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        AnimatedContainer(
          width: double.infinity,
          height: 24,
          duration: const Duration(milliseconds: 500),
          color: hasLastStop
              ? pickingUp
                  ? const Color(0xFF3E8841)
                  : Colors.red
              : const Color(0xFF3A3A3A),
          child: Center(
            child: hasLastStop
                ? pickingUp
                    ? const Text(
                        textAlign: TextAlign.center,
                        'Puede avanzar en cualquier momento',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    : const Text(
                        textAlign: TextAlign.center,
                        'En camino...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                : isOff
                    ? const Text(
                        textAlign: TextAlign.center,
                        'No hay información disponible',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    : const Text(
                        textAlign: TextAlign.center,
                        'Se mostrará información apenas esté disponible',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
          ),
        )
      ],
    );
  }
}
