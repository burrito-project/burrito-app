<!-- markdownlint-disable MD033 MD042 -->

# Construyendo el cliente móvil

Para obtener información más detallada, consulte
[Los documentos oficiales de flutter](https://docs.flutter.dev/deployment/android#build-the-app-for-release).

<div class="warning">
Tenga en cuenta que esta documentación es solo para Android. 
Aunque Flutter es compatible con iOS, aún no lo hemos probado para este proyecto.

Hay un flujo de trabajo funcional llamado ios-compilation.yml en el directorio
.github/workflows que puedes consultar.
</div>

## Construyendo el APK

Para crear APK para múltiples arquitecturas (p. ej., ARM, ARM64, x86), utilice el siguiente comando. Esto generará archivos APK separados para cada ABI (interfaz binaria de aplicación), lo que permitirá a los usuarios descargar el APK apropiado para la arquitectura de su dispositivo:

```json
flutter build apk --split-per-abi
```

Los APK se guardarán en `build/app/outputs/flutter-apk/` directorio. En esa carpeta se encuentran los APK generados, listos para probar o distribuir.

## Crea un paquete de aplicaciones para su lanzamiento

Además de crear archivos APK, también es una buena práctica generar un paquete de aplicaciones (.aab) para lanzar la aplicación en Google Play Store. El paquete de aplicaciones contiene todo lo necesario para la distribución y Google Play optimizará la aplicación para diferentes configuraciones de dispositivos de manera automática.

Para crear una versión de lanzamiento de la App Bundle, utilice el siguiente comando:

```json
flutter build appbundle --release
```

Una vez que se complete la compilación, el archivo .aab estará disponible en `build/app/outputs/bundle/release/` Puedes cargar este archivo en Google Play Console o en cualquier otra tienda de aplicaciones que admita App Bundles.
