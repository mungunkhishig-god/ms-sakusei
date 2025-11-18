class PadFlow {
  final String id;
  final String name;
  final String path;
  final String args;

  PadFlow({required this.id, required this.name, required this.path, required this.args});

  factory PadFlow.fromJson(Map<String, dynamic> json) {
    return PadFlow(
      id: json['id'],
      name: json['name'],
      path: json['path'],
      args: json['args'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'path': path,
      'args': args,
    };
  }
}
