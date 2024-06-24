/// This interface defines a contract for objects that can be copied.
abstract interface class Copyable {
  /// Returns a new instance that is an identical copy of this object.
  Copyable copy();

  /// Returns a new instance that is an identical copy of this object,
  /// with optional changes applied.
  ///
  /// The [changes] parameter specifies values to be updated in the copied instance.
  /// If [changes] is null or empty, the method should return an exact copy of this object.
  Copyable copyWith({Map<String, dynamic>? changes});
}

/// Extension for any list whose items implement the [Copyable] interface.
extension ListCopyExtension<T extends Copyable> on List<T> {
  /// Returns a new list where each element is a deep copy of the original elements.
  /// This is useful to ensure that modifications to the new list do not affect the original list,
  /// preventing unintended side effects.
  ///
  /// @Example:
  /// ```dart
  /// class MyClass implements Copyable {
  ///   int value;
  ///
  ///   MyClass(this.value);
  ///
  ///   @override
  ///   MyClass copy() {
  ///     return MyClass(value); // Perform deep copy logic as needed
  ///   }
  /// }
  ///
  /// void main() {
  ///   var originalList = [MyClass(1), MyClass(2), MyClass(3)];
  ///   var copiedList = originalList.deepCopy();
  ///
  ///   // Modify copiedList without affecting originalList
  ///   copiedList[0].value = 10;
  ///
  ///   print(originalList); // Output: [MyClass(1), MyClass(2), MyClass(3)]
  ///   print(copiedList);   // Output: [MyClass(10), MyClass(2), MyClass(3)]
  /// }
  /// ```
  List<T> deepCopy() {
    return map<T>((item) => item.copy() as T).toList();
  }
}