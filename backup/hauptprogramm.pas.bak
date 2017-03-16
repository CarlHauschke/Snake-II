unit Hauptprogramm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons;

type

  TMoveDirection = (up,down,left,right);

  { THauptfenster }

  // Hauptfenster
  THauptfenster = class(TForm)
    HUDScore: TLabel;
    HUDTextScore: TLabel;
    HUDTrenner: TShape;
    HighscoreLabel: TLabel;
    LastScore: TLabel;
    Start: TBitBtn;
    Essen: TImage;
    Kopf: TImage;
    GameTick: TTimer;
    procedure StartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure GameTickTimer(Sender: TObject);
    function Schwanzerstellen:boolean;
  private
    { private declarations }
  public
    { public declarations }
  end;

  TSchlangenCord=record                 //Speichert die Koordinaten, an dennen sich Schlangenelement vorher befunden hat
    Top:integer;                    //Position von links
    Left:Integer;                   //Position von rechts
  end;

const
  //Bestimmte Abstand zwischen Teleportationen der Schlange,
  //sowie die Groesse der Grafiken
  Delta=25;
var
  Hauptfenster: THauptfenster;
  MoveDirection: TMoveDirection;
  Score:integer=0;                   // Speichert den aktuellen Punktestand

  //Variaben für Snwanz
  Schwanzanzahl:integer=-1;   //Speichert die Anzahl an Schwanzelementen
  Schwanz: array of TImage;   //Speichert die Schwanzelemente
  Schlangencord: array of TSchlangencord; //Speichert die Koordinaten, an dennen sich Schlangenelement vorher befunden hat
  Kopfcord:TSchlangenCord;

  //Variablen für Dateiverwaltung
  ScoreText: textfile;
  ScoreFile: string;

implementation

{$R *.lfm}

{ THauptfenster }

// Highscore lesen
function Highscore:integer ;
var  HScore: string;
begin
  AssignFile(ScoreText,ScoreFile);
  Reset(ScoreText);
  readln(ScoreText,HScore);
  CloseFile(ScoreText);
  Highscore:=strtoint(HScore);
end;

// Highscore schreiben
procedure writeScore(Score: integer);
begin
  AssignFile(ScoreText,ScoreFile);
  Rewrite(ScoreText);
  writeln(ScoreText,inttostr(Score));
  CloseFile(ScoreText);
end;

//Objekt an zufällige Koordinaten bewegen
function RandomCord(Sender: TImage): boolean;
begin
  //Setzt Objekt an zufällige Koordinaten Auf Bildschirm
  //Berücksichtig HUD
  randomize;
  Sender.Top:= ((random(Hauptfenster.Height - (Hauptfenster.HUDTrenner.Top + Hauptfenster.HUDTrenner.Height)) + (Hauptfenster.HUDTrenner.Top + Hauptfenster.HUDTrenner.Height)) div Delta)* Delta;
  Sender.Left:= (random(Hauptfenster.Height) div Delta)* Delta;
  //(Hauptfenster.HUDTrenner.Top + TShape.HUDTrenner.Height)
end;

//Erstellung des Hauptfensters
procedure THauptfenster.FormCreate(Sender: TObject);
begin
  //Schwanz.SchwanzCreate(Schwanz);
  Hauptfenster.Color:=0;
  //Fenster Mittig auf Bildschirm platzieren
  Hauptfenster.Top:= (Screen.Height - Hauptfenster.Height) div 2;
  Hauptfenster.Left:= (Screen.Width - Hauptfenster.Width) div 2;
  //Highscore einlesen
  ScoreFile:=GetAppConfigDir(false)+'\highscore.txt';             //Datei festlegen
  // Prüfen, ob Dateipfad existier, ansonsten anlegen
  if not FileExists(ScoreFile) then
  begin
    CreateDir(GetAppConfigDir(false));
    AssignFile(ScoreText,ScoreFile);
    Rewrite(ScoreText);
    writeln(ScoreText,inttostr(Score));
    CloseFile(ScoreText);
  end;
  //Score und Highscore Felder ausfüllen
  LastScore.Caption:=     'Last Score:  '+ inttostr(Score);
  HighscoreLabel.Caption:='Highscore:   '+ inttostr(Highscore);
end;

//Spiel starten knopf
procedure THauptfenster.StartClick(Sender: TObject);
begin
  // Groesse von Kopf, Essen und Schwanz an Bewegungsabstand anpassen
  Kopf.Width := Delta;
  Kopf.Height := Delta;
  Essen.Width := Delta;
  Essen.Height := Delta;

  // Kopf, Essen an Zufällige Position platzieren platzieren
  RandomCord(Kopf);
  RandomCord(Essen);

  // Start Knopf und Score anzeigen ausblenden
  Start.Visible:=False;
  HighscoreLabel.Visible:=False;
  LastScore.Visible:=False;

  // Score zurücksetzen
  Score:=0;

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

