unit Hauptprogramm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls;

type

  TMoveDirection = (up,down,left,right);

  { TForm1 }

  TForm1 = class(TForm)
    Image1: TLabel;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

const
  Delta=10;
var
  Form1: TForm1;
  MoveDirection:TMoveDirection;
  WindowXSize, WindowYSize:integer;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin

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
end;

procedure TForm1.Image1Click(Sender: TObject);
begin

end;

procedure TForm1.Timer1Timer(Sender: TObject);
Var
  NewCord: integer;
begin
     Image1.Caption:= IntToStr(Image1.Top);
    Case MoveDirection of
    TMoveDirection.up:                        //Move Snake Up by Delta Pixels
      begin
        NewCord := Image1.Top - Delta;
        if NewCord < 0 then                   //If snake moves out of Window Teleport down
          Image1.Top := NewCord + WindowYSize
        else                                  //else just move up
          Image1.Top := NewCord;
      end;

    TMoveDirection.down:                      //Move Snake Down by Delta Pixels
      begin
        NewCord := Image1.Top + Delta;
        if NewCord > WindowYSize then         //If snake moves out of Window Teleport down
          Image1.Top := NewCord - WindowYSize
        else                                  //else just move up
          Image1.Top := NewCord;
      end;

    TMoveDirection.left:                      //Move Snake Left by Delta Pixels
      begin
        NewCord := Image1.Left - Delta;
        if NewCord < 0 then                   //If snake moves out of Window Teleport down
          Image1.Left := NewCord + WindowXSize
        else                                  //else just move up
          Image1.Left := NewCord;
      end;

    TMoveDirection.right:                     //Move Snake Right by Delta Pixels
      begin
        NewCord := Image1.Left + Delta;
        if NewCord > WindowXSize then         //If snake moves out of Window Teleport down
          Image1.Left := NewCord - WindowYSize
        else                                  //else just move up
          Image1.Left := NewCord;
      end;
    end;
end;

end.

