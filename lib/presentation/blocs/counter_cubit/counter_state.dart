part of 'counter_cubit.dart';

/// 📊 ESTADO DEL CUBIT - Información actual almacenada
/// 
/// El estado es idéntico al del BLoC, pero el Cubit es más simple
/// porque NO usa eventos. Los métodos del Cubit emiten directamente.
class CounterState extends Equatable {

  /// El valor actual del contador
  /// VALOR POR DEFECTO: 0 (comienza en 0, a diferencia del BLoC que es 10)
  final int counter;
  
  /// Cuántas veces se ha modificado el contador
  /// Registra todas las operaciones realizadas
  final int transactionCount;

  /// Constructor del estado
  /// 
  /// PARÁMETROS:
  /// - counter: (opcional) valor inicial del contador, por defecto 0
  /// - transactionCount: (opcional) contador de operaciones, por defecto 0
  const CounterState({
    this.counter = 0, 
    this.transactionCount = 0
  });

  /// Método copyWith - Crea una copia con cambios
  /// 
  /// Igual que en el BLoC, los estados son inmutables.
  /// Siempre creas uno nuevo en lugar de modificar el anterior.
  /// 
  /// EJEMPLO:
  /// final nuevoEstado = state.copyWith(counter: 20);
  copyWith({
    int? counter,
    int? transactionCount,
  }) => CounterState(
    counter: counter ?? this.counter,
    transactionCount: transactionCount ?? this.transactionCount,
  );
  
  /// props - Propiedades para Equatable
  /// 
  /// Permite a Equatable comparar dos estados.
  /// Si [counter, transactionCount] son iguales → estados iguales
  /// Si algunos valores difieren → estados diferentes → UI se actualiza
  @override
  List<Object> get props => [ counter, transactionCount ];

}}
