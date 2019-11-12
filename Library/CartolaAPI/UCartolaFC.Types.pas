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

    class function Fromstring(const Data: string): TTime;

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
    F30x30: string;
    F45x45: string;
    F60x60: string;
  public
    property p30x30: string read F30x30 write F30x30;
    property p45x45: string read F45x45 write F45x45;
    property p60x60: string read F60x60 write F60x60;
    function ToJsonstring: string;
    class function FromJsonstring(AJsonstring: string): TEscudos;
  end;

  TClube = class
  private
    FAbreviacao: string;
    FEscudos: TEscudos;
    FId: Extended;
    FNome: string;
    FNome_fantasia: string;
  public
    property abreviacao: string read FAbreviacao write FAbreviacao;
    property escudos: TEscudos read FEscudos write FEscudos;
    property id: Extended read FId write FId;
    property nome: string read FNome write FNome;
    property nome_fantasia: string read FNome_fantasia write FNome_fantasia;
    constructor Create;
    destructor Destroy; override;
    function ToJsonstring: string;
    class function FromJsonstring(AJsonstring: string): TClube;
  end;

  TClubes = class(TObjectList<TClube>)
  public type

    TEnumerator = class
    private
      FIndex: Integer;
      FList: TClubes;
    public
      constructor Create(const AList: TClubes);
      function GetCurrent: TClube; inline;
      function MoveNext: Boolean; inline;
      property Current: TClube read GetCurrent;
    end;
  public

    function GetEnumerator: TEnumerator; inline;

  end;

implementation

{$REGION 'TTime'}
class function TTime.Fromstring(const Data: string): TTime;
begin

  Result := TTime.Create;
  Result := TJson.JsonToObject<TTime>(Data);

end;
{$ENDREGION}

{$REGION 'TEscudos'}
function TEscudos.ToJsonstring: string;
begin
  result := TJson.ObjectToJsonstring(self);
end;

class function TEscudos.FromJsonstring(AJsonstring: string): TEscudos;
begin
  result := TJson.JsonToObject<TEscudos>(AJsonstring)
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

function TClube.ToJsonstring: string;
begin
  result := TJson.ObjectToJsonstring(self);
end;

class function TClube.FromJsonstring(AJsonString: string): TClube;
begin
  result := TJson.JsonToObject<TClube>(AJsonString)
end;
{$ENDREGION}

{ TClubes.TEnumerator }

constructor TClubes.TEnumerator.Create(const AList: TClubes);
begin
  inherited Create;
  FIndex := -1;
  FList := AList;
end;

function TClubes.TEnumerator.GetCurrent: TClube;
begin
  Result := FList[FIndex];
end;

function TClubes.TEnumerator.MoveNext: Boolean;
begin
  Inc(FIndex);
  Result := FIndex < FList.Count;
end;

{ TClubes }

function TClubes.GetEnumerator: TEnumerator;
begin
  Result := TEnumerator.Create(Self);
end;

end.
