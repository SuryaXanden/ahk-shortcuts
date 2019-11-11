; https://superuser.com/questions/205359/how-can-i-open-a-command-prompt-in-current-folder-with-a-keyboard-shortcut

SetTitleMatchMode RegEx
return

!x::
	search()
return

!z::
	browse()
return

#z::
	InputBox, proc, Killa, Enter the process to be killed
	if !ErrorLevel
	{
		Run, taskkill /f /t /im %proc%.exe,,hide
	}
return

#c::
	ps_in_cwd()
return

#Space::
    cmd_in_cwd()
return

ps_in_cwd()
{
    ; This is required to get the full path of the file from the address bar
    WinGetText, full_path, A

    ; Split on newline (`n)
    StringSplit, word_array, full_path, `n

    ; Find and take the element from the array that contains address
    Loop, %word_array0%
    {
        IfInString, word_array%A_Index%, Address
        {
            full_path := word_array%A_Index%
            break
        }
    }  

    ; strip to bare address
    full_path := RegExReplace(full_path, "^Address: ", "")

    ; Just in case - remove all carriage returns (`r)
    StringReplace, full_path, full_path, `r, , all

    IfInString full_path, \
    {
        Run, powershell, %full_path%, max
    }
	else
	{
		Run, powershell, %userprofile%\desktop, max
	}
}

cmd_in_cwd()
{
    ; This is required to get the full path of the file from the address bar
    WinGetText, full_path, A

    ; Split on newline (`n)
    StringSplit, word_array, full_path, `n

    ; Find and take the element from the array that contains address
    Loop, %word_array0%
    {
        IfInString, word_array%A_Index%, Address
        {
            full_path := word_array%A_Index%
            break
        }
    }  

    ; strip to bare address
    full_path := RegExReplace(full_path, "^Address: ", "")

    ; Just in case - remove all carriage returns (`r)
    StringReplace, full_path, full_path, `r, , all

    IfInString full_path, \
    {
        Run, cmd, %full_path%, max
    }
	else
	{
		Run, cmd, %userprofile%\desktop, max
	}
}

search()
{
	sleep 100
	Send, ^c
	sleep 100
    if (clipboard)
	    Run, http://www.google.com/search?q=%clipboard%
	Return
}

browse()
{
	sleep 100
	Send, ^c
	sleep 100
    if (clipboard)
	    {
            /*
            Send, ^t
	        sleep 100
            Send, ^v
	        sleep 100
            Send, {Enter}
            */

            Run chrome.exe "%clipboard%" " --new-window "
        }
	Return
}
