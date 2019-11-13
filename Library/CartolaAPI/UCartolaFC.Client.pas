unit UCartolaFC.Client;

interface

uses
  System.Classes,
  System.Net.HTTPClient,
  System.Net.HttpClientComponent,
  System.Net.URLClient,
  System.JSON,

  { Indy }
  IdHTTP,

  { CartolaFC }
  UCartolaFC.Types;

type

  TCartolaClient = class
  private
//    FHTTP: TIdHTTP;
    FHTTP: TNetHTTPClient;
    procedure HandleOnHTTPNeedClientCertificate(const Sender: TObject; const ARequest: TURLRequest; const ACertificateList: TCertificateList; var AnIndex: Integer);
    procedure HandleOnHTTPValidateServerCertificate(const Sender: TObject; const ARequest: TURLRequest; const Certificate: TCertificate; var Accepted: Boolean);
    procedure HandleOnHTTPComplete(const Sender: TObject; const AResponse: IHTTPResponse);
    procedure HandleOnHTTPReceiveData(const Sender: TObject; AContentLength: Int64; AReadCount: Int64; var Abort: Boolean);
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
    FClubes: TClubes;
    FOnReady: TNotifyEvent;
  protected
    function GetURL: string; override;
    procedure ProcessHTTPResponse(const Data: string); override;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    property Clubes: TClubes read FClubes write FClubes;
    property OnReady: TNotifyEvent read FOnReady write FOnReady;
  end;

  TCartolaPartidas = class(TCartolaClient)
  private
    FPartidas: TPartidas;
    FOnReady: TNotifyEvent;
  protected
    function GetURL: string; override;
    procedure ProcessHTTPResponse(const Data: string); override;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    property Partidas: TPartidas read FPartidas write FPartidas;
    property OnReady: TNotifyEvent read FOnReady write FOnReady;
  end;

implementation

uses
  System.SysUtils,
  System.Generics.Collections,
  System.Threading;

{$REGION 'TCartolaClient'}
constructor TCartolaClient.Create;
begin

  inherited Create;

//  FHTTP := TIdHTTP.Create(nil);
  FHTTP := TNetHTTPClient.Create(nil);
//  FHTTP := THTTPClient.Create;
//  FHTTP.Asynchronous := true;

//  FHTTP.NeedClientCertificateCallback
  FHTTP.OnReceiveData               := HandleOnHTTPReceiveData;
  FHTTP.OnNeedClientCertificate     := HandleOnHTTPNeedClientCertificate;
  FHTTP.OnValidateServerCertificate := HandleOnHTTPValidateServerCertificate;

//  FHTTP.Asynchronous       := FALSE;
//  FHTTP.OnRequestCompleted := HandleOnHTTPComplete;

//  Start;

end;

destructor TCartolaClient.Destroy;
begin

  FHTTP.Free;

  inherited Destroy;

end;

procedure TCartolaClient.HandleOnHTTPComplete(const Sender: TObject; const AResponse: IHTTPResponse{TIdHTTPResponse});
begin

//  if AResponse.StatusCode = 200 then
//  begin
//    ProcessHTTPResponse(AResponse.ContentAsString)
    //    AResponse.ContentStream.Position := 0;
//    ProcessHTTPResponse(TEncoding.UTF8.GetString(TBytes(TMemoryStream(AResponse.ContentStream).Memory), 0, AResponse.ContentStream.Size));
//  end;

end;

procedure TCartolaClient.HandleOnHTTPNeedClientCertificate(const Sender: TObject; const ARequest: TURLRequest; const ACertificateList: TCertificateList; var AnIndex: Integer);
begin
//
end;

procedure TCartolaClient.HandleOnHTTPReceiveData(const Sender: TObject;
  AContentLength, AReadCount: Int64; var Abort: Boolean);
begin
//
end;

procedure TCartolaClient.HandleOnHTTPValidateServerCertificate(const Sender: TObject; const ARequest: TURLRequest;
  const Certificate: TCertificate; var Accepted: Boolean);
begin
  Accepted := TRUE;
end;

procedure TCartolaClient.Start;
begin

//  TTask.Run(
//  procedure
//  begin
//    var Stream := TMemoryStream.Create;
//    try
//      FHTTP.Get(GetURL, Stream);
//      HandleOnHTTPComplete(Self, FHTTP.Response);
      HandleOnHTTPComplete(Self, FHTTP.Get(GetURL));
//    finally
//      Stream.Free;
//    end;
//  end);

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
constructor TCartolaClubes.Create;
begin

  inherited Create;

  FClubes := TClubes.Create;

end;

destructor TCartolaClubes.Destroy;
begin

  FClubes.Free;

  inherited Destroy;

end;

function TCartolaClubes.GetURL: string;
begin

  Result := 'https://api.cartolafc.globo.com/clubes';

end;

procedure TCartolaClubes.ProcessHTTPResponse(const Data: string);
begin

  var JSON := TJSONObject.ParseJSONValue(Data) AS TJSONObject;
  try

    for var Item in JSON do
    begin
      var Clube := TClube.FromJsonString(Item.JsonValue.ToString);
      Clubes.Add(Clube);
    end;

  finally
    JSON.Free;
  end;

  Clubes.Sort;

  TThread.Synchronize(nil,
  procedure
  begin
    if Assigned(FOnReady) then
      FOnReady(Self);
  end);

end;
{$ENDREGION}

{$REGION 'TCartolaPartidas'}
constructor TCartolaPartidas.Create;
begin

  inherited Create;

  FPartidas := TPartidas.Create;

end;

destructor TCartolaPartidas.Destroy;
begin

  FPartidas.Free;

  inherited Destroy;

end;

function TCartolaPartidas.GetURL: string;
begin

  Result := 'https://api.cartolafc.globo.com/partidas';

end;

procedure TCartolaPartidas.ProcessHTTPResponse(const Data: string);
var
  JPartidas: TJSONArray;
begin

  var JSON := TJSONObject.ParseJSONValue(Data) AS TJSONObject;
  try

    if not JSON.TryGetValue<TJSONArray>('partidas', JPartidas) then
      Exit;

    for var Item in JPartidas do
    begin
      var Partida := TPartida.FromJsonString(Item.ToString);
      Partidas.Add(Partida);
    end;

  finally
    JSON.Free;
  end;

  TThread.Synchronize(nil,
  procedure
  begin
    if Assigned(FOnReady) then
      FOnReady(Self);
  end);

end;
{$ENDREGION}

end.
