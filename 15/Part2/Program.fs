open System.Collections.Generic


let readInput
    (spokenNumbers: Dictionary<int, int * int>, _: int, iteration: int)
    (currentNumber: int) : Dictionary<int, int * int> * int * int =
        spokenNumbers.Add(currentNumber, (-1, iteration))
        (spokenNumbers, currentNumber, iteration + 1)
        
let addNumber
    (numbers: Dictionary<int, int * int>)
    (number: int)
    (iteration: int) =
        if numbers.ContainsKey number
        then
            let _, r = numbers.[number]
            numbers.[number] <- (r, iteration)
        else numbers.[number] <- (-1, iteration)
    
let nextNumber
    (spokenNumbers: Dictionary<int, int * int>, previousNumber: int, iteration: int):
    int * (Dictionary<int, int * int> * int * int) =
        let l, r = spokenNumbers.[previousNumber]
        let nextNumber =
            if l = -1
            then 0
            else r - l
        
        addNumber spokenNumbers nextNumber iteration
        
        nextNumber, (spokenNumbers, nextNumber, iteration + 1)
        
         
let solve (step: int) (input: int[]): int =
    let spokenNumbers, lastNumber, iteration = input |> Seq.fold readInput (Dictionary<int, int * int>(), 0, 1)
    
    (spokenNumbers, lastNumber, iteration)
    |> Seq.unfold (fun state ->
        let _, _, iter = state
        if iter > step
        then None
        else
            let res, nextState = nextNumber state
            Some (res, nextState)) 
    |> Seq.last

[<EntryPoint>]
let main _ =
    [|2; 15; 0; 9; 1; 20|]
    |> solve 30000000 
    |> printfn "%d\n"
    0 
