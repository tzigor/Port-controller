unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, synaser,
  jwawinbase, jwawinnt, Port;

type

  { TApp }

  TApp = class(TForm)
    ADCStart: TButton;
    ADCStop: TButton;
    CloseApp: TButton;
    Command: TEdit;
    ADCInput: TLabel;
    Memo1: TMemo;
    StopBtn: TButton;
    StartBtn: TButton;
    COMselectCB: TComboBox;
    procedure ADCStartClick(Sender: TObject);
    procedure ADCStopClick(Sender: TObject);
    procedure CloseAppClick(Sender: TObject);
    procedure StartBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
  private

  public

  end;

Const
  NewLine     = #13#10;
  TIME_OUT    = 3000;  { 3 sec }

var
  App: TApp;

  ser                 : TBlockSerial; { current serial port }
  mon                 : Boolean;      { port monitoring enable }
  FreePortsAvailable  : Boolean;
  ADCCycle            : Boolean;

implementation

{$R *.lfm}

procedure TApp.StartBtnClick(Sender: TObject);
begin
   if Command.Text <> '' then ShowMessage(GetResponse(Command.Text));
end;

procedure TApp.CloseAppClick(Sender: TObject);
begin
  mon:= False;
  App.Close;
end;

procedure TApp.ADCStartClick(Sender: TObject);
begin
  ADCCycle:= True;
  while ADCCycle do begin
     Application.ProcessMessages; { let app to listen other events }
     ADCInput.Caption:= GetResponse('1');
     ADCInput.Refresh;
  end;
end;

procedure TApp.ADCStopClick(Sender: TObject);
begin
  ADCCycle:= False;
end;

procedure TApp.FormShow(Sender: TObject);
begin
  PortInit;
end;

procedure TApp.StopBtnClick(Sender: TObject);
begin
  if FreePortsAvailable then begin
    ser.CloseSocket;
    FreeAndNil(ser);
    mon:= False; { port monitoring disable }
  end;
end;

end.

