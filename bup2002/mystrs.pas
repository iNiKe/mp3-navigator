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
begin
  i := 1;
  repeat
    while (i <= Length(s)) and (s[I] in BreakChars) do Inc(i);
    if i > Length(s) then break;
    s[i] := AnsiUpperCase(s[i])[1];
    while (i < Length(s)) and (not (s[i] in BreakChars)) do
    begin
      Inc(i); s[i] := AnsiLowerCase(s[i])[1];
    end;
  until i >= Length(s);
  Result := s;
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