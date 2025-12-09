#Requires AutoHotkey v2.0

; --- Win + Alt + N: создание папки ---
#!n:: {
    path := GetActivePath()
    if path != "" {
        name := AskFolderName()
        if name != ""
            CreateFolder(path, name)
    }
}
