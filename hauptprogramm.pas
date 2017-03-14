unit Hauptprogramm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons;

type

  TMoveDirection = (up,down,left,right);

  { TForm1 }

  // Hauptfenster
  TForm1 = class(TForm)
    Start: TBitBtn;
    Essen: TImage;
    Kopf: TImage;
    GameTick: TTimer;
    procedure StartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure GameTickTimer(Sender: TObject);
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
  Score:integer=0;                   // Speichert den aktuellen Punktestand

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  Form1.Color:=0;
end;

procedure TForm1.StartClick(Sender: TObject);
begin
  // Groesse von Kopf, Essen und Schwanz an Bewegungsabstand anpassen
  Kopf.Width := Delta;
  Kopf.Height := Delta;
  Essen.Width := Delta;
  Essen.Height := Delta;
  //Schwanz.Width := Delta;
  //Schwanz.Height := Delta;

  // Kopf an Zufällige Position platzieren platzieren
  randomize;
  Kopf.Top := ((random(Form1.Height)+1) div Delta)* Delta;
  Kopf.Left := ((random (Form1.Width)+1) div Delta)* Delta;

  // Essem an Zufällige Position platzieren platzieren
  randomize;
  Essen.Top := ((random(Form1.Height)+1) div Delta)* Delta;
  Essen.Left := ((random (Form1.Width)+1) div Delta)* Delta;

  // Start Knopf ausblenden
  Start.Visible:=False;

  // GameTick starten
  GameTick.Enabled:=True;

  // Kopf und Essen anzeigen
  Kopf.Visible := True;
  Essen.Visible := True;
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

procedure TForm1.GameTickTimer(Sender: TObject);
Var
  NewCord: integer;
begin
    Case MoveDirection of
    TMoveDirection.up:                        //Move Snake Up by Delta Pixels
      begin
        NewCord := Kopf.Top - Delta;
        if NewCord < 0 then                   //If snake moves out of Window Teleport down
          Kopf.Top := NewCord + Form1.Height
        else                                  //else just move up
          Kopf.Top := NewCord;
      end;

    TMoveDirection.down:                      //Move Snake Down by Delta Pixels
      begin
        NewCord := Kopf.Top + Delta;
        if NewCord > Form1.Height - Delta then         //If snake moves out of Window Teleport down
                                                      // - Delta, da Position an oberer, linker Ecke gemessen wird
          Kopf.Top := NewCord - Form1.Height
        else                                  //else just move down
          Kopf.Top := NewCord;
      end;

    TMoveDirection.left:                      //Move Snake Left by Delta Pixels
      begin
        NewCord := Kopf.Left - Delta;
        if NewCord < 0 then                   //If snake moves out of Window Teleport to right border
          Kopf.Left := NewCord + Form1.Width
        else                                  //else just move left
          Kopf.Left := NewCord;
      end;

    TMoveDirection.right:                     //Move Snake Right by Delta Pixels
      begin
        NewCord := Kopf.Left + Delta;
        if NewCord > Form1.Width - Delta then         //If snake moves out of Window Teleport to left border
                                                      // - Delta, da Position an oberer, linker Ecke gemessen wird
          Kopf.Left := NewCord - Form1.Width
        else                                  //else just move right
          Kopf.Left := NewCord;
      end;
    end;

    // Kollision zwischen Kopf und Essen
    if  (Essen.top  = Kopf.top) and (Essen.left = Kopf.left)
    then
      begin
        Essen.visible:=false;
        Score:= Score +1;

        // Neue Position für Essen
        randomize;
        Essen.top := ((random(Form1.Height)+1) div Delta)* Delta;
        Essen.left:= ((random (Form1.Width)+1) div Delta)* Delta;
        Essen.visible:=true;
    end;
end;

end.

