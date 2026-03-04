# 🎨 Resumen Visual y Diagramas

## Diagrama: Flujo de la Aplicación Completa

```
┌─────────────────────────────────────────────────────────────────┐
│                    FLUTTER FORMULARIOS APP                      │
└─────────────────────────────────────────────────────────────────┘

                            main.dart
                                │
                    ┌───────────┴───────────┐
                    │                       │
              AppRouter              AppTheme
                    │                       │
        ┌───────────┴─────────────────────┬┘
        │                                 │
        ▼                                 ▼
  ┌─────────────┐            ┌──────────────────┐
  │ HomeScreen  │            │  MaterialApp.    │
  │             │            │  router          │
  └──────┬──────┘            └──────────────────┘
        /│\
       / │ \
      /  │  \              RUTA: '/'
     /   │   \             ↓
    /    │    \       ┌──────────────┐
   /     │     \      │ HomeScreen   │
  /      │      \     │ (Menú)       │
 /       │       \    └──────────────┘
/        │        \       /      |      \
▼        ▼        ▼      /       |       \
│        │        │     /        |        \
├─┤      ├─┤      ├─┤  /         |         \
│ │      │ │      │ │ /          |          \
│ │      │ │      │ │/           |           \
│ │      │ │      │ │        /cubits     /counter-bloc    /new-user
│ │      │ │      │ │             │            │              │
│ │      │ │      │ │             ▼            ▼              ▼
│ │      │ │      │ │      ┌────────────┐ ┌──────────┐  ┌─────────┐
│ │      │ │      │ │      │ Cubit      │ │  BLoC    │  │Register │
│ │      │ │      │ │      │ Counter    │ │ Counter  │  │ Screen  │
│ │      │ │      │ │      │            │ │          │  │         │
│ │      │ │      │ │      │ State: 5   │ │State:10  │  │Formulario
│ │      │ │      │ │      │            │ │          │  │Validaciones
│ │      │ │      │ │      └────────────┘ └──────────┘  │
│ │      │ │      │ │             │            │         │
│ │      │ │      │ │             ▼            ▼         │
│ │      │ │      │ │      ┌──────────┐  ┌──────────┐   │
│ │      │ │      │ │      │ +1, +2   │  │ +1, +2   │   │
│ │      │ │      │ │      │ +3, Reset│  │ +3, Reset│   │
│ │      │ │      │ │      │  Botones │  │ Botones  │   │
│ │      │ │      │ │      └──────────┘  └──────────┘   │
│ │      │ │      │ │                                     │
│ │      │ │      │ │      ┌──────────┐  ┌──────────┐   │
│ │      │ │      │ │      │Métodos   │  │ Eventos  │   │
│ │      │ │      │ │      │increaseBy│  │CountInc. │   │
│ │      │ │      │ │      │reset()   │  │Reset     │   │
│ │      │ │      │ │      └──────────┘  └──────────┘   │
│ │      │ │      │ │
│ │      │ │      │ │      ┌──────────┐  ┌──────────┐   │
│ │      │ │      │ │      │Emit      │  │Emit      │   │
│ │      │ │      │ │      │Nuevo     │  │Nuevo     │   │
│ │      │ │      │ │      │Estado    │  │Estado    │   │
│ │      │ │      │ │      └──────────┘  └──────────┘   │
│ │      │ │      │ │
│ │      │ │      │ │      ┌──────────┐  ┌──────────┐   │
│ │      │ │      │ │      │BlocBuilder   BlocBuilder   │
│ │      │ │      │ │      │Escucha cambios            │
│ │      │ │      │ │      └──────────┘  └──────────┘   │
│ │      │ │      │ │
│ │      │ │      │ │      ┌──────────┐  ┌──────────┐   │
│ │      │ │      │ │      │UI ACTUALIZA │            │
│ │      │ │      │ │      │Muestra:17   │            │
│ │      │ │      │ │      │Muestra:5 tx │            │
│ │      │ │      │ │      └──────────┘  └──────────┘   │
└────────────────────────────────────────────────────────┘
```

---

## Tabla: Los Métodos que Importan

### context.read() - AHORA MISMO

```
┌────────────────────────────────────┐
│ context.read<MiBloc>()             │
│                                    │
│ ✅ Accede al BLoC en este momento │
│ ❌ NO escucha cambios futuros      │
│                                    │
│ USO: Botones, eventos              │
│                                    │
│ floatingActionButton:              │
│   onPressed: () =>                 │
│     context.read<CounterBloc>()    │
│       .increaseBy(3)               │
│                                    │
│ ✨ RÁPIDO Y EFICIENTE              │
└────────────────────────────────────┘
```

### context.select() - VALOR ESPECÍFICO

```
┌────────────────────────────────────┐
│ context.select((bloc) => valor)    │
│                                    │
│ ✅ Accede a un valor específico    │
│ ✅ Escucha SOLO ese valor          │
│ ✅ Se reconstruye si cambia        │
│ ❌ Más código que read()            │
│                                    │
│ USO: Mostrar datos en la UI        │
│                                    │
│ title: context.select(             │
│   (CounterBloc b) =>               │
│     Text('${b.state.counter}')     │
│ )                                  │
│                                    │
│ ✨ EFICIENTE                       │
└────────────────────────────────────┘
```

