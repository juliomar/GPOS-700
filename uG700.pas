unit uG700;

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
  FMX.Objects,
  FMX.Layouts,
  System.ImageList,
  FMX.ImgList,
  FMX.StdCtrls,
  FMX.Controls.Presentation,
  FMX.Edit,
  uPgto;

type
  TfrmMain = class(TForm)
    lytMain: TLayout;
    imgFundo: TImage;
    imgImagens: TImageList;
    tmrInicio: TTimer;
    lytLogin: TLayout;
    edtUsuario: TEdit;
    rctEntrar: TRoundRect;
    btnEntrar: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure tmrInicioTimer(Sender: TObject);
    procedure btnEntrarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

procedure TfrmMain.btnEntrarClick(Sender: TObject);
begin
  frmPgto.inicia();
  frmPgto.Show;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  lytLogin.Visible := false;
  imgFundo.Bitmap.Assign(imgImagens.Source.Items[0].MultiResBitmap[0].Bitmap);
  tmrInicio.Enabled := true;
end;

procedure TfrmMain.tmrInicioTimer(Sender: TObject);
begin
  tmrInicio.Enabled := false;
  lytLogin.Visible := true;
  lytLogin.Width := frmMain.Width;
  lytLogin.Margins.Top := 310;
  imgFundo.Bitmap.Assign(imgImagens.Source.Items[1].MultiResBitmap[0].Bitmap);
  edtUsuario.SetFocus;
end;

end.
