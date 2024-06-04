unit dmTeams_u;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB;

type
  TdmTeams = class(TDataModule)
    conTeams: TADOConnection;
    tblTeams: TADOTable;
    dsTeams: TDataSource;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmTeams: TdmTeams;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
