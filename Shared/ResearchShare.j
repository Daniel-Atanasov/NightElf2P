function ResearchStart takes nothing returns boolean
    local player p1 = GetTriggerPlayer()
    local player p2
    local integer i
    local integer t = GetResearched()
    
    if p1 == udg_MG_Player1 then
        set p2 = udg_Player2
    else
        set p2 = udg_MG_Player1
    endif
    call SetPlayerTechMaxAllowed(p2, t, GetPlayerTechCount(p1, t, true))
        
    set p1 = null
    set p2 = null
    return false
endfunction

function ResearchComplete takes nothing returns boolean
    local player p1 = GetTriggerPlayer()
    local player p2
    local integer t = GetResearched()
    local integer i
    local integer tn
    local integer t1
    local integer t2
    
    if p1 == udg_MG_Player1 then
        set p2 = udg_Player2
    else
        set p2 = udg_MG_Player1
    endif
    set i = 1
    loop
        exitwhen i > udg_ResearchMax
        if udg_ResearchType[i] == t then
            set t1 = GetPlayerTechMaxAllowed(p1, t)
            set t2 = GetPlayerTechMaxAllowed(p2, t)
            
            // In one of the players transfered the building that doing the research
            // Without this, it wouldn't let the other player research the next level(s)
            if t1 >= t2 then
                set tn = GetPlayerTechCount(p1, t, true)
                        
                call SetPlayerTechMaxAllowed(p1, t, t1)
                call SetPlayerTechResearched(p1, t, tn)

                call SetPlayerTechMaxAllowed(p2, t, t1)
                call SetPlayerTechResearched(p2, t, tn)
            else
                set tn = GetPlayerTechCount(p2, t, true)
                        
                call SetPlayerTechMaxAllowed(p1, t, t2)
                call SetPlayerTechResearched(p1, t, tn)

                call SetPlayerTechMaxAllowed(p2, t, t2)
                call SetPlayerTechResearched(p2, t, tn)
            endif
            
            call DisplayTextToPlayer(GetLocalPlayer(), 0, 0, "|cff9966ccRESEARCH|r - " + GetPlayerName(p1) + " has researched " + udg_ResearchString[(i - 1)*3 + tn] + " for both players.")
            call StartSound(gg_snd_Hint)
            
            exitwhen true
        endif
        set i = i + 1
    endloop
    
    set p1 = null
    set p2 = null
    return false
endfunction

function ResearchCancel takes nothing returns boolean
    local player p1 = GetTriggerPlayer()
    local player p2
    local integer t = GetResearched()
    local integer i
    local integer t1
    local integer t2
    
    if p1 == udg_MG_Player1 then
        set p2 = udg_Player2
    else
        set p2 = udg_MG_Player1
    endif
    set i = 1
    loop
        exitwhen i > udg_ResearchMax
        if udg_ResearchType[i] == t then
            set t1 = GetPlayerTechMaxAllowed(p1, t)
            set t2 = GetPlayerTechMaxAllowed(p2, t)
            
            // In one of the players transfered the building that doing the research
            // Without this, it wouldn't let the other player research the next level(s)
            if t1 >= t2 then
                call SetPlayerTechMaxAllowed(p1, t, t1)
                call SetPlayerTechMaxAllowed(p2, t, t1)
            else
                call SetPlayerTechMaxAllowed(p1, t, t2)
                call SetPlayerTechMaxAllowed(p2, t, t2)
            endif
            
            exitwhen true
        endif
        set i = i + 1
    endloop
    
    set p1 = null
    set p2 = null
    return false
endfunction

