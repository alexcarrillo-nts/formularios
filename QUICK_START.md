# ⚡ Quick Start - 5 Minutos


------------------------------------------------------------------------------------------------------------------------------------


## Lo más importante en menos de 100 palabras

Esta app tiene 3 conceptos claves:

### 🎯 BLoC = Sistema que organiza tu código
Usuario presiona botón → Se manda un EVENTO 
→ BLoC lo procesa → Emite ESTADO nuevo 
→ UI escucha y se redibuja

### ⚡ Cubit = Versión simplificada de BLoC
Usuario presiona botón → Se llama un método 
→ Cubit emite ESTADO nuevo → UI se redibuja

### 📱 La aplicación muestra ambos en 2 pantallas
- Pantalla Cubit: Contador simple
- Pantalla BLoC: Contador con eventos


------------------------------------------------------------------------------------------------------------------------------------


## Los 3 Archivos que DEBES entender

### 1. counter_bloc.dart
┌─ Recibe eventos (CounterIncreased, CounterReset)
├─ Procesa qué hacer con cada uno
└─ Emite nuevo estado

### 2. counter_state.dart
┌─ Almacena datos (counter, transactionCount)
├─ copyWith() = crear copia con cambios
└─ props = lista de propiedades importantes

### 3. bloc_counter_screen.dart
┌─ Crea el BLoC con BlocProvider
├─ Usa context.read() para acciones (botones)
└─ Usa context.select() para mostrar datos


------------------------------------------------------------------------------------------------------------------------------------


## Las 3 Formas de Acceder a tu BLoC

| Forma | Cuándo | Ejemplo |
|-------|--------|---------|
| **read()** | Acción AHORA | `onPressed: () => context.read<Bloc>().method()` |
| **select()** | Mostrar DATO | `Text(context.select(...))` |
| **BlocBuilder** | Lógica COMPLEJA | `BlocBuilder(...) { builder() }` |


------------------------------------------------------------------------------------------------------------------------------------


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


------------------------------------------------------------------------------------------------------------------------------------


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


------------------------------------------------------------------------------------------------------------------------------------