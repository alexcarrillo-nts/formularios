import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'counter_event.dart';
part 'counter_state.dart';

/// 🏗️ BLOC PRINCIPAL - El corazón de la gestión de estado
/// 
/// El BLoC (Business Logic Component) es responsable de:
/// 1. RECIBIR eventos del usuario
/// 2. PROCESAR lógica
/// 3. EMITIR nuevos estados
/// 
/// FLUJO COMPLETO:
/// ┌───────────────────────────────────────────┐
/// │  Usuario presiona botón                   │
/// │           ↓                                │
/// │  Se llama increaseBy(3)                   │
/// │           ↓                                │
/// │  Se agrega evento: CounterIncreased(3)    │
/// │           ↓                                │
/// │  BLoC recibe el evento                    │
/// │           ↓                                │
/// │  Ejecuta _onCounterIncreased()            │
/// │           ↓                                │
/// │  emit(nuevo_estado)                       │
/// │           ↓                                │
/// │  UI se actualiza automáticamente          │
/// └───────────────────────────────────────────┘
class CounterBloc extends Bloc<CounterEvent, CounterState> {

  /// Constructor del BLoC
  /// 
  /// super(const CounterState()): Estado inicial del BLoC
  /// En este caso, el contador comienza en 10 y transactionCount en 0
  /// 
  /// on<Evento>(manejador): Registra qué función maneja cada evento
  CounterBloc() : super(const CounterState()) {
    
    // Cuando se emit un evento CounterIncreased, ejecuta _onCounterIncreased
    on<CounterIncreased>( _onCounterIncreased );
    
    // Cuando se emit un evento CounterReset, ejecuta _onCounterReset
    on<CounterReset>( _onCounterReset );

  }

  /// Manejador del evento CounterIncreased
  /// 
  /// PARÁMETROS:
  /// - event: El evento que se emitió (contiene el valor a sumar)
  /// - emit: Función para emitir nuevo estado
  /// 
  /// FLUJO:
  /// 1. event.value contiene la cantidad a sumar (ej: 3)
  /// 2. state.counter es el valor actual (ej: 10)
  /// 3. Calculamos: 10 + 3 = 13
  /// 4. Incrementamos transactionCount en 1
  /// 5. emit() avisa a la UI que hay un nuevo estado
  void _onCounterIncreased( CounterIncreased event, Emitter<CounterState> emit ) {
    // Lógica:
    // - Sumar event.value al contador actual
    // - Contar una transacción más
    emit(state.copyWith(
      counter: state.counter + event.value,  // Nuevo contador = anterior + valor
      transactionCount: state.transactionCount + 1  // Contar esta operación
    ));
  }

  /// Manejador del evento CounterReset
  /// 
  /// Este manejador reinicia el contador a 0
  /// (pero NO reinicia transactionCount, para mantener el registro de cambios)
  void _onCounterReset( CounterReset event, Emitter<CounterState> emit ) {
    // Lógica: Volver counter a 0
    emit(state.copyWith(
      counter: 0,  // Resetear el contador
      // transactionCount NO se modifica, mantiene el número de operaciones
    ));
  }

  /// Método auxiliar: Aumentar el contador
  /// 
  /// Este método es más "amigable" para llamar desde la UI.
  /// En lugar de hacer: context.read<CounterBloc>().add(CounterIncreased(3))
  /// Puedes hacer: context.read<CounterBloc>().increaseBy(3)
  /// 
  /// PARÁMETRO:
  /// - value: (opcional) cantidad a sumar, por defecto 1
  /// 
  /// EJEMPLO:
  /// increaseBy();    // Suma 1
  /// increaseBy(5);   // Suma 5
  void increaseBy([int value = 1]){
    // add() agrega el evento a la cola para que sea procesado
    add( CounterIncreased(value) );
  }

  /// Método auxiliar: Resetear el contador
  /// 
  /// Alternativa a: context.read<CounterBloc>().add(CounterReset())
  /// 
  /// EJEMPLO:
  /// resetCounter();  // Vuelve el contador a 0
  void resetCounter(){
    add( CounterReset() );
  }

}
