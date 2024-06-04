unit MainForm_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, frmHelp_u, AdminLogin_u, ManagerLogin_u,
  Vcl.Imaging.jpeg;

type
  TfrmMainForm = class(TForm)
    pnlTitle: TPanel;
    rgpChoice: TRadioGroup;
    Image1: TImage;
    procedure rgpChoiceClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMainForm: TfrmMainForm;

implementation

{$R *.dfm}

procedure TfrmMainForm.rgpChoiceClick(Sender: TObject);
begin

  case rgpChoice.ItemIndex of
    0 : Begin
          frmManagerLogin.Show;
          rgpChoice.ItemIndex := -1;
        End;
    1 : Begin
          frmAdminLogin.Show;
          rgpChoice.ItemIndex := -1;
        End;
    2 : Begin
          frmHelp.Show;
          rgpChoice.ItemIndex := -1;
        End;
  end;
end;

end.
