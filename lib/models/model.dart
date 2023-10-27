abstract class Model {
  Model();

  factory Model.fromMap(Map<String, dynamic> map) {
    // This factory constructor should be overridden in concrete subclasses.
    throw UnimplementedError("Subclasses must implement fromMap.");
  }

  Map<String, dynamic> toMap();

  late String table;
  late int? id;
}
