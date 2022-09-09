*** Settings ***
Documentation       Orders robots from RobotSpareBin Industries Inc.
...                 Saves the order HTML receipt as a PDF file.
...                 Saves the screenshot of the ordered robot.
...                 Embeds the screenshot of the robot to the PDF receipt.
...                 Creates ZIP archive of the receipts and the images.

Resource            keywords.robot

Suite Setup         Open RPA Website
Suite Teardown      Close RPA Site


*** Tasks ***
Minimal task
    Agree to Modal Message
    ${orders}    Get Orders
    FOR    ${order}    IN    @{orders}
        Fill One Robot Form    ${order}
        Wait Until Keyword Succeeds    5x    2 sec    Submit Order
        ${screenshot}    Take Screenshot of Robot Preview    ${order}[Order number]
        ${pdf}    Store Receipt of Robot as PDF    ${order}[Order number].pdf
        Add Screenshot to PDF    ${pdf}    ${screenshot}
        Click Button    Order another robot
        Agree to Modal Message
    END
    Archive All Receipts
