# 📋 Documentación Completa del Proyecto

## Archivo: main.dart

```dart
import 'package:flutter/material.dart';
import 'package:forms_app/config/router/app_router.dart';
import 'package:forms_app/config/theme/app_theme.dart';

void main() {
  // main() es el punto de entrada de toda la aplicación
  // Se ejecuta primero y una sola vez
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp.router = Versión de MaterialApp que usa GoRouter para navegación
    // (En lugar del Navigator clásico que usaba routes: {} en un MaterialApp normal)
    return MaterialApp.router(
      routerConfig: appRouter,        // Configura las rutas disponibles
      debugShowCheckedModeBanner: false,  // Quita el banner de DEBUG
      theme: AppTheme().getTheme(),   // Aplica el tema personalizado
    );
  }
}
```

**Conceptos clave:**
- `main()` = Punto de entrada
- `runApp()` = Ejecuta la aplicación
- `MaterialApp.router` = Versión moderna de MaterialApp
- `routerConfig` = Define qué pantallas existen y cómo navegar

---

## Archivo: config/router/app_router.dart

```dart
import 'package:go_router/go_router.dart';
import 'package:forms_app/presentation/screens/screens.dart';

// GoRouter = Librería moderna para navegación en Flutter
// Define todas las RUTAS de la aplicación
// 
// VENTAJAS sobre el Navigator clásico:
// 1. URLs como web (ejemplo: /user/123)
// 2. Más fácil de mantener
// 3. Funciona mejor con web y deep linking
// 4. Historial automático

final appRouter = GoRouter(
  routes: [
    // RUTA 1: Pantalla principal (índice)
    GoRoute(
      path: '/',                              // URL: localhost:3000/ o app://
      builder: (context, state) => const HomeScreen(),  // Widget a mostrar
    ),

    // RUTA 2: Pantalla de Cubit
    GoRoute(
      path: '/cubits',                        // URL: localhost:3000/cubits
      builder: (context, state) => const CubitCounterScreen(),
    ),

    // RUTA 3: Pantalla de BLoC
    GoRoute(
      path: '/counter-bloc',                  // URL: localhost:3000/counter-bloc
      builder: (context, state) => const BlocCounterScreen(),
    ),

    // RUTA 4: Formulario de registro
    GoRoute(
      path: '/new-user',                      // URL: localhost:3000/new-user
      builder: (context, state) => const RegisterScreen(),
    ),
  ]
);

// CÓMO NAVEGAR a estas rutas:
// context.push('/cubits');        // Navega a Cubit Counter
// context.push('/counter-bloc');  // Navega a BLoC Counter
// context.push('/new-user');      // Navega a Formulario
```

**Conceptos clave:**
- `GoRoute` = Una ruta disponible
- `path` = La URL de esa ruta
- `builder` = El widget que se muestra
- `context.push()` = Navega a una ruta

---

## Archivo: config/theme/app_theme.dart

```dart
// Este archivo define la apariencia visual de toda la app
// El tema es consistente en todas las pantallas

class AppTheme {
  // Método que retorna el tema de Material Design
  ThemeData getTheme() {
    return ThemeData(
      useMaterial3: true,  // Usa Material Design 3 (más moderno)
      
      // Define el color primario usado en botones, AppBars, etc.
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF0066CC),  // Azul
      ),
    );
  }
}
```

**Para personalizar:**
- Cambiar `seedColor` para otros colores
- Agregar `textTheme` para fuentes
- Agregar `inputDecorationTheme` para formularios

---

## Flujo Completo de la Aplicación

```
┌─────────────────────────────────────────────────┐
│ 1. main() - Se ejecuta                          │
└─────────────┬───────────────────────────────────┘
              │
              ▼
┌──────────────────────────────────────────────────┐
│ 2. runApp(MainApp())                             │
└─────────────┬────────────────────────────────────┘
              │
              ▼
┌──────────────────────────────────────────────────┐
│ 3. MaterialApp.router                            │
│    - Carga appRouter                             │
│    - Carga AppTheme                              │
└─────────────┬────────────────────────────────────┘
              │
              ▼
┌──────────────────────────────────────────────────┐
│ 4. Navega a '/' (ruta inicial)                   │
└─────────────┬────────────────────────────────────┘
              │
              ▼
┌──────────────────────────────────────────────────┐
│ 5. Muestra HomeScreen                            │
│    (Menú principal con opciones)                 │
└──────────────────────────────────────────────────┘

OPCIONES EN HomeScreen:
  │
  ├─> Click "Cubits" ─> context.push('/cubits')
  │                     ↓
  │                   CubitCounterScreen
  │                     ↓
  │                   Mostrar contador con Cubit
  │
  ├─> Click "BLoC" ─> context.push('/counter-bloc')
  │                    ↓
  │                  BlocCounterScreen
  │                    ↓
  │                  Mostrar contador con BLoC
  │
  └─> Click "Nuevo Usuario" ─> context.push('/new-user')
                                ↓
                              RegisterScreen
                                ↓
                              Formulario de registro
```

