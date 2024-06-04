unit frmHelp_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls,
  Vcl.Imaging.jpeg, Vcl.ExtCtrls;

type
  TfrmHelp = class(TForm)
    redHelp: TRichEdit;
    btnClose: TBitBtn;
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmHelp: TfrmHelp;

implementation

{$R *.dfm}

procedure TfrmHelp.FormActivate(Sender: TObject);
Var
  Datafile : Textfile;
  Line : String;
begin
  if FileExists('Help.txt') then
  Begin
    AssignFile(Datafile, 'Help.txt');
    Reset(Datafile);

    while not eof(Datafile) do
    Begin
      Readln(Datafile, Line);
      redHelp.Lines.Add(Line);
    End;

    CloseFile(Datafile);
  End
  Else
  Begin
    MessageDlg('An error has occured, the help screen can not be displayed at this time.' , mtError, mbOKCancel, 0);
    btnClose.Click;
  End;
end;

end.
