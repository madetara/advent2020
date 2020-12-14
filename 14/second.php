<?php declare(strict_types=1);
    function leftPad(array $mask, int $x) {
        while (count($mask) != $x) {
            array_unshift($mask, '0');
        }

        return $mask;
    }

    function applyMask(int $x, string $mask) {
        $binary = array_reverse(str_split(decbin($x)));
        $i = -1;
        $fluent_bytes = [];

        foreach (array_reverse(str_split($mask)) as $c) {
            $i += 1;

            if ($c == '0') {
                if (!array_key_exists($i, $binary)) {
                    $binary[$i] = '0';
                }
                continue;
            }

            if ($c == '1') {
                $binary[$i] = '1';
                continue;
            }

            if ($c == 'X') {
                $binary[$i] = 'X';
                array_push($fluent_bytes, $i);
            }
        }

        $addresses = [];
        $n = count($fluent_bytes);

        foreach (range(0, 2**$n - 1) as $address_mask) {
            $j = 0;
            $bin_mask = leftPad(str_split(decbin($address_mask)), $n);

            foreach ($fluent_bytes as $i) {
                $binary[$i] = $bin_mask[$j];
                $j += 1;
            }

            array_push($addresses, bindec(implode(array_reverse($binary))));
        }

        return $addresses;
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

                foreach (applyMask($i, $mask) as $j) {
                    $memory[$j] = (int)$line[1];
                }
            }
        }
    }

    printf("%d\n", array_sum($memory));

    fclose($handle);
?>
