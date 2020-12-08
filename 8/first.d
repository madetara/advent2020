import std.stdio;
import std.file;
import std.array;
import std.conv;

private class Command {
    string cmd;
    int val;

    this(string cmd, int val) {
        this.cmd = cmd;
        this.val = val;
    }

    static auto parse(string s) {
        auto input = split(s);
        return new Command(input[0], to!int(input[1]));
    }
}

private class Program {
    Command[] commands;

    this(Command[] commands) {
        this.commands = commands;
    }

    static auto parseFile(string fileName) {
        auto file = File(fileName, "r");
        Command[] cmds = [];

        auto w = appender(&cmds);

        while (!file.eof()) {
            auto line = file.readln();

            if (line.length == 0) {
                continue;
            }

            auto command = Command.parse(line);
            w ~= command;
        }

        file.close();

        return new Program(w[]);
    }

    int run() {
        auto acc = 0;
        auto ptr = 0;
        auto visited = new bool[this.commands.length];

        while (true) {
            if (visited[ptr])
                break;

            visited[ptr] = true;
            const auto cc = this.commands[ptr];

            switch (cc.cmd) {
                case "nop":
                    ptr += 1;
                    break;
                case "acc":
                    acc += cc.val;
                    ptr += 1;
                    break;
                case "jmp":
                    ptr += cc.val;
                    break;
                default:
                    writeln("panic");
                    break;
            }
        }

        return acc;
    }
}

void main() {
    const fileName = "input.txt";

    auto program = Program.parseFile(fileName);

    writeln(program.run());
}
