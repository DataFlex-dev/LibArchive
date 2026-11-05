Use Windows.pkg
Use DFClient.pkg
Use cCJGrid.pkg
Use cCJGridColumn.pkg
Use File_dlg.pkg
Use cFilesArchiver.pkg

Activate_View Activate_oCreateArchiveFileView for oCreateArchiveFileView
Object oCreateArchiveFileView is a dbView
    Set Border_Style to Border_Thick
    Set Size to 175 393
    Set Location to 2 2
    Set Label to "Create Archive File"
    Set pbAutoActivate to True

    Object oFileNamesGrid is a cCJGrid
        Set Location to 4 9
        Set Size to 94 380
        Set peAnchors to anTopLeftRight

        Object oFileNameColumn is a cCJGridColumn
            Set piWidth to 946
            Set psCaption to "File or folder name"
            Set Prompt_Button_Mode to PB_PromptOn

            Procedure Prompt
                Handle hoFileSelector
                Boolean bFileSelected
                String sFileName

                Get CreateNamed (RefClass (OpenDialog)) "oOpenDialog" to hoFileSelector
                Get Show_Dialog of hoFileSelector to bFileSelected
                If (bFileSelected) Begin
                    Get File_Name of hoFileSelector to sFileName
                    Set Value to sFileName
                End
                Send Destroy of hoFileSelector
            End_Procedure
        End_Object

        Function FilesToArchive Returns String[]
            String[] sFileNames
            Handle hoDataSource
            Integer iElements iElement
            tDataSourceRow[] FilesGridData

            Get phoDataSource to hoDataSource
            Get DataSource of hoDataSource to FilesGridData
            Move (SizeOfArray (FilesGridData) - 1) to iElements
            For iElement from 0 to iElements
                Move FilesGridData[iElement].sValue[0] to sFileNames[-1]
            Loop

            Function_Return sFileNames
        End_Function
    End_Object

    Object oArchiveFileNameForm is a Form
        Set Location to 100 94
        Set Size to 12 295
        Set Label to "Archive File name:"
        Set Label_Col_Offset to 2
        Set Label_Justification_Mode to JMode_Right
        Set peAnchors to anTopLeftRight
        Set Prompt_Button_Mode to PB_PromptOn

        Procedure Prompt
            Handle hoFileSelector
            Boolean bFileSelected
            String sFileName

            Get CreateNamed (RefClass (SaveAsDialog)) "oSaveAsDialog" to hoFileSelector
            Get Show_Dialog of hoFileSelector to bFileSelected
            If (bFileSelected) Begin
                Get File_Name of hoFileSelector to sFileName
                Set Value to sFileName
            End
            Send Destroy of hoFileSelector
        End_Procedure
    End_Object

    Object oArchiveFormatComboForm is a ComboForm
        Set Location to 114 94
        Set Size to 12 193
        Set Label to "Archive format"
        Set Entry_State to False
        Set peAnchors to anTopLeftRight
        Set Label_Col_Offset to 2
        Set Label_Justification_Mode to JMode_Right

        Procedure Combo_Fill_List
            tArchiveFormat[] ArchiveFormats
            Integer iElements iElement

            Get pArchiveFormats of oFilesArchiver to ArchiveFormats
            Move (SizeOfArray (ArchiveFormats) - 1) to iElements
            For iElement from 0 to iElements
                Send Combo_Add_Item ArchiveFormats[iElement].sFormat
            Loop
        End_Procedure

        Function SelectedArchiveFormat Returns Integer
            String sArchiveFormat
            tArchiveFormat[] ArchiveFormats
            Integer iElements iElement

            Get Value to sArchiveFormat
            Move (Uppercase (sArchiveFormat)) to sArchiveFormat
            Get pArchiveFormats of oFilesArchiver to ArchiveFormats
            Move (SizeOfArray (ArchiveFormats) - 1) to iElements
            For iElement from 0 to iElements
                If (Uppercase (ArchiveFormats[iElement].sFormat) = sArchiveFormat) Begin
                    Function_Return ArchiveFormats[iElement].eFormat
                End
            Loop
        End_Function
    End_Object

    Object oFilesArchiver is a cFilesArchiver
    End_Object

    Object oCreateArchiveButton is a Button
        Set Location to 128 94
        Set Label to "Create"

        Procedure OnClick
            Integer eArchiveFormat
            String sArchiveFileName
            String[] sFileNames

            Get FilesToArchive of oFileNamesGrid to sFileNames
            Get Value of oArchiveFileNameForm to sArchiveFileName
            If (SizeOfArray (sFileNames) and sArchiveFileName <> "") Begin
                Send Init of oFilesArchiver
                Get SelectedArchiveFormat of oArchiveFormatComboForm to eArchiveFormat
                Set peArchiveFormat of oFilesArchiver to eArchiveFormat
                Set psArchiveFileName of oFilesArchiver to sArchiveFileName
                Send AddMultipleFiles of oFilesArchiver sFileNames
                Send WriteFilesToArchive of oFilesArchiver
            End
        End_Procedure
    End_Object

    // ToDo: Remove later is test code
    Procedure Activating
        Forward Send Activating

        Set Value of oArchiveFileNameForm to "c:\tmp\example.zip"
        Set Value of oArchiveFormatComboForm to "Zip"
    End_Procedure
End_Object
