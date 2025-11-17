unit UniStorageHelpers;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections,
  System.JSON, uniGUIForm,
  uniGUIBaseClasses, uniGUIClasses, uniGUIApplication;

type
  TStorageStringCallback = reference to procedure(const Value: string);
  TStorageJSONCallback   = reference to procedure(Obj: TJSONObject); // Obj нужно Free в колбэке

  // Базовый класс с общей логикой
  TBaseStorageHelper = class
  private
    class var FStringCallbacks: TDictionary<string, TStorageStringCallback>;
    class var FJSONCallbacks  : TDictionary<string, TStorageJSONCallback>;
    class procedure EnsureInit; static;
    class function MakeId: string; static;
    class function EncodeJS(const S: string): string; static;
    class function DefaultOwner: TUniForm; static;

  protected
    class procedure DoGet(const StorageName: string; Owner: TUniForm;
      const Key: string; const Callback: TStorageStringCallback); static;
    class procedure DoGetJSON(const StorageName: string; Owner: TUniForm;
      const Key: string; const Callback: TStorageJSONCallback); static;
    class procedure DoSet(const StorageName: string; const Key, Value: string); static;
    class procedure DoRemove(const StorageName: string; const Key: string); static;

  public
    class procedure HandleAjax(Owner: TComponent; EventName: string; Params: TStrings); static;
  end;

  // ---------- LocalStorage ----------
  TLocalStorage = class(TBaseStorageHelper)
  public
    // с указанием Owner (форма/фрейм)
    class procedure Get(Owner: TUniForm; const Key: string;
      const Callback: TStorageStringCallback); overload; static;
    class procedure GetJSON(Owner: TUniForm; const Key: string;
      const Callback: TStorageJSONCallback); overload; static;
    class procedure SetValue(const Key, Value: string); overload; static;
    class procedure SetValue(Owner: TUniForm; const Key, Value: string); overload; static;
    class procedure SetJSON(const Key: string; Obj: TJSONObject); overload; static;
    class procedure SetJSON(Owner: TUniForm; const Key: string; Obj: TJSONObject); overload; static;
    class procedure Remove(const Key: string); overload; static;
    class procedure Remove(Owner: TUniForm; const Key: string); overload; static;

    // без Owner — берёт MainForm как получателя ajaxRequest
    class procedure Get(const Key: string; const Callback: TStorageStringCallback); overload; static;
    class procedure GetJSON(const Key: string; const Callback: TStorageJSONCallback); overload; static;
  end;

  // ---------- SessionStorage ----------
  TSessionStorage = class(TBaseStorageHelper)
  public
    class procedure Get(Owner: TUniForm; const Key: string;
      const Callback: TStorageStringCallback); overload; static;
    class procedure GetJSON(Owner: TUniForm; const Key: string;
      const Callback: TStorageJSONCallback); overload; static;
    class procedure SetValue(const Key, Value: string); overload; static;
    class procedure SetValue(Owner: TUniForm; const Key, Value: string); overload; static;
    class procedure SetJSON(const Key: string; Obj: TJSONObject); overload; static;
    class procedure SetJSON(Owner: TUniForm; const Key: string; Obj: TJSONObject); overload; static;
    class procedure Remove(const Key: string); overload; static;
    class procedure Remove(Owner: TUniForm; const Key: string); overload; static;

    class procedure Get(const Key: string; const Callback: TStorageStringCallback); overload; static;
    class procedure GetJSON(const Key: string; const Callback: TStorageJSONCallback); overload; static;
  end;

implementation

uses
  MainModule;


{ TBaseStorageHelper }

class procedure TBaseStorageHelper.EnsureInit;
begin
  if FStringCallbacks = nil then
    FStringCallbacks := TDictionary<string, TStorageStringCallback>.Create;
  if FJSONCallbacks = nil then
    FJSONCallbacks := TDictionary<string, TStorageJSONCallback>.Create;
end;

class function TBaseStorageHelper.MakeId: string;
begin
  Result := 'st_' + IntToHex(Random(MaxInt), 8);
end;

class function TBaseStorageHelper.EncodeJS(const S: string): string;
var
  R: string;
