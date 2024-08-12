enum BusServiceStatus {
  working,
  outOfService,
  atRest,
  accident,
  off,
  loading,
  unknown;

  static BusServiceStatus fromInt(int value) {
    switch (value) {
      case 0:
        return working;
      case 1:
        return outOfService;
      case 2:
        return atRest;
      case 3:
        return accident;
      case 4:
        return off;
      default:
        return unknown;
    }
  }

  String get displayName {
    switch (this) {
      case working:
        return 'En ruta';
      case outOfService:
        return 'Fuera de servicio';
      case atRest:
        return 'En descanso';
      case accident:
        return 'Accidente';
      case off:
        return 'Error';
      case loading:
        return 'Cargando';
      case unknown:
        return 'Desconocido';
    }
  }

  bool locatable() {
    return this == working || this == accident;
  }
}
