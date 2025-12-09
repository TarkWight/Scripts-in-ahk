#Requires AutoHotkey v2.0

GetActivePath() {
    hwnd := WinActive("A")
    class := WinGetClass(hwnd)

    ; Рабочий стол
    if (class = "Progman" || class = "WorkerW") {
        return A_Desktop
    }

    ; Обычные окна Explorer / диалоги
    for window in ComObject("Shell.Application").Windows {
        try {
            if (window.HWND == hwnd)
                return window.Document.Folder.Self.Path
        } catch {
            continue
        }
    }
    return ""
}

AskFileName(ext) {
    input := InputBox("Введите имя файла (без расширения):", "Создание " . ext)
    if input.Result = "Cancel"
        return ""
    return input.Value != "" ? input.Value : "file"
}

AskFolderName() {
    input := InputBox("Введите имя папки:", "Создание папки")
    if input.Result = "Cancel"
        return ""
    return input.Value != "" ? input.Value : "NewFolder"
}

NewFileDialog() {
    ; 1) Имя без расширения
    nameInput := InputBox(
        "Введите имя файла (без расширения):",
        "Новый файл"
    )
    if (nameInput.Result = "Cancel")
        return ""

    name := Trim(nameInput.Value)
    if (name = "")
        name := "file"

    ; 2) Расширение
    extInput := InputBox(
        "Введите расширение (без точки, напр. txt, c, cpp, h, hpp, swift, rs):",
        "Тип файла",
        ,       ; Options
        "txt"   ; по умолчанию
    )
    if (extInput.Result = "Cancel")
        return ""

    ext := Trim(extInput.Value)
    if (ext = "")
        ext := "txt"

    if (SubStr(ext, 1, 1) = ".")
        ext := SubStr(ext, 2)

    return { Name: name, Ext: ext }
}

CreateFile(path, filename) {
    full := path "\" filename
    if FileExist(full) {
        TrayTip "Уведомление", "Файл уже существует: " filename, 2
        return
    }

    dotPos := InStr(filename, ".", , -1)

    if (dotPos > 0) {
        ext  := SubStr(filename, dotPos + 1)
        name := SubStr(filename, 1, dotPos - 1)
    } else {
        ext  := ""
        name := filename
    }

    content := ""

    if (ext = "h" || ext = "hpp") {
        content := CreateCHeaderFilePlaceholder(name, ext)
    }

    FileAppend(content, full)
    TrayTip "Создан файл", filename, 2
}

CreateFolder(path, folderName) {
    full := path "\" folderName

    if DirExist(full) {
        TrayTip "Уведомление", "Папка уже существует: " folderName, 2
        return
    }

    try {
        DirCreate full
        TrayTip "Создана папка", folderName, 2
    } catch as e {
        TrayTip "Ошибка", "Не удалось создать папку: " folderName "`n" e.Message, 2
    }
}

CreateCHeaderFilePlaceholder(name, ext) {
    guard := RegExReplace(name, "\W", "_")
    guard := StrUpper(guard) . "_" . StrUpper(ext)

    text := "#ifndef " . guard . "`n"
    text .= "#define " . guard . "`n`n"
    text .= "`n"
    text .= "#endif // " . guard . "`n"

    return text
}
