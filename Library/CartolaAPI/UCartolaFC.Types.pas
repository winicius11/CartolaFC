unit UCartolaFC.Types;

interface

uses
  System.Generics.Collections,
  REST.JSON,
  System.JSON;

type

  TStatusMercado = class
  private

    FRodadaAtual: Integer;

  end;

  TTime = class
  private

//    FAtletas: TJSONArray;
    FClubes: TJSONObject;
    FPosicoes: TJSONObject;
    FStatus: TJSONObject;
    FCapitaoId: Integer;
    FTime: TJSONObject;
    FPatrimonio: Integer;
    FEsquemaId: Integer;
    FPontos: Single;
    FValorTime: Single;
    FRodada_Atual: Integer;
    FNome: string;
    FSlug: string;
    FNome_Cartola: string;

//    "esquema_id":1,"pontos":37.489990234375,"valor_time":0,"rodada_atual":1

   public

    class function FromString(const Data: string): TTime;

    property Nome: string read FNome write FNome;
    property Nome_Cartola: string read FNome_Cartola write FNome_Cartola;
    property Slug: string read FSlug write FSlug;
    property Patrimonio: Integer read FPatrimonio write FPatrimonio;
    property Pontos: Single read FPontos write FPontos;
    property Valor_time: Single read FValorTime write FValorTime;
    property Rodada_Atual: Integer read FRodada_Atual write FRodada_Atual;

  end;

  TEscudos = class
  private
    F30x30: String;
    F45x45: String;
    F60x60: String;
  public
    property p30x30: String read F30x30 write F30x30;
    property p45x45: String read F45x45 write F45x45;
    property p60x60: String read F60x60 write F60x60;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TEscudos;
  end;

  TClube = class
  private
    FAbreviacao: String;
    FEscudos: TEscudos;
    FId: Extended;
    FNome: String;
    FNome_fantasia: String;
  public
    property abreviacao: String read FAbreviacao write FAbreviacao;
    property escudos: TEscudos read FEscudos write FEscudos;
    property id: Extended read FId write FId;
    property nome: String read FNome write FNome;
    property nome_fantasia: String read FNome_fantasia write FNome_fantasia;
    constructor Create;
    destructor Destroy; override;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TClube;
  end;

  TClubes = class(TObjectList<TClube>)
  end;

implementation

{$REGION 'TTime'}
class function TTime.FromString(const Data: string): TTime;
begin

  Result := TTime.Create;
  Result := TJson.JsonToObject<TTime>(Data);

end;
{$ENDREGION}

{$REGION 'TEscudos'}
function TEscudos.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TEscudos.FromJsonString(AJsonString: string): TEscudos;
begin
  result := TJson.JsonToObject<TEscudos>(AJsonString)
end;
{$ENDREGION}

{$REGION 'TClube'}
constructor TClube.Create;
begin
  inherited;
  FEscudos := TEscudos.Create();
end;

destructor TClube.Destroy;
begin
  FEscudos.Free;
  inherited;
end;

function TClube.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TClube.FromJsonString(AJsonString: string): TClube;
begin
  result := TJson.JsonToObject<TClube>(AJsonString)
end;
{$ENDREGION}

end.
