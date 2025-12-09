#Requires AutoHotkey v2.0

global lastC := 0
global lastX := 0
global clickTimerC := false
global clickTimerX := false

; --- Универсальный "новый файл": Win + Alt + F ---
#!f:: {
    path := GetActivePath()
    if (path = "")
        return

    params := NewFileDialog()
    if (params = "")
        return  ; отмена

    fullName := params.Name . "." . params.Ext
    CreateFile(path, fullName)
}

; --- Стандартные файлы ---

; Win + Alt + T → .txt
#!t:: {
    path := GetActivePath()
    if path != "" {
        name := AskFileName("txt")
        if name != ""
            CreateFile(path, name . ".txt")
    }
}

; Win + Alt + S → .swift
#!s:: {
    path := GetActivePath()
    if path != "" {
        name := AskFileName("swift")
        if name != ""
            CreateFile(path, name . ".swift")
    }
}

; --- Win + Alt + C: одиночное → .c, двойное → .h ---
#!c:: {
    global lastC, clickTimerC
    now := A_TickCount

    if (now - lastC < 400) {
        clickTimerC := false
        path := GetActivePath()
        if path != "" {
            name := AskFileName("h")
            if name != ""
                CreateFile(path, name . ".h")
        }
    } else {
        lastC := now
        clickTimerC := true
        SetTimer(() => HandleSingleC(), -400)
    }
}

HandleSingleC() {
    global clickTimerC
    if clickTimerC {
        path := GetActivePath()
        if path != "" {
            name := AskFileName("c")
            if name != ""
                CreateFile(path, name . ".c")
        }
    }
    clickTimerC := false
}

; --- Win + Alt + X: одиночное → .cpp, двойное → .hpp ---
#!x:: {
    global lastX, clickTimerX
    now := A_TickCount

    if (now - lastX < 400) {
        clickTimerX := false
        path := GetActivePath()
        if path != "" {
            name := AskFileName("hpp")
            if name != ""
                CreateFile(path, name . ".hpp")
        }
    } else {
        lastX := now
        clickTimerX := true
        SetTimer(() => HandleSingleX(), -400)
    }
}

HandleSingleX() {
    global clickTimerX
    if clickTimerX {
        path := GetActivePath()
        if path != "" {
            name := AskFileName("cpp")
            if name != ""
                CreateFile(path, name . ".cpp")
        }
    }
    clickTimerX := false
}

; --- Win + Alt + R → .rs ---
#!r:: {
    path := GetActivePath()
    if path != "" {
        name := AskFileName("rust")
        if name != ""
            CreateFile(path, name . ".rs")
    }
}
