# Publicando tu aplicación en Google Play Store

Hay algunas cosas que debes verificar antes de enviar la aplicación a Google Play Store (o cualquier otra tienda).

1. Asegúrate de que el servidor esté en funcionamiento

    Antes de enviar tu aplicación a una tienda, es importante verificar que el servidor del que depende esté activo, funcional y listo para manejar solicitudes. Muchas tiendas requieren que las aplicaciones proporcionen funcionalidad real y no solo marcadores de posición; por lo tanto, podrían revisar las respuestas de la aplicación para confirmar que funciona como se espera.

    Si aún no tienes un controlador enviando los datos, consulta la sección Usando rutas simuladas.

   - Verifica las respuestas esperadas: Prueba que la API proporcione correctamente la ubicación del burrito.
   - Monitorea el tiempo de actividad: Muchas tiendas pueden revisar periódicamente la funcionalidad de tu aplicación durante el proceso de revisión. Considera usar un servicio de monitoreo para recibir alertas si tu servidor deja de estar disponible inesperadamente.

2. Asegúrate de que la aplicación esté usando la API correcta y no localhost

    Revisa el archivo `lib/services/dio_client.dart` para asegurarte de que la aplicación esté conectada al punto final correcto de la API. El `baseUrl` debe estar configurado en la URL de tu API en vivo, no en localhost:

    ```json
    baseUrl: 'https://yourAPI.com',
    ```

    Ahora estás listo para publicar la aplicación en la tienda de tu elección.

