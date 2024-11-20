# Protocolo de actualización de la aplicación

El endpoint GET `/pending_updates?version=1.0.0` devolverá una lista de versiones de la aplicación que son más recientes que la proporcionada en el parámetro de consulta.

```json
// Ejemplo
{
  "must_update": true,
  "versions": [
    {
      "banner_url": "https://picsum.photos/id/866/400",
      "is_mandatory": false,
      "release_date": "2019-10-12T07:20:50.52Z",
      "release_notes": "Este es un resumen extenso de los cambios introducidos en la nueva versión, que puede incluir saltos de línea.\n\n- Característica 1\n- Característica 2",
      "semver": "1.1.0"
    }
  ]
}
```
El cliente NO DEBE permitir que el usuario continúe con la aplicación si alguna versión está marcada como `is_mandatory`. Si el cliente lo decide, puede mostrar un diálogo al usuario con el registro de cambios y la opción de actualizar, almacenando el reconocimiento en el almacenamiento local.

Un ejemplo del flujo de trabajo sería:

~~~
Acto 1: la primera vez

>el cliente solicita /pending_updates?version=1.0.0
>el servidor devuelve dos versiones pendientes, ninguna obligatoria
>se muestran dos opciones [Actualizar ahora] y [Más tarde] al usuario junto con los registros de cambios
>el usuario reconoce
>el cliente almacena la más alta como "latest_acknowledged_version" en el almacenamiento local
>el usuario decide no actualizar

Acto 2: al día siguiente, otra actualización

>el cliente solicita /pending_updates?version=1.0.0
>el servidor devuelve tres versiones, aún ninguna obligatoria
>como una de ellas es más reciente que "latest_acknowledged_version", el cliente muestra el diálogo
>el usuario reconoce
>el cliente almacena la más alta como "latest_acknowledged_version" en el almacenamiento local
>el usuario decide no actualizar

Acto 3: la actualización urgente

>el cliente solicita /pending_updates?version=1.0.0
>el servidor devuelve cuatro versiones, donde la última (2.0.0) es obligatoria
>el cliente combina los registros de cambios y los muestra al usuario junto con el botón [Actualizar ahora]
>el usuario reconoce y la única opción es actualizar
>el cliente almacena la más alta como "latest_acknowledged_version" en el almacenamiento local
>el usuario actualiza

Acto 4: la calma después de la tormenta

>el cliente solicita /pending_updates?version=2.0.0
>el servidor devuelve una lista vacía
>el cliente continúa con la aplicación
~~~
El ejemplo anterior describe nuestra implementación actual.
Podríamos cambiarla en el futuro, pero la idea general seguirá siendo la misma.



