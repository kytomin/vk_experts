class Expert {
  late final int id;
  late final int actionsCount;
  late final int position;
  late final String topicName;

  Expert({required this.id, required this.actionsCount, required this.position, required this.topicName});

  Expert.fromJSON(data, {String lang = 'ru'}) {
    this.id = data['user_id'];
    this.actionsCount = data['actions_count'];
    this.position = data['position'];
    this.topicName = _translateTopicName(lang, data['topic_name']);
  }

  String _translateTopicName(String lang, String topicName) {
    if (lang == 'ru') return topicName;

    if (topicName == 'Арт') return 'Art';

    if (topicName == 'IT') return 'IT';

    if (topicName == 'Игры') return 'Games';

    if (topicName == 'Музыка') return 'Music';

    if (topicName == 'Новости') return 'News';

    if (topicName == 'Фото') return 'Photos';

    if (topicName == 'Наука') return 'Science';

    if (topicName == 'Спорт') return 'Sports';

    if (topicName == 'Туризм') return 'Travel';

    if (topicName == 'Кино') return 'Movies';

    if (topicName == 'Юмор') return 'Humor';

    if (topicName == 'Стиль') return 'Style';

    return topicName;
  }

  @override
  String toString() {
    return 'Expert(id: $id, actionsCount: $actionsCount, position: $position, topicName: $topicName)';
  }
}
