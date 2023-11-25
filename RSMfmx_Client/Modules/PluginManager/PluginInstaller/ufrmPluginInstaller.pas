﻿unit ufrmPluginInstaller;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, udmStyles,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects,
  FMX.TabControl;

type
  TfrmPluginInstaller = class(TForm)
    lytNav: TLayout;
    grdpnllytBottomNav: TGridPanelLayout;
    rctnglNavuMod: TRectangle;
    lblNavuMod: TLabel;
    rctnglNavCodeFling: TRectangle;
    lblNavCodeFling: TLabel;
    rctnglNavLoneDesign: TRectangle;
    lblNavLoneDesign: TLabel;
    tbcVendors: TTabControl;
    tbtmuMod: TTabItem;
    tbtmCodeFling: TTabItem;
    tbtmLoneDesign: TTabItem;
    procedure FormCreate(Sender: TObject);
    procedure OnNavItemClick(Sender: TObject);
    procedure OnNavItemMouseEnter(Sender: TObject);
    procedure OnNavItemMouseLeave(Sender: TObject);
  private
    { Private Const }
    const
      UI_COLOR_DEFAULT = $FF1F222A;
      UI_COLOR_HOVER = $FF6F0000;
      UI_COLOR_SELECTED = $FF900000;
  private
    { Private declarations }
    procedure CreateStores;
  public
    { Public declarations }
  end;

var
  frmPluginInstaller: TfrmPluginInstaller;

implementation

uses
  ufrmuMod;

{$R *.fmx}

procedure TfrmPluginInstaller.CreateStores;
begin
  // uMod
  frmuMod := TfrmuMod.Create(tbtmuMod);
  while frmuMod.ChildrenCount > 0 do
    frmuMod.Children[0].Parent := tbtmuMod;
end;

procedure TfrmPluginInstaller.FormCreate(Sender: TObject);
begin
  {$IFDEF RELEASE}
  tbcVendors.TabPosition := TTabPosition.None;
  {$ENDIF}

  CreateStores;

  // Default nav uMod
  OnNavItemClick(rctnglNavuMod);
end;

procedure TfrmPluginInstaller.OnNavItemClick(Sender: TObject);
begin
  // Unselect other nav Items
  for var aControl in grdpnllytBottomNav.Controls do
  begin
    if aControl is TRectangle then
      TRectangle(aControl).Fill.Color := UI_COLOR_DEFAULT;
  end;

  // Change Nav Tab
  if (Sender = rctnglNavuMod) then // uMod
    tbcVendors.TabIndex := tbtmuMod.Index
  else if (Sender = rctnglNavCodeFling) then // CodeFling
    tbcVendors.TabIndex := tbtmCodeFling.Index
  else if (Sender = rctnglNavLoneDesign) then // Lone Design
    tbcVendors.TabIndex := tbtmLoneDesign.Index;

  // Mark current nav Item as selected
  (Sender as TRectangle).Fill.Color := UI_COLOR_SELECTED;
end;

procedure TfrmPluginInstaller.OnNavItemMouseEnter(Sender: TObject);
begin
  if (Sender as TRectangle).Fill.Color <> UI_COLOR_SELECTED then
    (Sender as TRectangle).Fill.Color := UI_COLOR_HOVER;
end;

procedure TfrmPluginInstaller.OnNavItemMouseLeave(Sender: TObject);
begin
  if (Sender as TRectangle).Fill.Color <> UI_COLOR_SELECTED then
    (Sender as TRectangle).Fill.Color := UI_COLOR_DEFAULT
end;

end.

