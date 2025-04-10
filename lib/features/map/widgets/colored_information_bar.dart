import 'package:flutter/material.dart';

const onItsWayText = 'En camino';
const pickingUpText = 'Recogiendo';
const noInformationText = 'No disponible';
const noInformationWeekendText = 'Descanso';
const waitingForText = 'Esperando';

const stylesMap = {
  onItsWayText: {
    'bg': Color(0xFF3A3A3A),
    'border': Color(0xFF3E8841),
    'text': Colors.white,
  },
  pickingUpText: {
    'bg': Color.fromARGB(255, 132, 190, 125),
    'border': Color.fromARGB(255, 42, 83, 44),
    'text': Color.fromARGB(255, 47, 91, 48),
  },
  noInformationText: {
    'bg': Color(0xFF3A3A3A),
    'border': Color(0xFF3A3A3A),
    'text': Colors.white,
  },
  noInformationWeekendText: {
    'bg': Color(0xFF3A3A3A),
    'border': Color(0xFF3A3A3A),
    'text': Colors.white,
  },
  waitingForText: {
    'bg': Color(0xfffeeba5),
    'border': Color(0xffd39647),
    'text': Colors.white,
  },
};

class ColoredInformationBar extends StatelessWidget {
  final bool hasLastStop;
  final bool pickingUp;
  final bool isOff;

  const ColoredInformationBar({
    super.key,
    required this.hasLastStop,
    required this.pickingUp,
    required this.isOff,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now().toLocal();
    final isWeekend =
        today.weekday == DateTime.saturday || today.weekday == DateTime.sunday;

    final String statusText;

    if (hasLastStop) {
      if (pickingUp) {
        statusText = pickingUpText;
      } else {
        statusText = onItsWayText;
      }
    } else {
      if (isOff) {
        statusText = isWeekend ? noInformationWeekendText : noInformationText;
      } else {
        statusText = waitingForText;
      }
    }

    final statusStyle = stylesMap[statusText]!;

    return AnimatedContainer(
      // width: double.infinity,
      duration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(3)),
        border: Border.all(
          color: statusStyle['border']!,
          width: 1.2,
        ),
        color: statusStyle['bg'],
      ),
      child: Center(
        child: Text(
          textAlign: TextAlign.center,
          statusText,
          style: TextStyle(
            color: statusStyle['border'],
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
