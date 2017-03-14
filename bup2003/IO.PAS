unit IO;

  interface

function FatalIOError(e : integer) : boolean;

  implementation 

function FatalIOError(e : integer) : boolean;
begin
  if (e in [0,103]) then Result := false else Result := true;
end;


end.
