type
  Constraint = class
  private
    a: integer;
    b: integer;
    c: integer;
    d: integer;
  public
    constructor Create(a, b, c, d: integer);
    begin
      self.a := a;
      self.b := b;
      self.c := c;
      self.d := d;
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
      m.Groups[2].Value.ToInteger(),
      m.Groups[3].Value.ToInteger(),
      m.Groups[4].Value.ToInteger(),
      m.Groups[5].Value.ToInteger()))
    .ToArray();

  input[2]
    .Split(new string[1](''#10''), System.StringSplitOptions.RemoveEmptyEntries)
    .Skip(1)
    .SelectMany(l -> l.Split(',').Select(c -> c.ToInteger()))
    .Where(x -> not constraints.Any(c -> c.isCompliant(x)))
    .Sum()
    .Print;
end.
