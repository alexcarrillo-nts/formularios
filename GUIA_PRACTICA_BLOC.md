# 🎓 Guía Práctica: BLoC paso a paso

## Entendiendo el flujo completo

### Escenario Real: Usuario presiona botón +3

```
┌─────────────────────────────────────────────────┐
│ 1. USUARIO PRESIONA BOTÓN +3 EN LA PANTALLA     │
└─────────────┬───────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────────┐
│ 2. Se ejecuta: increaseCounterBy(context, 3)    │
└─────────────┬───────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────────┐
│ 3. Dentro del método:                           │
│    context.read<CounterBloc>()                  │
│      .increaseBy(3)                             │
└─────────────┬───────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────────┐
│ 4. El BLoC recibe el llamado en increaseBy()    │
│    y ejecuta: add(CounterIncreased(3))          │
└─────────────┬───────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────────┐
│ 5. El evento CounterIncreased(3) se agrega      │
│    a la cola de eventos del BLoC                │
└─────────────┬───────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────────┐
│ 6. El BLoC procesa el evento                    │
│    y llama: _onCounterIncreased(evento, emit)   │
└─────────────┬───────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────────┐
│ 7. Dentro de _onCounterIncreased():             │
│    - estado anterior: counter = 10              │
│    - evento: value = 3                          │
│    - nuevo valor: 10 + 3 = 13                   │
│    - transactionCount aumenta en 1              │
└─────────────┬───────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────────┐
│ 8. Se emite nuevo estado:                       │
│    CounterState(                                │
│      counter: 13,        ← CAMBIO              │
│      transactionCount: 1  ← CAMBIO              │
│    )                                            │
└─────────────┬───────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────────┐
│ 9. Los listeners escuchan el cambio:            │
│    - context.select(...) detects change        │
│    - BlocBuilder detects change                │
│    - context.watch(...) detects change        │
└─────────────┬───────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────────┐
│ 10. La UI se reconstruye automáticamente        │
│     Muestra: "Counter value: 13"                │
│     Muestra: "Bloc Counter 1" (en AppBar)       │
└─────────────────────────────────────────────────┘
```

---

## Las 3 formas de acceder al BLoC desde la UI

### 1. context.read() - Leer SIN escuchar
```dart
// Usa esto cuando necesitas el valor AHORA pero NO quieres reconstruir

void resetButtonPressed(BuildContext context) {
  // Accede al BLoC en este momento
  context.read<CounterBloc>().resetCounter();
  // La UI NO se reconstruye automáticamente
}

// USO TÍPICO: En event handlers (onClick, onSubmit, etc)
```

**Ventajas:**
- Eficiente: no reconstruye innecesariamente
- Simple para acciones puntuales

**Desventajas:**
- Solo es para leer en ese momento
- No reacciona a cambios

---

### 2. context.select() - Seleccionar valor específico
```dart
// Usa esto cuando necesitas SOLO UN valor y quieres escucharlos

title: context.select(
  (CounterBloc bloc) => Text('Transactions: ${bloc.state.transactionCount}')
)

// O más explícito:
title: context.select(
  (CounterBloc bloc) => bloc.state.transactionCount
)

// La UI se reconstruye SOLO cuando transactionCount cambia
// Si solo counter cambia, la UI NO se reconstruye
```

**Ventajas:**
- Muy eficiente: reconstruye solo lo necesario
- Reacciona a cambios del valor seleccionado

**Desventajas:**
- Solo para valores simples
- Complejo si necesitas múltiples valores

---

### 3. BlocBuilder - Escuchar TODOS los cambios
```dart
// Usa esto cuando quieres reconstruir cuando EL ESTADO cambia

BlocBuilder<CounterBloc, CounterState>(
  builder: (context, state) {
    // Este builder se ejecuta cada vez que CounterState cambia
    return Text('Counter: ${state.counter}');
  },
)

// Versión con filtro (buildWhen):
BlocBuilder<CounterBloc, CounterState>(
  buildWhen: (previous, current) {
    // Retorna true si quieres reconstruir, false si no
    return current.counter != previous.counter;
  },
  builder: (context, state) {
    return Text('Counter: ${state.counter}');
  },
)
```

