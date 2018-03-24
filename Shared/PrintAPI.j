// Printing wrappers for convenience
// Makes code much more readable, not really gonna slow down anything
// plus, jasshelper will inline most of it
function InitPrint takes nothing returns nothing
	set udg_MG_PrintHash = InitHashtable()
	
	set udg_MG_errorSound = CreateSound("Sound\\Interface\\Error.wav", false, false, false, 10000, 10000, "")
endfunction

function PrintPlayer takes player p, string message returns nothing
	call DisplayTextToPlayer(p, 0, 0, message)
endfunction

function PrintPlayerTimed takes player p, real time, string message returns nothing
	call DisplayTimedTextToPlayer(p, 0, 0, time, message)
endfunction

function Print takes string message returns nothing
	call PrintPlayer(GetLocalPlayer(), message)
endfunction

function PrintDebug takes string message returns nothing 
	call Print("|cffff0000DEBUG|r - " + message)
endfunction

function PrintTimed takes real time, string message returns nothing
	call PrintPlayerTimed(GetLocalPlayer(), time, message)
endfunction

function PrintLong takes string message returns nothing
	call PrintTimed(600.0, message)
endfunction

// General function for queued messages, such as hints,
// units received and maybe even quest stuff
function PrintQueue takes nothing returns boolean
	local trigger trig = GetTriggeringTrigger()
	
	local string message = LoadStr(udg_MG_PrintHash, GetHandleId(trig), 0)
	local sound snd = LoadSoundHandle(udg_MG_PrintHash, GetHandleId(trig), 1)
	local real time = LoadReal(udg_MG_PrintHash, GetHandleId(trig), 2)
	
	call PrintTimed(time, " ")
	call PrintTimed(time, message)
	call StartSound(snd)
	
	call DestroyTrigger(trig)
	
	return false
endfunction

function PrintQueuedMessage takes string message, real time, sound s, bool queued returns nothing
	local trigger t
	
	if queued then
		set t = CreateTrigger()
		call TriggerAddCondition(t, Condition(function PrintQueue))
		
		call SaveStr(udg_MG_PrintHash, GetHandleId(t), 0, message)
		call SaveSoundHandle(udg_MG_PrintHash, GetHandleId(t), 1, s)
		call SaveReal(udg_MG_PrintHash, GetHandleId(t), 2, time)
		
		// Just in case, you never know
		// Probably not gonna print anything anytime soon
		if not QueuedTriggerAddBJ(t, true) then
			call PrintDebug("Printing hint failed, trigger queue full")
		endif
		
	else
		call PrintTimed(time, " ")
		call PrintTimed(time, message)
		call StartSound(s)
	endif
endfunction

function PrintHint takes string message, boolean queued returns nothing
	call PrintQueuedMessage("|cff32CD32HINT|r  - " + message, bj_TEXT_DELAY_HINT, bj_questHintSound, queued)
endfunction

// function PrintNote takes string message, boolean queued returns nothing
// 	call PrintQueuedMessage("|cff32CD32HINT|r  - " + message, bj_TEXT_DELAY_HINT, bj_questHintSound, queued)
// endfunction

function PrintAllies takes player p, string message returns nothing
	call PrintPlayer(p, "|cffcc6600ALLIES|r - " + message)
endfunction