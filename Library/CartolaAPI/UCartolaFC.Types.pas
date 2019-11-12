unit UCartolaFC.Types;

interface

uses
  System.Generics.Collections,
  System.Generics.Defaults,
  REST.JSON,
  System.JSON;

type
//
//  TCartolaLists<T> = class(TObjectList<T>)
//  public type
//    TEnumerator = class
//    private
//      FIndex: Integer;
//      FList: TCartolaLists<T>;
//    public
//      constructor Create(const AList: TCartolaLists<T>);
//      function GetCurrent: t; inline;
//      function MoveNext: Boolean; inline;
//      property Current: T read GetCurrent;
//    end;
//  end;

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
    FId: Integer;
    FNome: string;
    FNome_fantasia: string;
  public
    property abreviacao: string read FAbreviacao write FAbreviacao;
    property escudos: TEscudos read FEscudos write FEscudos;
    property id: Integer read FId write FId;
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
    procedure Sort;
    function Locate(ClubeID: Integer): TClube;
    function GetEnumerator: TEnumerator; inline;
  end;

  TClubesComparer = class(TDelegatedComparer<TClube>)
    function Compare(const Left, Right: TClube): Integer;  
    function Equals(const Left, Right: TClube): Boolean;
    function GetHashCode(const Value: TClube): Integer;
  end;

  TTransmissao = class
  private
    FLabel: string;
    FUrl: string;
  public
    property &Label: string read FLabel write FLabel;
    property url: string read FUrl write FUrl;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TTransmissao;
  end;

  TPartida = class
  private
    FAproveitamento_mandante: TArray<string>;
    FAproveitamento_visitante: TArray<string>;
    FClube_casa_id: Integer;
    FClube_casa_posicao: Integer;
    FClube_visitante_id: Integer;
    FClube_visitante_posicao: Integer;
    FLocal: String;
    FPartida_data: TDateTime;
    FPartida_id: Integer;
    FTransmissao: TTransmissao;
    FUrl_confronto: String;
    FUrl_transmissao: String;
    FValida: Boolean;
  public
    property aproveitamento_mandante: TArray<String> read FAproveitamento_mandante write FAproveitamento_mandante;
    property aproveitamento_visitante: TArray<String> read FAproveitamento_visitante write FAproveitamento_visitante;
    property clube_casa_id: Integer read FClube_casa_id write FClube_casa_id;
    property clube_casa_posicao: Integer read FClube_casa_posicao write FClube_casa_posicao;
    property clube_visitante_id: Integer read FClube_visitante_id write FClube_visitante_id;
    property clube_visitante_posicao: Integer read FClube_visitante_posicao write FClube_visitante_posicao;
    property local: String read FLocal write FLocal;
    property partida_data: TDateTime read FPartida_data write FPartida_data;
    property partida_id: Integer read FPartida_id write FPartida_id;
    property transmissao: TTransmissao read FTransmissao write FTransmissao;
    property url_confronto: String read FUrl_confronto write FUrl_confronto;
    property url_transmissao: String read FUrl_transmissao write FUrl_transmissao;
    property valida: Boolean read FValida write FValida;
    constructor Create;
    destructor Destroy; override;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TPartida;
  end;

  TPartidas = class(TObjectList<TPartida>)
  public type
    TEnumerator = class
    private
      FIndex: Integer;
      FList: TPartidas;
    public
      constructor Create(const AList: TPartidas);
      function GetCurrent: TPartida; inline;
      function MoveNext: Boolean; inline;
      property Current: TPartida read GetCurrent;
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

{$REGION 'TClubes'}

{$REGION 'TClubes.Enumerator'}
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
{$ENDREGION}

function TClubes.GetEnumerator: TEnumerator;
begin
  Result := TEnumerator.Create(Self);
end;

function DoCompare(const Left, Right: TClube): Integer;
begin
  if Left.id > Right.id then  
    Result := 1
  else if Left.id < Right.id then  
    Result := -1
  else if Left.id = Right.id then  
    Result := 0;
end;

function DoEqual(const Left, Right: TClube): Boolean;
begin
  Result := Left.id = Right.id;
end;

function DoHash(const Value: TClube): Integer;
var
  FGetHashCode: THasher<TClube>;
begin
  Result := FGetHashCode(Value);
end;

function TClubes.Locate(ClubeID: Integer): TClube;
begin

  var Clube := TClube.Create;
  try

    Clube.id  := ClubeID;
    var Index  := -1;

    var FComparer := TClubesComparer.Create(DoCompare);      
    try
      TArray.BinarySearch<TClube>(Self.ToArray, Clube, Index, FComparer);
      Result := Self.Items[Index];
    finally
      FComparer.Free;
    end;

  finally
    Clube.Free;
  end;
  
end;

procedure TClubes.Sort;
begin            
  var Comparer := TComparer<TClube>.Construct(DoCompare);
  inherited Sort(Comparer);
end;

{$ENDREGION}

{$REGION 'TClubesComparer'}
function TClubesComparer.Compare(const Left, Right: TClube): Integer;
begin
  Result := DoCompare(Left, Right);
end;

function TClubesComparer.Equals(const Left, Right: TClube): Boolean;
begin
  Result := DoEqual(Left, Right);
end;

function TClubesComparer.GetHashCode(const Value: TClube): Integer;
begin
  Result := DoHash(Value);
end;
{$ENDREGION}

{$REGION 'TTransmissao'}
function TTransmissao.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TTransmissao.FromJsonString(AJsonString: string): TTransmissao;
begin
  result := TJson.JsonToObject<TTransmissao>(AJsonString)
end;
{$ENDREGION}

{$REGION 'TPartida'}

{$REGION 'TPartidas.TEnumerator'}
constructor TPartidas.TEnumerator.Create(const AList: TPartidas);
begin
  inherited Create;
  FIndex := -1;
  FList := AList;
end;

function TPartidas.TEnumerator.GetCurrent: TPartida;
begin
  Result := FList[FIndex];
end;

function TPartidas.TEnumerator.MoveNext: Boolean;
begin
  Inc(FIndex);
  Result := FIndex < FList.Count;
end;
{$ENDREGION}

constructor TPartida.Create;
begin
  inherited;
  FTransmissao := TTransmissao.Create();
end;

destructor TPartida.Destroy;
begin
  FTransmissao.Free;
  inherited;
end;

function TPartida.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TPartida.FromJsonString(AJsonString: string): TPartida;
begin
  result := TJson.JsonToObject<TPartida>(AJsonString)
end;

function TPartidas.GetEnumerator: TEnumerator;
begin
  Result := TEnumerator.Create(Self);
end;
{$ENDREGION}

end.
