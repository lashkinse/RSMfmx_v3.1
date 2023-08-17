﻿unit RSM.Config;

interface

type
  TRSMConfig = class
  private
  { Private Types }
    // Licensing
    type
      TRSMConfigLicense = record
        licenseKey: string;
      end;
    // UI
    type
      TRSMConfigIU = record // Saved on main form destroy event except nav, serverinfo
        navIndex: Integer;  // Saved on index change
        windowPosX: Integer;
        windowPosY: Integer;
        windowHeight: Single;
        windowWidth: Single;
        ShowServerInfoPanel: Boolean; // Saved on btnShowHideServerInfoClick
        serverInstallerBranchIndex: Integer; // Item index for server installer branch
      end;
  private
      { Private Variables }
    FConfigFile: string;
  private
      { Private Methods }
    function GetConfigFile: string;
  public
    { Public Variables }
    License: TRSMConfigLicense;
    UI: TRSMConfigIU;
  public
    { Public Methods }
    constructor Create;
    procedure SaveConfig;
    procedure LoadConfig;
  end;

var
  rsmConfig: TRSMConfig;

implementation

uses
  XSuperObject, System.SysUtils, System.IOUtils, uframeMessageBox, FMX.Forms;

{ TRSMConfig }

constructor TRSMConfig.Create;
begin
  // Licensing
  Self.License.LicenseKey := '';

  // UI
  Self.UI.navIndex := 0;
  Self.UI.windowPosX := 0;
  Self.UI.windowPosY := 0;
  Self.UI.windowHeight := 600;
  Self.UI.windowWidth := 1000;
  Self.UI.ShowServerInfoPanel := True;
  Self.UI.serverInstallerBranchIndex := 0;

  // Setup Methods
  Self.FConfigFile := Self.GetConfigFile;

  // Load Config
  Self.LoadConfig;
end;

function TRSMConfig.GetConfigFile: string;
begin
  Result := ExtractFilePath(ParamStr(0)) + 'rsm\cfg\rsmConfig.json';
end;

procedure TRSMConfig.LoadConfig;
begin
   // Check if config file exists
  if not TFile.Exists(Self.FConfigFile) then
  begin
    Self.SaveConfig;
    Exit;
  end;

  // Load Config
  Self.AssignFromJSON(TFile.ReadAllText(Self.FConfigFile, TEncoding.UTF8));

  // Save Config again after loading to populate new properties in the file.
  Self.SaveConfig;

  // Check Params
  for var I := 1 to System.ParamCount do
  begin
    var param := System.ParamStr(I).ToLower;

    // Reset
    if param = '-reset' then
    begin
      // Skip if there's no options supplied
      if I + 1 > System.ParamCount then
        Continue;

      var paramOption := System.ParamStr(I + 1).ToLower;

      // Window Pos
      if paramOption = 'windowpos' then
      begin
        Self.UI.windowPosX := 0;
        Self.UI.windowPosY := 0;

        Self.SaveConfig;
      end;

      // Window Size
      if paramOption = 'windowsize' then
      begin
        Self.UI.windowHeight := 600;
        Self.UI.windowWidth := 1000;

        Self.SaveConfig;
      end;
    end;
  end;
end;

procedure TRSMConfig.SaveConfig;
begin
  if not TDirectory.Exists(ExtractFileDir(Self.FConfigFile)) then
    ForceDirectories(ExtractFilePath(Self.FConfigFile));

  TFile.WriteAllText(Self.FConfigFile, Self.AsJSON(True), TEncoding.UTF8);
end;

end.

