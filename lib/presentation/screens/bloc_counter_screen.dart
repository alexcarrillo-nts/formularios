import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forms_app/presentation/blocs/counter_bloc/counter_bloc.dart';

/// PANTALLA CON BLOC - Ejemplo de como usar BLoC
/// 
/// Esta pantalla demuestra:
/// 1. COMO crear el BLoC con BlocProvider
/// 2. COMO leer el BLoC desde la UI
/// 3. COMO agregar eventos
/// 4. COMO escuchar cambios de estado
class BlocCounterScreen extends StatelessWidget {
  const BlocCounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. CREAR EL BLOC
    // 
    // BlocProvider: Hace el BLoC disponible para todos los widgets hijos
    // create: Funcion que crea la instancia del BLoC
    // 
    // ANALOGIA: Es como proporcionar una computadora a todos en la casa.
    // Una vez proporcionada, cualquiera puede usarla.
    return BlocProvider(
      create: (_) => CounterBloc(),  // Crea una nueva instancia de CounterBloc
      child: const BlocCounterView()  // Los widgets hijos pueden usar el BLoC
    );
  }
}

/// Vista del contador con BLoC
class BlocCounterView extends StatelessWidget {
  const BlocCounterView({
    super.key,
  });

  /// Metodo auxiliar: Aumentar contador
  /// 
  /// Este metodo encapsula la logica de como comunicarse con el BLoC
  /// Hay DOS formas de hacerlo:
  /// 
  /// FORMAS DE COMUNICAR:
  /// 
  /// OPCION 1: Agregar evento directamente (mas formal)
  /// context.read<CounterBloc>().add(CounterIncreased(value));
  /// 
  /// OPCION 2: Usar metodo auxiliar (mas simple)
  /// context.read<CounterBloc>().increaseBy(value);
  /// 
  /// En este codigo usamos la OPCION 2 (por eso esta simplificado)
  void increaseCounterBy( BuildContext context, [ int value = 1 ]) {
    // // Forma 1 - Directa (opcional)
    // context.read<CounterBloc>()
    //   .add( CounterIncreased(value) );
    
    // Forma 2 - Usando metodo (mas legible)
    context.read<CounterBloc>()
      .increaseBy(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // BARRA SUPERIOR
      appBar: AppBar(
        // context.select() = Escuchar SOLO ciertos valores
        // 
        // EN LUGAR DE:
        // BlocBuilder { builder: (context, state) => ... } // Reconstruye cuando ANY cosa cambia
        // 
        // USAMOS:
        // context.select { (bloc) => valor_especifico } // Reconstruye SOLO si ese valor cambia
        // 
        // VENTAJA: Mas eficiente porque solo se reconstruye cuando realmente es necesario
        title: context.select(
          (CounterBloc bloc) => Text('Bloc Counter ${ bloc.state.transactionCount }')
        ),
        
        // Boton para resetear
        actions: [
          IconButton(
            // context.read() = Leer sin escuchar cambios
            // 
            // Se usa cuando necesitas acceder al BLoC AHORA MISMO,
            // pero NO quieres reconstruir el widget cuando cambie.
            // 
            // EJEMPLO: Click de boton => no necesitas escuchar cambios while
            onPressed: () => context.read<CounterBloc>().resetCounter(), 
            icon: const Icon( Icons.refresh_outlined )
          )
        ],
      ),
      
      // CUERPO PRINCIPAL
      body: Center(
        // Mostrar el contador actual
        // context.select() = Seleccionar un valor especifico
        child: context.select(
          ( CounterBloc counterBloc) => Text('Counter value: ${ counterBloc.state.counter }')
        ),
      ),
      
      // BOTONES FLOTANTES
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // BOTON: +3
          FloatingActionButton(
            heroTag: '1',  // ID unico para evitar conflictos
            child: const Text('+3'),
            onPressed: () => increaseCounterBy(context, 3)  // Sumar 3
          ),
          const SizedBox(height: 15,),

          // BOTON: +2
          FloatingActionButton(
            heroTag: '2',
            child: const Text('+2'),
            onPressed: () => increaseCounterBy(context, 2)  // Sumar 2
          ),
          const SizedBox(height: 15,),

          // BOTON: +1
          FloatingActionButton(
            heroTag: '3',
            child: const Text('+1'),
            onPressed: () => increaseCounterBy(context)  // Sumar 1 (valor por defecto)
          ),

        ],
      )
    );
  }
}