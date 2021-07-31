unit Main;

interface

uses
    System.SysUtils,
    System.Variants,
    System.Classes,
    Vcl.Graphics,
    Vcl.Controls,
    Vcl.Forms,
    Vcl.Dialogs,
    Winapi.Windows,
    Winapi.Messages,
    VirtualTrees,
    {$IF CompilerVersion >= 24}
        VirtualTrees.Types,
        {$if CompilerVersion <= 32}
            // this header is added automatically since 10.3 Rio
            VirtualTrees.DrawTree,
        {$IFEND}
    {$IFEND}
    Vcl.ImgList,
    UTWSVGGraphic,
    UTWSVGImageList;

const
    g_CellSize = 195;

type
    {**
     Main form
    }
    TMainForm = class(TForm)
        vdtGridView: TVirtualDrawTree;
        ilImages: TWSVGImageList;

        procedure FormCreate(Sender: TObject);
        procedure vdtGridViewDrawNode(Sender: TBaseVirtualTree; const PaintInfo: TVTPaintInfo);

        private
            { Private declarations }

        public
            { Public declarations }
  end;

var
    MainForm: TMainForm;

implementation
//---------------------------------------------------------------------------
{$R *.dfm}
//---------------------------------------------------------------------------
procedure TMainForm.FormCreate(Sender: TObject);
var
    i:        Integer;
    pColumn:  TVirtualTreeColumn;
begin
    vdtGridView.DefaultNodeHeight := g_CellSize;

    // create 3 columns
    for i := 0 to 2 do
    begin
        pColumn       := vdtGridView.Header.Columns.Add;
        pColumn.Style := vsOwnerDraw;
        pColumn.Width := g_CellSize;
    end;

    // create 100 rows
    for i := 0 to 99 do
        vdtGridView.AddChild(nil, nil);
end;
//---------------------------------------------------------------------------
procedure TMainForm.vdtGridViewDrawNode(Sender: TBaseVirtualTree; const PaintInfo: TVTPaintInfo);
var
    index:  Integer;
    pGlyph: TWSVGGraphic;
begin
    // select the background color
    if (PaintInfo.Node.Index mod 2) = 0 then
    begin
        if (PaintInfo.Column mod 2) = 0 then
            PaintInfo.Canvas.Brush.Color := clWhite
        else
            PaintInfo.Canvas.Brush.Color := $f0f0f0;
    end
    else
    begin
        if (PaintInfo.Column mod 2) = 0 then
            PaintInfo.Canvas.Brush.Color := $f0f0f0
        else
            PaintInfo.Canvas.Brush.Color := clWhite
    end;

    // fill the cell background
    PaintInfo.Canvas.FillRect(PaintInfo.CellRect);

    // calculate the current index
    index := (Integer(PaintInfo.Node.Index) * vdtGridView.Header.Columns.Count) + PaintInfo.Column;

    // draw the glyph
    pGlyph := ilImages.GetSVG(index mod 7);
    pGlyph.SetSize(g_CellSize, g_CellSize);
    pGlyph.Proportional := True;
    PaintInfo.Canvas.Draw(PaintInfo.Column * g_CellSize, 0, pGlyph);
end;
//---------------------------------------------------------------------------

end.
