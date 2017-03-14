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
    HUDScore: TLabel;
    HUDTextScore: TLabel;
    HUDTrenner: TShape;
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

function RandomCord(Sender: TImage): boolean;
begin
  randomize;
  Sender.Top:= ((random(Form1.Height - (Form1.HUDTrenner.Top + Form1.HUDTrenner.Height)) + (Form1.HUDTrenner.Top + Form1.HUDTrenner.Height)) div Delta)* Delta;
  Sender.Left:= (random(Form1.Height) div Delta)* Delta;
  //(Form1.HUDTrenner.Top + TShape.HUDTrenner.Height)
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Form1.Color:=0;
  Form1.Top:= (Screen.Height - Form1.Height) div 2;
  Form1.Left:= (Screen.Width - Form1.Width) div 2;
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

  // Kopf, Essen an Zufällige Position platzieren platzieren
  RandomCord(Kopf);
  RandomCord(Essen);

  // Start Knopf ausblenden
  Start.Visible:=False;

  // HUD Einblenden
  HUDTrenner.Visible:=true;
  HUDTextScore.Visible:=true;
  HUDScore.Visible:=true;
  HUDScore.Caption:=inttostr(Score);

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
        if NewCord < (HUDTrenner.Top + HUDTrenner.Height) then                   //If snake moves out of Window Teleport down
          Kopf.Top := NewCord + Form1.Height - (HUDTrenner.Top + HUDTrenner.Height)
        else                                  //else just move up
          Kopf.Top := NewCord;
      end;

    TMoveDirection.down:                      //Move Snake Down by Delta Pixels
      begin
        NewCord := Kopf.Top + Delta;
        if NewCord > Form1.Height - Delta then         //If snake moves out of Window Teleport down
                                                      // - Delta, da Position an oberer, linker Ecke gemessen wird
          Kopf.Top := NewCord - Form1.Height + (HUDTrenner.Top + HUDTrenner.Height)
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
        RandomCord(Essen);
        HUDScore.Caption:=inttostr(Score);
        Essen.visible:=true;
    end;
end;

end.