---

## Análisis de RegisterScreen (Formulario)

### Estructura
```dart
RegisterScreen
  └── _RegisterView
      └── _RegisterForm (StatefulWidget)
          └── _RegisterFormState
              └── Form
                  ├── CustomTextFormField (Username)
                  ├── CustomTextFormField (Email)
                  ├── CustomTextFormField (Password)
                  └── FilledButton (Crear usuario)
```

### Validaciones Implementadas

#### 1. Username
```dart
validator: (value) {
  if ( value == null || value.isEmpty ) return 'Campo requerido';
  if ( value.trim().isEmpty ) return 'Campo requerido';
  if ( value.length < 6 ) return 'Mas de 6 letras';
  return null;  // Sin errores
}
```
**Reglas:**
- No vacío
- Mínimo 6 caracteres
- Sin espacios al inicio/final

#### 2. Email
```dart
validator: (value) {
  if ( value == null || value.isEmpty ) return 'Campo requerido';
  if ( value.trim().isEmpty ) return 'Campo requerido';
  final emailRegExp = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );
  if ( !emailRegExp.hasMatch(value) ) return 'No tiene formato de correo';
  return null;
}
```
**Reglas:**
- No vacío
- Debe ser formato email válido (ejemplo@ejemplo.com)
- Validación con Regex

#### 3. Password (igual a username)
```dart
validator: (value) {
  if ( value == null || value.isEmpty ) return 'Campo requerido';
  if ( value.trim().isEmpty ) return 'Campo requerido';
  if ( value.length < 6 ) return 'Mas de 6 letras';
  return null;
}
```

### ¿Cómo funciona el formulario?

```
Usuario escribe en campos
           ↓
Presiona "Crear usuario"
           ↓
_formKey.currentState!.validate()  // Ejecuta todos los validators
           ↓
       SI hay errores:              SI todo OK:
           ↓                          ↓
     Muestra error              Imprime datos
     en cada campo              print('$username, $email, $password')
           ↓                          ↓
       Usuario corrige          Aquí iría: Enviar a API,
                                Guardar en BD, etc.
```

### Código del formulario explicado

```dart
class _RegisterFormState extends State<_RegisterForm> {
  
  // GlobalKey para acceder al estado del formulario
  // Permite validar desde fuera del Form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  // Variables para almacenar los valores ingresados
  String username = '';
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,  // Identifica este formulario
      child: Column(
        children: [
          // Campo 1: Username
          CustomTextFormField(
            label: 'Nombre de usuario',
            onChanged: (value) => username = value,  // Guardar valor mientras escribe
            validator: (value) { ... },             // Validar cuando se envía
          ),
          
          // Campo 2: Email
          CustomTextFormField(
            label: 'Correo electronico',
            onChanged: (value) => email = value,
            validator: (value) { ... },
          ),
          
          // Campo 3: Contraseña
          CustomTextFormField(
            label: 'Contrasena',
            obscureText: true,  // Oculta el texto (** para contraseña)
            onChanged: (value) => password = value,
            validator: (value) { ... },
          ),
          
          // Botón para enviar
          FilledButton.tonalIcon(
            onPressed: () {
              // 1. Validar
              final isValid = _formKey.currentState!.validate();
              if ( !isValid ) return;  // Si hay errores, no continúa
              
              // 2. Si llegó aquí, los datos son válidos
              print('$username, $email, $password');
              // Aquí irían acciones como:
              // - Enviar a API
              // - Guardar en base de datos
              // - Emitir evento en un BLoC
            },
            icon: const Icon( Icons.save),
            label: const Text('Crear usuario'),
          ),
        ],
      )
    );
  }
}
```

---

## Diferencia entre onChanged vs validator

```dart
////// onChanged ///////
CustomTextFormField(
  onChanged: (value) {
    username = value;  // Se ejecuta CADA VEZ que el usuario escribe
  }
)
// Uso: Guardar el valor en tiempo real

////// validator //////
CustomTextFormField(
  validator: (value) {
    if (value == null) return 'Requerido';
  }
)
// Uso: Validar SOLO cuando se llama a .validate()
```

---

## Estructura Completa del Código

