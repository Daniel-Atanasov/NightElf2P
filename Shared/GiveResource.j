function GiveResource takes nothing returns nothing
    local playerstate ps
    local integer i
    local integer a
    local player p1 = GetTriggerPlayer()
    local player p2
    local string tmp
    local string resource
    local string message = GetEventPlayerChatString()
    local string gold = SubString(message, 0, 6)
    local string lumber = SubString(message, 0, 8)
    
    if gold == "-gold " or lumber == "-lumber " then
        if p1 == udg_MG_Player1 then
            set p2 = udg_Player2
        else
            set p2 = udg_MG_Player1
        endif
        if gold == "-gold " then
            set resource = "gold"
            set ps = PLAYER_STATE_RESOURCE_GOLD
            set a = S2I(SubString(message, 6, StringLength(message)))
        else
            set resource = "lumber"
            set ps = PLAYER_STATE_RESOURCE_LUMBER
            set a = S2I(SubString(message, 8, StringLength(message)))
        endif
        
        set i = GetPlayerState(p1, ps)
        
        if a > i then
            set a = i
        endif
        if a > 0 then
            set tmp = I2S(a)
            call SetPlayerState(p1, ps, i - a)
            call SetPlayerState(p2, ps, GetPlayerState(p2, ps) + a)
            call DisplayTextToPlayer(p2, 0, 0, "|cffcc6600ALLIES|r - " + tmp + " " + resource + " received from " + GetPlayerName(p1) + ".")
            call DisplayTextToPlayer(p1, 0, 0, "|cffcc6600ALLIES|r - " + tmp + " " + resource + " sent to " + GetPlayerName(p2) + ".")
            if GetLocalPlayer() == p2 then
                call StartSound(gg_snd_ItemReceived)
            endif
        else
            call DisplayTextToPlayer(p1, 0, 0, "|cffcc6600ALLIES|r - Not enough " + resource + ".")
        endif
    endif
    set ps = null
    set p1 = null
    set p2 = null
endfunction

function InitTrig_GiveResource takes nothing returns nothing
    set gg_trg_GiveResource = CreateTrigger()
    call DisableTrigger(gg_trg_GiveResource)
    
    call TriggerRegisterPlayerChatEvent(gg_trg_GiveResource, udg_MG_Player1, "-gold ", false)
    call TriggerRegisterPlayerChatEvent(gg_trg_GiveResource, udg_Player2, "-gold ", false)
    call TriggerRegisterPlayerChatEvent(gg_trg_GiveResource, udg_MG_Player1, "-lumber ", false)
    call TriggerRegisterPlayerChatEvent(gg_trg_GiveResource, udg_Player2, "-lumber ", false)
    call TriggerAddAction(gg_trg_GiveResource, function GiveResource)
endfunction