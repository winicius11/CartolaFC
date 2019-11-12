unit UMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListView, System.Net.URLClient,
  System.Net.HttpClient, System.Net.HttpClientComponent,

  System.JSON,
  UCartolaFC.Client,
  UCartolaFC.Types;

type
  TForm1 = class(TForm)
    ListView1: TListView;
    Button1: TButton;
    AniIndicator1: TAniIndicator;
    procedure Button1Click(Sender: TObject);
  private
    Clubes: TCartolaClubes;

    procedure HandleOnReady(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses

  System.Threading,

  UCartolaFC.Utils;

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
begin

//  var Response := NetHTTPRequest1.Execute;
//
//
//  Exit;

  Clubes := TCartolaClubes.Create;
  try
    Clubes.OnReady := HandleOnReady;
    Clubes.Start;
  finally
//    Clubes.Free;
  end;
  Exit;



end;

procedure TForm1.HandleOnReady(Sender: TObject);
begin

  AniIndicator1.Enabled := TRUE;

  TTask.Run(
  procedure
  begin

    for var Clube in Clubes.Clubes do
    begin

//      ListView1.Visible := FALSE;

      ListView1.BeginUpdate;
      try

        if Clube.escudos.p60x60.IsEmpty then
          Continue;

        var Item := ListView1.Items.Add;

        Item.Bitmap := CreateBitmapFromURL(Clube.escudos.p60x60);

      finally
        ListView1.EndUpdate;
      end;

      ListView1.Visible := TRUE;
      AniIndicator1.Visible := FALSE;
      AniIndicator1.Enabled := FALSE;

    end;

  end);

end;

end.
