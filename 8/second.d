import std.stdio;
import std.file;
import std.array;
import std.conv;
import std.typecons;

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
    private Command[] commands;

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

    Tuple!(int, bool) run() {
        auto acc = 0;
        auto ptr = 0;
        auto visited = new bool[this.commands.length];

        while (true) {
            if (ptr == this.commands.length)
                return tuple(acc, true);
            if (visited[ptr])
                return tuple(0, false);

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
    }

    int fix() {
        for (int i = 0; i < this.commands.length; ++i) {
            const auto cc = this.commands[i];
            if (cc.cmd == "acc")
                continue;

            Tuple!(int, bool) result;

            switch (cc.cmd) {
                case "nop":
                    this.commands[i].cmd = "jmp";
                    result = this.run();
                    this.commands[i].cmd = "nop";
                    break;
                case "jmp":
                    this.commands[i].cmd = "nop";
                    result = this.run();
                    this.commands[i].cmd = "jmp";
                    break;
                default:
                    writeln("panic");
                    break;
            }

            if (result[1])
                return result[0];
        }

        return -1;
    }
}

void main() {
    const fileName = "input.txt";

    auto program = Program.parseFile(fileName);

    writeln(program.fix());
}
