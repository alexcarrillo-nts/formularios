# 🎯 Referencia Rápida: Cubit vs BLoC

## Tabla de Comparación Rápida

| | **Cubit** | **BLoC** |
|---|-----------|---------|
| **Complejidad** | ⭐⭐ Fácil | ⭐⭐⭐⭐ Avanzado |
| **Código** | Poco | Más |
| **Métodos** | Directos: `increaseBy()` | Eventos: `add(CounterIncreased())` |
| **Archivos** | 2 | 3 |
| **Mejor para** | Apps simples | Apps complejas |
| **Extensión** | `Cubit<State>` | `Bloc<Event, State>` |
| **Entrada** | Métodos | Eventos |
| **Inicialización** | `super(const State())` | `super(const State())` + `on<>()` |

---

## Scaffolds de Código

### Crear un Cubit

```dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'counter_state.dart';

class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(const CounterState());

  void increment() {
    emit(state.copyWith(value: state.value + 1));
  }
}
```

```dart
// counter_state.dart
part of 'counter_cubit.dart';

class CounterState extends Equatable {
  final int value;
  const CounterState({this.value = 0});

  CounterState copyWith({int? value}) => CounterState(
    value: value ?? this.value,
  );

  @override
  List<Object> get props => [value];
}
```

---

### Crear un BLoC

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'counter_event.dart';
part 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterState()) {
    on<CounterIncremented>(_onIncremented);
  }

  void _onIncremented(CounterIncremented event, Emitter<CounterState> emit) {
    emit(state.copyWith(value: state.value + 1));
  }
}
```

```dart
// counter_event.dart
part of 'counter_bloc.dart';

abstract class CounterEvent {}

class CounterIncremented extends CounterEvent {}
```

```dart
// counter_state.dart
part of 'counter_bloc.dart';

class CounterState extends Equatable {
  final int value;
  const CounterState({this.value = 0});

  CounterState copyWith({int? value}) => CounterState(
    value: value ?? this.value,
  );

