unit AdminLogin_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Admin_u,
  Vcl.Imaging.jpeg;

type
  TfrmAdminLogin = class(TForm)
    edtPassword: TEdit;
    edtUsername: TEdit;
    lblUsername: TLabel;
    lblPassword: TLabel;
    pnlAdmin: TPanel;
    btnLogin: TButton;
    Image1: TImage;
    procedure btnLoginClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAdminLogin: TfrmAdminLogin;

implementation

{$R *.dfm}

procedure TfrmAdminLogin.btnLoginClick(Sender: TObject);
Var
  sUsername, sPassword : String;
begin
  sUsername := edtUsername.Text;
  sPassword := edtPassword.Text;

  if (UpperCase(sUsername) = 'KAILASH') and (sPassword = 'Nagasar') then
  begin
    edtUsername.Clear;
    edtPassword.Clear;
    MessageDlg('Successful login! You will now gain Administrator privileges.', mtInformation, mbOKCancel, 0);
    frmAdmin.Show;
    frmAdminLogin.Hide;
  end
  else
  begin
    edtUsername.Clear;
    edtPassword.Clear;
    edtUsername.SetFocus;
    MessageDlg('You have entered the wrong Admin details. There is only one Administrator. Please re-enter your details.', mtError, mbOKCancel, 0);
  end;

end;

end.
