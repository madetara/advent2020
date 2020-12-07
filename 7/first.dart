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

int findPossibleContainments(startingBag, containmentMap, visited) {
  if (visited.contains(startingBag)) {
    return visited.length;
  }

  visited.add(startingBag);

  containmentMap[startingBag]?.forEach((element) {
    findPossibleContainments(element, containmentMap, visited);
  });

  return visited.length;
}

main() async {
  var file = File('input.txt');

  if (await file.exists()) {
    var contentStream = file.openRead();
    var bagContainmentMap = Map<String, Set<String>>();

    contentStream.transform(Utf8Decoder()).transform(LineSplitter()).listen(
        (String line) {
      var bag = parseBag(line);

      bag.content.forEach((element) {
        if (bagContainmentMap[element.color] == null) {
          bagContainmentMap[element.color] = Set<String>();
        }

        bagContainmentMap[element.color]?.add(bag.color);
      });
    },
        onDone: () => print(findPossibleContainments(
                'shiny gold', bagContainmentMap, Set<String>()) -
            1),
        onError: (e) => print('[Problems]: $e'));
  }
}
