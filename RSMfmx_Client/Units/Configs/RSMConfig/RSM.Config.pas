﻿unit RSM.Config;

interface

type
  TRSMConfig = class
  private
  { Private Types }
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
        quickServerControls: Boolean; // Quick Server controls under server info
      end;
    // Tray Icon
    type
      TRSMConfigTrayIcon = record
        Enabled: Boolean;
        Title: string;
      end;
      // Auto Restart Server
    type
      TRSMConfigAutoRestartItem = record
        Enabled: Boolean;
        Time: TTime;
        WarningTimeSecs: Integer;
      end;
    type
      TRSMConfigAutoRestart = record
        AutoRestart1: TRSMConfigAutoRestartItem;
        AutoRestart2: TRSMConfigAutoRestartItem;
        AutoRestart3: TRSMConfigAutoRestartItem;
      end;
  public
    { Public Variables }
    UI: TRSMConfigIU;
    TrayIcon: TRSMConfigTrayIcon;
    AutoRestart: TRSMConfigAutoRestart;
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
  XSuperObject, System.SysUtils, System.IOUtils, uframeMessageBox, RSM.Core;

{ TRSMConfig }

constructor TRSMConfig.Create;
begin
  // UI
  Self.UI.navIndex := 0;
  Self.UI.windowPosX := 0;
  Self.UI.windowPosY := 0;
  Self.UI.windowHeight := 600;
  Self.UI.windowWidth := 1000;
  Self.UI.ShowServerInfoPanel := True;
  Self.UI.serverInstallerBranchIndex := 0;
  Self.UI.quickServerControls := True;

  // Tray Icon
  Self.TrayIcon.Enabled := True;
  Self.TrayIcon.Title := 'RSMfmx v3';

  // Auto Restart
  Self.AutoRestart.AutoRestart1.Enabled := False;
  Self.AutoRestart.AutoRestart1.Time := EncodeTime(5, 0, 0, 0);
  Self.AutoRestart.AutoRestart1.WarningTimeSecs := 300;
  Self.AutoRestart.AutoRestart2.Enabled := False;
  Self.AutoRestart.AutoRestart2.Time := EncodeTime(12, 0, 0, 0);
  Self.AutoRestart.AutoRestart2.WarningTimeSecs := 300;
  Self.AutoRestart.AutoRestart3.Enabled := False;
  Self.AutoRestart.AutoRestart3.Time := EncodeTime(17, 0, 0, 0);
  Self.AutoRestart.AutoRestart3.WarningTimeSecs := 300;

  // Load Config
  Self.LoadConfig;
end;

procedure TRSMConfig.LoadConfig;
begin
   // Check if config file exists
  if not TFile.Exists(rsmCore.Paths.GetRSMConfigFilePath) then
  begin
    Self.SaveConfig;
    Exit;
  end;

  // Load Config
  Self.AssignFromJSON(TFile.ReadAllText(rsmCore.Paths.GetRSMConfigFilePath, TEncoding.UTF8));

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
  if not TDirectory.Exists(rsmCore.Paths.GetRSMConfigDir) then
    ForceDirectories(rsmCore.Paths.GetRSMConfigDir);

  TFile.WriteAllText(rsmCore.Paths.GetRSMConfigFilePath, Self.AsJSON(True), TEncoding.UTF8);
end;

end.

