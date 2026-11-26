# taskflow

Aplicación Flutter para organizar tareas académicas.

## Alcance de TaskFlow

Problema: necesito organizar actividades académicas y saber cuáles faltan.
Usuario objetivo: estudiante que planifica entregas semanales.

### Historias de usuario y criterios de aceptación
1. Como estudiante, quiero listar mis tareas para ver qué debo hacer.
   Criterio: la lista muestra título, prioridad y estado de cada tarea.
2. Como estudiante, quiero abrir una tarea para leer su descripción.
   Criterio: al tocar una tarjeta aparece el detalle de la tarea elegida.
3. Como estudiante, quiero crear una tarea para registrar un pendiente.
   Criterio: el formulario guarda una tarea válida y la lista la muestra.
4. Como estudiante, quiero editar una tarea para corregir sus datos.
   Criterio: los cambios guardados aparecen en lista y detalle.
5. Como estudiante, quiero eliminar una tarea terminada para limpiar la lista.
   Criterio: después de confirmar, la tarea desaparece de la lista.

### Modelo de datos
Task: id (entero único), title (texto), description (texto),
priority (Alta, Media o Baja), isCompleted (verdadero/falso),
userId (entero que identifica al usuario de prueba).

### Pantallas previstas
Lista: tarjetas de tareas y acción para crear.
Detalle: información completa y acciones de editar o eliminar.
Formulario: campos de título, descripción y prioridad.

### Requisitos no funcionales
La navegación debe tener textos comprensibles.
Un id inexistente debe mostrar un mensaje en vez de cerrar la app.

### Contrato de API que necesitaremos
GET /tasks        listar tareas
GET /tasks/:id    consultar detalle
POST /tasks       crear tarea
PATCH /tasks/:id  actualizar tarea
DELETE /tasks/:id eliminar tarea

La API concreta se eligió después (JSONPlaceholder). Estas rutas eran
requisitos iniciales.

## API de tareas

- URL exacta: `https://jsonplaceholder.typicode.com/todos?userId=1`
- Método: GET
- Parámetro `userId`: filtra las tareas de un usuario (valor elegido: 1).
- Campos que llegan de la API: `userId`, `id`, `title` y `completed`
  (en el modelo `completed` se guarda como `isCompleted`).
- Valores que TaskFlow completa por defecto: `description`
  ("Sin descripción (API)") y `priority` ("Sin prioridad (API)"),
  porque la API no los entrega.
- Marcar una tarea como completada o pendiente es un cambio local en memoria:
  JSONPlaceholder no guarda cambios y, al reiniciar la app, vuelve al valor remoto.

## Estados de la lista de tareas

La pantalla de tareas distingue cuatro estados: carga, éxito, vacío y error.

- **Carga:** se muestra un indicador de progreso mientras llega la respuesta.
- **Éxito:** con internet, la API devuelve las tareas y se dibuja una tarjeta por cada una.
- **Vacío:** se cambió temporalmente `userId` a `999` en `TaskApiService`; la API
  responde una lista vacía y aparece "Todavía no hay tareas para mostrar" con el
  botón Actualizar. Después se restauró `userId = 1`.
- **Error:** se desactivó internet y se pulsó Actualizar; aparece
  "No se pudieron cargar las tareas." con el botón Reintentar. Al reactivar
  internet y pulsar Reintentar, la lista vuelve sin reiniciar la app.

## Formulario de tareas

La pantalla "Nueva tarea" valida el título (obligatorio, mínimo 3 caracteres),
permite escribir una descripción, elegir la prioridad (Alta, Media o Baja) y
una fecha límite opcional con `showDatePicker`. Cancelar vuelve a la lista sin
mensaje.

## CRUD con JSONPlaceholder (sesión 10)

TaskFlow implementa POST (crear), PATCH (editar título) y DELETE (eliminar).
JSONPlaceholder solo SIMULA las escrituras: responde como si guardara, pero no
persiste nada. Al actualizar la lista o reiniciar la app, vuelven los datos
originales. Las tareas creadas reciben el id 201 de la API y no existen
realmente en el servidor, por lo que editarlas o eliminarlas en la API puede
devolver error.