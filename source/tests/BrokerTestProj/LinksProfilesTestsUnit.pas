unit LinksProfilesTestsUnit;

interface

procedure ExecuteLinksProfilesTests;

implementation

uses
  System.SysUtils,
  AppConfigUnit,
  EntityUnit,
  LinkUnit,
  LinksRestBrokerUnit,
  LinksHttpRequests,
  ProfileUnit,
  ProfileRuleUnit,
  ProfilesRestBrokerUnit,
  ProfileHttpRequests;

procedure ExecuteLinksProfilesTests;
var
  LinksBroker: TLinksRestBroker;
  ProfilesBroker: TProfilesRestBroker;
  LinksReq: TLinkReqList;
  LinksResp: TLinkListResponse;
  ProfilesReq: TProfileReqList;
  ProfilesResp: TProfileListResponse;
  Link: TFieldSet;
  Profile: TFieldSet;
  Rule: TProfileRule;
  BasePath: string;
  FtaText: string;
begin
  BasePath := ResolveServiceBasePath('drvcomm');

  LinksBroker := TLinksRestBroker.Create('ST-Test', BasePath);
  ProfilesBroker := TProfilesRestBroker.Create('ST-Test', BasePath);
  try
    LinksReq := LinksBroker.CreateReqList as TLinkReqList;
    LinksResp := LinksBroker.List(LinksReq);
    try
      Writeln('-----------------------------------------------------------------');
      Writeln('Links list request URL: ' + LinksReq.GetURLWithParams);
      Writeln(Format('Links returned: %d', [LinksResp.LinkList.Count]));

      for Link in LinksResp.LinkList do
      begin
        Writeln(Format('Link %s: type=%s, dir=%s, status=%s, comsts=%s',
          [TLink(Link).Lid, TLink(Link).TypeStr, TLink(Link).Dir, TLink(Link).Status, TLink(Link).Comsts]));

        ProfilesReq := ProfilesBroker.CreateReqList as TProfileReqList;
        ProfilesReq.Lid := TLink(Link).Lid;
        ProfilesResp := ProfilesBroker.List(ProfilesReq);
        try
          Writeln(Format('  Profiles returned: %d', [ProfilesResp.ProfileList.Count]));

          for Profile in ProfilesResp.ProfileList do
          begin
            Rule := TProfile(Profile).ProfileBody.Rule;
            FtaText := string.Join(', ', TProfile(Profile).ProfileBody.Play.FTA.ToArray);
            if FtaText = '' then
              FtaText := '(no FTA values)';

            if Assigned(Rule) then
              Writeln(Format(
                '  - %s: %s (handlers=%d, inc_filters=%d, exc_filters=%d, FTA=[%s])',
                [TProfile(Profile).Id, TProfile(Profile).Description, Rule.Handlers.Count,
                Rule.IncFilters.Count, Rule.ExcFilters.Count, FtaText]))
            else
              Writeln(Format('  - %s: %s (FTA=[%s])',
                [TProfile(Profile).Id, TProfile(Profile).Description, FtaText]));
          end;
        finally
          ProfilesResp.Free;
          ProfilesReq.Free;
        end;
      end;
    finally
      LinksResp.Free;
      LinksReq.Free;
    end;
  finally
    ProfilesBroker.Free;
    LinksBroker.Free;
  end;
end;

end.
