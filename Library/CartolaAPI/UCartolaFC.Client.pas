unit UCartolaFC.Client;

interface

uses
  System.Classes,
  System.Net.HTTPClient,
  System.Net.HttpClientComponent,
  System.JSON,
  UCartolaFC.Types;

type

  TCartolaClient = class
  private

    FHTTP: TNetHTTPClient;

    procedure HandleOnHTTPComplete(const Sender: TObject; const AResponse: IHTTPResponse);

  protected

    function GetURL: string; virtual; abstract;

    procedure ProcessHTTPResponse(const Data: string); virtual; abstract;

  public

    constructor Create; reintroduce;
    destructor Destroy; override;

    procedure Start;

  end;

  TCartolaRequestStatusMercado = class(TCartolaClient)
  protected

    function GetURL: string; override;

    procedure ProcessHTTPResponse(const Data: string); override;

  end;

  TOnBuscaTimeInfo = reference to procedure(Time: TTime);
  TCartolaRequestTimeInfo = class(TCartolaClient)
  private

    FSlug: string;
    FRodada: Integer;
    FCallback: TOnBuscaTimeInfo;

  protected

    function GetURL: string; override;

    procedure ProcessHTTPResponse(const Data: string); override;

  public

    constructor Create(const Slug: string; Rodada: Integer; CallBack: TOnBuscaTimeInfo);

  end;

  TOnBuscaTimesResult = reference to procedure(Times: TArray<TTime>);
  TCartolaBuscaTimes = class(TCartolaClient)
  private

    FCallback: TOnBuscaTimesResult;

    FTimeNome: string;

  protected

    function GetURL: string; override;

    procedure ProcessHTTPResponse(const Data: string); override;

  public

    constructor Create(Time: string; Callback: TOnBuscaTimesResult);

    property Time: string read FTimeNome write FTimeNome;

  end;

  TCartolaClubes = class(TCartolaClient)
  private
  protected
    function GetURL: string; override;
    procedure ProcessHTTPResponse(const Data: string); override;
  public
  end;

implementation

uses
  System.SysUtils,
  System.Generics.Collections;

{$REGION 'TCartolaClient'}
constructor TCartolaClient.Create;
begin

  inherited Create;

  FHTTP                    := TNetHTTPClient.Create(nil);
  FHTTP.Asynchronous       := FALSE;
  FHTTP.OnRequestCompleted := HandleOnHTTPComplete;

//  Start;

end;

destructor TCartolaClient.Destroy;
begin

  FHTTP.Free;

  inherited Destroy;

end;

procedure TCartolaClient.HandleOnHTTPComplete(const Sender: TObject; const AResponse: IHTTPResponse);
begin

  if AResponse.StatusCode = 200 then
    ProcessHTTPResponse(AResponse.ContentAsString);

end;
procedure TCartolaClient.Start;
begin

  HandleOnHTTPComplete(Self, FHTTP.Get(GetURL));

end;

{$ENDREGION}

{$REGION 'TCartolaRequestStatusMercado'}
function TCartolaRequestStatusMercado.GetURL: string;
begin

  Result := 'https://api.cartolafc.globo.com/mercado/status';

end;

procedure TCartolaRequestStatusMercado.ProcessHTTPResponse(const Data: string);
begin
//
end;
{$ENDREGION}

{$REGION 'TCartolaRequestTimeInfo'}
constructor TCartolaRequestTimeInfo.Create(const Slug: string; Rodada: Integer;
  CallBack: TOnBuscaTimeInfo);
begin

  FRodada := Rodada;
  FSlug   := Slug;

  FCallback := CallBack;

  inherited Create;

end;

function TCartolaRequestTimeInfo.GetURL: string;
begin

  Result := Format('https://api.cartolafc.globo.com/time/slug/%s/%d', [FSlug, FRodada]);

end;

procedure TCartolaRequestTimeInfo.ProcessHTTPResponse(const Data: string);
var
  Time: TTime;
begin

  Time := TTime.FromString(Data);

  TThread.Synchronize(TThread.Current,
  procedure
  begin
    FCallback(Time);
  end);

end;
{$ENDREGION}

{$REGION 'TCartolaBuscaTimes'}
constructor TCartolaBuscaTimes.Create(Time: string;
  Callback: TOnBuscaTimesResult);
begin

  FCallback := Callback;
  FTimeNome := Time;

  inherited Create;

end;

function TCartolaBuscaTimes.GetURL: string;
begin

  Result := 'https://api.cartolafc.globo.com/times?q=' + FTimeNome;

end;

procedure TCartolaBuscaTimes.ProcessHTTPResponse(const Data: string);
var
  JSONObj: TJSONObject;
  JSONArray: TJSONArray;
  JSONValue: TJSONValue;
  Times: TArray<TTime>;
begin

  JSONArray := TJSONObject.ParseJSONValue(Data) as TJSONArray;

  SetLength(Times, 0);
  for JSONValue in JSONArray do
  begin

    JSONObj := TJSONObject.ParseJSONValue(JSONValue.ToString) as TJSONObject;  

    if not Assigned(JSONObj) then
      Continue;    
    
    SetLength(Times, Length(Times) + 1);
    Times[High(Times)] := TTime.FromString(JSONObj.ToString);

  end;

  TThread.Synchronize(TThread.Current,
  procedure
  begin
    FCallback(Times);
  end);

end;
{$ENDREGION}

{$REGION 'TCartolaClubes'}
function TCartolaClubes.GetURL: string;
begin

  Result := 'https://api.cartolafc.globo.com/clubes';

end;

procedure TCartolaClubes.ProcessHTTPResponse(const Data: string);
var
  Clubes: TClubes;
begin

  Clubes := TClubes.Create;
  try
  
    var JSON := TJSONObject.ParseJSONValue(Data) AS TJSONObject;
    try

      for var Item in JSON do
      begin

        var Clube := TClube.FromJsonString(Item.JsonValue.ToString);
        
      end;

    finally
      JSON.Free;
    end;
      
  finally
    Clubes.Free;
  end;

end;
{$ENDREGION}

end.
