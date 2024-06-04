unit dmPlayers_u;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB;

type
  TdmPlayers = class(TDataModule)
    tblPlayers: TADOTable;
    dsPlayers: TDataSource;
    ConPlayers: TADOConnection;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmPlayers: TdmPlayers;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
