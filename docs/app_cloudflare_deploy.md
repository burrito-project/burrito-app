# Desplegando la aplicación en la web usando Cloudflare Pages

El despliegue en Cloudflare Pages ya está configurado como un flujo de trabajo de GitHub que se activa con cada *push* a la rama `main`.

Para más detalles, consulta el archivo `.github/workflows/deploy.yml`.

## Usando un dominio personalizado

Por defecto, las páginas de Cloudflare se despliegan en el dominio `*.pages.dev`.  
Para usar un dominio personalizado, sigue las instrucciones proporcionadas por Cloudflare en el panel de Pages.

## Construyendo manualmente la aplicación web

Construye la aplicación para web con:

```console
flutter build web -t lib/main.dart
```
