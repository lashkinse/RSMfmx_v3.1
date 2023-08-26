﻿unit RCON.Events;

interface

uses
  RCON.Types, RCON.Commands, System.Generics.Collections;

type
  TRCONEvents = class
  { Private Variables }
  private
  { Private Methods }
  private
    // Server Info
    procedure OnServerInfo(const serverInfo: TRCONServerInfo);
    // Player Count Changed. Gets called in OnServerInfo()
    procedure OnPlayerCountChanged(const OldCount, NewCount: Integer);
    // On Playerlist
    procedure OnPlayerList(const PlayerList: TArray<TRCONPlayerListPlayer>);
  { Public Methods }
  public
    procedure OnRconMessage(const rconMessage: TRCONMessage);

  end;

var
  rconEvents: TRCONEvents;

implementation

uses
  RCON.Parser, ufrmMain, System.SysUtils, System.DateUtils, uServerInfo;

{ TRCONEvents }

procedure TRCONEvents.OnPlayerCountChanged(const OldCount, NewCount: Integer);
begin
  // Player Count Changed. Request new playerlist
  TRCON.SendRconCommand(RCON_CMD_PLAYERLIST, RCON_ID_PLAYERLIST, frmMain.wsClientRcon);

  frmMain.lblAppVersionValue.Text := Format('OLD: %d  NEW: %d', [OldCount, NewCount]);
end;

procedure TRCONEvents.OnPlayerList(const PlayerList: TArray<TRCONPlayerListPlayer>);
begin
  for var aPlayer in PlayerList do
  begin
    //
  end;
end;

procedure TRCONEvents.OnRconMessage(const rconMessage: TRCONMessage);
begin
  // All messages received from rcon will be processed here.

  // ServerInfo
  if rconMessage.aIdentifier = RCON_ID_SERVERINFO then
  begin
    var serverInfo := TRCONParser.ParseServerInfo(rconMessage.aMessage);
    OnServerInfo(serverInfo);

    // Player Count Change
    if serverInfoCurrent.Players <> serverInfo.Players then
      OnPlayerCountChanged(serverInfoCurrent.Players, serverInfo.Players);

    // Assign Global Server info variable
    serverInfoCurrent := serverInfo;
  end;

  // PlayerList
  if rconMessage.aIdentifier = RCON_ID_PLAYERLIST then
  begin
    OnPlayerList(TRCONParser.ParsePlayerList(rconMessage.aMessage));
  end;
end;

procedure TRCONEvents.OnServerInfo(const serverInfo: TRCONServerInfo);
begin
  // Players
  frmMain.lblPlayerCountValue.Text := Format('%d / %d', [serverInfo.Players, serverInfo.MaxPlayers]);

  // Queued
  frmMain.lblQueuedValue.Text := serverInfo.Queued.ToString;

  // Joining
  frmMain.lblJoiningValue.Text := serverInfo.Joining.ToString;

  // Network Out
  frmMain.lblNetworkOutValue.Text := Format('%d b/s ↑', [serverInfo.NetworkOut]);

  // Network In
  frmMain.lblNetworkInValue.Text := Format('%d b/s ↓', [serverInfo.NetworkIn]);

  // FPS
  frmMain.lblServerFPSValue.Text := serverInfo.FPS.ToString;

  // Entity Count
  frmMain.lblServerEntityCountValue.Text := serverInfo.EntityCount.ToString;

  // Protocol
  frmMain.lblServerProtocolValue.Text := serverInfo.Protocol;

  // Ram Usage
  frmMain.lblServerMemoryUsageValue.Text := serverInfo.MemoryUsageSystem.ToString + ' MB';

  // Last Wipe
  frmMain.lblLastWipeValue.Text := FormatDateTime('yyyy/mm/dd hh:nn:ss', serverInfo.SaveCreatedTime);
end;

initialization
begin
  rconEvents := TRCONEvents.Create;
end;


finalization
begin
  rconEvents.Free;
end;

end.

