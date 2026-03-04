# ⚡ Quick Start - 5 Minutos

## Lo más importante en menos de 100 palabras

Esta app tiene 3 conceptos claves:

### 🎯 BLoC = Sistema que organiza tu código
```
Usuario presiona botón → Se manda un EVENTO 
→ BLoC lo procesa → Emite ESTADO nuevo 
→ UI escucha y se redibuja
```

### ⚡ Cubit = Versión simplificada de BLoC
```
Usuario presiona botón → Se llama un método 
→ Cubit emite ESTADO nuevo → UI se redibuja
```

### 📱 La aplicación muestra ambos en 2 pantallas
- Pantalla Cubit: Contador simple
- Pantalla BLoC: Contador con eventos

---

## Los 3 Archivos que DEBES entender

### 1. counter_bloc.dart
```
┌─ Recibe eventos (CounterIncreased, CounterReset)
├─ Procesa qué hacer con cada uno
└─ Emite nuevo estado
```
**Línea clave:**
```dart
on<CounterIncreased>(_onCounterIncreased);
```

### 2. counter_state.dart
```
┌─ Almacena datos (counter, transactionCount)
├─ copyWith() = crear copia con cambios
└─ props = lista de propiedades importantes
```
**Línea clave:**
```dart
emit(state.copyWith(counter: state.counter + 1));
```

### 3. bloc_counter_screen.dart
```
┌─ Crea el BLoC con BlocProvider
├─ Usa context.read() para acciones (botones)
└─ Usa context.select() para mostrar datos
```
**Línea clave:**
```dart
context.read<CounterBloc>().increaseBy(3);
```

---

## Las 3 Formas de Acceder a tu BLoC

| Forma | Cuándo | Ejemplo |
|-------|--------|---------|
| **read()** | Acción AHORA | `onPressed: () => context.read<Bloc>().method()` |
| **select()** | Mostrar DATO | `Text(context.select(...))` |
| **BlocBuilder** | Lógica COMPLEJA | `BlocBuilder(...) { builder() }` |

---

## Una Variable, 3 Responsables

```
Dato: numero = 5

┌─────────────────────────────────────┐
│ 1. STATE                            │
│    Almacena: numero = 5             │
│    ← Responsable de guardar         │
└─────────────────────────────────────┘
         ▲
         │ Cambio a 5
         │
┌─────────────────────────────────────┐
│ 2. BLOC                             │
│    Recibe evento: "aumentar por 1"  │
│    Calcula: 5 + 1 = 6               │
│    Emite: estado nuevo              │
│    ← Responsable de procesar        │
└─────────────────────────────────────┘
         ▲
         │ Cambio a 6
         │
┌─────────────────────────────────────┐
│ 3. UI WIDGET                        │
│    Escucha cambio a 6               │
│    Muestra: "Numero: 6"             │
│    ← Responsable de mostrar         │
└─────────────────────────────────────┘
```

---

## Paso a Paso: Bug Clásico

### ❌ INCORRECTO (BloC nunca se actualiza)
```dart
// En bloc_counter_screen.dart
Text(context.read<CounterBloc>().state.counter)
```
**Problema:** read() solo accede AHORA, no escucha cambios

### ✅ CORRECTO
```dart
// En bloc_counter_screen.dart
context.select(
  (CounterBloc b) => Text('${b.state.counter}')
)
```
**Beneficio:** Ahora sí escucha cambios y se actualiza

---

## Copyith() - El truco del estado

```dart
// Original
CounterState(counter: 10, transactions: 0)

// Cambiar SOLO counter
.copyWith(counter: 15)
// Resultado: counter=15, transactions=0 (se mantiene)

// Cambiar SOLO transactions
.copyWith(transactionCount: 1)
// Resultado: counter=10, transactions=1 (se mantiene)
```

**Por qué:** Crear un objeto NUEVO le avisa a Flutter que cambió

---

## 5 Líneas: Lo más importante

1. **Estados son inmutables**
   ```dart
   // ❌ No: state.counter = 5;
   // ✅ Sí: emit(state.copyWith(counter: 5));
   ```

2. **Siempre usa Equatable**
   ```dart
   // ✅ class CounterState extends Equatable
   ```

3. **Registra eventos en el constructor**
   ```dart
   // ✅ on<CounterIncreased>(_onCounterIncreased);
   ```

4. **Lee con context.read(), mira con context.select()**
   ```dart
   // ✅ context.read() para botones
   // ✅ context.select() para mostrar
   ```

5. **Devuelve props en Equatable**
   ```dart
   // ✅ @override List<Object> get props => [counter];
   ```

---

## Los 3 Constructores que necesitas

### 1. Estado
```dart
class MyState extends Equatable {
  final int valor;
  const MyState({this.valor = 0});
  
  MyState copyWith({int? valor}) => MyState(
    valor: valor ?? this.valor,
  );
  
  @override
  List<Object> get props => [valor];
}
```

### 2. Cubit
```dart
class MyCubit extends Cubit<MyState> {
  MyCubit() : super(const MyState());
  
  void increment() {
    emit(state.copyWith(valor: state.valor + 1));
  }
}
```

### 3. BLoC
```dart
class MyBloc extends Bloc<MyEvent, MyState> {
  MyBloc() : super(const MyState()) {
    on<Increment>(_onIncrement);
  }
  
  void _onIncrement(Increment e, Emitter emit) {
    emit(state.copyWith(valor: state.valor + 1));
  }
}
```

---

## Preguntas de Prueba

Si respondes TODAS estas, lo entiendes:

1. ¿Qué va en counter_event.dart?
   > **R:** Clases que representan acciones (CounterIncreased, CounterReset)

2. ¿Cuál es la diferencia entre read() y select()?
   > **R:** read() accede ahora mismo, select() reconstruye si cambia

3. ¿Por qué usamos copyWith()?
   > **R:** Para crear un estado NUEVO (los estados son inmutables)

4. ¿Qué hace Equatable?
   > **R:** Permite comparar objetos por sus propiedades

5. ¿Cuándo se emite un estado nuevo?
   > **R:** Después de procesar un evento en el manejador _on...()

6. ¿Para qué sirve BlocProvider?
   > **R:** Para hacer el BLoC disponible a todos los widgets hijos

7. ¿Cuándo usar Cubit en lugar de BLoC?
   > **R:** Cuando la lógica es simple y no necesitas eventos

---

## Recursos en tu Proyecto

| Archivo | Qué aprender |
|---------|-------------|
| `main.dart` | Punto de entrada |
| `counter_bloc.dart` | Cómo funciona BLoC |
| `counter_cubit.dart` | Versión simple |
| `bloc_counter_screen.dart` | Cómo usarlos |
| **README_GUIAS.md** | Guía de aprendizaje |
| **GUIA_PRACTICA_BLOC.md** | Ejemplos detallados |

---

**Ahora sí, estás listo para leer el código comentado** 🚀

Lee primero [GUIA_COMPLETA.md](GUIA_COMPLETA.md) para contexto  
Luego abre [counter_bloc.dart](lib/presentation/blocs/counter_bloc/counter_bloc.dart) con los comentarios

