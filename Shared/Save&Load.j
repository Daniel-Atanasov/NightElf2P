//
//	Edited version of Acehart's Save/Load system
//		http://www.thehelper.net/threads/save-load-code-yet-another.41354/
//
function SL_Add takes integer int, integer length returns nothing
    local integer l
    local integer i
    local string s = I2S(int)
    set l = StringLength(s)
    set i = 0
    loop
        exitwhen i == length - l
        set s = "0" + s
        set i = i + 1
    endloop
    set udg_SL_BufferSave = s + udg_SL_BufferSave
endfunction

function SL_Get takes integer length returns integer
    local integer i = StringLength(udg_SL_BufferLoad) - udg_SL_BufferPos
    if i <= 0 then
        return 0
    endif
    if length >= i then
        set udg_SL_BufferPos = i + udg_SL_BufferPos
        return S2I(SubString(udg_SL_BufferLoad, 0, i))
    else
        set udg_SL_BufferPos = udg_SL_BufferPos + length
        return S2I(SubString(udg_SL_BufferLoad, i - length, i))
    endif
endfunction

function SL_Encode takes nothing returns nothing
    local integer i
    local integer j
    local integer k
    local integer l
    local integer m
    local integer array a
    local string buffer
    local string c = ""
    local integer skip = 0
    local integer CONST = 1000000
    local string abc = "0123456789"

    set i = 0
    set j = StringLength(udg_SL_BufferSave)
    set k = 0
    loop
        exitwhen i >= j
        set k = k + S2I(SubString(udg_SL_BufferSave, i, i + 1))
        set i = i + 1
    endloop

	set c = I2S(k + j)
	loop
		set c = "0" + c
		exitwhen StringLength(c) >= 3
	endloop
	
    set buffer = udg_SL_BufferSave + c

    set i = 0
    loop
        set a[i] = 0
        set i = i + 1
        exitwhen i >= 100
    endloop

    set m = 0
    set i = 0
    loop
        set j = 0
        loop
            set a[j] = a[j] * 10
            set j = j + 1
            exitwhen j > m
        endloop

        set l = 0
        set c = SubString(buffer, i, i + 1)
        loop
            exitwhen SubString(abc,l,l + 1) == c
            set l = l + 1
            exitwhen l >= 9
        endloop
        set a[0] = a[0] + l

        set j = 0
        loop
            set k = a[j] / CONST
            set a[j] = a[j] - k * CONST
            set a[j + 1] = a[j + 1] + k
            set j = j + 1
            exitwhen j > m
        endloop
        if k > 0 then
            set m = m + 1
        endif
        set i = i + 1
        exitwhen i >= StringLength(buffer)
    endloop

    set buffer = ""
    loop
        exitwhen m < 0
        set j = m
        loop
            exitwhen j <= 0
            set k = a[j] / udg_SL_DigitCount
            set a[j - 1] = a[j - 1] + (a[j] - k * udg_SL_DigitCount) * CONST
            set a[j] = k
            set j = j - 1
        endloop
        set k = a[j] / udg_SL_DigitCount
        set i = a[j] - k * udg_SL_DigitCount
        set buffer = buffer + udg_SL_Digit[i]
        set a[j] = k
        if a[m] == 0 then
            set m = m - 1
        endif
    endloop

    set i = StringLength(buffer)
    set skip = 0
    set c = ""
    loop
        set i = i - 1
        set c = c + SubString(buffer, i, i + 1)
        set skip = skip + 1
        if skip == 4 and i > 0 then
            set c = c + "-"
            set skip = 0
        endif
        exitwhen i <= 0
    endloop

    set udg_SL_Code = c
endfunction

function SL_Decode takes string s returns boolean
    local integer i
    local integer j
    local integer k
    local integer l
    local integer m
    local integer SaveCode = 0
    local integer array a
    local string buffer = ""
    local integer skip = -1
    local integer CONST = 1000000
    local string abc = "0123456789"
    local string c

    set i = 0
    set j = StringLength(s)
    loop
        exitwhen i >= j
        if SubString(s, i, i + 1) == "-" then
            set s = SubString(s, 0, i) + SubString(s, i + 1, j)
            set i = i - 1
        endif
        set i = i + 1
    endloop

    set i = 0
    loop
        set a[i] = 0
        set i = i + 1
        exitwhen i >= 100
    endloop

    set m = 0

    set i = 0
    loop
        set j = 0
        loop
            set a[j] = a[j] * udg_SL_DigitCount
            set j = j + 1
            exitwhen j > m
        endloop

        set l = udg_SL_DigitCount
        set c = SubString(s, i, i + 1)
        loop
            set l = l - 1
            exitwhen l < 1
            exitwhen udg_SL_Digit[l] == c
        endloop
        set a[0] = a[0] + l

        set j = 0
        loop
            set k = a[j] / CONST
            set a[j] = a[j] - k * CONST
            set a[j + 1] = a[j + 1] + k
            set j = j + 1
            exitwhen j > m
        endloop
        if k > 0 then
            set m = m + 1
        endif
        set i = i + 1
        exitwhen i >= StringLength(s)
    endloop

    loop
        exitwhen m < 0
        set j = m
        loop
            exitwhen j <= 0
            set k = a[j] / 10
            set a[j - 1] = a[j - 1] + (a[j] - k * 10) * CONST
            set a[j] = k
            set j = j - 1
        endloop
        set k = a[j] / 10
        set i = a[j] - k * 10
        set buffer = SubString(abc, i, i + 1) + buffer
        set a[j] = k
        if a[m] == 0 then
            set m = m - 1
        endif
    endloop

    set i = 0
    set j = 0
    set udg_SL_BufferLoad = ""
    loop
        loop
            exitwhen i >= StringLength(buffer)
            exitwhen i > 0 and SubString(buffer, i, i + 1) == "-" and SubString(buffer, i - 1, i) != "-"
            set i = i + 1
        endloop
        if i < StringLength(buffer) then
            set k = i
        endif

        set udg_SL_BufferLoad = udg_SL_BufferLoad + SubString(buffer, j, i)
        set j = i + 1
        set i = i + 1
        exitwhen i >= StringLength(buffer)
    endloop

    set i = 1
    set j = StringLength(udg_SL_BufferLoad)
	set k = SL_Get(3)
	set l = 0
	loop
		exitwhen i >= j - 3
		
		set l = l + S2I(SubString(udg_SL_BufferLoad, i - 1, i))
		set i = i + 1
	endloop

    return l + j - 3 == k
endfunction

function InitSaveLoad takes nothing returns nothing
    local integer i
    
	set udg_SL_DigitCount = StringLength(udg_SL_ABC)
	
    set i = 0
    loop
        exitwhen i == udg_SL_DigitCount
        
        set udg_SL_Digit[i] = SubString(udg_SL_ABC, i, i + 1)
        
        set i = i + 1
    endloop
endfunction