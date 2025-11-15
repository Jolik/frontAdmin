unit SearchUnitTests;

interface

procedure RunSearchTests;

implementation

uses
  System.SysUtils,
  System.JSON,
  SearchUnit;

type
  ESearchTestFailure = class(Exception);

procedure Ensure(Condition: Boolean; const Msg: string);
begin
  if not Condition then
    raise ESearchTestFailure.Create(Msg);
end;

function CreateSearchInfoJSON: TJSONObject;
var
  Obj: TJSONObject;
  SearchCmpIdArray: TJSONArray;
begin
  Obj := TJSONObject.Create;
  try
    Obj.AddPair('cmpid', '85697f9f-b80d-4668-8ed2-2f70ed825eee');
    Obj.AddPair('direction', 'backward');
    Obj.AddPair('end_at', TJSONNumber.Create(1763130684));
    Obj.AddPair('find', TJSONNumber.Create(0));
    Obj.AddPair('in_cache', TJSONNumber.Create(0));
    Obj.AddPair('position', TJSONNumber.Create(0));
    SearchCmpIdArray := TJSONArray.Create;
    SearchCmpIdArray.Add('6113408c-b4e1-11e7-b36c-e069955b7462');
    SearchCmpIdArray.Add('bd8218ba-9244-11e7-abc4-cec278b6b50a');
    Obj.AddPair('search_cmpid', SearchCmpIdArray);
    Obj.AddPair('search_id', '986508b5-c166-11f0-b6e3-02420a00017c');
    Obj.AddPair('search_renewal', TJSONNumber.Create(1763130817));
    Obj.AddPair('search_start', TJSONNumber.Create(1763130683));
    Obj.AddPair('start_at', TJSONNumber.Create(1763044284));
    Obj.AddPair('status', 'done');
    Obj.AddPair('total', TJSONNumber.Create(24046));
    Obj.AddPair('uid', '4bcf9d6d-53b1-11ec-ab14-02420a0001b2');
    Result := Obj;
  except
    Obj.Free;
    raise;
  end;
end;

function CreateSearchListJSON: TJSONArray;
var
  Items: TJSONArray;
  Search1, Search2: TJSONObject;
  ArrayValue: TJSONArray;
begin
  Items := TJSONArray.Create;
  try
    Search1 := TJSONObject.Create;
    Search1.AddPair('cmpid', '00000000-0000-0000-0000-000000000000');
    Search1.AddPair('uid', '00000000-0000-0000-0000-000000000000');
    Search1.AddPair('direction', 'backward');
    Search1.AddPair('end_at', TJSONNumber.Create(1508426574));
    Search1.AddPair('find', TJSONNumber.Create(4));
    Search1.AddPair('in_cache', TJSONNumber.Create(4));
    Search1.AddPair('position', TJSONNumber.Create(1508375113));
    ArrayValue := TJSONArray.Create;
    ArrayValue.Add('6113408c-b4e1-11e7-b36c-e069955b7462');
    ArrayValue.Add('bd8218ba-9244-11e7-abc4-cec278b6b50a');
    Search1.AddPair('search_cmpid', ArrayValue);
    Search1.AddPair('search_id', '6113408c-b4e1-11e7-b36c-e069955b7462');
    Search1.AddPair('search_start', TJSONNumber.Create(1508340174));
    Search1.AddPair('start_at', TJSONNumber.Create(1508340174));
    Search1.AddPair('status', 'pending');
    Search1.AddPair('total', TJSONNumber.Create(194000));
    Items.AddElement(Search1);

    Search2 := TJSONObject.Create;
    Search2.AddPair('cmpid', '00000000-0000-0000-0000-000000000000');
    Search2.AddPair('uid', '00000000-0000-0000-0000-000000000000');
    Search2.AddPair('search_id', '7ab903d0-b4e6-11e7-abc4-ce6b50a');
    Search2.AddPair('total', TJSONNumber.Create(1000));
    Search2.AddPair('find', TJSONNumber.Create(10));
    Search2.AddPair('in_cache', TJSONNumber.Create(10));
    Search2.AddPair('status', 'done');
    Items.AddElement(Search2);

    Result := Items;
  except
    Items.Free;
    raise;
  end;
end;

procedure TestSearchParseAndSerialize;
var
  Search: TSearch;
  SourceJson, Serialized: TJSONObject;
  SerializedArray: TJSONArray;
begin
  Search := TSearch.Create;
  SourceJson := CreateSearchInfoJSON;
  try
    Search.Parse(SourceJson);
    Ensure(Search.CmpId = '85697f9f-b80d-4668-8ed2-2f70ed825eee', 'CmpId parsed incorrectly');
    Ensure(Search.Direction = 'backward', 'Direction parsed incorrectly');
    Ensure(Search.EndAt = 1763130684, 'EndAt parsed incorrectly');
    Ensure(Search.Find = 0, 'Find parsed incorrectly');
    Ensure(Search.InCache = 0, 'InCache parsed incorrectly');
    Ensure(Search.Position = 0, 'Position parsed incorrectly');
    Ensure(Search.SearchCmpId.Count = 2, 'SearchCmpId array parsed incorrectly');
    Ensure(Search.SearchId = '986508b5-c166-11f0-b6e3-02420a00017c', 'SearchId parsed incorrectly');
    Ensure(Search.SearchRenewal = 1763130817, 'SearchRenewal parsed incorrectly');
    Ensure(Search.SearchStart = 1763130683, 'SearchStart parsed incorrectly');
    Ensure(Search.StartAt = 1763044284, 'StartAt parsed incorrectly');
    Ensure(Search.Status = 'done', 'Status parsed incorrectly');
    Ensure(Search.Total = 24046, 'Total parsed incorrectly');
    Ensure(Search.Uid = '4bcf9d6d-53b1-11ec-ab14-02420a0001b2', 'Uid parsed incorrectly');

    Serialized := TJSONObject.Create;
    try
      Search.Serialize(Serialized);
      Ensure(Serialized.GetValue<string>('cmpid') = Search.CmpId, 'CmpId serialization mismatch');
      SerializedArray := Serialized.GetValue<TJSONArray>('search_cmpid');
      Ensure(Assigned(SerializedArray) and (SerializedArray.Count = Search.SearchCmpId.Count), 'SearchCmpId serialization mismatch');
    finally
      Serialized.Free;
    end;
  finally
    SourceJson.Free;
    Search.Free;
  end;
end;

procedure TestSearchListParsing;
var
  List: TSearchList;
  ItemsArray: TJSONArray;
  FirstSearch, SecondSearch: TSearch;
begin
  List := TSearchList.Create;
  ItemsArray := CreateSearchListJSON;
  try
    List.ParseList(ItemsArray);
    Ensure(List.Count = 2, 'List count parsed incorrectly');

    FirstSearch := TSearch(List[0]);
    SecondSearch := TSearch(List[1]);
    Ensure(FirstSearch.Total = 194000, 'First search total mismatch');
    Ensure(FirstSearch.SearchCmpId.Count = 2, 'First search cmpid array mismatch');
    Ensure(SecondSearch.Status = 'done', 'Second search status mismatch');
    Ensure(SecondSearch.Find = 10, 'Second search find mismatch');
  finally
    ItemsArray.Free;
    List.Free;
  end;
end;

procedure RunSearchTests;
begin
  TestSearchParseAndSerialize;
  TestSearchListParsing;
end;

end.

