unit Main;

interface

uses
  System.SysUtils, System.Variants, System.Classes,
  Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIRegClasses, uniGUIForm, uniGUIBaseClasses, uniLabel,
  uniButton, uniSplitter, uniPageControl, uniTreeView, uniTreeMenu,
  uniMultiItem, uniComboBox, EntityUnit,
  CompaniesRestBrokerUnit, DepartmentsRestBrokerUnit,
  RestBrokerBaseUnit, BaseRequests, BaseResponses, uniScreenMask, uniPanel,
  AuthMainFormUnit, Vcl.Menus, uniMainMenu, uniTimer, uniImage, uniImageList;

type
  TMainForm = class(TAuthMainForm)
    btnChannel: TUniButton;
    btnLinks: TUniButton;
    btnRouterSources: TUniButton;
    btnAliases: TUniButton;
    btnQueues: TUniButton;
    btnAbonents: TUniButton;
    btnOperatorLinks: TUniButton;
    btnRules: TUniButton;
    btnHandlers: TUniButton;
    OSLabel: TUniLabel;
    URLLabel: TUniLabel;
    uncntnrpnInfo: TUniContainerPanel;
    btnOperatorLinksContent: TUniButton;
    btnSearch: TUniButton;
    btnContentStream: TUniButton;
    unlblName1: TUniLabel;
    uncntnrpnForms: TUniContainerPanel;
    procedure btnAbonentsClick(Sender: TObject);
    procedure btnChannelClick(Sender: TObject);
    procedure btnLinksClick(Sender: TObject);
    procedure btnRouterSourcesClick(Sender: TObject);
    procedure btnAliasesClick(Sender: TObject);
    procedure btnRulesClick(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
    procedure btnHandlersClick(Sender: TObject);
    procedure btnQueuesClick(Sender: TObject);
    procedure btnOperatorLinksClick(Sender: TObject);
    procedure btnOperatorLinksContentClick(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure btnContentStreamClick(Sender: TObject);
  private
  public
    { Public declarations }
  end;

function MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  uniGUIVars, uniGUIApplication,
  MainModule,
  AppConfigUnit,
  HttpClientUnit,
  ChannelsFormUnit,
  LinksFormUnit,
  QueuesFormUnit,
  AliasesFormUnit,
  AbonentsFormUnit,
  RouterSourcesFormUnit,
  RulesFormUnit,
  OperatorLinksFormUnit,
  OperatorLinkContectFormUnit,
  SearchFormUnit,
  ContentStreamFormUnit, HandlersFormUnit;

function MainForm: TMainForm;
begin
  Result := TMainForm(UniMainModule.GetFormInstance(TMainForm));

end;

{  TMainForm  }

procedure TMainForm.btnChannelClick(Sender: TObject);
begin
  ChannelsForm.Show();
end;

procedure TMainForm.btnHandlersClick(Sender: TObject);
begin
  HandlersForm.Show();
  HandlersForm.Parent:= uncntnrpnForms;
end;

procedure TMainForm.btnRulesClick(Sender: TObject);
begin
  RulesForm.Show();
end;

procedure TMainForm.btnAbonentsClick(Sender: TObject);
begin
  AbonentsForm.Show();
end;

procedure TMainForm.btnOperatorLinksClick(Sender: TObject);
begin
  OperatorLinksForm.Show();
end;

procedure TMainForm.btnOperatorLinksContentClick(Sender: TObject);
begin
  OperatorLinkContectForm.Show();
end;

procedure TMainForm.btnSearchClick(Sender: TObject);
begin
  SearchForm.Show();
end;

procedure TMainForm.btnContentStreamClick(Sender: TObject);
begin
  ContentStreamForm.Show();
end;

procedure TMainForm.btnAliasesClick(Sender: TObject);
begin
  AliasesForm.Show();
end;

procedure TMainForm.btnRouterSourcesClick(Sender: TObject);
begin
  RouterSourcesForm.Show();
end;

procedure TMainForm.btnLinksClick(Sender: TObject);
begin
  LinksForm.Show();
end;

procedure TMainForm.btnQueuesClick(Sender: TObject);
begin
  QueuesForm.Show();
end;

procedure TMainForm.UniFormCreate(Sender: TObject);
begin
  inherited;
  OSLabel.Caption := 'Платформа: ' + TOSVersion.ToString;
  UniMainModule.XTicket := 'ST-Test';

  HttpClient.Addr := '213.167.42.170';
  if GetEnvironmentVariable('ADDR') <> '' then
    HttpClient.Addr := GetEnvironmentVariable('ADDR');

  HttpClient.Port := 8088;
  if GetEnvironmentVariable('PORT') <> '' then
    HttpClient.Port := StrToInt(GetEnvironmentVariable('PORT'));

  URLLabel.Caption := 'Url:' + HttpClient.Addr + ' : ' + IntToStr(HttpClient.Port);
  InitializeCompanyData;
end;

initialization
  RegisterAppFormClass(TMainForm);

end.




