part of 'counter_bloc.dart';

/// 🎯 EVENTOS DEL BLOC - Define todas las acciones posibles
/// 
/// En el patrón BLoC, los eventos son como "acciones" que el usuario quiere realizar.
/// Cada evento es una clase que representa una intención de cambio.
/// 
/// FLUJO:
/// Usuario presiona botón → Se emite un evento → BLoC lo procesa → Emite nuevo estado
abstract class CounterEvent {
  const CounterEvent();
}

/// Evento: El usuario quiere aumentar el contador
/// 
/// EJEMPLO DE USO:
/// context.read<CounterBloc>().add(CounterIncreased(5));
/// 
/// PARÁMETROS:
/// - value: La cantidad a sumar al contador
class CounterIncreased extends CounterEvent {
  final int value;
  const CounterIncreased(this.value);
}

/// Evento: El usuario quiere reiniciar el contador a 0
/// 
/// EJEMPLO DE USO:
/// context.read<CounterBloc>().add(CounterReset());
class CounterReset extends CounterEvent {}