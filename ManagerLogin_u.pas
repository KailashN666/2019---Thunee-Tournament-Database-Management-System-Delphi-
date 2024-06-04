unit ManagerLogin_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Manager_u, dmManagerDetails_u,
  Vcl.Imaging.jpeg;

type
  TfrmManagerLogin = class(TForm)
    btnLogin: TButton;
    edtPassword: TEdit;
    edtUsername: TEdit;
    lblUsername: TLabel;
    lblPassword: TLabel;
    pnlManager: TPanel;
    Image1: TImage;
    procedure btnLoginClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmManagerLogin: TfrmManagerLogin;

implementation

{$R *.dfm}

procedure TfrmManagerLogin.btnLoginClick(Sender: TObject);
Var
  bFound : Boolean;
  sUsername, sPassword : String;
begin
  dmManagerDetails.tblManagerDetails.First;
  bFound := False;
  sUsername := edtUsername.Text;
  sPassword := edtPassword.Text;
  sUsername := UpperCase(sUsername);

  while (Not dmManagerDetails.tblManagerDetails.Eof) and (bFound = False) do
  Begin
    if (sUsername = UpperCase(dmManagerDetails.tblManagerDetails['Username'])) and (sPassword = dmManagerDetails.tblManagerDetails['Password']) then
    begin
      bFound := True;
      edtUsername.Clear;
      edtPassword.Clear;
      MessageDlg('Successful login! You will now gain Manager privileges.', mtInformation, mbOKCancel, 0);
      frmManager.Show;
    end;

    dmManagerDetails.tblManagerDetails.Next;
  End;

  if bFound = False then
  begin
    MessageDlg('Unsuccessful login! Please re-enter your registered manager details.', mtError, mbOKCancel, 0);
    edtPassword.Clear;
    edtUsername.Clear;
    edtUsername.SetFocus;
  end;

end;

end.
