function ExchangeUnits takes nothing returns nothing
    local player p1 = GetTriggerPlayer()
    local player p2
    local group units = CreateGroup()
    local boolean b1
    local boolean b2
    local boolean b3
    local boolean b4
    local integer food = 0
    local integer uyes = 0
    local integer uall = 0
    local integer fUsed
    local integer fMax
    local integer i
    local unit u
    local unit u1
    local unit u2
    local string result
    local string result2
    
    if p1 == udg_MG_Player1 then
        set p2 = udg_Player2
    else
        set p2 = udg_MG_Player1
    endif
    
    // Gonna get reused
    set fUsed = GetPlayerState(p2, PLAYER_STATE_RESOURCE_FOOD_USED)
    set fMax = GetPlayerState(p2, PLAYER_STATE_RESOURCE_FOOD_CAP)
    
    call GroupEnumUnitsSelected(units, p1, null)
    set u = FirstOfGroup(units)
    loop
        set u = FirstOfGroup(units)
        exitwhen u == null
        set i = GetUnitFoodUsed(u)
        
        // Kinda confusing but better than a mile long line, trust me
        set b1 = GetUnitFoodMade(u) == 0 and IsUnitType(u, UNIT_TYPE_STRUCTURE)
        set b2 = i + fUsed <= fMax and not IsUnitType(u, UNIT_TYPE_STRUCTURE)
        set b3 = not (IsUnitType(u, UNIT_TYPE_HERO) or IsUnitType(u, UNIT_TYPE_SUMMONED) or IsUnitType(u, UNIT_TYPE_PEON))
        set b4 = GetOwningPlayer(u) == p1 and GetUnitTypeId(u) != 'eate'
        
        if (b1 or b2) and b3 and b4 then
            set uyes = uyes + 1
            set food = food + i
            call SetUnitOwner(u, p2, true)
            
            set u1 = LoadUnitHandle(udg_MG_TechHash, 0, GetHandleId(u))
            if u1 != null then
                call SetUnitOwner(u1, p1, true)
            endif
            
            set u2 = LoadUnitHandle(udg_MG_TechHash, 1, GetHandleId(u))
            if u2 != null then
                call SetUnitOwner(u2, p1, true)
            endif
            call PingMinimap(GetUnitX(u), GetUnitY(u), 3)
        endif
        set uall = uall + 1
        call GroupRemoveUnit(units, u)
    endloop
    
    if uyes == uall and uall != 0 then
        call StartSound(gg_snd_Rescue)
        set result = "|cffcc6600ALLIES|r - All " + I2S(uall) + " units were exchanged successfully"
        set result2 = "|cffcc6600ALLIES|r - " + I2S(uyes) + " units were exchanged to you"
        if food > 0 then
            set result = result + " - a total of " + I2S(food) + " food."
            set result2 = result2 + " - a total of " + I2S(food) + " food."
        else
            set result = result + "."
            set result2 = result2 + "."
        endif
    elseif uyes != 0 then
        if udg_LocalPlayer == p1 then
            call StartSound(gg_snd_Error)
        elseif udg_LocalPlayer == p2 then
			call StartSound(gg_snd_Rescue)
		endif
        set result = "|cffcc6600ALLIES|r - " + I2S(uyes) + "/" + I2S(uall) + " units were successfully exchanged"
        set result2 = "|cffcc6600ALLIES|r - " + I2S(uyes) + " units were exchanged to you"
        if (food > 0) then
            set result = result + " - a total of " + I2S(food) + " food"
            set result2 = result2 + " - a total of " + I2S(food) + " food"
        else
            set result = result + "."
            set result2 = result2 + "."
        endif
    elseif uall != 0 then
        if udg_LocalPlayer == p1 then
            call StartSound(gg_snd_Error)
        endif
        set result = "|cffcc6600ALLIES|r - No units could be exchanged."
        set result2 = "Empty"
    else
        if udg_LocalPlayer == p1 then
            call StartSound(gg_snd_Error)
        endif
        set result = "|cffcc6600ALLIES|r - No units selected."
        set result2 = "Empty"
    endif
    call DisplayTextToPlayer(p1, 0, 0, " ")
    call DisplayTextToPlayer(p2, 0, 0, " ")
    call DisplayTextToPlayer(p1, 0, 0, result)
    if result2 != "Empty" then
        call DisplayTextToPlayer(p2, 0, 0, result2)
    endif
    if not udg_MG_UExchangeTip then
        set udg_MG_UExchangeTip = true
        call TriggerSleepAction(bj_QUEUE_DELAY_HINT)
        call StartSound(gg_snd_Hint)
        call DisplayTextToPlayer(GetLocalPlayer(), 0, 0, " ")
        call DisplayTextToPlayer(GetLocalPlayer(), 0, 0, "|cff32CD32HINT|r  - You cannot exchange Wisps, Heroes, Tree of Life/Tree of Ages/Tree of Eternity, Altars and Moon Wells.")
        call DisplayTextToPlayer(GetLocalPlayer(), 0, 0, "Units must also obey the food limit.")
    endif
    call DestroyGroup(units)
    
    set units = null
    set u = null
    set u1 = null
    set u2 = null
    set p1 = null
    set p2 = null
endfunction

function InitTrig_ExchangeUnits takes nothing returns nothing
    set gg_trg_ExchangeUnits = CreateTrigger()
    call DisableTrigger(gg_trg_ExchangeUnits)
    call TriggerRegisterPlayerChatEvent(gg_trg_ExchangeUnits, udg_MG_Player1, "-exchange", true)
    call TriggerRegisterPlayerChatEvent(gg_trg_ExchangeUnits, udg_Player2, "-exchange", true)
    call TriggerAddAction(gg_trg_ExchangeUnits, function ExchangeUnits)
endfunction