```
flutter-formularios/
├── lib/
│   ├── main.dart ← PUNTO DE ENTRADA
│   │
│   ├── config/
│   │   ├── router/
│   │   │   └── app_router.dart ← RUTAS Y NAVEGACIÓN
│   │   └── theme/
│   │       └── app_theme.dart ← TEMA VISUAL
│   │
│   └── presentation/
│       │
│       ├── blocs/ ← GESTIÓN DE ESTADO
│       │   ├── counter_bloc/
│       │   │   ├── counter_bloc.dart (la lógica)
│       │   │   ├── counter_event.dart (acciones)
│       │   │   └── counter_state.dart (datos)
│       │   └── counter_cubit/
│       │       ├── counter_cubit.dart (lógica simple)
│       │       └── counter_state.dart (datos)
│       │
│       ├── screens/ ← PANTALLAS
│       │   ├── home_screen.dart (menú)
│       │   ├── bloc_counter_screen.dart (ejemplo BLoC)
│       │   ├── cubit_counter_screen.dart (ejemplo Cubit)
│       │   └── register_screen.dart (formulario)
│       │
│       └── widgets/ ← COMPONENTES REUTILIZABLES
│           └── custom_text_form_field.dart (input personalizado)
│
├── pubspec.yaml ← DEPENDENCIAS
└── README.md
```

---

## Dependencias y qué hacen

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  flutter_bloc: ^8.1.2
    # Para implementar el patrón BLoC/Cubit
    # Proporciona: BLoC, Cubit, BlocProvider, BlocBuilder, etc.
  
  go_router: ^6.2.0
    # Para navegación moderna
    # Proporciona: rutas, push, pop, etc.
  
  equatable: ^2.0.5
    # Para comparar objetos
    # Proporciona: comparación automática de properties
```

---

## Ciclo de Vida de un Widget

```
En esta app hay dos tipos de widgets principales:

1. STATELESS (sin estado mutable):
   - MainApp
   - HomeScreen
   - BlocCounterScreen (la parte de estructura)
   - CubitCounterScreen
   
   Ciclo: build() → render

2. STATEFUL (con estado mutable):
   - _RegisterForm
   - _RegisterFormState
   
   Ciclo: 
   createState() → initState() → build() → setState() → rebuild() → dispose()
```

### Ejemplo en RegisterForm

```dart
class _RegisterForm extends StatefulWidget {
  const _RegisterForm();

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  // ← Aquí es donde guardamos username, email, password
  
  String username = '';
  String email = '';
  String password = '';

  @override
  void initState() {
    super.initState();
    // Se ejecuta una sola vez cuando se crea
    // Ideal para inicializar listeners, cargar datos, etc.
  }

  @override
  Widget build(BuildContext context) {
    // Se ejecuta cada vez que setState() es llamado
    return Form(...);
  }

  @override
  void dispose() {
    // Se ejecuta cuando el widget se destruye
    // Ideal para limpiar (cerrar controllers, etc.)
    super.dispose();
  }
}
```

---

## Cómo Extender la Aplicación

### 1. Agregar una Pantalla Nueva

```dart
// Step 1: Crear archivo lib/presentation/screens/user_screen.dart
class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: const Center(child: Text('User List')),
    );
  }
}

// Step 2: Agregar a lib/config/router/app_router.dart
GoRoute(
  path: '/users',
  builder: (context, state) => const UserScreen(),
),

// Step 3: Navegar desde otra pantalla
context.push('/users');
```

### 2. Agregar un BLoC Nuevo

```dart
// Step 1: Crear estructura
// lib/presentation/blocs/user_bloc/
//   ├── user_bloc.dart
//   ├── user_event.dart
//   └── user_state.dart

// Step 2: Definir Event, State, BLoC
part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(const UserState()) {
    on<FetchUser>(_onFetchUser);
  }

  void _onFetchUser(FetchUser event, Emitter<UserState> emit) {
    // Lógica
  }
}

// Step 3: Usar en pantalla
BlocProvider(
  create: (_) => UserBloc(),
  child: UserScreen(),
)
```

### 3. Agregar un Validador Custom

```dart
// En custom_text_form_field.dart
class CustomTextFormField extends StatelessWidget {
  final String label;
  final String? Function(String?)? validator;
  final bool obscureText;
  final void Function(String)? onChanged;

  const CustomTextFormField({
    required this.label,
    this.validator,
    this.obscureText = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(label: Text(label)),
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
    );
  }
}

// Uso con validador custom
CustomTextFormField(
  label: 'DNI',
  validator: (value) {
    if (value?.isEmpty ?? true) return 'Campo requerido';
    if (int.tryParse(value!) == null) return 'Solo numeros';
    if (value!.length != 8) return 'Debe tener 8 digitos';
    return null;
  },
)
```

---

## Preguntas Comunes

**P: ¿Dónde creo un archivo nuevo?**  
R: Depende de su tipo:
- Screens: `lib/presentation/screens/`
- BLoCs: `lib/presentation/blocs/nombre_bloc/`
- Widgets: `lib/presentation/widgets/`
- Config: `lib/config/`

**P: ¿Cómo agrego una pantalla nueva?**  
R: 1) Crear archivo | 2) Agregar ruta en app_router.dart | 3) Navegar con context.push()

**P: ¿Puede la app guardar datos?**  
R: Sí, usando shared_preferences o drift(base de datos local)

**P: ¿Por qué usar BLoC y no Provider?**  
R: Ambos funcionan. BLoC es más formal, Provider es más simple. Elige según tu preferencia.

