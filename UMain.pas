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
  UCartolaFC.Types, FMX.Layouts;

type
  TForm1 = class(TForm)
    ListView1: TListView;
    Layout1: TLayout;
    procedure ListView1PullRefresh(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListView1Click(Sender: TObject);
  private
    Clubes: TCartolaClubes;
    Partidas: TCartolaPartidas;

    procedure HandleOnReady(Sender: TObject);
    procedure HandleOnPartidasReady(Sender: TObject);
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


procedure TForm1.HandleOnReady(Sender: TObject);
begin

  TTask.Run(
  procedure
  begin

//    for var Clube in Clubes.Clubes do
//    begin
//
//      ListView1.BeginUpdate;
//      try
//
//        var Item := ListView1.Items.Add;
//        Item.Text := Format('%d - %s', [Clube.id, Clube.nome_fantasia]);
//
//      finally
//        ListView1.EndUpdate;
//      end;
//
//    end;

    Partidas.Start;

  end);

end;

procedure TForm1.ListView1Click(Sender: TObject);
begin
  {$IFDEF WIN32}
    ListView1PullRefresh(Self);
  {$ENDIF}
end;

procedure TForm1.ListView1PullRefresh(Sender: TObject);
begin

  Clubes         := TCartolaClubes.Create;
  Clubes.OnReady := HandleOnReady;
  Clubes.Start;

  Partidas := TCartolaPartidas.Create;
  Partidas.OnReady := HandleOnPartidasReady;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  {$IFDEF WIN32}
    ListView1PullRefresh(Self);
  {$ENDIF}
end;

procedure TForm1.HandleOnPartidasReady(Sender: TObject);
begin

  for var Partida in Partidas.Partidas do
  begin

    ListView1.BeginUpdate;
    try

      var Mandante  := Clubes.Clubes.Locate(Partida.clube_casa_id);
      var Visitante := Clubes.Clubes.Locate(Partida.clube_visitante_id);

      var Item := ListView1.Items.Add;

      Item.Objects.FindObjectT<TListItemImage>('Image2').Bitmap := CreateBitmapFromURL(Mandante.escudos.p45x45);
      Item.Objects.FindObjectT<TListItemImage>('Image3').Bitmap := CreateBitmapFromURL(Visitante.escudos.p45x45);
      Item.Objects.FindObjectT<TListItemText>('Text1').Text     := Format('%s  x  %s', [Mandante.nome_fantasia, Visitante.nome_fantasia]);

    finally
      ListView1.EndUpdate;
    end;

    ListView1.Visible := TRUE;



  end;

end;

end.
