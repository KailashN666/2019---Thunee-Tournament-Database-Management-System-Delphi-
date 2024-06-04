program ManagingThunee;

uses
  Vcl.Forms,
  MainForm_u in 'MainForm_u.pas' {frmMainForm},
  AdminLogin_u in 'AdminLogin_u.pas' {frmAdminLogin},
  ManagerLogin_u in 'ManagerLogin_u.pas' {frmManagerLogin},
  Admin_u in 'Admin_u.pas' {frmAdmin},
  dmPlayers_u in 'dmPlayers_u.pas' {dmPlayers: TDataModule},
  Manager_u in 'Manager_u.pas' {frmManager},
  dmManagerDetails_u in 'dmManagerDetails_u.pas' {dmManagerDetails: TDataModule},
  dmTeams_u in 'dmTeams_u.pas' {dmTeams: TDataModule},
  dmSemiFinals_u in 'dmSemiFinals_u.pas' {dmSemiFinals: TDataModule},
  dmFinals_u in 'dmFinals_u.pas' {dmFinals: TDataModule},
  frmHelp_u in 'frmHelp_u.pas' {frmHelp};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMainForm, frmMainForm);
  Application.CreateForm(TfrmAdminLogin, frmAdminLogin);
  Application.CreateForm(TfrmManagerLogin, frmManagerLogin);
  Application.CreateForm(TfrmAdmin, frmAdmin);
  Application.CreateForm(TdmPlayers, dmPlayers);
  Application.CreateForm(TfrmManager, frmManager);
  Application.CreateForm(TdmManagerDetails, dmManagerDetails);
  Application.CreateForm(TdmTeams, dmTeams);
  Application.CreateForm(TdmSemiFinals, dmSemiFinals);
  Application.CreateForm(TdmFinals, dmFinals);
  Application.CreateForm(TfrmHelp, frmHelp);
  Application.Run;
end.
