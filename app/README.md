# Aplicación web — FIFA Control Room

Aplicación demostrable de la Entrega 3, construida sin dependencias externas:

1. Abrir `index.html` en un navegador moderno.
2. Usar el menú para administrar ediciones, sedes, ciudades, estadios,
   selecciones, grupos, jugadores y cuerpo técnico.
3. Registrar partidos, estadísticas e incidencias.
4. Usar los filtros del resumen o de `Reportes` para consultar resultados,
   posiciones, goleadores e incidencias por edición, selección, grupo y fase.

La aplicación guarda los cambios en `localStorage` para poder demostrarse sin
credenciales del servidor Oracle. `Exportar JSON` permite conservar una
evidencia de los datos de la demostración. El botón `Restablecer` vuelve al
dataset sintético inicial.

En el despliegue del curso, las colecciones locales se sustituyen por:

- `VW_E3_RESULTADOS_CONSOLIDADOS`
- `VW_E3_TABLA_POSICIONES_GRUPO`
- `VW_E3_GOLEADORES`
- `VW_E3_INCIDENCIAS_DETALLE`
- `UPDATE` de resultados + `INSERT SELECT` de posiciones (ver `10_entrega3_programacion.sql`)
- `INSERT` en `CIERRE_FASE` (sin procedimientos ni triggers)

No se incluyen contraseñas, cadenas de conexión ni credenciales en el
repositorio.
