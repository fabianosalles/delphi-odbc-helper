unit Aeonsoft.ODBC;

(*
  Aeonsoft's ODBC Helper unit.
  ----------------------------------------------------------------------
  Origianl Author : Fabiano Sales
  This file is distributed under MIT Licence, so you can freely use it on
  commercial projects since you mention it somewhere on your product.
*)

interface

uses
  Generics.Collections,
  System.Classes,
  System.SysUtils;

type
  TDSNType = (dsnSystem, dsnUser);
  TDNSTypes = set of TDSNType;

  TDSNInfo = class
  public
    Name: string;
    Driver: string;
    constructor Create(const AName: string; const ADriver: string);
  end;

  EODBCException = class(Exception);

  function GetDSN(ATypes: TDNSTypes): TList<TDSNInfo>; overload;

implementation

uses
  System.Odbc;


function GetDSN(AType: TDSNType): TList<TDSNInfo>; overload;
const
  BUFF_LEN = 1024;
var
  HEnvirontent: SQLHENV;
  DSN : array [0..SQL_MAX_DSN_LENGTH-1] of WideChar;
  Description: array [0..BUFF_LEN-1] of WideChar;
  DSNLen, DescriptionLen, Return: SmallInt;
  ADirection : Word;
  DSNInfo: TDSNInfo;
begin
  Result := TList<TDSNInfo>.Create;
  HEnvirontent := Pointer(SQL_NULL_HENV);
  Return := SQLAllocHandle(SQL_HANDLE_ENV,
    Pointer(SQL_NULL_HANDLE),
    HEnvirontent);

  if not SQL_SUCCEEDED(Return) then
    raise Exception.Create('Could not get an environment handler for ODBC API');

  //set ODBC version parameter
  Return := SQLSetEnvAttr(
    HEnvirontent,
    SQL_ATTR_ODBC_VERSION,
    SQLPOINTER(SQL_OV_ODBC3_80), 0);
  try
    if not SQL_SUCCEEDED(Return) then
      raise Exception.Create('Could not set ODBC version parameter');

    case AType of
      dsnSystem: ADirection := SQL_FETCH_FIRST_SYSTEM;
      dsnUser  : ADirection := SQL_FETCH_FIRST_USER;
    end;

    Return := SQLDataSources(HEnvirontent, ADirection,
      @DSN, SQL_MAX_DSN_LENGTH, DSNLen,
      @Description, BUFF_LEN, DescriptionLen);
    if SQL_SUCCEEDED(Return) then
    begin
      Result.Add(TDSNInfo.Create(DSN, Description));
      repeat
        Return := SQLDataSources(HEnvirontent, SQL_FETCH_NEXT,
          @DSN, SQL_MAX_DSN_LENGTH, DSNLen,
          @Description, BUFF_LEN, DSNLen);

        if SQL_SUCCEEDED(Return) then
          Result.Add(TDSNInfo.Create(DSN, Description));

        until ((Return <> SQL_SUCCESS) and (Return <> SQL_SUCCESS_WITH_INFO));
    end
    else
      //TODO: call SQLGetDiagRec to get error details and improve exception message
      case Return of
        SQL_ERROR         : raise EODBCException.Create('SQL_ERROR');
        SQL_INVALID_HANDLE: raise EODBCException.Create('SQL_INVALID_HANDLE');
      end;
  finally
    SQLFreeHandle(SQL_HANDLE_ENV, HEnvirontent);
  end;
end;


function GetDSN(ATypes: TDNSTypes): TList<TDSNInfo>;
var
  List:  TList<TDSNInfo>;
begin
  Result := TList<TDSNInfo>.Create;
  if dsnUser in ATypes then
  begin
    List := GetDSN(dsnUser);
    Result.AddRange(List);
    List.Free;
  end;

  if dsnSystem in ATypes then
  begin
    List := GetDSN(dsnSystem);
    Result.AddRange(List);
    List.Free;
  end;

end;

{ TDSNInfo }

constructor TDSNInfo.Create(const AName, ADriver: string);
begin
  Name := AName;
  Driver := ADriver;
end;

end.
