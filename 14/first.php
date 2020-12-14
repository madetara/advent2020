<?php declare(strict_types=1);
    function applyMask(int $x, string $mask) {
        $binary = array_reverse(str_split(decbin($x)));
        $i = -1;

        foreach (array_reverse(str_split($mask)) as $c) {
            $i += 1;
            if ($c == 'X') {
                if (!array_key_exists($i, $binary)) {
                    $binary[$i] = '0';
                }
                continue;
            }

            $binary[$i] = $c;
        }

        return bindec(implode(array_reverse($binary)));
    }

    $filename = "input.txt";
    $handle = fopen($filename, "r");

    $mask = "";
    $memory = [];

    if ($handle) {
        while (!feof($handle)) {
            $line = explode(" = ", (string)fgets($handle));

            if ($line[0] == "")
                continue;

            if ($line[0] == "mask") {
                $mask = trim($line[1]);
            } else {
                $i = (int)(preg_split("/\[|\]/", $line[0])[1]);

                $memory[$i] = applyMask((int)$line[1], $mask);
            }
        }
    }

    printf("%d\n", array_sum($memory));

    fclose($handle);
?>
