Unit MyStrs;

  interface

var BreakChars  : Set of Char = [',',' ','[',']','{','}','(',')',':',';','.','^',
                                 '&','*','!','#','$','/','\','"','%','>','<',
                                 '-','+','=','|','?',#13,#10,#9,#26,#12,'@'];

function STRALLUP(s : string) : string;
function stralldown(s : string) : string;
function StrCap(s : string) : string;
function StrCapFirst(s : string) : string;

  implementation uses sysutils;

function STRALLUP(s : string) : string;
begin
  Result := AnsiUpperCase(s);
end;

function stralldown(s : string) : string;
begin
  Result := AnsiLowerCase(s);
end;

function StrCap(s : string) : string;
var i : Integer;
    ns,ts : string;
    fst : boolean;
begin
  i := 1; ns := ''; fst := true;
  repeat
    while (i <= Length(s)) and (s[I] in BreakChars) do
    begin
      ns := ns + s[i];
      Inc(i);
    end;
    if i > Length(s) then break;
    ts := '';
    while (i <= Length(s)) and (not (s[i] in BreakChars)) do
    begin
      ts := ts + s[i];
      Inc(i);
    end;
    ts := AnsiLowerCase(ts);
    if (ts = 'dj')or(ts = 'cj')or(ts = 'vj')or(ts = 'd.j.')or(ts = 'c.j.')or(ts = 'v.j.') then
    begin
      ts := AnsiUpperCase(ts);
    end else
    if fst then
    begin
      fst := false;
      ts[1] := AnsiUpperCase(ts[1])[1];
    end else
    if ts<>'' then
    if (ts <> 'for')and(ts <> 'or')and(ts<>'a')and(ts<>'the')and(ts<>'at')and(ts<>'de')and(ts<>'la')and(ts<>'des')and(ts<>'of')and(ts<>'to')
    then
    begin
      ts[1] := AnsiUpperCase(ts[1])[1];
    end;
    ns := ns+ts{ + ' '};
  until i > Length(s);
  Result := Trim(ns);
end;

function StrCapFirst(s : string) : string;
var i : Integer;
begin
  i := 1;
  while (i <= Length(s)) and (s[i] in BreakChars) do Inc(i);
  if i <= length(s) then s[i] := AnsiUpperCase(s[i])[1];
  Result := s;
end;

end.