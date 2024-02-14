class SelectableEntity<T> {
  final bool selected;
  final String title;
  final String subTitle;
  final String description;
  final bool completo;
  final bool enviado;
  final T entity;
  final DateTime? fechaEnviado;

  SelectableEntity({
    required this.selected,
    required this.title,
    required this.subTitle,
    required this.description,
    required this.completo,
    required this.enviado,
    required this.entity,
    required this.fechaEnviado,
  });

  SelectableEntity copyWith({
    bool? selected,
    String? title,
    String? subTitle,
    String? description,
    bool? completo,
    bool? enviado,
    T? entity,
    DateTime? fechaEnviado,
  }) =>
      SelectableEntity(
        selected: selected ?? this.selected,
        title: title ?? this.title,
        subTitle: subTitle ?? this.subTitle,
        description: description ?? this.description,
        completo: completo ?? this.completo,
        enviado: enviado ?? this.enviado,
        entity: entity ?? this.entity,
        fechaEnviado: fechaEnviado ?? this.fechaEnviado,
      );
}