  @override
  List<Object> get props => [value];
}
```

---

### Usar en una Pantalla

#### Con Cubit
```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterCubit(),
      child: BlocBuilder<CounterCubit, CounterState>(
        builder: (context, state) {
          return Scaffold(
            body: Text('${state.value}'),
            floatingActionButton: FloatingActionButton(
              onPressed: () => context.read<CounterCubit>().increment(),
              child: Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}
```

#### Con BLoC
```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterBloc(),
      child: BlocBuilder<CounterBloc, CounterState>(
        builder: (context, state) {
          return Scaffold(
            body: Text('${state.value}'),
            floatingActionButton: FloatingActionButton(
              onPressed: () => context.read<CounterBloc>().add(CounterIncremented()),
              child: Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}
```

---

## Comandos de Lectura

### context.read() - Ahora mismo
```dart
// LECTURA ÚNICA - Sin reacciones
int currentValue = context.read<MyBloc>().state.value;

// ACCIÓN - Típicamente en botones
onPressed: () => context.read<MyBloc>().myMethod(),
```

### context.select() - Valor específico
```dart
// RECONSTRUYE SI value cambia
Text(context.select(
  (MyBloc b) => Text('${b.state.value}')
))

// RECONSTRUYE SI cualquier cosa en state cambia
Text(context.select(
  (MyBloc b) => Text('${b.state}')
))
```

### context.watch() - Todo el estado
```dart
// RECONSTRUYE si state cambia
final state = context.watch<MyBloc>().state;

Text('${state.value}')
```

### BlocBuilder - Control fino
```dart
// Forma simple
BlocBuilder<MyBloc, MyState>(
  builder: (context, state) => Text('${state.value}'),
)

// Con buildWhen (filtro)
BlocBuilder<MyBloc, MyState>(
  buildWhen: (p, c) => p.value != c.value,
  builder: (context, state) => Text('${state.value}'),
)
```

### BlocListener - Sin reconstruir
```dart
// Ejecutar acciones sin reconstruir
BlocListener<MyBloc, MyState>(
  listener: (context, state) {
    if (state.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.error!))
      );
    }
  },
  child: MyWidget(),
)
```

---

## copyWith() explicado

```dart
// ORIGINAL
MyState(value: 5, name: 'John', isActive: true)

// CON copyWith - Cambiar SOLO value
.copyWith(value: 10)
// RESULTADO: MyState(value: 10, name: 'John', isActive: true)

// CON copyWith - Cambiar SOLO name
.copyWith(name: 'Jane')
// RESULTADO: MyState(value: 5, name: 'Jane', isActive: true)

// CON copyWith - Cambiar MÚLTIPLES
.copyWith(value: 10, isActive: false)
// RESULTADO: MyState(value: 10, name: 'John', isActive: false)
```

### Cómo se implementa copyWith()

```dart
class MyState {
  final int value;
  final String name;
  final bool isActive;

  const MyState({
    this.value = 0,
    this.name = '',
    this.isActive = true,
  });

  // El truco: usar ?? para mantener el original si llegó null
  MyState copyWith({
    int? value,
    String? name,
    bool? isActive,
  }) => MyState(
    value: value ?? this.value,      // Nuevo o mantén el anterior
    name: name ?? this.name,          // Nuevo o mantén el anterior
    isActive: isActive ?? this.isActive,  // Nuevo o mantén el anterior
  );
}
```

---

## Flujo de Eventos en BLoC

```
┌──────────────────┐
│ Usuario Action   │ ← Click botón
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│ add(Evento)      │ ← Se agrega a la cola
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│ BLoC Recibe      │ ← Se procesa
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│ Manejador _on... │ ← Lógica aquí
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│ emit(Estado)     │ ← Resultado
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│ UI Escucha       │ ← Observa
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│ Reconstruir      │ ← Actualización
└──────────────────┘
```

---

## Preguntas Frecuentes Rápidas

**P: ¿Cuándo usar Cubit vs BLoC?**  
R: Cubit para lógica simple (contadores, toggles). BLoC para lógica compleja (APIs, múltiples eventos).

**P: ¿Por qué necesito Equatable?**  
R: Para comparar objetos. Sin Equatable, `state1 == state2` siempre es `false`.

**P: ¿Puedo tener múltiples BLoCs?**  
R: Sí, usa `MultiBlocProvider`.

**P: ¿Debo usar BlocListener para todo?**  
R: No. BlocListener es para efectos secundarios (banners, navegación). BlocBuilder es para UI.

**P: ¿Puedo navegar desde el BLoC?**  
R: Mejor que no. Emite un estado de "navegación" y la UI navega.

**P: ¿Puedo hacer operaciones asincrónicas?**  
R: Sí, usa `async` en el manejador.

---

## Checklist de Implementación

```
Para Cubit:
☐ Crear archivo cubit_name_cubit.dart
☐ Crear parte: part 'cubit_name_state.dart'
☐ Crear clase State extendiendo Equatable
☐ Implementar copyWith()
☐ Implementar props
☐ Crear clase Cubit extendiendo Cubit<State>
☐ Implementar métodos para cambiam de estado
☐ Cada método debe emit()

Para BLoC:
☐ Crear archivo bloc_name_bloc.dart
☐ Crear parte: part 'bloc_name_event.dart'
☐ Crear parte: part 'bloc_name_state.dart'
☐ Crear clases de Event
☐ Crear clase State extendiendo Equatable
☐ Implementar copyWith()
☐ Implementar props
☐ Crear clase BLoC extendiendo Bloc<Event, State>
☐ En constructor, registrar eventos con on<>()
☐ Crear manejadores _on...()
☐ Cada manejador debe emit()

En la UI:
☐ Envolver con BlocProvider
☐ Usar BlocBuilder/select/watch para leer
☐ Usar context.read() para acciones
☐ Usar BlocListener para efectos secundarios
```

---

## Estructura de Carpetas Recomendada

```
lib/
├── blocs/
│   ├── counter/
│   │   ├── counter_bloc.dart      (o counter_cubit.dart)
│   │   ├── counter_event.dart     (solo BLoC)
│   │   └── counter_state.dart
│   ├── auth/
│   │   ├── auth_bloc.dart
│   │   ├── auth_event.dart
│   │   └── auth_state.dart
│   └── ...
├── pages/
│   ├── home/
│   │   └── home_page.dart
│   ├── login/
│   │   └── login_page.dart
│   └── ...
├── widgets/
│   ├── custom_button.dart
│   └── ...
└── main.dart
```

---

## La regla de oro

> **Nunca modifiques directamente el estado. Siempre crea uno nuevo con `emit(state.copyWith(...))`.**

Esta regla asegura que:
1. Equatable pueda detectar cambios
2. La UI se reconstruya
3. El código sea predecible
4. No haya bugs raros 🐛

---