**Ventajas:**
- Acceso a todo el estado
- Control fino con buildWhen

**Desventajas:**
- Puede reconstruir más de lo necesario
- Más código

---

## Comparación lado a lado: read() vs select() vs BlocBuilder

```dart
// Escenario: Mostrar counter en la UI

// OPCIÓN 1: context.read() - INCORRECTO!
Text(context.read<CounterBloc>().state.counter)
// PROBLEMA: Si el contador cambia, el texto NO se actualiza


// OPCIÓN 2: context.select() - CORRECTO para valor simple
context.select(
  (CounterBloc bloc) => Text('${bloc.state.counter}')
)
// BENEFICIO: Se actualiza cuando counter cambia


// OPCIÓN 3: BlocBuilder - CORRECTO para lógica compleja
BlocBuilder<CounterBloc, CounterState>(
  builder: (context, state) => Text('${state.counter}'),
)
// BENEFICIO: Se actualiza cuando el estado cambia


// OPCIÓN 4: context.watch() - SIMILAR A BLOCBUILDER
context.watch<CounterBloc>().state.counter
// Reconstruye cuando el estado cambia
```

---

## Patrones Comunes

### Patrón 1: Contador con validación
```dart
class MyBloc extends Bloc<MyEvent, MyState> {
  MyBloc() : super(MyState()) {
    on<IncrementPressed>(_onIncrement);
  }

  void _onIncrement(IncrementPressed event, Emitter<MyState> emit) {
    // Validar
    if (state.counter >= 100) {
      emit(state.copyWith(error: 'Máximo alcanzado'));
      return;
    }
    
    // Actualizar
    emit(state.copyWith(counter: state.counter + 1));
  }
}
```

### Patrón 2: Llamada asincrónica (API)
```dart
class DataBloc extends Bloc<DataEvent, DataState> {
  DataBloc() : super(DataState()) {
    on<FetchDataPressed>(_onFetchData);
  }

  Future<void> _onFetchData(FetchDataPressed event, Emitter<DataState> emit) async {
    // Emitir estado "cargando"
    emit(state.copyWith(isLoading: true));
    
    try {
      // Hacer llamada a API
      final data = await fetchFromAPI();
      
      // Emitir éxito
      emit(state.copyWith(isLoading: false, data: data));
    } catch (e) {
      // Emitir error
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
```

### Patrón 3: Múltiples eventos del mismo tipo
```dart
class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  CheckoutBloc() : super(CheckoutState()) {
    // Un mismo evento puede ocurrir múltiples veces
    on<ItemAdded>(_onItemAdded);
    on<ItemRemoved>(_onItemRemoved);
  }

  void _onItemAdded(ItemAdded event, Emitter<CheckoutState> emit) {
    final newItems = [...state.items, event.item];
    emit(state.copyWith(items: newItems));
  }

  void _onItemRemoved(ItemRemoved event, Emitter<CheckoutState> emit) {
    final newItems = state.items.where((i) => i.id != event.itemId).toList();
    emit(state.copyWith(items: newItems));
  }
}
```

---

## Estado vs Evento

### ¿Qué va en un EVENTO?
- Acciones del usuario
- Datos necesarios para procesar la acción
- Lo que el usuario QUIERE hacer

**Ejemplos:**
```dart
class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  const LoginRequested(this.email, this.password);
}

class LogoutPressed extends AuthEvent {}

class RefreshTokenRequested extends AuthEvent {}
```

### ¿Qué va en un ESTADO?
- Información actual
- Lo que pasó DESPUÉS de la acción
- Lo que la UI necesita saber

