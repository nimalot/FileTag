/*
 */

import bb.cascades 1.2
import bb.cascades.pickers 1.0
import bb.data 1.0

Page {
    property alias tbOpenSaveText: main_tb_opensave.title

    titleBar: TitleBar {
        objectName: "main_tb"
        id: main_tb
        title: "File Tag"
        kind: TitleBarKind.Default

        acceptAction: ActionItem {
            id: main_tb_opensave
            title: "Open"

            onTriggered: {
                if (appui.editMode == false) {
                    // Open new files
                    fp.open() // entering edit mode depends on result of file picker
                } else {
                    // Save changes to filename changes
                    fnOrig_TF.text = "Saving..."

                    if (appui.commitFileChanges()) {
                        // File changes made
                        fnOrig_TF.text = fnNew_TF.text
                        fnNew_TF.text = "Saved"
                        main_tb.resetDismissAction()
                    } else {
                        // File changes failed
                        fnOrig_TF.text = appui.fileList[0];
                        fnNew_TF.text = "Failed"
                    }
                    appui.editMode = false;
                    main_tb_opensave.title = "Open"
                }
            }
        }
    }
    Container {
        id: main_c
        //background: Color.create("#ffffff") //this looks gash on amoled screens which default to black
        topMargin: 20.0
        leftMargin: 20.0
        rightMargin: 20.0
        topPadding: 20.0
        leftPadding: 20.0
        rightPadding: 20.0

        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }
        layoutProperties: StackLayoutProperties {
        }

        TextField {
            id: fnOrig_TF
            text: "Nothing Selected"
        }

        TextField {
            id: fnNew_TF
            text: "Preview"
            
        }
        Container {
            id: tagAdder_C
            //background: Color.create("#ffffff")
            topMargin: 20.0
            leftMargin: 20.0
            rightMargin: 20.0
            layoutProperties: StackLayoutProperties {
            }
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            TextField {
                id: fnNewTag_TF
                text: ""
            }
            Button {
                id: addTag_B
                preferredWidth: 30
                text: "Add"
                onClicked: {
                    appui.previewUpdated.connect(addTag_B.onPreviewChanged)
                    appui.addTag(fnNewTag_TF.text)
                    fnNewTag_TF.text = ""
                    fnNewTag_TF.requestFocus()
                }
                function onPreviewChanged(val) {
                    fnNew_TF.text = val;
                }
            }
        }
        Container {
            //background: Color.White
            ListView {
                id:tagListV
                //rootIndexPath: [1]
                dataModel: tagXmlDataModel
                //property bool listMode: false
                onTriggered: {
                    //this triggers based on the titles etc
//                    if (isSelected(indexPath))
//                    	clearSelection(indexPath)
//                    else
//                    	select(indexPath)
                    appui.test("foo" + indexPath)

                }
                function itemChecked(data, isChecked){
                    if (isChecked){
                        appui.previewUpdated.connect(addTag_B.onPreviewChanged)
                    	
                        //add this item to the tag List
                        appui.test("ADD " + data)
                        appui.addTag(data)
                    } else {
                        appui.test("REMOVE " + data)
                        appui.removeTag(data)
                        
                    }
                }
                listItemComponents: [
                    ListItemComponent {
                        type:"item"
                        Container {
                            id: itemCont
                            layout: StackLayout {
                                orientation: LayoutOrientation.LeftToRight
                            }
                            topPadding: 10.0
                            rightPadding: 10.0
                            leftPadding: 10.0
                            bottomPadding: 10.0
                            CheckBox {
                                // Determine whether the CheckBox should be checked
                                // according to a value in the data model
                                checked: ListItemData.checked
                                
                                onCheckedChanged: {
                                    //ListItemData.checked = 
                                    itemCont.ListItem.view.itemChecked(ListItemData.title, checked)
                                }
                            }
                            Label {
                                text: ListItemData.title
                                
                                // Apply a text style to create a title-sized font
                                // with normal weight
                                textStyle {
                                    base: SystemDefaults.TextStyles.TitleText
                                    fontWeight: FontWeight.Normal
                                }
                                onTouch: {
                                    //itemCont.ListItem.CheckBox.toggle()
                                }
                            }
                        } // end of Container
                    }
                ]
            }
        }
    }
    
    
    attachedObjects: [
        ActionItem {
            id: main_tb_cancel
            title: "Cancel"

            onTriggered: {
                fnOrig_TF.text = "Nothing Selected"
                fnNew_TF.text = "Preview"
                fnNewTag_TF.resetText()
                appui.editMode = false;
                main_tb_opensave.title = "Open"
                main_tb.resetDismissAction()
            }
        },
        GroupDataModel {
            id: dataModel
        },
        DataSource {
            id: tagDataSource
            source: "tags.xml"
            
            onDataLoaded: {
                dataModel.insertList(data);
            }
        },
        XmlDataModel {
          id: tagXmlDataModel  
          source: "tags.xml"

        },
        FilePicker {
            id: fp
            type: FileType.Picture
            mode: FilePickerMode.PickerMultiple
            title: "Select Files"
            onFileSelected: {
                appui.fileList = selectedFiles;
                fnOrig_TF.text = appui.fileList[0];
                main_tb_opensave.title = "Save"
                appui.editMode = true

                main_tb.dismissAction = main_tb_cancel
                fnNew_TF.text = "Preview"
                
                
                tagListV.resetDataModel()
                tagListV.setDataModel(tagXmlDataModel)
                //dataSource.load();
                
                //make sure to prepend "file://" when using as a source for an ImageView or MediaPlayer
                //"file://" + selectedFiles[0];
                console.log("FileSelected signal received : " + selectedFiles);
            }
        }
    ]
}