begin
  R := S;
  R := StringReplace(R, '\', '\\', [rfReplaceAll]);
  R := StringReplace(R, '"', '\"', [rfReplaceAll]);
  Result := R;
end;

class function TBaseStorageHelper.DefaultOwner: TUniForm;
begin
  if (UniMainModule <> nil) and (UniMainModule.MainForm <> nil) and
     (UniMainModule.MainForm is TUniForm) then
    Result := UniMainModule.MainForm as TUniForm
  else
    raise Exception.Create('DefaultOwner (MainForm) is not available yet');
end;

class procedure TBaseStorageHelper.DoGet(const StorageName: string;
  Owner: TUniForm; const Key: string; const Callback: TStorageStringCallback);
var
  ReqId: string;
  JS: string;
begin
  EnsureInit;
  ReqId := MakeId;
  FStringCallbacks.Add(ReqId, Callback);

  JS :=
    Format('ajaxRequest(%s, "%s", { value: %s.getItem("%s") });',
      [Owner.WebForm.JSName, ReqId, StorageName, EncodeJS(Key)]);

  UniSession.AddJS(JS);
end;

class procedure TBaseStorageHelper.DoGetJSON(const StorageName: string;
  Owner: TUniForm; const Key: string; const Callback: TStorageJSONCallback);
var
  ReqId: string;
  JS: string;
begin
  EnsureInit;
  ReqId := MakeId;
  FJSONCallbacks.Add(ReqId, Callback);

  JS :=
    Format('ajaxRequest(%s, "%s", { value: %s.getItem("%s") });',
      [Owner.WebForm.JSName, ReqId, StorageName, EncodeJS(Key)]);

  UniSession.AddJS(JS);
end;

class procedure TBaseStorageHelper.DoSet(const StorageName, Key, Value: string);
var
  JS: string;
begin
  JS := Format('%s.setItem("%s","%s");', [StorageName, EncodeJS(Key), EncodeJS(Value)]);
  UniSession.AddJS(JS);
end;

class procedure TBaseStorageHelper.DoRemove(const StorageName, Key: string);
var
  JS: string;
begin
  JS := Format('%s.removeItem("%s");', [StorageName, EncodeJS(Key)]);
  UniSession.AddJS(JS);
end;

class procedure TBaseStorageHelper.HandleAjax(Owner: TComponent; EventName: string; Params: TStrings);
var
  cbS: TStorageStringCallback;
  cbJ: TStorageJSONCallback;
  v: string;
  Obj: TJSONObject;
begin
  EnsureInit;

  // сначала пробуем как строковый callback
  if (FStringCallbacks <> nil) and FStringCallbacks.TryGetValue(EventName, cbS) then
  begin
    v := Params.Values['value'];
    try
      if Assigned(cbS) then
        cbS(v);
    finally
      FStringCallbacks.Remove(EventName);
    end;
    Exit;
  end;

  // потом как JSON callback
  if (FJSONCallbacks <> nil) and FJSONCallbacks.TryGetValue(EventName, cbJ) then
  begin
    v := Params.Values['value'];
    Obj := nil;
    if v <> '' then
      Obj := TJSONObject(TJSONObject.ParseJSONValue(v));
    try
      if Assigned(cbJ) then
        cbJ(Obj);  // ВНИМАНИЕ: колбэк обязан вызвать Obj.Free, если Obj <> nil
    finally
      FJSONCallbacks.Remove(EventName);
    end;
  end;
end;

{ TLocalStorage }

class procedure TLocalStorage.Get(Owner: TUniForm; const Key: string;
  const Callback: TStorageStringCallback);
begin
  DoGet('localStorage', Owner, Key, Callback);
end;

class procedure TLocalStorage.Get(const Key: string;
  const Callback: TStorageStringCallback);
begin
  Get(DefaultOwner, Key, Callback);
end;

class procedure TLocalStorage.GetJSON(Owner: TUniForm; const Key: string;
  const Callback: TStorageJSONCallback);
begin
  DoGetJSON('localStorage', Owner, Key, Callback);
end;

class procedure TLocalStorage.GetJSON(const Key: string;
  const Callback: TStorageJSONCallback);
begin
  GetJSON(DefaultOwner, Key, Callback);
end;

class procedure TLocalStorage.SetValue(const Key, Value: string);
begin
  DoSet('localStorage', Key, Value);
end;

class procedure TLocalStorage.SetValue(Owner: TUniForm; const Key, Value: string);
begin
  // Owner тут не нужен в JS, но для симметрии оставлен
  DoSet('localStorage', Key, Value);
end;

class procedure TLocalStorage.SetJSON(const Key: string; Obj: TJSONObject);
begin
  if Obj <> nil then
    DoSet('localStorage', Key, Obj.ToJSON)
  else
    DoRemove('localStorage', Key);
end;

class procedure TLocalStorage.SetJSON(Owner: TUniForm; const Key: string; Obj: TJSONObject);
begin
  SetJSON(Key, Obj);
end;

class procedure TLocalStorage.Remove(const Key: string);
begin
  DoRemove('localStorage', Key);
end;

class procedure TLocalStorage.Remove(Owner: TUniForm; const Key: string);
begin
  DoRemove('localStorage', Key);
end;

{ TSessionStorage }

class procedure TSessionStorage.Get(Owner: TUniForm; const Key: string;
  const Callback: TStorageStringCallback);
begin
  DoGet('sessionStorage', Owner, Key, Callback);
end;

class procedure TSessionStorage.Get(const Key: string;
  const Callback: TStorageStringCallback);
begin
  Get(DefaultOwner, Key, Callback);
end;

class procedure TSessionStorage.GetJSON(Owner: TUniForm; const Key: string;
  const Callback: TStorageJSONCallback);
begin
  DoGetJSON('sessionStorage', Owner, Key, Callback);
end;

class procedure TSessionStorage.GetJSON(const Key: string;
  const Callback: TStorageJSONCallback);
begin
  GetJSON(DefaultOwner, Key, Callback);
end;

class procedure TSessionStorage.SetValue(const Key, Value: string);
begin
  DoSet('sessionStorage', Key, Value);
end;

class procedure TSessionStorage.SetValue(Owner: TUniForm; const Key, Value: string);
begin
  DoSet('sessionStorage', Key, Value);
end;

class procedure TSessionStorage.SetJSON(const Key: string; Obj: TJSONObject);
begin
  if Obj <> nil then
    DoSet('sessionStorage', Key, Obj.ToJSON)
  else
    DoRemove('sessionStorage', Key);
end;

class procedure TSessionStorage.SetJSON(Owner: TUniForm; const Key: string; Obj: TJSONObject);
begin
  SetJSON(Key, Obj);
end;

class procedure TSessionStorage.Remove(const Key: string);
begin
  DoRemove('sessionStorage', Key);
end;

class procedure TSessionStorage.Remove(Owner: TUniForm; const Key: string);
begin
  DoRemove('sessionStorage', Key);
end;

end.

