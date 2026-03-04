import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forms_app/presentation/blocs/counter_cubit/counter_cubit.dart';

/// PANTALLA CON CUBIT - Ejemplo de como usar Cubit (version simplificada de BLoC)
/// 
/// Diferencias con BLoC:
/// 1. NO HAY EVENTOS - Llamamos metodos directamente
/// 2. MAS SIMPLE - Menos codigo, menos estructura
/// 3. IDEAL para logica simple
class CubitCounterScreen extends StatelessWidget {
  const CubitCounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. CREAR EL CUBIT
    // 
    // Exactamente igual que BLoC con BlocProvider
    // BlocProvider funciona para BLoC y Cubit indistintamente
    return BlocProvider(
        create: (_) => CounterCubit(),  // Crea instancia del Cubit
        child: const _CubitCounterView()
    );
  }
}

/// Vista del contador con Cubit
class _CubitCounterView extends StatelessWidget {
  const _CubitCounterView();

  /// Metodo auxiliar: Aumentar contador
  /// 
  /// Con Cubit es incluso mas simple que con BLoC:
  /// - NO USAMOS events
  /// - Llamamos el metodo DIRECTAMENTE
  /// 
  /// COMPARACION:
  /// BLoC:  context.read<CounterBloc>().add(CounterIncreased(3))
  /// Cubit: context.read<CounterCubit>().increaseBy(3)
  /// 
  /// Cubit es mas directo y simple
  void increaseCounterBy( BuildContext context, [ int value = 1 ]) {
    // Llamada directa al metodo - SIN EVENTOS!
    context.read<CounterCubit>().increaseBy(value);
  }

  @override
  Widget build(BuildContext context) {

    // FORMA 1 (comentada): Usar watch() para escuchar TODO el estado
    // final counterState = context.watch<CounterCubit>().state;
    // 
    // Esto reconstruye el widget CADA VEZ que el estado cambia.
    // Util si necesitas acceder a multiples propiedades.

    return Scaffold(
        appBar: AppBar(
          // FORMA 2: Usar select() para escuchar SOLO la propiedad que necesitas
          title: context.select(( CounterCubit value) {
            return Text('Cubit Counter: ${ value.state.transactionCount }');
          }),
          
          actions: [
            // Reset button
            IconButton(
                onPressed: () {
                  context.read<CounterCubit>().reset();
                }, 
              icon: const Icon(Icons.refresh_outlined))
          ],
        ),
        
        body: Center(
          // FORMA 3: Usar BlocBuilder para escuchar cambios y reconstruir
          // 
          // BlocBuilder es util cuando necesitas:
          // - Logica compleja basada en el estado
          // - Mostrar diferentes widgets segun el estado
          // - Usar buildWhen para filtrar reconstrucciones
          child: BlocBuilder<CounterCubit, CounterState>(
            // buildWhen: (previous, current) => current.counter != previous.counter,
            // 
            // buildWhen es OPCIONAL
            // Se usa para NO reconstruir si ciertos valores no cambian
            // EJEMPLO: Solo reconstruir si counter cambio, no si transactionCount cambio
            
            builder: (context, state) {
              // Este builder se ejecuta CADA VEZ que el estado cambia
              print('Estado cambio');
              return Text('Counter value: ${ state.counter }');
            },
          ),
        ),
        
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // BOTON: +3
            FloatingActionButton(
                heroTag: '1', 
                child: const Text('+3'), 
                onPressed: () => increaseCounterBy(context, 3) 
            ),
            const SizedBox(
              height: 15,
            ),
            // BOTON: +2
            FloatingActionButton(
                heroTag: '2', 
                child: const Text('+2'), 
                onPressed: () => increaseCounterBy(context, 2) 
            ),
            const SizedBox(
              height: 15,
            ),
            // BOTON: +1
            FloatingActionButton(
                heroTag: '3', 
                child: const Text('+1'), 
                onPressed: () => increaseCounterBy(context) 
            ),
          ],
        )
    );
  }
}
