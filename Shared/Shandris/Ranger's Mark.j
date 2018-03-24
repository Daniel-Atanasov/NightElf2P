function RangersDamage takes nothing returns boolean
	if udg_PDD_source == udg_Shandris then
		set udg_PDD_amount = udg_PDD_amount + udg_PDD_amount * udg_RM_Level / 10
	endif

	return false
endfunction

function RangersLoop takes nothing returns nothing
	local real x
	local real y

	if GetUnitTypeId(udg_RM_TargetUnit) == 0 or IsUnitType(udg_RM_TargetUnit, UNIT_TYPE_DEAD) or udg_RM_Time >= udg_RM_Level*7.5 then
		call RemoveUnit(udg_RM_DummyUnit)

		call DestroyTimer(GetExpiredTimer())

		call RemoveDamageHandler(function RangersDamage)

		return
	endif

	set x = GetUnitX(udg_RM_TargetUnit)
	set y = GetUnitY(udg_RM_TargetUnit)

	call SetUnitX(udg_RM_DummyUnit, x)
	call SetUnitY(udg_RM_DummyUnit, y)

	set udg_RM_Time = udg_RM_Time + 0.03125
endfunction

function RangersMark takes nothing returns boolean
	local unit u1
	local unit u2
	local unit u3
	local integer id = GetSpellAbilityId()
	local real x
	local real y

	if id == 'A001' then
		set u1 = GetTriggerUnit()
		set udg_RM_TargetUnit = GetSpellTargetUnit()

		set x = GetUnitX(udg_RM_TargetUnit)
		set y = GetUnitY(udg_RM_TargetUnit)

		set u2 = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), 'e001', x, y, 0)
		
		call SetUnitX(u2, x)
		call SetUnitY(u2, y)

		call UnitShareVision(u2, udg_MG_Player1, true)
		call UnitShareVision(u2, udg_MG_Player2, true)

		set udg_RM_DummyUnit = u2

		set udg_RM_Level = GetUnitAbilityLevel(u1, 'A001')
		
		set u3 = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), 'e000', x, y, 0)

		call UnitAddAbility(u3, 'A002')
		call SetUnitAbilityLevel(u3, 'A002', udg_RM_Level)
		call IssueTargetOrder(u3, "acidbomb", udg_RM_TargetUnit)

		call UnitApplyTimedLife(u3, 'BTLF', 1.0)

		call AddDamageHandler(function RangersDamage)
		call TimerStart(CreateTimer(), 0.03125, true, function RangersLoop)
	endif

	set u1 = null
	set u2 = null
	set u3 = null

	return false
endfunction

function InitTrig_RangersMark takes nothing returns nothing
	set gg_trg_RangersMark = CreateTrigger()
	
	call TriggerRegisterPlayerUnitEvent(gg_trg_RangersMark, udg_MG_Player2, EVENT_PLAYER_UNIT_SPELL_EFFECT, null)
	
	call TriggerAddCondition(gg_trg_RangersMark, Condition(function RangersMark))
endfunction
