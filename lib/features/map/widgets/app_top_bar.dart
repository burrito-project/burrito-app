import 'package:burrito/data/entities/burrito_status.dart';
import 'package:burrito/data/entities/last_stop_info.dart';
import 'package:burrito/features/map/widgets/burrito_status_badge.dart';
import 'package:burrito/services/dio_client.dart';
import 'package:flutter/material.dart';

class BurritoTopAppBar extends StatefulWidget {
  final BurritoState? burritoState;

  const BurritoTopAppBar({super.key, this.burritoState});

  @override
  State<BurritoTopAppBar> createState() => BurritoTopAppBarState();
}

class BurritoTopAppBarState extends State<BurritoTopAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
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
    final burritoState = widget.burritoState;

    final hasLastStopInfo = burritoState?.lastStop != null;
    final pickingUp = burritoState?.lastStop?.hasReached ?? false;
    final isOff = burritoState?.lastInfo.status == BurritoStatus.off;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 90,
          // color: Theme.of(context).colorScheme.primary,
          color: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image.asset('assets/logos/unmsm_logo.png', width: 32),
              Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 44,
                        width: 48,
                      ),
                      BurritoStatusBadge(
                        status: burritoState?.lastInfo.status ??
                            BurritoStatus.loading,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return pickingUp || isOff || !hasLastStopInfo
                              ? Container(child: child)
                              : Transform(
                                  alignment: Alignment.bottomCenter,
                                  transform: Matrix4.diagonal3Values(
                                      1, _animation.value, 1),
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
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasLastStopInfo
                          ? pickingUp
                              ? 'Recogiendo pasajeros...'
                              : 'Próxima estación (${burritoState!.lastStop!.distanceMeters})'
                          : '-- --',
                      style: TextStyle(
                        fontSize: 15,
                        color: pickingUp
                            ? const Color.fromARGB(255, 97, 221, 101)
                            : Colors.white,
                      ),
                    ),
                    Text(
                      hasLastStopInfo
                          ? burritoState!.lastStop!.name
                          : isOff
                              ? 'Fuera de servicio'
                              : 'Esperando al burro...',
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
          color: hasLastStopInfo
              ? pickingUp
                  ? const Color(0xFF3E8841)
                  : Colors.red
              : const Color.fromARGB(255, 58, 58, 58),
          child: Center(
            child: hasLastStopInfo
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
                : const Text(
                    textAlign: TextAlign.center,
                    'Aún no hay información disponible',
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
