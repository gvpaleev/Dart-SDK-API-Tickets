class Ticket {
  late String subject;
  late String subtopic;
  late String question;
  late String correctOption;
  List<String> options;
  Ticket(this.subject, this.subtopic, this.question, this.correctOption,
      this.options) {
    options.add(correctOption);
    options.shuffle();
  }

  @override
  String toString() {
    // TODO: implement toString
    return '''$subject -> $subtopic

$question

${options.map((e) => ' - ' + e + '\n\n').toList().join('')}

''';
  }

  bool isCheck(int) {
    if (int < 1 || int > 4) return false;
    bool flag = correctOption == options[--int];

    return flag;
  }
}


// <i> - $correctOption</i>

// <i> - ${options[0]}</i>

// <i> - ${options[1]}</i>

// <i> - ${options[2]}</i>