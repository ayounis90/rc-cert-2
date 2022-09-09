*** Settings ***
Library     RPA.Browser.Selenium    auto_close=${False}
Library     RPA.FileSystem
Library     RPA.Archive
Library     RPA.PDF
Library     RPA.Tables
Library     Screenshot
Library     RPA.Robocorp.Vault
Library     RPA.HTTP
Library     RPA.Robocorp.Vault
Library     RPA.Dialogs


*** Keywords ***
Open RPA Website
    ${secret}    Get Secret    secrets
    Open Available Browser    ${secret}[site-url]

Close RPA Site
    Close All Browsers

Agree to Modal Message
    Click Button    OK

Get Orders
    ${download_link}    Ask for CSV Link

    RPA.HTTP.Download    ${download_link}[link]    ${OUTPUT_DIR}${/}orders.csv    overwrite=True
    ${orders}    Read table from CSV    ${OUTPUT_DIR}${/}orders.csv
    RETURN    ${orders}

Submit Order
    Click button    Order
    Page Should Contain Element    id:receipt    limit=1

Fill One Robot Form
    [Arguments]    ${robot_data}
    Select From List By Value    alias:Head    ${robot_data}[Head]
    Select Radio Button    body    ${robot_data}[Body]
    Input Text    alias:Legs    ${robot_data}[Legs]
    Input Text    address    ${robot_data}[Address]
    Click button    Preview

Take Screenshot of Robot Preview
    [Arguments]    ${filename}
    Screenshot    id:robot-preview-image    ${OUTPUT_DIR}${/}${filename}.png
    RETURN    ${OUTPUT_DIR}${/}${filename}.png

Store Receipt of Robot as PDF
    [Arguments]    ${filename}

    Wait Until Element Is Visible    id:receipt
    ${receipt_html}    Get Element Attribute    id:receipt    outerHTML
    Html To Pdf    ${receipt_html}    ${OUTPUT_DIR}${/}${filename}
    RETURN    ${OUTPUT_DIR}${/}${filename}

Add Screenshot to PDF
    [Arguments]    ${pdf}    ${screenshot}
    ${screenshots}    Create List    ${screenshot}
    Open Pdf    ${pdf}
    Add Files To Pdf    ${screenshots}    ${pdf}    append=${True}
    Close Pdf    ${pdf}

Archive All Receipts
    ${archive_name}    Set Variable    receipts.zip
    Log    ${OUTPUT_DIR}
    Archive Folder With Zip    ${OUTPUT_DIR}    receipts.zip    False    *.pdf
    Move File    ${archive_name}    ${OUTPUT_DIR}${/}${archive_name}

Ask for CSV Link
    Add heading    Provide Orders Link
    Add text input    link    label=Orders CSV Link
    ${result}    Run dialog
    RETURN    ${result}
