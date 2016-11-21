module Tracker exposing (..)

import Aliases           exposing (..)
import List              exposing (length)
import TrackerComponents exposing (..)
import TrackerTypes      exposing (..)
import Array             exposing (set)
import Types
import ParseInt          exposing (..)
import UpdateUtil        exposing (..)


update : Msg -> Model -> (Model, Types.Msg)
update message model =
  case message of
    UpdateCell ri ci str ->
      let {sheet} = model in
      { sheet
      | data =
          let {data, width} = sheet in
          toArrayDeep data
          |>setElement width ri ci str
          |>toListDeep
      }
      |>Types.UpdateSheet
      |>(,) model

    UpdateRadix radixField ->
      let
        newRadix =
          if radixField == "" then model.radix
          else
            case (parseInt radixField) of
              Ok result -> result
              Err _ -> 2
      in
      packModel
      { model 
      | radixField = radixField
      , radix      = newRadix
      }

    UpdateSheetName newName ->
      let {sheet} = model in
      { sheet | name = newName }
      |>Types.UpdateSheetName sheet.name
      |>(,) model

    DropDown ->
      packModel
      { model | droppedDown = True }

    SetSheet sheetName ->
      let {sheet} = model in
      (,)
      { model
      | sheet =
        { sheet | name = sheetName }
      , droppedDown = False
      }
      Types.SyncTrackers

    NewSheet ->
      let 
        {sheet, otherSheets} = model

        newName =
          getNewSheetName otherSheets
      in
      (,)
      { model
      | sheet = { sheet | name = newName }
      }
      (Types.NewSheet newName)

    CloseSheet ->
      let {otherSheets, sheet} = model in
      if length otherSheets == 1 then
        packModel model
      else
        (model, Types.RemoveSheet sheet.name)

    Save ->
      (model, Types.SaveSheet model.sheet)

    Open ->
      (model, Types.OpenDialog model.name)

    ColumnIndexMouseOver index ->
      packModel
      { model 
      | columnHoverOvers = 
          set index True model.columnHoverOvers
      }
      
    ColumnIndexMouseOut index ->
      packModel
      { model 
      | columnHoverOvers = 
          set index False model.columnHoverOvers
      }

    RowIndexMouseOver index ->
      packModel
      { model
      | rowHoverOvers = 
          set index True model.rowHoverOvers
      }

    RowIndexMouseOut index ->
      packModel
      { model
      | rowHoverOvers = 
          set index False model.rowHoverOvers
      }

    NewRow index ->
      let {sheet} = model in
      { sheet
      | data =
          let {data, width} = sheet in
          newRow width index data           
      , height = 
          sheet.height + 1
      }
      |>Types.UpdateSheet
      |>(,) model

    RemoveRow index ->
      let {sheet} = model in
      { sheet
      | data =
          removeRow 
            index 
            sheet.data           
      , height = 
          sheet.height - 1
      }
      |>Types.UpdateSheet
      |>(,) model

    NewColumn index ->
      let {sheet} = model in
      { sheet
      | data =
          sheet.data
          |>removeColumn 8 
          |>insertColumn index        
      }
      |>Types.UpdateSheet
      |>(,) model

    RemoveColumn index ->
      let {sheet} = model in
      { sheet
      | data =
          sheet.data
          |>removeColumn index
          |>insertColumn 8         
      }
      |>Types.UpdateSheet
      |>(,) model
      
    NoOp ->
      packModel model


