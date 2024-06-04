unit Admin_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Grids, Vcl.DBGrids, dmTeams_u, dmPlayers_u, dmManagerDetails_u, Math,
  Vcl.Imaging.jpeg;

type
  TfrmAdmin = class(TForm)
    grpAdmin: TGroupBox;
    pnlAdmin: TPanel;
    btnResetScoreboard: TButton;
    btnDeleteAManager: TButton;
    btnAddANewManager: TButton;
    btnAddNewTeam: TButton;
    btnDeleteTeam: TButton;
    btnChangeDetailsOfTeam: TButton;
    grpTeams: TGroupBox;
    grpManager: TGroupBox;
    btnAmountTeams: TButton;
    grpPlayer: TGroupBox;
    btnAverageTournament: TButton;
    btnAverageGame: TButton;
    TeamGrid: TDBGrid;
    PlayerGrid: TDBGrid;
    ManagerGrid: TDBGrid;
    rgpHideShow: TRadioGroup;
    grpManagerOptions: TGroupBox;
    btnAmountManagers: TButton;
    grpTournamentAnalyses: TGroupBox;
    grpTeamOptions: TGroupBox;
    grpNewTeam: TGroupBox;
    lblSurname: TLabel;
    lblName: TLabel;
    edtSurname: TEdit;
    edtName: TEdit;
    edtDOB: TEdit;
    btnConfirm: TButton;
    lblDOB: TLabel;
    rgpEditTeam: TRadioGroup;
    Image1: TImage;
    procedure rgpHideShowClick(Sender: TObject);
    procedure btnAddNewTeamClick(Sender: TObject);
    Function CheckIfTeamNameIsPresent (sLine : String) : Boolean;
    Function CheckIfManagerPresent (sManager : String) : Boolean;
    procedure btnConfirmClick(Sender: TObject);
    Procedure ResetTeamRecordScores;
    Procedure ChangeInTeamTable (sTeamName: String; sFieldName : string; iValue : Integer);
    Procedure DeleteFromPlayerTable (sTeamName : String);
    Function SumInTeamsTable(sFieldName : String) : Integer;
    procedure btnAmountTeamsClick(Sender: TObject);
    procedure btnAmountManagersClick(Sender: TObject);
    procedure btnAddANewManagerClick(Sender: TObject);
    procedure btnDeleteAManagerClick(Sender: TObject);
    procedure btnResetScoreboardClick(Sender: TObject);
    procedure btnAverageTournamentClick(Sender: TObject);
    procedure btnAverageGameClick(Sender: TObject);
    procedure btnDeleteTeamClick(Sender: TObject);
    procedure btnChangeDetailsOfTeamClick(Sender: TObject);
    procedure rgpEditTeamClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAdmin: TfrmAdmin;
  sP1Name, sP1Surname, sP1DOB : String;

implementation

{$R *.dfm}

procedure TfrmAdmin.btnAddANewManagerClick(Sender: TObject);
Var
  sUsername : String;
  sPassword : String;
  bCheck : Boolean;
