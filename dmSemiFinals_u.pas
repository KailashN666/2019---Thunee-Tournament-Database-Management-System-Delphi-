unit dmSemiFinals_u;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB;

type
  TdmSemiFinals = class(TDataModule)
    conSemiFinals: TADOConnection;
    dsSemiFinals: TDataSource;
    tblSemiFinals: TADOTable;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmSemiFinals: TdmSemiFinals;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
