class Prompt {
  final String id;
  final String name;
  final String prompt;

  Prompt({required this.id, required this.name, required this.prompt});

  factory Prompt.fromJson(Map<String, dynamic> json) {
    return Prompt(
      id: json['id'],
      name: json['name'],
      prompt: json['prompt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'prompt': prompt,
    };
  }
}