begin
  if MessageDlg('You will now be required to enter details to register a manager, Is this okay?', mtConfirmation, mbYesNo, 0) = mrYes then
  Begin
    sUsername := InputBox('Username','Please Input the Username of the new Manager','');

    if (sUsername = '') or (CheckIfManagerPresent(sUsername) = True) then
    Begin
      bCheck := True;

      repeat
        MessageDlg('You have not entered a unique Username, please re-enter a unique Username.', mtError, mbOKCancel, 0);
        sUsername := InputBox('Username','Please Input the Username of the new Manager','');
        bCheck := CheckIfManagerPresent(sUsername);
      until (bCheck = False);
    End;

    MessageDlg('Congratulations! The Username meets the requirements. You will now be required to enter a password, Make sure you enter it without errors.', mtConfirmation, mbOKCancel, 0);

    sPassword := InputBox('Password','Please enter a Password.','');

    if MessageDlg('The password you have choosen is ' + sPassword + ', Are you happy with this password? ',mtConfirmation, mbYesNo, 0) = mrYes then
    Begin
      MessageDlg('Congratulations on registering a Manager, the Manager will be added to the Database.', mtInformation, mbOKCancel, 0);
    End
    Else
    Begin
      sPassword := InputBox('Password','Please enter a Password.','');
    End;

    dmManagerDetails.tblManagerDetails.Last;
    dmManagerDetails.tblManagerDetails.Insert;

    dmManagerDetails.tblManagerDetails['Username'] := sUsername;
    dmManagerDetails.tblManagerDetails['Password'] := sPassword;

    dmManagerDetails.tblManagerDetails.Post;
    dmManagerDetails.tblManagerDetails.First;

    MessageDlg('Register Confirmation: ' +#13+ 'Username: ' + sUsername +#13+ 'Password: ' + sPassword, mtInformation, mbOKCancel, 0);

  End
  Else
  Begin
    MessageDlg('Re-Click the button when you wish to register a new Manager.', mtInformation, mbOKCancel, 0);
  End;

end;

procedure TfrmAdmin.btnAddNewTeamClick(Sender: TObject);
begin
  if MessageDlg('When you add a new team to the database, you will be required to enter the details of two players as there are two players in a team, is this okay?', mtConfirmation, mbYesNo, 0)  = mrYes then
  Begin
    grpNewTeam.Enabled := True;
    grpNewTeam.Show;
    grpNewTeam.Caption := 'Player 1 Details';
  End
  else
  Begin
    grpNewTeam.Enabled := False;
    grpNewTeam.Hide;
    grpNewTeam.Caption := 'Adding a new Team';
  End;
end;

procedure TfrmAdmin.btnAmountManagersClick(Sender: TObject);
Var
  iManagers : Integer;
begin
  iManagers := dmManagerDetails.tblManagerDetails.RecordCount;

  if iManagers = 1 then
  Begin
    MessageDlg('There is a number of 1 manager registered.', mtInformation, mbOKCancel, 0);
  End
  Else
  Begin
    MessageDlg('There are a number of ' + IntToStr(iManagers) + ' managers registered.', mtInformation, mbOKCancel, 0);
  End;
end;

procedure TfrmAdmin.btnAmountTeamsClick(Sender: TObject);
Var
  iTeams : Integer;
begin
  iTeams := dmTeams.tblTeams.RecordCount;
  if iTeams = 1 then
  Begin
    MessageDlg('There is a number of 1 team registered.', mtInformation, mbOKCancel, 0);
  End
  Else
  Begin
    MessageDlg('There are a number of ' + IntToStr(iTeams) + ' teams registered.', mtInformation, mbOKCancel, 0);
  End;
end;

procedure TfrmAdmin.btnAverageGameClick(Sender: TObject);
Var
  sFieldName : String;
  iGames : Integer;
  rGames : Real;
begin
  sFieldName := 'GamesWon';

  iGames := SumInTeamsTable(sFieldName);

  rGames := iGames / dmTeams.tblTeams.RecordCount;

  MessageDlg('The average amount of games won are: ' + FloatToStrF(rGames, ffFixed, 5,2), mtInformation ,mbOKCancel ,0 );
end;

procedure TfrmAdmin.btnAverageTournamentClick(Sender: TObject);
Var
  iTournaments : Integer;
  sFieldName : String;
  rTournaments : Real;
begin
  sFieldName := 'TournamentsWon';
  iTournaments := SumInTeamsTable(sFieldName);

  rTournaments := iTournaments / dmTeams.tblTeams.RecordCount;

  MessageDlg('The average amount of Tournaments Won are: ' + FloatToStrF(rTournaments, ffFixed, 5,2), mtInformation , mbOKCancel, 0);

end;

procedure TfrmAdmin.btnChangeDetailsOfTeamClick(Sender: TObject);
Var
  sTeamName : String;
begin
  if MessageDlg('With this option, you will be able to change the details of the Team Name that you enter, Is this what you would like?', mtConfirmation,mbYesNo , 0) = mrYes then
  Begin
    sTeamName := InputBox('Edit','Enter the Name of the Team that you wish to edit.','');

    if CheckIfTeamNameIsPresent(sTeamName) = True then
    Begin
      rgpEditTeam.Caption := sTeamName;
      rgpEditTeam.Visible := True;
    End
    Else
    Begin
      MessageDlg('The Team name has not been located hence details for the Team can not be edited.',mtInformation,mbOKCancel,0);
    End;
  End
  Else
  Begin
    rgpEditTeam.Visible := False;
    rgpEditTeam.Caption := 'Edit Team';
    MessageDlg('Re-Click the button when you wish to change details of a Team', mtInformation,mbOKCancel, 0);
  End;

end;

procedure TfrmAdmin.btnConfirmClick(Sender: TObject);
Var
  bCheck : Boolean;
  sP2Name, sP2Surname, sP2DOB, sP1ID, sP2ID, sTeamName, sTeamID : String;
begin
  if btnConfirm.Caption = 'Confirm Player 1 Details' then
  Begin
    sP1Name := edtName.Text;
    sP1Surname := edtSurname.Text;
    sP1DOB := edtDOB.Text;

    if (sP1Name <> '') and (sP1Surname <> '') and (sP1DOB <> '') then
    begin
      edtName.Clear;
      edtSurname.Clear;
      edtDOB.Clear;
      MessageDlg('Valid player information for player one has been provided successfully. Please enter the details for Player two.', mtInformation, mbOKCancel, 0);
      grpNewTeam.Caption := 'Player 2 Details';
      btnConfirm.Caption := 'Confirm Player 2 Details';
    end
    else
    begin
      edtName.Clear;
      edtSurname.Clear;
      edtDOB.Clear;
      edtName.SetFocus;

      MessageDlg('The details that you have entered have not been entered correctly, Please re-enter the Player details.', mtError, mbOKCancel, 0);
    end;
  End
  else
  begin
    sP2Name := edtName.Text;
    sP2Surname := edtSurname.Text;
    sP2DOB := edtDOB.Text;

    if (sP2Name <> '') and (sP2Surname <> '') and (sP2DOB <> '') then
    Begin
      edtName.Clear;
      edtSurname.Clear;
      edtDOB.Clear;

      MessageDlg('Congratulations! Details for both players of the team has been entered correctly. Please be aware that automated Player IDs have been generated for both Players. You will now have to enter a Team Name.', mtInformation, mbOKCancel, 0);

      if MessageDlg('Entering a Team Name is very important because once it is entered it can not be changed. Make sure that the team name is not the same as other team names. Do you accept the terms?', mtConfirmation, mbYesNo, 0) = mrYes then
      Begin
        sP1ID := sP1Name[1] + sP1Surname[1] + IntToStr(RandomRange(100, 1000));
        sP2ID := sP2Name[1] + sP2Surname[1] + IntToStr(RandomRange(100, 1000));

        sTeamName := InputBox('Team Name','Please input a unique Team Name for the new Team.','');
        sTeamName := Trim(sTeamName);

        if CheckIfTeamNameIsPresent(sTeamName) = True then
        Begin
          bCheck := True;

          repeat
            MessageDlg('The Team Name already exists in the database, Please enter a valid Team Name', mtError, mbOKCancel, 0);
            sTeamName := InputBox('Team Name','Please input a unique Team Name for the new Team.','');
            sTeamName := Trim(sTeamName);
            bCheck := CheckIfTeamNameIsPresent(sTeamName);
          until (bCheck = False);
        End;

        MessageDlg('Congratulations! The Team name is valid. The details of the Team will now be entered into the Database.', mtInformation, mbOKCancel, 0);

        sTeamID := sTeamName[1] + sTeamName[Length(sTeamName)] + sTeamName[Length(sTeamName)-2] + IntToStr(RandomRange(100, 1000));

        dmTeams.tblTeams.Last;
        dmTeams.tblTeams.Insert;

        dmTeams.tblTeams['TeamID'] := sTeamID;
        dmTeams.tblTeams['TeamName'] := sTeamName;
        dmTeams.tblTeams['GamesWon'] := 0;
        dmTeams.tblTeams['MinigamesWon'] := 0;
        dmTeams.tblTeams['MinigamesLost'] := 0;
        dmTeams.tblTeams['TournamentsWon'] := 0;
        dmTeams.tblTeams['TournamentsEntered'] := 0;
        dmTeams.tblTeams['DateRegistered'] := Now;

        dmTeams.tblTeams.Post;
        grpNewTeam.Enabled := False;
        btnConfirm.Caption := 'Confirm Player 1 Details';
        grpNewTeam.Caption := 'Adding a new Team';
        grpNewTeam.Enabled := False;
        TeamGrid.Refresh;

        dmPlayers.tblPlayers.Last;
        dmPlayers.tblPlayers.Insert;

        dmPlayers.tblPlayers['TeamName'] := sTeamName;
        dmPlayers.tblPlayers['PlayerID'] := sP1ID;
        dmPlayers.tblPlayers['PlayerName'] := sP1Name;
        dmPlayers.tblPlayers['PlayerSurname'] := sP1Surname;
        dmPlayers.tblPlayers['PlayerDOB'] := sP1DOB;

        dmPlayers.tblPlayers.Post;

        dmPlayers.tblPlayers.Insert;

        dmPlayers.tblPlayers['TeamName'] := sTeamName;
        dmPlayers.tblPlayers['PlayerID'] := sP2ID;
        dmPlayers.tblPlayers['PlayerName'] := sP2Name;
        dmPlayers.tblPlayers['PlayerSurname'] := sP2Surname;
        dmPlayers.tblPlayers['PlayerDOB'] := sP2DOB;

        dmPlayers.tblPlayers.Post;

        MessageDlg('The Team has been added successfully!', mtInformation, mbOKCancel, 0);

        grpNewTeam.Hide;
        TeamGrid.Refresh;
        PlayerGrid.Refresh;
      End
      else
      begin
        MessageDlg('The team will not be entered into the database until a Team Name is entered. Please re-enter Team Details.', mtInformation, mbOKCancel, 0);
        btnConfirm.Caption := 'Confirm Player 1 Details';
        grpNewTeam.Caption := 'Adding a New Team';
      end;

    End
    else
    begin
      edtName.Clear;
      edtSurname.Clear;
      edtDOB.Clear;
      edtName.SetFocus;

      MessageDlg('The details that you have entered have not been entered correctly, Please re-enter the Player details.', mtError, mbOKCancel, 0);
    end;
  end;


end;

procedure TfrmAdmin.btnDeleteAManagerClick(Sender: TObject);
Var
  sUsername : String;
  I : Integer;
begin
  if MessageDlg('You have chosen to delete a Manager, Are you okay with this?', mtConfirmation, mbYesNo, 0) = mrYes then
  Begin
    sUsername := InputBox('Username','Please enter the Username of the Manager you wish to delete.','');

    if CheckIfManagerPresent(sUsername) = True then
    Begin
      if MessageDlg('You have chosen to remove Manager ' + sUsername + ', Can you confirm this? ', mtConfirmation, mbYesNo, 0)=mrYes then
      Begin
        dmManagerDetails.tblManagerDetails.First;

        for I := 1 to dmManagerDetails.tblManagerDetails.RecordCount do
        begin
          if UpperCase(dmManagerDetails.tblManagerDetails['Username']) = UpperCase(sUsername) then
          Begin
            dmManagerDetails.tblManagerDetails.Delete;
            TeamGrid.Refresh;
            MessageDlg('Delete Confirmation: ' +#13+ 'Username: ' + sUsername, mtInformation,mbOKCancel, 0);
            Break
          End;

          dmManagerDetails.tblManagerDetails.Next;
        end;
      End
      Else
      Begin
        MessageDlg('The Manager has not been removed.', mtInformation, mbOKCancel, 0);
      End;
    End
    Else
    Begin
      MessageDlg('The Username entered does not exist hence can not be removed from the Manager database.', mtInformation, mbOKCancel, 0);
    End;

  End
  Else
  Begin
    MessageDlg('Re-Click the button when you wish to remove a Manager.', mtInformation, mbOKCancel, 0);
  End;
end;

procedure TfrmAdmin.btnDeleteTeamClick(Sender: TObject);
Var
  sTeamName : String;
  I: Integer;
begin
  if MessageDlg('You will be required to enter the name of the Team you wish to delete, Is this okay?', mtConfirmation, mbYesNo, 0) = mrYes then
  Begin
    sTeamName := InputBox('Delete','Enter the name of the Team you wish to Delete.','');

    if CheckIfTeamNameIsPresent(sTeamName) = True then
    Begin
      If MessageDlg('You have chosen to delete the Team ' + sTeamName + ' from the Database, Can you confirm this? ',mtConfirmation,mbYesNo, 0 ) = mrYes Then
      Begin
        dmTeams.tblTeams.First;

        DeleteFromPlayerTable(sTeamName);

        for I := 1 to dmTeams.tblTeams.RecordCount do
        begin
          if dmTeams.tblTeams['TeamName'] = sTeamName then
          Begin
            dmTeams.tblTeams.Delete;
            TeamGrid.Refresh;
            Break
          End;

          dmTeams.tblTeams.Next;
        end;

        dmTeams.tblTeams.First;

        MessageDlg('Delete Confirmation: ' +#13+ 'Team Name: ' + sTeamName,mtInformation, mbOKCancel, 0);
      End
      Else
      Begin
        MessageDlg('The Team has not been deleted from the Database. ',mtInformation, mbOKCancel,0 );
      End;
    End
    Else
    Begin
      MessageDlg('The Team Name has not been found in the database hence cannot be removed.', mtInformation,mbOKCancel, 0);
    End;
  End
  Else
  Begin
    MessageDlg('Re-Click the button when you wish to Delete a Team from the Database', mtInformation, mbOKCancel, 0);
  End;
end;

procedure TfrmAdmin.btnResetScoreboardClick(Sender: TObject);
var
  I: Integer;
begin
  dmTeams.tblTeams.First;

  for I := 1 to dmTeams.tblTeams.RecordCount do
  begin
    dmTeams.tblTeams.Edit;
    ResetTeamRecordScores;
    dmTeams.tblTeams.Post;
    dmTeams.tblTeams.Next;
  end;

  MessageDlg('The Score Values has been Reset.', mtInformation,mbOKCancel,0);
end;



procedure TfrmAdmin.ChangeInTeamTable(sTeamName, sFieldName: string;
  iValue: Integer);
var
  I: Integer;
begin
  dmTeams.tblTeams.First;

  for I := 1 to dmTeams.tblTeams.RecordCount do
  begin
    if dmTeams.tblTeams['TeamName'] = sTeamName then
    Begin
      dmTeams.tblTeams.Edit;
      dmTeams.tblTeams[sFieldName] := iValue;
      dmTeams.tblTeams.Post;
      TeamGrid.Refresh;
    End;

    dmTeams.tblTeams.Next;
  end;

  dmTeams.tblTeams.First;
end;

function TfrmAdmin.CheckIfManagerPresent(sManager: String): Boolean;
var
  I: Integer;
  bPresent : Boolean;
begin
  dmManagerDetails.tblManagerDetails.First;
  bPresent := False;

  while (bPresent = False) and (not dmManagerDetails.tblManagerDetails.Eof) do
  Begin
    if UpperCase(sManager) = UpperCase(dmManagerDetails.tblManagerDetails['Username']) then
    begin
      bPresent := True;
    end;

    dmManagerDetails.tblManagerDetails.Next;
  End;

  dmManagerDetails.tblManagerDetails.First;

  if bPresent = False then
  Begin
    Result := False;
  End
  else
  Begin
    Result := True;
  End;
end;

function TfrmAdmin.CheckIfTeamNameIsPresent(sLine: String): Boolean;
var
  I: Integer;
  bPresent : Boolean;
begin
  dmTeams.tblTeams.First;
  bPresent := False;

  while (bPresent = False) and (not dmTeams.tblTeams.Eof) do
  Begin
    if sLine = dmTeams.tblTeams['TeamName'] then
    begin
      bPresent := True;
    end;

    dmTeams.tblTeams.Next;
  End;

  dmTeams.tblTeams.First;

  if bPresent = False then
  Begin
    Result := False;
  End
  else
  Begin
    Result := True;
  End;
end;

procedure TfrmAdmin.DeleteFromPlayerTable(sTeamName: String);
var
  I: Integer;
begin
  dmPlayers.tblPlayers.First;
  for I := 1 to dmPlayers.tblPlayers.RecordCount do
  begin
    if dmPlayers.tblPlayers['TeamName'] = sTeamName then
    Begin
      dmPlayers.tblPlayers.Delete;
      PlayerGrid.Refresh;
      dmPlayers.tblPlayers.Refresh;
    End;

    dmPlayers.tblPlayers.Next;
  end;

  dmPlayers.tblPlayers.First;
end;

procedure TfrmAdmin.rgpEditTeamClick(Sender: TObject);
Var
  iChange : Integer;
  sFieldName : String;
begin
  case rgpEditTeam.ItemIndex of
    0 : Begin
          rgpEditTeam.ItemIndex := -1;
          sFieldName := 'GamesWon';
          iChange := StrToInt(InputBox('Edit','Input the value of Games Won.',''));
          if MessageDlg('You have chosen to change the Games won value for the Team ' + rgpEditTeam.Caption + ' to ' + IntToStr(iChange) + ', Can you confirm this?', mtConfirmation, mbYesNo, 0) = mrYes then
          Begin
            ChangeInTeamTable(rgpEditTeam.Caption, sFieldName, iChange);
            MessageDlg('Edit/Update Confirmation: ' +#13+ 'Team Name: ' + rgpEditTeam.Caption + #13+ 'Games Won: ' + IntToStr(iChange), mtInformation,mbOKCancel, 0);
            rgpEditTeam.Caption := 'Edit Team';
            rgpEditTeam.Visible := False;
          End
          Else
          Begin
            MessageDlg('The value has not been changed.' ,mtInformation ,mbOKCancel ,0);
            rgpEditTeam.Caption := 'Edit Team';
            rgpEditTeam.Visible := False;
          End;
        End;

    1 : Begin
          rgpEditTeam.ItemIndex := -1;
          sFieldName := 'MinigamesWon';
          iChange := StrToInt(InputBox('Edit','Input the value of Minigames Won.',''));
          if MessageDlg('You have chosen to change the Minigames Won value for the Team ' + rgpEditTeam.Caption + ' to ' + IntToStr(iChange) + ', Can you confirm this?', mtConfirmation, mbYesNo, 0) = mrYes then
          Begin
            ChangeInTeamTable(rgpEditTeam.Caption, sFieldName, iChange);
            MessageDlg('Edit/Update Confirmation: ' +#13+ 'Team Name: ' + rgpEditTeam.Caption + #13+ 'Minigames Won: ' + IntToStr(iChange), mtInformation,mbOKCancel, 0);
            rgpEditTeam.Caption := 'Edit Team';
            rgpEditTeam.Visible := False;
          End
          Else
          Begin
            MessageDlg('The value has not been changed.' ,mtInformation ,mbOKCancel ,0);
            rgpEditTeam.Caption := 'Edit Team';
            rgpEditTeam.Visible := False;
          End;
        End;

    2 : Begin
          rgpEditTeam.ItemIndex := -1;
          sFieldName := 'MinigamesLost';
          iChange := StrToInt(InputBox('Edit','Input the value of Minigames Lost.',''));
          if MessageDlg('You have chosen to change the Minigames Lost value for the Team ' + rgpEditTeam.Caption + ' to ' + IntToStr(iChange) + ', Can you confirm this?', mtConfirmation, mbYesNo, 0) = mrYes then
          Begin
            ChangeInTeamTable(rgpEditTeam.Caption, sFieldName, iChange);
            MessageDlg('Edit/Update Confirmation: ' +#13+ 'Team Name: ' + rgpEditTeam.Caption + #13+ 'Minigames Lost: ' + IntToStr(iChange), mtInformation,mbOKCancel, 0);
            rgpEditTeam.Caption := 'Edit Team';
            rgpEditTeam.Visible := False;
          End
          Else
          Begin
            MessageDlg('The value has not been changed.' ,mtInformation ,mbOKCancel ,0);
            rgpEditTeam.Caption := 'Edit Team';
            rgpEditTeam.Visible := False;
          End;
        End;

    3 : Begin
          rgpEditTeam.ItemIndex := -1;
          sFieldName := 'TournamentsWon';
          iChange := StrToInt(InputBox('Edit','Input the value of Tournaments Won.',''));
          if MessageDlg('You have chosen to change the Tournaments Won value for the Team ' + rgpEditTeam.Caption + ' to ' + IntToStr(iChange) + ', Can you confirm this?', mtConfirmation, mbYesNo, 0) = mrYes then
          Begin
            ChangeInTeamTable(rgpEditTeam.Caption, sFieldName, iChange);
            MessageDlg('Edit/Update Confirmation: ' +#13+ 'Team Name: ' + rgpEditTeam.Caption + #13+ 'Tournaments Won: ' + IntToStr(iChange), mtInformation,mbOKCancel, 0);
            rgpEditTeam.Caption := 'Edit Team';
            rgpEditTeam.Visible := False;
          End
          Else
          Begin
            MessageDlg('The value has not been changed.' ,mtInformation ,mbOKCancel ,0);
            rgpEditTeam.Caption := 'Edit Team';
            rgpEditTeam.Visible := False;
          End;
        End;

    4 : Begin
          rgpEditTeam.ItemIndex := -1;
          sFieldName := 'TournamentsEntered';
          iChange := StrToInt(InputBox('Edit','Input the value of Tournaments Entered.',''));
          if MessageDlg('You have chosen to change the Tournaments Entered value for the Team ' + rgpEditTeam.Caption + ' to ' + IntToStr(iChange) + ', Can you confirm this?', mtConfirmation, mbYesNo, 0) = mrYes then
          Begin
            ChangeInTeamTable(rgpEditTeam.Caption, sFieldName, iChange);
            MessageDlg('Edit/Update Confirmation: ' +#13+ 'Team Name: ' + rgpEditTeam.Caption + #13+ 'Tournaments Entered: ' + IntToStr(iChange), mtInformation,mbOKCancel, 0);
            rgpEditTeam.Caption := 'Edit Team';
            rgpEditTeam.Visible := False;
          End
          Else
          Begin
            MessageDlg('The value has not been changed.' ,mtInformation ,mbOKCancel ,0);
            rgpEditTeam.Caption := 'Edit Team';
            rgpEditTeam.Visible := False;
          End;
        End;
  end;
end;

procedure TfrmAdmin.ResetTeamRecordScores;
begin
  dmTeams.tblTeams['GamesWon'] := 0;
  dmTeams.tblTeams['MinigamesWon'] := 0;
  dmTeams.tblTeams['MinigamesLost'] := 0;
  dmTeams.tblTeams['TournamentsWon'] := 0;
  dmTeams.tblTeams['TournamentsEntered'] := 0;
end;

procedure TfrmAdmin.rgpHideShowClick(Sender: TObject);
begin
  case rgpHideShow.ItemIndex of
    0 : Begin
          rgpHideShow.ItemIndex := -1;
          if grpTeams.Visible = True then
          Begin
            grpTeams.Visible := False;
          End
          Else
          Begin
            grpTeams.Visible := True;
          End;
        End;
    1 : Begin
          rgpHideShow.ItemIndex := -1;
          if grpPlayer.Visible = True then
          Begin
            grpPlayer.Visible := False;
          End
          Else
          Begin
            grpPlayer.Visible := True;
          End;
        End;
    2 : Begin
          rgpHideShow.ItemIndex := -1;
          if grpManager.Visible = True then
          Begin
            grpManager.Visible := False;
          End
          Else
          Begin
            grpManager.Visible := True;
          End;
        End;
  end;
end;

function TfrmAdmin.SumInTeamsTable(sFieldName : String) : Integer;
Var
  iSum, I : Integer;
begin
  iSum := 0;
  dmTeams.tblTeams.First;

  for I := 1 to dmTeams.tblTeams.RecordCount do
  begin
    iSum := iSum + dmTeams.tblTeams[sFieldName];
    dmTeams.tblTeams.Next;
  end;
  dmTeams.tblTeams.First;
  Result := iSum;
end;

end.
