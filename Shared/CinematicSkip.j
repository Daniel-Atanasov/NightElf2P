function CinematicSkip takes nothing returns boolean
    local player p = GetTriggerPlayer()
	
    if udg_CinRunning1 or udg_CinRunning2 or udg_CinRunning3 then
        if not (udg_P1Skip or udg_P2Skip) then
            if p == udg_MG_Player1 then
                set udg_P1Skip = true
            else
                set udg_P2Skip = true
            endif
			
            call PrintAlies(GetPlayerName(p) + " wishes to skips this cinematic.")
        elseif (p == udg_MG_Player1 and udg_P2Skip) or (p == udg_Player2 and udg_P1Skip) then
            call PrintAlies("Cinematic skipped.")
			
            set udg_SkipCinematic = true
            set udg_P1Skip = false
            set udg_P2Skip = false
			
            if udg_CinRunning1 then
                set udg_CinSkip1 = true
                set udg_CinRunning1 = true
				call TriggerExecute(gg_trg_CinSkip1)
            elseif udg_CinRunning2 then
                set udg_CinSkip2 = true
                set udg_CinRunning2 = true
				call TriggerExecute(gg_trg_CinSkip1)
            elseif udg_CinRunning3 then
                set udg_CinSkip3 = true
                set udg_CinRunning3 = true
				call TriggerExecute(gg_trg_CinSkip3)
            endif
        endif
    endif
	
    return false
endfunction

function InitTrig_CinematicSkip takes nothing returns nothing
        set gg_trg_CinematicSkip = CreateTrigger()
        call TriggerRegisterPlayerEvent(gg_trg_CinematicSkip, udg_MG_Player1, EVENT_PLAYER_END_CINEMATIC)
        call TriggerRegisterPlayerEvent(gg_trg_CinematicSkip, udg_Player2, EVENT_PLAYER_END_CINEMATIC)
        call TriggerAddCondition(gg_trg_CinematicSkip, Condition(function CinematicSkip))
endfunction
