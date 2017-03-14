unit SrchUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, UPTTreeList;

type
  TQueryForm = class(TForm)
    QueryEdit: TEdit;
    GroupBox1: TGroupBox;
    ArtistBox: TCheckBox;
    TitleBox: TCheckBox;
    AlbumBox: TCheckBox;
    CommentsBox: TCheckBox;
    GenreBox: TCheckBox;
    FNameBox: TCheckBox;
    TagMaskBox: TCheckBox;
    OKBtn: TButton;
    ResultLV: TPTListView;
    Label1: TLabel;
    CancelBtn: TButton;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure AddAllItems;
    procedure QueryEditChange(Sender: TObject);
    procedure FilterItems(s : string);
    procedure DoAutoFit;
    procedure DecPos;
    procedure IncPos;
    procedure AddItem(i : integer);
    procedure FilterChanged;
    procedure QueryEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ArtistBoxClick(Sender: TObject);
    procedure TitleBoxClick(Sender: TObject);
    procedure AlbumBoxClick(Sender: TObject);
    procedure CommentsBoxClick(Sender: TObject);
    procedure GenreBoxClick(Sender: TObject);
    procedure FNameBoxClick(Sender: TObject);
    procedure TagMaskBoxClick(Sender: TObject);
    procedure ResultLVDblClick(Sender: TObject);
    procedure SetLVTopItem(it : integer);
    procedure ClearList;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var QueryForm: TQueryForm;
    LastSt : string = '';

procedure QueryItems;

implementation uses Main,commctrl;

{$R *.DFM}

procedure TQueryForm.ClearList;
begin
  ResultLV.Items.BeginUpdate;
  ResultLV.Items.Clear;
  ResultLV.Items.EndUpdate;
end;

procedure TQueryForm.SetLVTopItem(it : integer);
begin
  with ResultLV do if (it >= 0)and(it < Items.Count) then
  begin
    Items[Items.Count - 1].Focused := true;
    with Items[it] do
    begin
      Focused := true;
      MakeVisible(true);{}
    end;
    Selected := nil;
    Selected := Items[it];
  end;
end;

