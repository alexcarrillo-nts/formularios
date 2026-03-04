import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'counter_state.dart';

/// ⚡ CUBIT - Un gestor de estado SIMPLIFICADO
/// 
/// El Cubit es como una versión "más fácil" del BLoC.
/// Diferencias principales:
/// 
/// BLoC:
/// Usuario → add(Evento) → Manejador → emit(estado) → UI actualiza
/// 
/// CUBIT:
/// Usuario → llamar método() → lógica → emit(estado) → UI actualiza
/// 
/// NO hay eventos, los métodos emiten directamente.
class CounterCubit extends Cubit<CounterState> {
  
  /// Constructor
  /// 
  /// super(...): Define el estado inicial
  /// En este caso: contador comienza en 5
  /// Si NO especificas super(), USA el comando:
  /// super(const CounterState(counter: 5))
  CounterCubit() : super( const CounterState( counter: 5 ) );

  /// Método: Aumentar el contador
  /// 
  /// DIFERENCIA con BLoC:
  /// - BLoC: add(CounterIncreased(value)) luego procesa evento
  /// - CUBIT: incrementByDirectamente aquí emite
  /// 
  /// PARÁMETRO:
  /// - value: La cantidad a sumar
  /// 
  /// EJEMPLOS DE USO:
  /// context.read<CounterCubit>().increaseBy(1);
  /// context.read<CounterCubit>().increaseBy(5);
  void increaseBy( int value ) {
    // Lógica simple: emit nuevo estado con el contador aumentado
    emit( state.copyWith(
      counter: state.counter + value,      // Sumar el valor
      transactionCount: state.transactionCount + 1,  // Contar la operación
    ));
  }

  /// Método: Resetear el contador a 0
  /// 
  /// ✅ MÁS SIMPLE que BLoC - no hay eventos, solo lógica aquí
  void reset() {
    // Lógica: volver counter a 0
    emit( state.copyWith(
      counter: 0,  // Resetear
    ));
  }

}

