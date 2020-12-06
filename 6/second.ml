open List
open Printf

module SC = Set.Make(Char);;

let file = "input.txt"

let file_lines (filename : string) : string list =
  let lines = ref [] in
  let chan = open_in filename in
  try
    while true; do
      lines := input_line chan :: !lines
    done; []
  with End_of_file ->
     close_in chan;
     List.rev !lines;;

let set_counter aggregator elem =
  match aggregator with
  | (set, fresh, result) ->
    if (String.length elem) != 0 then
      let char_list = (List.init (String.length elem) (String.get elem)) in
      let set_adder = (fun set elem -> SC.add elem set) in
      let line_set = (List.fold_left set_adder SC.empty char_list) in
      if fresh then
        (line_set, false, result)
      else
        ((SC.inter set line_set), false, result)
    else
      (SC.empty, true, result + (SC.cardinal set))

let () =
  let lines = file_lines file in
  let result = (List.fold_left set_counter (SC.empty, true, 0) lines) in
  match result with
  | (remains, _, result) ->
    printf "%d\n" (result + (SC.cardinal remains))
