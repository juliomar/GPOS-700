unit uPgto;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.Controls.Presentation,
  FMX.Layouts,
  FMX.Objects,
  Androidapi.Helpers,
  G700Interface,
  GEDIPrinter,
  GER7TEF,
  System.Threading,
  FMX.Surfaces,
  System.ImageList,
  FMX.ImgList;

type
  TfrmPgto = class(TForm)
    lytTeclado: TLayout;
    gpnTeclado: TGridPanelLayout;
    btn1: TSpeedButton;
    btn2: TSpeedButton;
    btn3: TSpeedButton;
    btn4: TSpeedButton;
    btn5: TSpeedButton;
    btn6: TSpeedButton;
    btn7: TSpeedButton;
    btn8: TSpeedButton;
    btn9: TSpeedButton;
    btnC: TSpeedButton;
    btn0: TSpeedButton;
    lblValorTransacao: TLabel;
    lytPgto: TLayout;
    imgReturn: TImage;
    btnReturn: TSpeedButton;
    lytDados: TLayout;
    imgfundo: TImage;
    lytMensagem: TLayout;
    lblMensagem: TLabel;
    procedure btnTecladoTAP(Sender: TObject; const Point: TPointF);
    procedure btnCClick(Sender: TObject);
    procedure btnReturnClick(Sender: TObject);

  const
    NORMAL = false;
    BOLD = true;
    GER7_VENDA = '1';
    GER7_CANCELAMENTO = '2';
    GER7_FUNCOES = '3';
    GER7_DESABILITA_IMPRESSAO = '0';
    GER7_HABILITA_IMPRESSAO = '1';
    GER7_CREDITO = '1';
    GER7_DEBITO = '2';
    GER7_VOUCHER = '4';
    GER7_SEMPARCELAMENTO = '0';
    GER7_PARCELADO_LOJA = '1';
    GER7_PARCELADO_ADM = '2';
  private
    FValorTransacao: string;
    { Private declarations }
    procedure FormataValor();
    procedure Transaciona();
    function Numeric(numero: string): string;
    procedure EnviaTEF(Tipo, Id, Amount, Parcelas, TipoParcelamento, Product, HabilitaImpressao: string);

  public
    { Public declarations }
    procedure inicia();
  end;

var
  frmPgto: TfrmPgto;

implementation

{$R *.fmx}

procedure TfrmPgto.btnCClick(Sender: TObject);
begin
  FValorTransacao := '0';
  FormataValor();
end;

procedure TfrmPgto.btnReturnClick(Sender: TObject);
begin
  Transaciona();
end;

procedure TfrmPgto.btnTecladoTAP(Sender: TObject; const Point: TPointF);
begin
  FValorTransacao := FValorTransacao + TSpeedButton(Sender).Text;
  FormataValor();
end;

procedure TfrmPgto.EnviaTEF(Tipo, Id, Amount, Parcelas, TipoParcelamento, Product, HabilitaImpressao: string);
var
  bTask: ITask;
begin
  ExecuteTEF(Tipo, Id, Amount, Parcelas, TipoParcelamento, Product, HabilitaImpressao);

  bTask := TTask.Create(
    procedure
    var
      res: integer;
    begin

      while TEFExecuteFlag = 0 do
      begin
        sleep(500);
      end;

      res := transacao.response;

      if (res = 0) and (TEFExecuteFlag = 1) then
      begin

        TThread.Synchronize(nil,
          procedure
          begin
            FValorTransacao := '0';
            FormataValor();
            lblMensagem.FontColor := TAlphaColorRec.Green;
            lblMensagem.Text := 'Transação aprovada!';
          end);

      end
      else
      begin
        TThread.Synchronize(nil,
          procedure
          begin
            FValorTransacao := '0';
            FormataValor();
            lblMensagem.FontColor := TAlphaColorRec.Red;
            lblMensagem.Text := 'Transação negada!';
          end);
      end;
      TEFExecuteFlag := 0;
    end);
  bTask.Start;
end;

procedure TfrmPgto.FormataValor;
var
  lValor: Extended;
begin

  if (lblMensagem.Text <> 'Digite o valor!') then
  begin
    lblMensagem.FontColor := TAlphaColorRec.Black;
    lblMensagem.Text := 'Digite o valor!';
  end;

  lValor := StrToFloat(FValorTransacao);
  if lValor > 0 then
    lValor := lValor / 100;
  lblValorTransacao.Text := FormatFloat('#0.,00', lValor);
end;

procedure TfrmPgto.inicia;
begin
  FValorTransacao := '0';
  FormataValor();

end;

function TfrmPgto.Numeric(numero: string): string;
var
  i, iPos: integer;
  ch: char;
  strResult: string;
begin
  iPos := Pos(',', numero);
  iPos := length(numero) - iPos;
  case iPos of
    0:
      numero := numero + '00';
    1:
      numero := numero + '0';
  end;

  strResult := '';
  for i := 0 to length(numero) - 1 do
  begin
    ch := numero[i];
    if (ch >= '0') and (ch <= '9') then
      strResult := strResult + ch;
  end;
  result := strResult;
end;

procedure TfrmPgto.Transaciona;
var
  Produto, HabilitaImpressao, Parcelas, TipoParcelamento: String;
begin
  try
    HabilitaImpressao := GER7_HABILITA_IMPRESSAO;
    Produto := GER7_CREDITO;
    Parcelas := '1';
    TipoParcelamento := GER7_SEMPARCELAMENTO;
    TipoParcelamento := GER7_PARCELADO_LOJA;

    EnviaTEF(GER7_VENDA, '123456', Numeric(FValorTransacao), Parcelas, TipoParcelamento, Produto, HabilitaImpressao);

  except
    on e: exception do
    begin
      ShowMessage('Erro=>' + e.Message);
    end;
  end;
end;

end.
