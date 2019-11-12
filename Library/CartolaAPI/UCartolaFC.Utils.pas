unit UCartolaFC.Utils;

interface

uses
  FMX.Graphics;

function CreateBitmapFromURL(const URL: string): TBitmap;

implementation

uses
  System.Net.HTTPClientComponent;

function CreateBitmapFromURL(const URL: string): TBitmap;
begin

  Result := TBitmap.Create;

  var HTTP := TNetHTTPClient.Create(nil);
  try

    var Response := HTTP.Get(URL);
    Result.LoadFromStream(Response.ContentStream);

  finally
    HTTP.Free;
  end;

end;


end.
