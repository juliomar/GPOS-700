program Project1;

uses
  System.StartUpCopy,
  FMX.Forms,
  uPagamento in 'uPagamento.pas' {frmPagamento},
  G700Interface in 'G700Interface.pas',
  GEDIPrinter in 'GEDIPrinter.pas',
  uG700 in 'uG700.pas' {frmMain},
  uPgto in 'uPgto.pas' {frmPgto};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmPagamento, frmPagamento);
  Application.CreateForm(TfrmPgto, frmPgto);
  Application.Run;
end.
