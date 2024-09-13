unit uRSMAPIv1;

interface

uses
  Horse, System.SysUtils;

type
  Tv1RSMAPIEndpoints = class
  public
    // serverConfig
    class procedure v1GETserverConfig(Req: THorseRequest; Res: THorseResponse);
    class procedure v1PUTserverConfig(Req: THorseRequest; Res: THorseResponse);

    // serverStatus
    class procedure v1GETserverStatus(Req: THorseRequest; Res: THorseResponse);
  end;

implementation

uses
  RSM.Config, uServerConfig, XSuperObject, ufrmMain, RCON.Types, uServerProcess;

{ Tv1RSMAPIEndpoints }

class procedure Tv1RSMAPIEndpoints.v1GETserverStatus(Req: THorseRequest; Res: THorseResponse);
begin
  // Provide Data
  try
    Res.ContentType('application/json').Status(THTTPStatus.OK).Send(serverProcess.AsJSON(True));

  except
    // Provide Exception
    on E: Exception do
    begin
      Res.Status(THTTPStatus.InternalServerError).Send(E.ClassName + ': ' + E.Message);
    end;
  end;
end;

class procedure Tv1RSMAPIEndpoints.v1GETserverConfig(Req: THorseRequest; Res: THorseResponse);
begin
  // Provide Data
  try
    Res.ContentType('application/json').Status(THTTPStatus.OK).Send(serverConfig.AsJSON(True));
  except
    // Provide Exception
    on E: Exception do
    begin
      Res.Status(THTTPStatus.InternalServerError).Send(E.ClassName + ': ' + E.Message);
    end;
  end;
end;

class procedure Tv1RSMAPIEndpoints.v1PUTserverConfig(Req: THorseRequest; Res: THorseResponse);
begin
  // Provide Data
  try
    serverConfig.AssignFromJSON(Req.Body);
    serverConfig.SaveConfig;
    serverConfig.LoadConfig;

    frmMain.PopulateServerConfigUI;

    TRCON.SendRconCommand('server.readcfg', 0, frmMain.wsClientRcon);

    Res.Status(THTTPStatus.OK).Send('{ "message": "Server Config Applied. Some Changes will only take effect after a server restart." }');
  except
    // Provide Exception
    on E: Exception do
    begin
      Res.Status(THTTPStatus.InternalServerError).Send(E.ClassName + ': ' + E.Message);
    end;
  end;
end;

end.

