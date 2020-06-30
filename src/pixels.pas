program Pixels;

{$G+}

uses
  CRT;

procedure PutPixel (x, y : integer; color: byte);
begin
  mem[$A000:320 * y + x] := color;
end;

begin

  {set graphics mode 320x200, 256 colors}
  asm
    mov   ax, $13
    int   10h
  end;

  repeat

    PutPixel(random(320), random(200), random (256));

  until KeyPressed;

  {set text mode}
  asm
    mov   ax, $03
    int   10h
  end;

end.
