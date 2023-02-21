unit Unit1;

interface

uses
  System.SysUtils, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TForm1 = class(TForm)
    lvwDSN: TListView;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  Aeonsoft.ODBC,
  Generics.Collections;


procedure TForm1.FormCreate(Sender: TObject);
var
  DSN : TDSNInfo;
  DSNList : TList<TDSNInfo>;
  Item : TListItem;
begin
  DSNList := GetDSN([dsnUser]);
  for dsn in DSNList do
  begin
    Item := lvwDSN.Items.Add;
    Item.GroupID := 0;
    Item.Caption := DSN.Name;
    Item.SubItems.Add(DSN.Driver);
  end;
  DSNList.Free;


  DSNList := GetDSN([dsnSystem]);
  for dsn in DSNList do
  begin
    Item := lvwDSN.Items.Add;
    Item.GroupID := 1;
    Item.Caption := DSN.Name;
    Item.SubItems.Add(DSN.Driver);
  end;
  DSNList.Free;
end;

end.
