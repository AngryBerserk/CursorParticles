unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

const bits_count=100000;
type
  Bit=Record
          X,Y:Real;
          Color:Byte;
          dx,dy:Real;
        End;
  TForm1 = class(TForm)
    procedure FormShow(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MyIdleHandler(Sender: TObject; var Done: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    X0,
    Y0,
    Max_X,
    Max_Y:Word;
    State:Boolean;
    Bit_map:TBitmap;
    Bits:Array[1..bits_count] of Bit;
    Scans:Array of PByteArray;
    Radius:Real;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormShow(Sender: TObject);
 var z:LongWord;
begin
Bit_Map:=TBitmap.Create;
FormResize(Self);
//Initialize bits starting location
For z:=1 to Bits_Count Do Begin
  Bits[z].x:=Random(Max_x);
  Bits[z].y:=Random(Max_y);
  Bits[z].dx:=random-random;
  Bits[z].dy:=random-random;
  Bits[z].Color:=170;
End;
Bit_map.Canvas.Brush.Color:=clBlack;
end;

Procedure TForm1.MyIdleHandler;
 Var z,x:LongWord;
 Begin
For z:=0 to Max_y-1 Do
  Scans[Z]:=Bit_Map.ScanLine[Z];
For z:=1 to Max_y-1 Do
  For x:=1 to Max_x*3 Do
    Scans[z][x]:=0;

For z:=1 to Bits_Count Do Begin
If Radius>0 Then
If Sqr(Bits[z].x-X0)+Sqr(Bits[z].y-y0)<Sqr(Radius) then
  Begin
    If State Then Begin
      Bits[z].dx:=(X0-Bits[z].x)/(Random(1000)+1);
      Bits[z].dy:=(Y0-Bits[z].y)/(Random(1000)+1);
      //Bits[z].Color:=100;
    End Else
      Begin
        Bits[z].dx:=(Bits[z].x-X0)/(Random(1000)+1);
        Bits[z].dy:=(Bits[z].y-Y0)/(Random(1000)+1);
        //Bits[z].Color:=255;
    End
  End;
 Bits[z].x:=Bits[z].x+Bits[z].dx;
 Bits[z].y:=Bits[z].y+Bits[z].dy;
 If Bits[z].x>Max_x-1 then Bits[z].x:=1;
 If Bits[z].y>Max_y-1 then Bits[z].y:=1;
 If Bits[z].x<1 then Bits[z].x:=Max_x-1;
 If Bits[z].y<1 then Bits[z].y:=Max_y-1;
 Scans[Round(Bits[z].y)][Round(Bits[z].x)*3+1]:=Bits[Z].Color;
End;
Canvas.Draw(0,0,Bit_map);
Done:=false
End;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
If (SSLeft in Shift)  or (SSRight in Shift) then Begin
 X0:=x;Y0:=y; Radius:=Radius+0.5;
end;
End;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
Radius:=0;
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
If Button = mbLeft then State:=True Else State:=False;
Radius:=100;X0:=x;Y0:=y;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
Max_x:=ClientWidth;
Max_y:=ClientHeight;
Bit_Map.PixelFormat:=Pf24bit;
Bit_Map.Width:=Max_x+1;
Bit_Map.Height:=Max_y+1;
SetLength(Scans,Max_y+1);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
Application.OnIdle:= MyIdleHandler;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
If Key=VK_Escape then Form1.Close
end;

end.
