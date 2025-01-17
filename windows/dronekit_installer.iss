; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "DroneKit"
; #define MyAppVersion "1"
#define MyAppPublisher "3D Robotics, Inc"
#define MyAppURL "https://github.com/venkatkamesh/dronekit-python"
#define MyAppExeName ""

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{35EE5962-C212-4874-90EC-50863DD1537D}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
CreateAppDir=no
OutputBaseFilename=DroneKitsetup-{#MyAppVersion}
Compression=lzma
SolidCompression=yes
LicenseFile=..\LICENSE
DisableDirPage=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
Source: "..\dronekit\*"; DestDir: "{code:GetMAVProxyPath}\dronekit"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\examples\*"; DestDir: "{code:GetMAVProxyPath}\examples"; Flags: ignoreversion recursesubdirs createallsubdirs

; NOTE: Don't use "Flags: ignoreversion" on any shared system files

; Check if MAVProxy is installed (if so, get the install path)
[Code]
function IsMAVProxyInstalled: boolean;
begin
  result := RegKeyExists(HKEY_LOCAL_MACHINE,
    'Software\Microsoft\Windows\CurrentVersion\Uninstall\{D81B9EDA-1357-462E-96E4-B47372709F7C}_is1');
end;

function GetMAVProxyPath(Dummy: string): string;
var
  sInstallPath: string;
  MAVProxyPath: string;
begin
  MAVProxyPath := 'Software\Microsoft\Windows\CurrentVersion\Uninstall\{D81B9EDA-1357-462E-96E4-B47372709F7C}_is1'
  sInstallPath := '';
  RegQueryStringValue(HKLM, MAVProxyPath, 'InstallLocation', sInstallPath);
  Result := sInstallPath;
end;

function InitializeSetup: boolean;
begin
  result := IsMAVProxyInstalled;
  if not result then
    MsgBox('You need to install MAVProxy before you install DroneKit. Install MAVProxy and then run this installer again.', mbError, MB_OK);
end;

function MAVDir_CreatePage(PreviousPageId: Integer): Integer; 
var
  Page: TWizardPage;
  Label1: TLabel;
  MAVDir: TEdit;
begin
  Page := CreateCustomPage(
    PreviousPageId,
    'Installation Directory',
    ''
  );

  Label1 := TLabel.Create(Page);
  with Label1 do
  begin
    Parent := Page.Surface;
    Caption := 'DroneKit will be installed in the MAVProxy directory:'
    Left := ScaleX(16);
    Top := ScaleY(0);
    Width := ScaleX(300);
    Height := ScaleY(17);
  end;

  MAVDir := TEdit.Create(Page);
  with MAVDir do
  begin
    Parent := Page.Surface;
    Left := ScaleX(16);
    Top := ScaleY(24);
    Width := ScaleX(300);
    Height := ScaleY(25);
    TabOrder := 0;
    Text := GetMAVProxyPath('');
    Enabled := False;
  end

end;

procedure InitializeWizard();
begin
  MAVDir_CreatePage(wpLicense);
end;
