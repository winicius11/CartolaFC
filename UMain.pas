unit UMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListView;

type
  TForm1 = class(TForm)
    ListView1: TListView;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  UCartolaFC.Client,
  UCartolaFC.Utils;

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
begin

  var Clubes := TCartolaClubes.Create;
  try
//    Clubes.Start;
  finally
    Clubes.Free;
  end;

  ListView1.BeginUpdate;
  try

    for var i := 0 to 1 do
    begin

      var Item := ListView1.Items.Add;

      Item.Bitmap := CreateBitmapFromURL('https://s.glbimg.com/es/sde/f/organizacoes/2014/04/14/palmeiras_60x60.png');

    end;

  finally
    ListView1.EndUpdate;
  end;

end;

end.