function InitTrig_ResearchShare takes nothing returns nothing
    local trigger t1 = CreateTrigger()
    local trigger t2 = CreateTrigger()
    local trigger t3 = CreateTrigger()
    
    call TriggerRegisterPlayerUnitEvent(t1, udg_MG_Player1, EVENT_PLAYER_UNIT_RESEARCH_START, null)
    call TriggerRegisterPlayerUnitEvent(t1, udg_Player2, EVENT_PLAYER_UNIT_RESEARCH_START, null)
    call TriggerAddCondition(t1, Condition(function ResearchStart))
    
    call TriggerRegisterPlayerUnitEvent(t2, udg_MG_Player1, EVENT_PLAYER_UNIT_RESEARCH_FINISH, null)
    call TriggerRegisterPlayerUnitEvent(t2, udg_Player2, EVENT_PLAYER_UNIT_RESEARCH_FINISH, null)
    call TriggerAddCondition(t2, Condition(function ResearchComplete))
    
    call TriggerRegisterPlayerUnitEvent(t3, udg_MG_Player1, EVENT_PLAYER_UNIT_RESEARCH_CANCEL, null)
    call TriggerRegisterPlayerUnitEvent(t3, udg_Player2, EVENT_PLAYER_UNIT_RESEARCH_CANCEL, null)
    call TriggerAddCondition(t3, Condition(function ResearchCancel))
	
	// Research IDs
    set udg_ResearchType[1] = 'Resm'
    set udg_ResearchType[2] = 'Resw'
    set udg_ResearchType[3] = 'Rema'
    set udg_ResearchType[4] = 'Rerh'
    set udg_ResearchType[5] = 'Reuv'
    set udg_ResearchType[6] = 'Repb'
    set udg_ResearchType[7] = 'Renb'
    set udg_ResearchType[8] = 'Resc'
    set udg_ResearchType[9] = 'Remg'
    set udg_ResearchType[10] = 'Reib'
    set udg_ResearchType[11] = 'Remk'
    set udg_ResearchType[12] = 'Redt'
    set udg_ResearchType[13] = 'Redc'
    set udg_ResearchType[14] = 'Resi'
    set udg_ResearchType[15] = 'Recb'
    set udg_ResearchType[16] = 'Reht'
    set udg_ResearchMax = 16
	
    // Research Strings
	// string of research = (<index of research> - 1)*3 + <level of research>
	// up to 3 levels
    set udg_ResearchString[1] = "Strength of the Moon"
    set udg_ResearchString[2] = "Improved Strength of the Moon"
    set udg_ResearchString[3] = "Advanced Strength of the Moon"
    set udg_ResearchString[4] = "Strength of the Wild"
    set udg_ResearchString[5] = "Improved Strength of the Wild"
    set udg_ResearchString[6] = "Advanced Strength of the Wild"
    set udg_ResearchString[7] = "Moon Armor"
    set udg_ResearchString[8] = "Improved Moon Armor"
    set udg_ResearchString[9] = "Advanced Moon Armor"
    set udg_ResearchString[10] = "Strength of the Wild"
    set udg_ResearchString[11] = "Improved Strength of the Wild"
    set udg_ResearchString[12] = "Advanced Strength of the Wild"
    set udg_ResearchString[13] = "Ultravision"
    set udg_ResearchString[16] = "Impaling Bolts"
    set udg_ResearchString[19] = "Nature's Blessing"
    set udg_ResearchString[22] = "Sentinel"
    set udg_ResearchString[25] = "Upgrade Moon Glaive"
    set udg_ResearchString[28] = "Improved Bows"
    set udg_ResearchString[31] = "Marksmanship"
    set udg_ResearchString[34] = "Druid of the Talon Adept Training"
    set udg_ResearchString[35] = "Druid of the Talon Master Training"
    set udg_ResearchString[37] = "Druid of the Claw Adept Training"
    set udg_ResearchString[38] = "Druid of the Claw Master Training"
    set udg_ResearchString[40] = "Abolish Magic"
    set udg_ResearchString[43] = "Corrosive Breath"
    set udg_ResearchString[46] = "Hippogryph Taming"
    set udg_ResearchString[49] = "Mark of the Claw"
    set udg_ResearchString[52] = "Mark of the Talon"
    
    set t1 = null
    set t2 = null
    set t3 = null
endfunction