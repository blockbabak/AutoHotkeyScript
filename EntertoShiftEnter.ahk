#Requires AutoHotkey v2.0

; List of applications/websites where the Enter/Shift+Enter swap should be active
; Format: Window title must contain one of these strings (case-insensitive)
chatApplications := [
    "WhatsApp",      ; WhatsApp Desktop
    "ChatGPT",       ; ChatGPT
    "Claude",        ; Claude AI
    "Anthropic",     ; Claude/Anthropic
    "Copilot",       ; Microsoft Copilot
    "Gemini",          ; Google Bard
    "Perplexity",    ; Perplexity AI
    "Telegram"       ; Telegram Desktop
]

; Check if the active window is a chat application
IsActiveChatApp() {
    activeTitle := WinGetTitle("A")
    for app in chatApplications {
        if InStr(activeTitle, app, true) {
            return true
        }
    }
    return false
}

; Swap Enter and Shift+Enter only in chat applications
#HotIf IsActiveChatApp()
    ; Enter becomes Shift+Enter
    Enter:: {
        Send "+{Enter}"
    }
    
    ; Shift+Enter becomes Enter
    +Enter:: {
        Send "{Enter}"
    }
#HotIf

; Create a tray menu to allow users to edit the application list
A_TrayMenu.Add("Edit Application List", EditAppList)
A_TrayMenu.Add()  ; Add a separator line
A_TrayMenu.Add("Reload Script", ReloadScript)
A_TrayMenu.Add("Exit", ExitScript)

; Function to edit the application list
EditAppList(*) {
    ; Join the array into a comma-separated string
    appListText := ""
    for index, app in chatApplications {
        appListText .= app
        if index < chatApplications.Length {
            appListText .= ", "
        }
    }
    
    ; Show input box with current list
    newList := InputBox("Enter application names, separated by commas:", "Edit Application List", , appListText)
    
    ; Process the new list if user didn't cancel
    if !newList.Result = "Cancel" {
        ; Clear current list
        chatApplications.Length := 0
        
        ; Split by comma and trim whitespace
        appArray := StrSplit(newList.Value, ",")
        for app in appArray {
            appTrimmed := Trim(app)
            if appTrimmed != "" {
                chatApplications.Push(appTrimmed)
            }
        }
        
        ; Reload script to apply changes
        Reload
    }
}

; Function to reload the script
ReloadScript(*) {
    Reload
}

; Function to exit the script
ExitScript(*) {
    ExitApp
}

; Show a startup tooltip
ToolTip("Enter/Shift+Enter Swap Active`nRight-click tray icon for options", 1000, 700)
SetTimer () => ToolTip(), -3000  ; Remove after 3 seconds