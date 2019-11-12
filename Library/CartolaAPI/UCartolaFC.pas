unit UCartolaFC;

interface

uses
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

implementation

{$REGION 'TTime'}
class function TTime.FromString(const Data: string): TTime;
begin

  Result := TTime.Create;
  Result := TJson.JsonToObject<TTime>(Data);

end;
{$ENDREGION}

end.
