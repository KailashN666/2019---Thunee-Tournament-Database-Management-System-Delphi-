unit dmFinals_u;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB;

type
  TdmFinals = class(TDataModule)
    conFinals: TADOConnection;
    tblFinals: TADOTable;
    dsFinals: TDataSource;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmFinals: TdmFinals;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