### BlocBuilder - VERSÁTIL

```
┌────────────────────────────────────┐
│ BlocBuilder<Bloc, State>(())       │
│                                    │
│ ✅ Control completo                │
│ ✅ Acceso a todo el estado         │
│ ✅ buildWhen para filtrar          │
│ ❌ Más código                       │
│                                    │
│ USO: Lógica compleja               │
│                                    │
│ BlocBuilder<CounterBloc,           │
│   CounterState>(                   │
│   buildWhen: (p, c) =>             │
│     c.counter != p.counter,        │
│   builder: (ctx, state) =>         │
│     Text('${state.counter}'),      │
│ )                                  │
│                                    │
│ ✨ FLEXIBLE                        │
└────────────────────────────────────┘
```

---

## Comparación: Cubit vs BLoC (Lado a Lado)

### Estructura

```
CUBIT:                      BLoC:

┌─────────────────┐         ┌──────────────────┐
│ State           │         │ Event            │
│                 │         │                  │
│ - data          │         │ - Acción 1       │
│ - copyWith()    │         │ - Acción 2       │
└─────────────────┘         │ - Acción 3       │
        ▲                   └──────────────────┘
        │                           │
        │                           ▼
        │                   ┌──────────────────┐
        │                   │ BLoC             │
        │                   │                  │
        │                   │ on<Evento1>()    │
        │                   │ on<Evento2>()    │
        │                   │ on<Evento3>()    │
        │                   │                  │
        │                   │ _on...() handlers│
        │                   └──────────────────┘
        │                           │
        │                           ▼
        │                   emit(State)
        │                           │
        │                           ▼
        └─ emit(State) ◄────────────┘
```

### Uso en la UI

```
CUBIT:                              BLoC:

context.read<                       context.read<
  CounterCubit                        CounterBloc
>().increaseBy(3)                   >().increaseBy(3)
                                    
O DIRECTAMENTE:                     O CON EVENTO:
                                    
context.read<                       context.read<
  CounterCubit                        CounterBloc
>().add(                            >().add(
  CounterIncreased(3)                 CounterIncreased(3)
)                                   )
```

### Líneas de Código

```
CUBIT (Más corto):

class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(const CounterState());
  
  void increaseBy(int val) {
    emit(state.copyWith(counter: state.counter + val));
  }
}
← 7 líneas


BLoC (Más completo):

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterState()) {
    on<CounterIncremented>(_onIncremented);
  }
  
  void _onIncremented(CounterIncremented e, Emitter emit) {
    emit(state.copyWith(counter: state.counter + e.value));
  }
}
← 10 líneas
```

---

## Estado - Árboles de Propiedades

### Cómo funciona copyWith()

```
ESTADO ORIGINAL:
┌──────────────────────────┐
│ CounterState             │
│  ├─ counter: 5           │
│  └─ transactionCount: 0  │
└──────────────────────────┘

.copyWith(counter: 10)

┌──────────────────────────┐
│ CounterState NUEVO       │
│  ├─ counter: 10 ← CAMBIÓ │
│  └─ transactionCount: 0  │ (igual)
└──────────────────────────┘

.copyWith(transactionCount: 1)

┌──────────────────────────┐
│ CounterState NUEVO       │
│  ├─ counter: 10          │ (igual)
│  └─ transactionCount: 1 ← │ CAMBIÓ
└──────────────────────────┘

.copyWith(counter: 11, transactionCount: 2)

┌──────────────────────────┐
│ CounterState NUEVO       │
│  ├─ counter: 11 ← CAMBIÓ │
│  └─ transactionCount: 2 ← │ CAMBIÓ
└──────────────────────────┘
```

---

## El Ciclo de un Usuario Action

```
1️⃣ USUARIO PRESIONA EL BOTÓN "+3"
   └─ onPressed() se ejecuta

2️⃣ SE LLAMA A increaseCounterBy(context, 3)
   └─ Método en la pantalla

3️⃣ DENTRO DEL MÉTODO:
   context.read<CounterBloc>()
   .increaseBy(3)

4️⃣ EL BLOC RECIBE:
   void increaseBy([int value = 1]) {
     add( CounterIncreased(value) );
   }
   └─ Agrega el evento a la cola

5️⃣ EL EVENTO ENTRA A LA COLA:
   [CounterIncreased(3)] ← En espera

6️⃣ EL BLOC LO PROCESA:
   Llama a _onCounterIncreased(evento, emit)
   └─ La lógica se ejecuta aquí

7️⃣ DENTRO DEL MANEJADOR:
   - Estado anterior: counter = 10, tx = 0
   - Evento contiene: value = 3
   - Nueva lógica: 10 + 3 = 13, tx = 1

8️⃣ EMITE NUEVO ESTADO:
   emit(state.copyWith(
     counter: 13,
     transactionCount: 1
   ))

9️⃣ LOS LISTENERS ESCUCHAN:
   - context.select(...) detecta cambio
   - BlocBuilder detecta cambio
   - context.watch(...) detecta cambio

🔟 LA UI SE RECONSTRUYE:
   Text('Counter value: 13')
   Text('Bloc Counter 1')

¡LISTO! ✅
```

