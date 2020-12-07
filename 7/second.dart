import 'dart:convert';
import 'dart:io';

class Bag {
  final String color;
  final List<BagContent> content;

  Bag(this.color, this.content);

  @override
  String toString() {
    return "$color: ${content.map((e) => e.toString()).join(" ")}";
  }
}

class BagContent {
  final String color;
  final int count;

  BagContent(this.color, this.count);

  @override
  String toString() {
    return "($color : $count)";
  }
}

Bag parseBag(info) {
  List<String> splitted = info.split(" ");
  String color = splitted.take(2).join(" ");

  return Bag(color, parseContent(splitted.skip(4)));
}

List<BagContent> parseContent(input) {
  if (input.isEmpty || input.first == "no") {
    return List<BagContent>.empty();
  }

  int count = int.parse(input.first);
  String color = input.skip(1).take(2).join(" ");
  List<BagContent> result = [BagContent(color, count)];
  List<BagContent> remains = parseContent(input.skip(4));

  result.addAll(remains);
  return result;
}

int countContainedBags(startingBag, containmentMap) {
  return containmentMap[startingBag]?.fold(
      0,
      (x, bagContent) =>
          x +
          bagContent.count +
          bagContent.count *
              countContainedBags(bagContent.color, containmentMap));
}

main() async {
  var file = File('input.txt');

  if (await file.exists()) {
    var contentStream = file.openRead();
    var bags = Map<String, List<BagContent>>();

    contentStream.transform(Utf8Decoder()).transform(LineSplitter()).listen(
        (String line) {
      var bag = parseBag(line);
      bags[bag.color] = bag.content;
    },
        onDone: () => print(countContainedBags('shiny gold', bags)),
        onError: (e) => print('[Problems]: $e'));
  }
}
