type
  Constraint = class
  private
    a: integer;
    b: integer;
    c: integer;
    d: integer;
  public
    name: string;

    constructor Create(name: string; a, b, c, d: integer);
    begin
      self.a := a;
      self.b := b;
      self.c := c;
      self.d := d;
      self.name := name;
    end;

    function isCompliant(x: integer): boolean;
    begin
      Result := ((self.a <= x) and (x <= self.b))
                or
                ((self.c <= x) and (x <= self.d));
    end;
  end;

begin
  var fileName := 'input.txt';
  var separator := new string[1](''#10#10'');
  var input := ReadAllText(fileName)
    .Split(separator, System.StringSplitOptions.RemoveEmptyEntries);

  var constraints := input[0]
    .Matches('(\w+ ?\w+): (\d+)-(\d+) or (\d+)-(\d+)')
    .Select(m -> new Constraint(
      m.Groups[1].Value,
      m.Groups[2].Value.ToInteger(),
      m.Groups[3].Value.ToInteger(),
      m.Groups[4].Value.ToInteger(),
      m.Groups[5].Value.ToInteger()))
    .ToArray();

  var validTickets := input[2]
    .Split(new string[1](''#10''), System.StringSplitOptions.RemoveEmptyEntries)
    .Skip(1)
    .Select(l -> l.Split(',').Select(c -> c.ToInteger()))
    .Where(t -> t.All(x -> constraints.Any(c -> c.isCompliant(x))))
    .Select(t -> t.ToArray());

  var yourTicket := input[1]
    .Split(new string[1](''#10''), System.StringSplitOptions.RemoveEmptyEntries)
    .Skip(1)
    .Take(1)
    .JoinToString()
    .Split(',')
    .Select(c -> c.ToInteger())
    .ToArray();

  var rows := (0..(yourTicket.Length - 1))
    .Select(i -> validTickets.Select(t -> t[i]).ToArray());

  var assignedRows := new HashSet<integer>();

  constraints
    .Select(c -> rows
                  .Select((r, i) -> (r.All(x -> c.IsCompliant(x)), i))
                  .Where(p -> p[0])
                  .Select(p -> p[1]))
    .Select((c, i) -> (i, c))
    .OrderBy(s -> s[1].Count())
    .Select(c ->
      begin
        var row := c[1].First(x -> not assignedRows.Contains(x));
        assignedRows.Add(row);
        Result := (c[0], row);
      end)
    .Where(c -> constraints[c[0]].Name.StartsWith('departure'))
    .Select(c -> yourTicket[c[1]])
    .Product()
    .Print;
end.