//Tastendruck registrieren
procedure THauptfenster.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
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

//GameTick
procedure THauptfenster.GameTickTimer(Sender: TObject);
Var
  NewCord: integer;
  i:integer;
begin
    //alte Koordinaten aktualisieren
    Kopfcord.Left:=Kopf.Left;
    Kopfcord.Top:=Kopf.Top;
    for i:= 0 to Schwanzanzahl do
    begin
      Schlangencord[i].Left:=Schwanz[i].Left;
      Schlangencord[i].Top:=Schwanz[i].Top;
    end;

    //Schlangenkopf bewegen
    Case MoveDirection of
    TMoveDirection.up:                        //Move Snake Up by Delta Pixels
      begin
        NewCord := Kopf.Top - Delta;
        if NewCord < (HUDTrenner.Top + HUDTrenner.Height) then                   //If snake moves out of Window Teleport down
          Kopf.Top := NewCord + Hauptfenster.Height - (HUDTrenner.Top + HUDTrenner.Height)
        else                                  //else just move up
          Kopf.Top := NewCord;
      end;

    TMoveDirection.down:                      //Move Snake Down by Delta Pixels
      begin
        NewCord := Kopf.Top + Delta;
        if NewCord > Hauptfenster.Height - Delta then         //If snake moves out of Window Teleport down
                                                      // - Delta, da Position an oberer, linker Ecke gemessen wird
          Kopf.Top := NewCord - Hauptfenster.Height + (HUDTrenner.Top + HUDTrenner.Height)
        else                                  //else just move down
          Kopf.Top := NewCord;
      end;

    TMoveDirection.left:                      //Move Snake Left by Delta Pixels
      begin
        NewCord := Kopf.Left - Delta;
        if NewCord < 0 then                   //If snake moves out of Window Teleport to right border
          Kopf.Left := NewCord + Hauptfenster.Width
        else                                  //else just move left
          Kopf.Left := NewCord;
      end;

    TMoveDirection.right:                     //Move Snake Right by Delta Pixels
      begin
        NewCord := Kopf.Left + Delta;
        if NewCord > Hauptfenster.Width - Delta then         //If snake moves out of Window Teleport to left border
                                                      // - Delta, da Position an oberer, linker Ecke gemessen wird
          Kopf.Left := NewCord - Hauptfenster.Width
        else                                  //else just move right
          Kopf.Left := NewCord;
      end;
    end;

    //Schwanz bewegen
    if Schwanzanzahl > -1 then
    begin
      Schwanz[0].Left:=Kopfcord.Left;
      Schwanz[0].Top:=Kopfcord.Top;
      for i:= 1 to Schwanzanzahl do
      begin
        Schwanz[i].Left:=Schlangencord[i-1].Left;
        Schwanz[i].Top:=Schlangencord[i-1].Top;
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

        //Schlange anfügen
        Schwanzerstellen;
    end;
end;

//Neuen Schwanz anhängen
function THauptfenster.Schwanzerstellen: boolean;
begin
  Schwanzanzahl:=Schwanzanzahl+1;
  SetLength(Schwanz,Schwanzanzahl+1);    // Array um 1 Platz vergrößern
  SetLength(Schlangencord,Schwanzanzahl+1);
  Schwanz[Schwanzanzahl]:=TImage.Create(Kopf);     // Schwanzelemnt in neuen Platz einfügen
  with Schwanz[Schwanzanzahl] do
  begin
    Picture.LoadFromFile('Bilder\Schwanz1.png');
    Top:=50;
    Left:=50;
    Width:=Delta;
    Height:=Delta;
    Stretch:=true;
    Enabled:=true;
    Visible:=true;
    Parent:=Hauptfenster;                         //Ordnet Schlangenelement Hauptfenster zu
                                                  //dadurch wird es auch erst angezeigt
  end;
  if Schwanzanzahl < 1 then                       //Wenn noch kein Schanz existiert, Koordinaten von Kopf nehmen
  begin
    Schwanz[Schwanzanzahl].Top:=Kopfcord.Top;
    Schwanz[Schwanzanzahl].Left:=Kopfcord.Left;
  end else
  begin                                           //Sonst Koordinaten von vorangestelltem Schwanz nehmen
    Schwanz[Schwanzanzahl].Top:=Schlangencord[Schwanzanzahl-1].Top;
    Schwanz[Schwanzanzahl].Left:=Schlangencord[Schwanzanzahl-1].Left;
  end;
  if assigned(Schwanz[Schwanzanzahl]) then
    Schwanzerstellen:=true
end;

end.

