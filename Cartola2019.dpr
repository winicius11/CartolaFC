program Cartola2019;

uses
  System.StartUpCopy,
  FMX.Forms,
  UMain in 'UMain.pas' {Form1},
  UCartolaFC.Client in 'Library\CartolaAPI\UCartolaFC.Client.pas',
  UCartolaFC in 'Library\CartolaAPI\UCartolaFC.pas',
  UCartolaFC.Types in 'Library\CartolaAPI\UCartolaFC.Types.pas',
  UCartolaFC.Utils in 'Library\CartolaAPI\UCartolaFC.Utils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
