function StartText takes nothing returns nothing
    if udg_GameSelection then
        call ClearTextMessages()
        call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 600, "|cff338844-=NIGHT ELF CHAPTER 6=-|r")
        call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 600, "A Destiny of Flame and Sorrow")
        call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 600, " ")
        if udg_CodeError then
            call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 600, "The code you entered is not compatible with this chapter.")
            call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 600, "You can type '-load' again, followed your code, to try again.")
        else
            call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 600, "Type '-load' followed by the code received in the previous chapter to load your score.")
        endif
        call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 600, "Alternatively, both players can type '-new' to start a new game.")
        call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 600, " ")
        if udg_InsaneMode then
            call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 600, "|cffffcc00Gamemode: |r|cffff0000INSANE|r")
            call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 600, " ")
            call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 600, "To decrease the difficulty type '-normal'.")
        else
            call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 600, "|cffffcc00Gamemode: |r|cff00cc00NORMAL|r")
            call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 600, " ")
            call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 600, "To increase the difficulty type '-insane'.")
        endif
    call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 600, "|cff32CD32NOTE|r  - This is NOT used if you are loading a code. The code transfers the difficulty along with everything else.")
    endif
endfunction

function InitTrig_Starttext takes nothing returns nothing
	set gg_trg_Starttext = CreateTrigger()
	call TriggerAddAction(gg_trg_Starttext, function StartText)
endfunction