procedure TQueryForm.DoAutoFit;
var i : integer;
begin
{  MainForm.PlayList.Items.BeginUpdate;{}
  with ResultLV.Columns do
  begin
    for i:=0 to count-1 do
    begin
      Items[i].Width := -1;{}
      Items[i].Width := ListView_GetColumnWidth(ResultLV.Columns.Owner.Handle, I);{}
    end;
  end;
{  MainForm.PlayList.Items.EndUpdate;{}
end;

procedure TQueryForm.AddItem(i : integer);
begin
  with ResultLV.Items.Add do
  begin
    Caption := MainForm.PlayList.Items[i].Caption;
    while SubItems.Count < 8 do SubItems.Add('');
    SubItems[0] := MainForm.PlayList.Items[i].SubItems[0];
    SubItems[1] := MainForm.PlayList.Items[i].SubItems[1];
    SubItems[2] := MainForm.PlayList.Items[i].SubItems[2];
    SubItems[3] := MainForm.PlayList.Items[i].SubItems[3];
    SubItems[4] := MainForm.PlayList.Items[i].SubItems[4];
    SubItems[5] := MainForm.PlayList.Items[i].SubItems[5];
    SubItems[6] := MainForm.PlayList.Items[i].SubItems[6];
    SubItems[7] := inttostr(MainForm.PlayList.Items[i].Index);
  end;
end;

procedure TQueryForm.AddAllItems;
var i : integer;
begin
  ResultLV.Items.BeginUpdate;
{  ResultLV.Items.Assign(MainForm.PlayList.Items);}
  for i := 0 to MainForm.PlayList.Items.Count - 1 do AddItem(i);
  ResultLV.Items.EndUpdate;
end;

procedure TQueryForm.FilterItems(s : string);

  function GoodItem(li : tlistitem) : boolean;
  begin
    Result := false;
    if li <> nil then with li do
    begin
      Result := true;
      if ArtistBox.Checked then
      begin
        Result := pos(s,ansiuppercase(Caption)) < 1;
      end;
      if (Result)and(TitleBox.Checked) then
      begin
        Result := pos(s,ansiuppercase(Subitems[0])) < 1;
      end;
      if (Result)and(AlbumBox.Checked) then
      begin
         Result := pos(s,ansiuppercase(Subitems[1])) < 1;
      end;
(* Год
      if (Result)and(YearBox.Checked) then
      begin
         Result := pos(s,ansiuppercase(Subitems[5]);
      end;
*)
      if (Result)and(CommentsBox.Checked) then
      begin
         Result := pos(s,ansiuppercase(Subitems[3])) < 1;
      end;
      if (Result)and(GenreBox.Checked) then
      begin
         Result := pos(s,ansiuppercase(Subitems[4])) < 1;
      end;
(* Время
      if (Result)and(TimeBox.Checked) then
      begin
         Result := pos(s,ansiuppercase(Subitems[5]);
      end;
*)
      if (Result)and(FNameBox.Checked) then
      begin
         Result := pos(s,ansiuppercase(Subitems[6])) < 1;
      end;
      Result := not Result;
    end;
  end;

var i : integer;
    ts : string;
    f : boolean;

begin
  ResultLV.Items.BeginUpdate;
  s := AnsiUpperCase(s);
  if (s = '')and(LastSt <> '') then
  begin
    ResultLV.Items.Clear;
    AddAllItems;
  end else
  begin
    f := true;
    if LastSt <> '' then
    begin
      ts := ansiuppercase(LastSt);
      if pos(ts,s) <> 1 then
      begin
        f := false;
        ResultLV.Items.Clear;
        for i := MainForm.PlayList.Items.Count - 1 downto 0 do if GoodItem(MainForm.PlayList.Items[i]) then AddItem(i);
      end;
    end;
    if f then
    begin
      for i := ResultLV.Items.Count - 1 downto 0 do if not GoodItem(ResultLV.Items[i]) then ResultLV.Items[i].Delete;
    end;
  end;
  if ResultLV.Items.Count > 0 then
  begin
    ResultLV.Selected := ResultLV.Items[0];
    ResultLV.Items[0].Focused := true;
  end;
  ResultLV.Items.EndUpdate;
end;

procedure QueryItems;
var t,i,e : integer;
begin
  with TQueryForm.Create(Application) do
  try
    case ShowModal of
    mrOK:
      begin
        if ResultLV.ItemFocused <> nil then
        begin
          val(ResultLV.ItemFocused.SubItems[7],i,e);
          if e = 0 then
          begin
            SetTopItem(i);
            PlayItem(i);
          end;
        end;
      end;
    mrYes:
      begin
        MainForm.PlayList.Selected := nil;
        for i := 0 to ResultLV.Items.Count - 1 do
        begin
          if ResultLV.Items[i] <> nil then
          begin
            val(ResultLV.Items[i].SubItems[7],t,e);
            if e = 0 then
            begin
              if t < MainForm.PlayList.Items.Count then
                MainForm.PlayList.Items[t].Selected := true;
            end;
          end;
        end;
      end;
    end;
   finally
    Free;
  end;
end;

procedure TQueryForm.FormCreate(Sender: TObject);
begin
  ClearList;
  AddAllItems;{}
  DoAutoFit;
  if ResultLV.Items.Count > 0 then
  begin
    ResultLV.Selected := ResultLV.Items[0];
    ResultLV.Items[0].Focused := true;
  end;
end;

procedure TQueryForm.FilterChanged;
var s : string;
begin
  s := QueryEdit.Text;
  FilterItems(s);
  LastSt := s;
end;

procedure TQueryForm.QueryEditChange(Sender: TObject);
begin
  FilterChanged;
end;

procedure TQueryForm.DecPos;
var i : integer;
begin
  with ResultLV do
  begin
    if ItemFocused <> nil then
    begin
      i := ItemFocused.Index;
      if i > 0 then dec(i) else i := Items.Count - 1;
      SetLVTopItem(i);
      Items[i].Focused := true;
      Selected := Items[i];
    end;
  end;
end;

procedure TQueryForm.IncPos;
var i : integer;
begin
  with ResultLV do
  begin
    if ItemFocused <> nil then
    begin
      i := ItemFocused.Index;
      if i < Items.Count - 1 then inc(i) else i := 0;
      SetLVTopItem(i);
      Items[i].Focused := true;
      Selected := Items[i];
    end;
  end;
end;

procedure TQueryForm.QueryEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = VK_DOWN) then IncPos else
  if (key = VK_UP) then DecPos else
  ;
end;

procedure TQueryForm.ArtistBoxClick(Sender: TObject);
begin
{  FilterChanged;{}
end;

procedure TQueryForm.TitleBoxClick(Sender: TObject);
begin
{  FilterChanged;{}
end;

procedure TQueryForm.AlbumBoxClick(Sender: TObject);
begin
{  FilterChanged;{}
end;

procedure TQueryForm.CommentsBoxClick(Sender: TObject);
begin
{  FilterChanged;{}
end;

procedure TQueryForm.GenreBoxClick(Sender: TObject);
begin
{  FilterChanged;{}
end;

procedure TQueryForm.FNameBoxClick(Sender: TObject);
begin
{  FilterChanged;{}
end;

procedure TQueryForm.TagMaskBoxClick(Sender: TObject);
begin
{  FilterChanged;{}
end;

procedure TQueryForm.ResultLVDblClick(Sender: TObject);
begin
  if not MouseEn then
  if ResultLV.ItemFocused <> nil then
  begin
(*
      SetTopItem(i);
      PlayItem(i);
*)
    ModalResult := mrOK;
  end;
end;

end.