---

## Comandos de Validación en Formularios

```
┌──────────────────────────────────────┐
│ VALIDACIONES EN REGISTER_SCREEN       │
└──────────────────────────────────────┘

USERNAME:
  ├─ ❌ Vacío
  ├─ ❌ Solo espacios
  └─ ❌ Menos de 6 caracteres

EMAIL:
  ├─ ❌ Vacío
  ├─ ❌ Solo espacios
  └─ ❌ Formato inválido (REGEX)
      ✅ ejemplo@dominio.com

PASSWORD:
  ├─ ❌ Vacío
  ├─ ❌ Solo espacios
  └─ ❌ Menos de 6 caracteres

FLUJO DE VALIDACIÓN:
  Usuario escribe ← onChanged()
       ↓
  Presiona botón ← onClick()
       ↓
  validator() se ejecuta
       ↓
  ¿Hay errores?
  ├─ SÍ ← Rojo, mensaje de error
  └─ NO ← Verde, procesamiento
```

---

## Mapa Mental: Dónde va Cada Cosa

```
                    ┌─────────────────────┐
                    │       USUARIO       │
                    └──────────────┬──────┘
                                   │ Click
                                   ▼
                        ┌──────────────────┐
                        │   PANTALLA (UI)  │
                        │ - Widgets        │
                        │ - Listen state   │
                        └────────┬─────────┘
                                 │ add/method
                                 ▼
                    ┌────────────────────────┐
                    │   CUBIT / BLOC        │
                    │ - Procesa acción      │
                    │ - Emite estado        │
                    └─────────┬──────────────┘
                              │ emit()
                              ▼
                    ┌────────────────────────┐
                    │   STATE               │
                    │ - Contiene datos      │
                    │ - Inmutable           │
                    │ - copyWith()          │
                    └─────────┬──────────────┘
                              │
                              ▼ (UI escucha)
                    ┌──────────────────┐
                    │  RECONSTRUCCIÓN  │
                    │  DEL WIDGET      │
                    └──────────────────┘
                              │
                              ▼
                       ┌────────────┐
                       │ Pantalla   │
                       │ actualizada│
                       └────────────┘

═══════════════════════════════════════════════

¿DÓNDE PONER CADA COSA?

❌ NUNCA aquí (UI):
  - Lógica compleja
  - Estados
  - Reglas de negocio

✅ SIEMPRE aquí (BLoC/Cubit):
  - Lógica
  - Procesamiento
  - Transformación de datos

✅ AQUÍ (State):
  - Datos
  - Información del negocio
  - copyWith

✅ AQUÍ (UI):
  - Mostrar datos
  - Reaccionar a cambios
  - Capturar input
```

---

## Checklist de Diagnóstico: ¿Mi BLoC está bien?

```
ESTRUCTURA:
☐ ¿Tengo 3 archivos? (event, state, bloc)
☐ ¿Usan part of 'archivo.dart'?
☐ ¿La clase extend Bloc<Event, State>?

STATE:
☐ ¿Extends Equatable?
☐ ¿Tiene copyWith()?
☐ ¿Sobrescribe props?
☐ ¿Nunca se modifica directamente?

EVENTOS:
☐ ¿Todos extienden una clase abstracta?
☐ ¿Cada evento tiene los datos que necesita?

BLOC:
☐ ¿Instancia todos los eventos en constructor con on<>?
☐ ¿Cada evento tiene un manejador?
☐ ¿Los manejadores usan emit()?
☐ ¿Los manejadores son privados (_on...)?

EN LA UI:
☐ ¿Está envuelto en BlocProvider?
☐ ¿Uso read() para acciones?
☐ ¿Uso select() o BlocBuilder para leer datos?
☐ ¿Paso context a los métodos correctamente?
```

---

## Errores Fatales (NUNCA HACER ESTO)

```
❌ NO HACER ESTO:

1. Modificar state directamente
   state.counter = 5;  ← ¡ERROR!
   
   ✅ HACER ESTO:
   emit(state.copyWith(counter: 5));

2. Olvidar BlocProvider
   BlocCounterView()  ← ¡ERROR! No hay BLoC
   
   ✅ HACER ESTO:
   BlocProvider(
     create: (_) => CounterBloc(),
     child: BlocCounterView(),
   )

3. Usar read() para datos que cambian
   Text(context.read<CounterBloc>().state.counter)  ← ¡NUNCA se actualiza!
   
   ✅ HACER ESTO:
   context.select(
     (CounterBloc b) => Text('${b.state.counter}')
   )

4. Olvidar las props en Equatable
   class MyState extends Equatable {}  ← ¡FALTA override!
   
   ✅ HACER ESTO:
   class MyState extends Equatable {
     @override
     List<Object> get props => [...];
   }

5. No extender Equatable
   class MyState { }  ← ¡Equatable falta!
   
   ✅ HACER ESTO:
   class MyState extends Equatable { }
```

---

*Imprime este documento como referencia rápida durante el desarrollo* 📖

