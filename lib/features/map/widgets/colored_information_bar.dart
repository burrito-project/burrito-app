import 'package:flutter/material.dart';

const ongoingText = 'En camino...';
const pickingUpText = 'Recogiendo pasajeros...';
const noInformationText = 'No disponible';
const noInformationWeekendText = 'Descanso por fin de semana';
const waitingForText = 'Iniciando ruta...';

const stylesMap = {
  ongoingText: {
    'bg': Color.fromARGB(255, 193, 64, 64),
    'border': Color.fromARGB(255, 117, 32, 32),
    'text': Color.fromARGB(255, 247, 222, 222),
  },
  pickingUpText: {
    'bg': Color.fromARGB(255, 132, 190, 125),
    'border': Color.fromARGB(255, 27, 59, 28),
    'text': Color.fromARGB(255, 27, 59, 28),
  },
  noInformationText: {
    'bg': Color.fromARGB(255, 78, 78, 78),
    'border': Color.fromARGB(255, 52, 52, 52),
    'text': Colors.white,
  },
  noInformationWeekendText: {
    'bg': Color.fromARGB(255, 78, 78, 78),
    'border': Color.fromARGB(255, 52, 52, 52),
    'text': Colors.white,
  },
  waitingForText: {
    'bg': Color.fromARGB(255, 252, 205, 104),
    'border': Color.fromARGB(255, 100, 68, 26),
    'text': Color.fromARGB(255, 100, 68, 26),
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
        statusText = ongoingText;
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
      duration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: statusStyle['border']!, width: 0.8),
          bottom: BorderSide(color: statusStyle['border']!, width: 0.8),
        ),
        color: statusStyle['bg'],
      ),
      child: Center(
        child: Text(
          textAlign: TextAlign.center,
          statusText,
          style: TextStyle(
            color: statusStyle['text'],
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
