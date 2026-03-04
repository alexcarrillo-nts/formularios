# 📱 Guía Completa de la Aplicación - Flutter Formularios

## Tabla de Contenidos
1. [Descripción General](#descripción-general)
2. [Estructura del Proyecto](#estructura-del-proyecto)
3. [Dependencias Utilizadas](#dependencias-utilizadas)
4. [¿Qué es BLoC y Cubit?](#qué-es-bloc-y-cubit)
5. [Guía Detallada de BLoC](#guía-detallada-de-bloc)
6. [Diferencias entre BLoC y Cubit](#diferencias-entre-bloc-y-cubit)
7. [Flujo de la Aplicación](#flujo-de-la-aplicación)

---

## 🎯 Descripción General

Esta es una **aplicación educativa de Flutter** que demuestra tres conceptos clave de gestión de estado:

### Pantallas principales:
- **Home Screen**: Menú principal con opciones de navegación
- **Cubit Counter**: Ejemplo simple de gestión de estado con Cubit
- **BLoC Counter**: Ejemplo más complejo de gestión de estado con BLoC
- **Register Screen**: Ejemplo de manejo de formularios con validaciones

---

## 📁 Estructura del Proyecto

```
lib/
├── main.dart                    # Punto de entrada de la app
├── config/
│   ├── router/
│   │   └── app_router.dart     # Configuración de rutas con GoRouter
│   └── theme/
│       └── app_theme.dart      # Tema visual de la app
└── presentation/
    ├── blocs/                  # Gestores de estado
    │   ├── counter_bloc/       # Implementación con BLoC
    │   │   ├── counter_bloc.dart
    │   │   ├── counter_event.dart
    │   │   └── counter_state.dart
    │   └── counter_cubit/      # Implementación con Cubit
    │       ├── counter_cubit.dart
    │       └── counter_state.dart
    ├── screens/                # Pantallas de la app
    │   ├── home_screen.dart
    │   ├── bloc_counter_screen.dart
    │   ├── cubit_counter_screen.dart
    │   └── register_screen.dart
    └── widgets/                # Componentes reutilizables
        └── custom_text_form_field.dart
```

---

## 📦 Dependencias Utilizadas

### Flutter y Dart
- **flutter_bloc (v8.1.2)**: Librería para implementar el patrón BLoC
- **go_router (v6.2.0)**: Sistema de navegación moderno basado en rutas
- **equatable (v2.0.5)**: Facilita la comparación de objetos en Dart

### ¿Para qué sirve cada una?

#### flutter_bloc
Proporciona herramientas para crear y gestionar estados en la aplicación de manera estructurada.

#### go_router
Maneja la navegación entre pantallas de forma declarativa y eficiente.

#### equatable
Permite comparar objetos automáticamente, evitando escribir `==` y `hashCode` manualmente.

---

## 🔄 ¿Qué es BLoC y Cubit?

### **Cubit** ⚡
Es un **gestor de estado simplificado**. 

**Características:**
- Más simple que BLoC
- Métodos directos para cambiar estado
- Ideal para lógica simple
- Emite estados directamente desde métodos

**Ciclo:**
```
Usuario → Método Cubit → emit(nuevo_estado) → UI actualiza
```

**Ejemplo en código:**
```dart
class CounterCubit extends Cubit<CounterState> {
  void increaseBy(int value) {
    emit(state.copyWith(counter: state.counter + value));
  }
}
```

### **BLoC** 🏗️
Es un patrón más **robusto y escalable**.

**Características:**
- Usa un sistema de Eventos
- Los eventos se procesan de forma estructurada
- Ideal para lógica compleja
- Mejor mantenibilidad para proyectos grandes

**Ciclo:**
```
Usuario → add(Evento) → Evento procesado → emit(nuevo_estado) → UI actualiza
```

**Ejemplo en código:**
```dart
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterState()) {
    on<CounterIncreased>(_onCounterIncreased);
  }

  void _onCounterIncreased(CounterIncreased event, Emitter<CounterState> emit) {
    emit(state.copyWith(counter: state.counter + event.value));
  }
}
```

---

## 📚 Guía Detallada de BLoC

### ¿Cómo está organizado?

Un BLoC está compuesto por **3 archivos principales**:

#### 1. **counter_event.dart** - Definir Eventos
Los eventos representan **acciones del usuario** que quieren cambiar el estado.

```dart
part of 'counter_bloc.dart';

abstract class CounterEvent {
  const CounterEvent();
}

// Evento para aumentar el contador
class CounterIncreased extends CounterEvent {
  final int value;
  const CounterIncreased(this.value);
}

// Evento para resetear el contador
class CounterReset extends CounterEvent {}
```

**¿Cuándo usar cada evento?**
- `CounterIncreased`: Cuando el usuario presiona un botón para aumentar
- `CounterReset`: Cuando el usuario quiere reiniciar el contador

#### 2. **counter_state.dart** - Definir Estado
El estado representa la **información actual de la aplicación**.

```dart
part of 'counter_bloc.dart';

class CounterState extends Equatable {
  final int counter;           // Valor actual del contador
  final int transactionCount;  // Cantidad de cambios realizados

  const CounterState({
    this.counter = 10,
    this.transactionCount = 0
  });

  // Método para crear una copia con cambios
  CounterState copyWith({
    int? counter,
    int? transactionCount,
  }) => CounterState(
    counter: counter ?? this.counter,
    transactionCount: transactionCount ?? this.transactionCount,
  );

  @override
  List<Object> get props => [counter, transactionCount];
}
```

**¿Qué es `copyWith()`?**
Es un patrón común en Dart que crea una **nueva copia del objeto** con algunos campos modificados. Esto es importante para que la UI se actualice (los objetos antiguos y nuevos son diferentes).

#### 3. **counter_bloc.dart** - La Lógica Principal
El BLoC procesa eventos y emite nuevos estados.

```dart
class CounterBloc extends Bloc<CounterEvent, CounterState> {

  // Constructor: registra qué manejador usa cada evento
  CounterBloc() : super(const CounterState()) {
    on<CounterIncreased>(_onCounterIncreased);  // Evento → Manejador
    on<CounterReset>(_onCounterReset);
  }

  // Manejador del evento CounterIncreased
  void _onCounterIncreased(CounterIncreased event, Emitter<CounterState> emit) {
    // Acciones antes de emitir (lógica compleja, APIs, etc.)
    
    // Emitir nuevo estado con el contador aumentado
    emit(state.copyWith(
      counter: state.counter + event.value,
      transactionCount: state.transactionCount + 1
    ));
  }

  // Manejador del evento CounterReset
  void _onCounterReset(CounterReset event, Emitter<CounterState> emit) {
    emit(state.copyWith(counter: 0));
  }

  // Métodos auxiliares para que la UI llame de forma más sencilla
  void increaseBy([int value = 1]) {
    add(CounterIncreased(value));  // Agregar evento a la cola
  }

  void resetCounter() {
    add(CounterReset());
  }
}
```

### 📊 Flujo paso a paso de BLoC

```
1. USUARIO PRESIONA BOTÓN
        ↓
2. increaseBy(3) se llama
        ↓
3. add(CounterIncreased(3)) agrega el evento a la cola
        ↓
4. BLoC recibe el evento
        ↓
5. Ejecuta _onCounterIncreased(evento, emit)
        ↓
6. emit(nuevo_estado) emite el estado actualizado
        ↓
7. BlocBuilder/context.select escucha el cambio
        ↓
8. LA UI SE REDIBUJA
```

---

### Consumiendo el BLoC en la UI

En `bloc_counter_screen.dart`:

```dart
// 1. Crear el BLoC con BlocProvider
BlocProvider(
  create: (_) => CounterBloc(),
  child: const BlocCounterView()
)

// 2. Leer el BLoC sin escuchar cambios
context.read<CounterBloc>().increaseBy(3);

// 3. Seleccionar solo algunos datos
context.select(
  (CounterBloc bloc) => Text('${bloc.state.transactionCount}')
)

// 4. Escuchar cambios y reconstruir
BlocBuilder<CounterBloc, CounterState>(
  builder: (context, state) => Text('${state.counter}'),
)
```

---

## 🔄 Diferencias entre BLoC y Cubit

| Aspecto | BLoC | Cubit |
|--------|------|-------|
| **Complejidad** | ⭐⭐⭐⭐⭐ | ⭐⭐ |
| **Mantenibilidad** | Mejor para apps grandes | Mejor para apps pequeñas |
| **Métodos de entrada** | Eventos (más formal) | Métodos (más directo) |
| **Escalabilidad** | Excelente | Moderada |
| **Código** | Más código inicial | Menos código |
| **Recomendado para** | Lógica compleja | Lógica simple |

### Ejemplo: Cubit vs BLoC

#### Usando Cubit:
```dart
// Llamar desde UI
context.read<CounterCubit>().increaseBy(3);
```

#### Usando BLoC:
```dart
// Opción 1: Usar el método auxiliar
context.read<CounterBloc>().increaseBy(3);

// Opción 2: Agregar evento directamente
context.read<CounterBloc>().add(CounterIncreased(3));
```

---

## 🗺️ Flujo de la Aplicación

### 1️⃣ Inicio (`main.dart`)
- La app se ejecuta
- Carga el tema y el router
- Muestra la pantalla inicial

### 2️⃣ Menú Principal (`home_screen.dart`)
```
[Home Screen]
    ├── Opción: Cubits → Lleva a /cubits
    ├── Opción: BLoC → Lleva a /counter-bloc
    └── Opción: Nuevo usuario → Lleva a /new-user
```

### 3️⃣ Ejemplo de Cubit (`cubit_counter_screen.dart`)
```
[Cubit Counter] (inicio: 5)
    ├── +3 botón
    ├── +2 botón
    └── +1 botón
    └── Reset botón
```

**Lógica:**
- Cada click suma el valor al contador
- El `transactionCount` registra cuántas veces se modificó
- Reset vuelve todo a 0

### 4️⃣ Ejemplo de BLoC (`bloc_counter_screen.dart`)
```
[BLoC Counter] (inicio: 10)
    ├── +3 botón
    ├── +2 botón
    └── +1 botón
    └── Reset botón (en IconButton)
```

**Lógica:**
- Idéntica a Cubit, pero usa eventos

### 5️⃣ Formulario (`register_screen.dart`)
```
[Register Screen]
    ├── Input: Username (min 6 caracteres)
    ├── Input: Email (validar formato)
    ├── Input: Password (min 6 caracteres)
    └── Botón: Crear usuario
```

**Validaciones:**
- Campo requerido
- NO espacios al inicio/final
- Username: mínimo 6 caracteres
- Email: debe ser formato válido
- Password: mínimo 6 caracteres

---

## 🎓 Aprende paso a paso

### Nivel 1: Entiende la estructura
1. Lee `main.dart` - Punto de entrada
2. Lee `app_router.dart` - Cómo navegar
3. Lee `home_screen.dart` - Las opciones

### Nivel 2: Aprende Cubit
1. Lee `counter_state.dart` - El estado
2. Lee `counter_cubit.dart` - La lógica
3. Lee `cubit_counter_screen.dart` - Cómo usarlo
4. **Practica**: Agrega un botón que multiplique por 2

### Nivel 3: Aprende BLoC
1. Lee `counter_event.dart` - Los eventos
2. Lee `counter_state.dart` - El estado
3. Lee `counter_bloc.dart` - La lógica
4. Lee `bloc_counter_screen.dart` - Cómo usarlo
5. **Practica**: Agrega un nuevo evento `CounterMultiplied`

### Nivel 4: Aplicaciones prácticas
1. Crea un gestor de TODO con lista persistente
2. Implementa un BLoC para manejar login
3. Crea un carrito de compras con estado complejo

---

## 💡 Conceptos Clave a Recordar

### State Management = Las 3 Preguntas:
1. **¿Qué información necesito?** → Estado
2. **¿Qué puede cambiar esa información?** → Eventos (BLoC) o Métodos (Cubit)
3. **¿Cómo cambio esa información?** → Lógica en Manejadores

### El ciclo es SIMPLE:
```
Evento/Acción → Procesar → Emit nuevo estado → UI se actualiza
```

### Regla de Oro:
> **NUNCA** modifiques el estado directamente. **SIEMPRE** emite un estado nuevo.

---

## 🚀 Recursos Adicionales

- [Documentación flutter_bloc](https://bloclibrary.dev/)
- [Documentación go_router](https://pub.dev/packages/go_router)
- [Patrón BLoC oficial](https://bloclibrary.dev/bloc-concepts/)

---

**Autor**: Flutter Learning Guide  
**Fecha**: 2024  
**Nivel**: Principiante a Intermedio