**Ejemplos:**
```dart
class AuthState extends Equatable {
  final bool isLoggedIn;
  final User? user;
  final bool isLoading;
  final String? error;
  
  const AuthState({
    this.isLoggedIn = false,
    this.user,
    this.isLoading = false,
    this.error,
  });
  
  @override
  List<Object?> get props => [isLoggedIn, user, isLoading, error];
}
```

---

## Errores Comunes y cómo evitarlos

### ❌ ERROR 1: Modificar el estado directamente
```dart
// INCORRECTO!
state.counter = state.counter + 1;

// CORRECTO!
emit(state.copyWith(counter: state.counter + 1));
```

**Por qué:** Equatable y la UI necesitan un objeto NUEVO para detectar cambios.

---

### ❌ ERROR 2: Olvidar BlocProvider
```dart
// INCORRECTO!
BlocCounterView()  // CounterBloc no existe

// CORRECTO!
BlocProvider(
  create: (_) => CounterBloc(),
  child: BlocCounterView(),
)
```

**Por qué:** Sin BlocProvider, context.read() no encuentra el BLoC.

---

### ❌ ERROR 3: Usar read() para valores que cambian
```dart
// INCORRECTO!
Text(context.read<CounterBloc>().state.counter)  // Nunca se actualiza

// CORRECTO!
Text(context.select(
  (CounterBloc b) => Text('${b.state.counter}')
))  // Se actualiza cuando counter cambia
```

**Por qué:** read() solo accede en ese momento, no escucha cambios.

---

### ❌ ERROR 4: OBTENER Equatable cuando no lo necesitas
```dart
// INCORRECTO!
class MyState {  // Sin Equatable, === no funciona
  final int value;
}

// CORRECTO!
class MyState extends Equatable {
  final int value;
  @override
  List<Object> get props => [value];
}
```

**Por qué:** Equatable permite comparar objetos por sus valores.

---

## Checklist: ¿Está tu BLoC bien hecho?

- [ ] ¿Tienes una clase State con Equatable?
- [ ] ¿La clase State tiene copyWith()?
- [ ] ¿La clase State sobrescribe props?
- [ ] ¿Tienes una o más clases Event?
- [ ] ¿El BLoC extiende Bloc<Event, State>?
- [ ] ¿Registraste todos los eventos en el constructor con on<>()?
- [ ] ¿Cada evento tiene un manejador (_on...)?
- [ ] ¿Nunca modificas el estado directamente?
- [ ] ¿Siempre usas emit() para nuevos estados?
- [ ] ¿Envolviste tu pantalla con BlocProvider?
- [ ] ¿Usas context.read() para acciones?
- [ ] ¿Usas context.select() o BlocBuilder para lecturas?

---

## Resumen de las 3 Capas

```
┌────────────────────────────┐
│  PRESENTATION LAYER (UI)   │  ← Widgets, Screens
│  - Llama métodos del BLoC  │
│  - Escucha cambios         │
└────────────┬───────────────┘
             │ read/select/watch
             ▼
┌────────────────────────────┐
│  BLOC LAYER (Logic)        │  ← BLoC, Cubit
│  - Recibe eventos          │
│  - Procesa lógica          │
│  - Emite estados           │
└────────────┬───────────────┘
             │ emit(estado)
             ▼
┌────────────────────────────┐
│  MODEL LAYER (Data)        │  ← State, Classes
│  - Almacena datos          │
│  - Define estructura       │
└────────────────────────────┘
```

---

## Recursos Clave

### Documentación
- [flutter_bloc docs](https://bloclibrary.dev/)
- [Bloc Pattern en español](https://bloclibrary.dev/bloc-concepts/)

### En tu proyecto
- [counter_bloc.dart](lib/presentation/blocs/counter_bloc/counter_bloc.dart) - Ejemplo real
- [counter_cubit.dart](lib/presentation/blocs/counter_cubit/counter_cubit.dart) - Ejemplo simple
- [bloc_counter_screen.dart](lib/presentation/screens/bloc_counter_screen.dart) - Cómo usarlo

