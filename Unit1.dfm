object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'ODBC Data Sources Listing'
  ClientHeight = 276
  ClientWidth = 510
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lvwDSN: TListView
    Left = 0
    Top = 0
    Width = 510
    Height = 276
    Align = alClient
    Columns = <
      item
        Caption = 'Name'
        Width = 150
      end
      item
        Caption = 'Driver'
        Width = 300
      end>
    DoubleBuffered = True
    Groups = <
      item
        Header = 'User'#39's data sources'
        GroupID = 0
        State = [lgsNormal]
        HeaderAlign = taLeftJustify
        FooterAlign = taLeftJustify
        TitleImage = -1
      end
      item
        Header = 'System'#39's data sources'
        GroupID = 1
        State = [lgsNormal]
        HeaderAlign = taLeftJustify
        FooterAlign = taLeftJustify
        TitleImage = -1
      end>
    GroupView = True
    ReadOnly = True
    ParentDoubleBuffered = False
    TabOrder = 0
    ViewStyle = vsReport
    ExplicitWidth = 360
    ExplicitHeight = 225
  end
end
