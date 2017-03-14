unit Hauptprogramm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls;

type

  TMoveDirection = (up,down,left,right);

  { TForm1 }

  // Hauptfenster
  TForm1 = class(TForm)
    Food: TImage;
    Kopf: TImage;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

  (* Schlangen Schwanz versuch, geht nicht
  //Schlangen Schwanz
  TSchwanz = class(TImage)
    procedure Move();
    private
    var Schlangennummer, Nachfolgenummer: integer;
    public
    { public declarations }
  end;
  *)

const
  //Bestimmte Abstand zwischen Teleportationen der Schlange,
  //sowie die Groesse der Grafiken
  Delta=25;
var
  Form1: TForm1;
  MoveDirection:TMoveDirection;
  WindowXSize, WindowYSize:integer;
  Score:integer=0;                   // Speichert den aktuellen Punktestand

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  Food.top := ((random(Form1.Height)+1) div Delta)* Delta;
  Food.left:= ((random (Form1.Width)+1) div Delta)* Delta;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  case Key of
    38: //Up Arrow
      MoveDirection := TMoveDirection.up;
    40: //Down Arrow
      MoveDirection := TMoveDirection.down;
    37: //Left Arrow
      MoveDirection := TMoveDirection.left;
    39: //Right Arrow
      MoveDirection := TMoveDirection.right;
  end;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  WindowXSize := Form1.Width;
  WindowYSize := Form1.Height;

  Kopf.Width := Delta;
  Kopf.Height := Delta;

  //Kopf an oberen, linken Bildschirmrand platzieren
  Kopf.Top := 0;
  Kopf.Left := 0;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
Var
  NewCord: integer;
begin
    Case MoveDirection of
    TMoveDirection.up:                        //Move Snake Up by Delta Pixels
      begin
        NewCord := Kopf.Top - Delta;
        if NewCord < 0 then                   //If snake moves out of Window Teleport down
          Kopf.Top := NewCord + WindowYSize
        else                                  //else just move up
          Kopf.Top := NewCord;
      end;

    TMoveDirection.down:                      //Move Snake Down by Delta Pixels
      begin
        NewCord := Kopf.Top + Delta;
        if NewCord > WindowYSize - Delta then         //If snake moves out of Window Teleport down
                                                      // - Delta, da Position an oberer, linker Ecke gemessen wird
          Kopf.Top := NewCord - WindowYSize
        else                                  //else just move down
          Kopf.Top := NewCord;
      end;

    TMoveDirection.left:                      //Move Snake Left by Delta Pixels
      begin
        NewCord := Kopf.Left - Delta;
        if NewCord < 0 then                   //If snake moves out of Window Teleport to right border
          Kopf.Left := NewCord + WindowXSize
        else                                  //else just move left
          Kopf.Left := NewCord;
      end;

    TMoveDirection.right:                     //Move Snake Right by Delta Pixels
      begin
        NewCord := Kopf.Left + Delta;
        if NewCord > WindowXSize - Delta then         //If snake moves out of Window Teleport to left border
                                                      // - Delta, da Position an oberer, linker Ecke gemessen wird
          Kopf.Left := NewCord - WindowYSize
        else                                  //else just move right
          Kopf.Left := NewCord;
      end;
    end;

    // Kollision zwischen Kopf und Essen
    if  (Food.top  = Kopf.top) and (Food.left = Kopf.left)
    then
      begin
        Food.visible:=false;
        Score:= Score +1;

        // Neue Position für Essen
        randomize;
        Food.top := ((random(Form1.Height)+1) div Delta)* Delta;
        Food.left:= ((random (Form1.Width)+1) div Delta)* Delta;
        Food.visible:=true;
    end;
end;

end.

