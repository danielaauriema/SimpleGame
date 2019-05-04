unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Noise;

type
  TForm1 = class(TForm)
    userShape: TShape;
    Timer1: TTimer;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Timer2: TTimer;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    FCount: Integer;
    FVector: Integer;
    FShapes: TList;
    FLives: Byte;
    FPoints: Integer;
    FNoise1: TNoise;
    FNoise2: TNoise;
    FNoise3: TNoise;
    function NewShape: TShape;
    procedure Start;
    procedure Reset;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  FNoise1:= TNoise.Create(500, 100, 127);
  FNoise2:= TNoise.Create(100, 1000, 127);
  FNoise3:= TNoise.Create(200, 500, 127);
  FShapes:= TList.Create;
  Start;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      Close;
    VK_RIGHT:
      FVector:= + 30;
    VK_LEFT:
      FVector:= -30;
    VK_RETURN:
      if not Timer1.Enabled then
      begin
        Start;
        Timer1.Enabled:= True;
      end;
  end;
end;

procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if ((Key = VK_RIGHT) and (FVector >0))
  or ((Key = VK_LEFT) and (FVector < 0)) then
    FVector:= 0;
end;

function TForm1.NewShape: TShape;
begin
  Result:= TShape.Create(Self);
  with Result do
  begin
    Parent:= Self;
    Height:= 20;
    Width:= 20;
    Brush.Color:= clRed;
    Left:= Random(Self.Width - Width);
  end;
end;

procedure TForm1.Reset;
begin
  while FShapes.Count > 0 do
  begin
    TShape (FShapes.Items[0]).Destroy;
    FShapes.Delete(0);
  end;
  userShape.Left:= (Width - userShape.Width) div 2;
end;

procedure TForm1.Start;
begin
  Timer2.Enabled:= true;
  FLives:= 3;
  FPoints:= 0;
  Reset;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  i: Integer;
  r1, r2: TRect;
begin

  FCount:= (FCount + 1) mod 30;
  if FCount = 0 then
    FShapes.Add(NewShape);

  r1:= userShape.ClientRect;
  r1.Offset(userShape.Left, userShape.Top);

  i:= 0;
  while i < FShapes.Count do
  begin
    with TShape (FShapes.Items[i]) do
    begin
      Top:= Top + 10;
      if Top > Self.Height then
      begin
        Destroy;
        FShapes.Delete(i);
        Dec(FLives);
        if FLives = 0 then
        begin
          FNoise2.Play;
          Timer1.Enabled:= False
        end
        else
        begin
          FNoise3.Play;
          Reset;
        end;
      end
      else
      begin
        r2:= ClientRect;
        r2.Offset(Left, Top);
        if r1.IntersectsWith(r2) then
        begin
          FNoise1.Play;
          Destroy;
          FShapes.Delete(i);
          Inc(FPoints);
        end
        else
          inc(i);
      end
    end;
  end;

  with userShape do
  begin
    Left:= Left + FVector;
    if Left < 0 then
      Left:= 0
    else if Left > Self.Width - Width then
      Left:= Self.Width - Width;
  end;

  Label1.Caption:= 'Sprites: ' + IntToStr(FShapes.Count);
  Label2.Caption:= 'Points: ' + IntToStr(FPoints);
  Label3.Caption:= 'Lives: ' + IntToStr(FLives);

end;

procedure TForm1.Timer2Timer(Sender: TObject);
var
  i: integer;
  b1, b2: TNoise;
begin
  Timer2.Enabled:= False;

  b1:= TNoise.Create(600, 50, 127);
  b2:= TNoise.Create(900, 50, 127);

  Application.ProcessMessages;

  for i := 1 to 3 do
  begin
    b1.Play;
    Sleep(120);
    b2.Play;
    Sleep(120);
    Application.ProcessMessages;
  end;

end;

end.
