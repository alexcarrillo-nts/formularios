part of 'counter_bloc.dart';

/// 📊 ESTADO DEL BLOC - Almacena la información actual
/// 
/// El estado representa TODO lo que necesitas saber sobre el contador en un momento dado.
/// Cuando cambias el estado, la UI se reconstruye automáticamente.
/// 
/// IMPORTANTE: El estado es INMUTABLE - nunca lo modificas, siempre creas uno nuevo.
class CounterState extends Equatable {

  /// El valor actual del contador
  /// VALOR POR DEFECTO: 10 (comienza en 10)
  final int counter;
  
  /// Cuántas veces se ha modificado el contador
  /// Sirve para saber cuántas "transacciones" se han hecho
  final int transactionCount;

  /// Constructor del estado
  /// 
  /// PARÁMETROS:
  /// - counter: (opcional) valor del contador, por defecto 10
  /// - transactionCount: (opcional) cantidad de cambios, por defecto 0
  const CounterState({
    this.counter = 10, 
    this.transactionCount = 0
  });

  /// Método copyWith - Crea una COPIA del estado con cambios
  /// 
  /// Este es un patrón común en Dart para trabajar con objetos inmutables.
  /// 
  /// EJEMPLO:
  /// final nuevoEstado = state.copyWith(counter: 15);
  /// // Crea un nuevo estado con counter=15, pero transactionCount se mantiene igual
  /// 
  /// ¿POR QUÉ es importante?
  /// Para que Flutter sepa que hubo un cambio, el objeto debe ser DIFERENTE.
  /// No puedes modificar el objeto anterior, debes crear uno nuevo.
  CounterState copyWith({
    int? counter,
    int? transactionCount,
  }) => CounterState(
    counter: counter ?? this.counter,  // Usa el nuevo valor o mantén el actual
    transactionCount: transactionCount ?? this.transactionCount,
  );
  
  /// props - Propiedades para Equatable
  /// 
  /// Equatable usa esto para comparar dos objetos.
  /// Si los valores en props son iguales → los objetos son iguales
  /// Si algún valor es diferente → los objetos son diferentes
  /// 
  /// ESTO PERMITE QUE:
  /// BlocListener sepa cuándo el estado realmente cambió
  @override
  List<Object> get props => [counter, transactionCount];
}


