// Helper function so it less of a pain to do presets in different maps
function ShareBuilding takes unit building returns boolean
	local player p
	local unit u
    local integer id = GetUnitTypeId(building)
    local integer i
    local integer hid = GetHandleId(building)
    local real x = GetUnitX(building)
    local real y = GetUnitY(building)
	local boolean b = false
	
	if GetOwningPlayer(building) == udg_MG_Player1 then
		set p = udg_Player2
	else
		set p = udg_MG_Player1
	endif
	set u = LoadUnitHandle(udg_MG_TechHash, 0, hid)
	if not (u == null) then
		set b = true
		call RemoveUnit(u)
	endif
	
	set i = id - 'e'*256*256*256 + 'z'*256*256*256
    set u = CreateUnit(p, i, x, y, 0)
	
    call SetUnitX(u, x)
    call SetUnitY(u, y)
	
    call SaveUnitHandle(udg_MG_TechHash, 0, hid, u)
	
	set p = null
	set u = null
	
	return b
endfunction

function ConstructionComplete takes nothing returns boolean
    local player p = GetTriggerPlayer()
    local unit u = GetTriggerUnit()
    local integer id = GetUnitTypeId(u)
	local string s

    if (p == udg_MG_Player1 or p == udg_Player2) and (id == 'etol' or id == 'etoa' or id == 'etoe' or id == 'eate' or id == 'eaom' or id == 'edob') then
		set s = GetUnitName(u)
		if ShareBuilding(u) then
			call DisplayTextToPlayer(GetLocalPlayer(), 0, 0, "|cff6666ccTECHTREE|r - " + GetPlayerName(p) + " has upgraded to " + s + " for both players.")
		elseif SubString(s, 0, 1) == "a" then
			call DisplayTextToPlayer(GetLocalPlayer(), 0, 0, "|cff6666ccTECHTREE|r - " + GetPlayerName(p) + " has constructed an " + s + " for both players.")
		else
			call DisplayTextToPlayer(GetLocalPlayer(), 0, 0, "|cff6666ccTECHTREE|r - " + GetPlayerName(p) + " has constructed a " + s + " for both players.")
		endif
    endif

	set p = null
	set u = null
    return false
endfunction

function BuildingDies takes nothing returns boolean
    local unit u1 = GetTriggerUnit()
    local unit u2
    local integer id = GetUnitTypeId(u1)

    if id == 'etol' or id == 'etoa' or id == 'etoe' or id == 'eate' or id == 'eaom' or id == 'edob' then
        set u2 = LoadUnitHandle(udg_MG_TechHash, 0, GetHandleId(u1))
        if not (u2 == null) then
            call RemoveUnit(u2)
        endif
    endif

    set u1 = null
    set u2 = null
    return false
endfunction

function InitTrig_TechShare takes nothing returns nothing
    local trigger t1 = CreateTrigger()
    local trigger t2 = CreateTrigger()
    local unit u
    local real x
    local real y
    
    set udg_MG_TechHash = InitHashtable()
    
    //On Completion
    call TriggerRegisterPlayerUnitEvent(t1, udg_MG_Player1, EVENT_PLAYER_UNIT_CONSTRUCT_FINISH, null)
    call TriggerRegisterPlayerUnitEvent(t1, udg_Player2, EVENT_PLAYER_UNIT_CONSTRUCT_FINISH, null)
    call TriggerRegisterPlayerUnitEvent(t1, udg_MG_Player1, EVENT_PLAYER_UNIT_UPGRADE_FINISH, null)
    call TriggerRegisterPlayerUnitEvent(t1, udg_Player2, EVENT_PLAYER_UNIT_UPGRADE_FINISH, null)
    call TriggerAddCondition(t1, Condition(function ConstructionComplete))
    
    //On Death
    call TriggerRegisterPlayerUnitEvent(t2, udg_MG_Player1, EVENT_PLAYER_UNIT_DEATH, null)
    call TriggerRegisterPlayerUnitEvent(t2, udg_Player2, EVENT_PLAYER_UNIT_DEATH, null)
    call TriggerAddCondition(t2, Condition(function BuildingDies))
    
    //Blue TOA
	call ShareBuilding(gg_unit_etoa_0189)
    
    //Teal TOL
	call ShareBuilding(gg_unit_etol_0001)
    
    //Teal AOW
	call ShareBuilding(gg_unit_eaom_0045)
    
    //Teal HH
	call ShareBuilding(gg_unit_edob_0103)
endfunction