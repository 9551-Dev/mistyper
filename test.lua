local keyboard,row_length =
    "qwertyuiop"
..  "asdfghjkl "
..  " zxcvbnm  ",10

local keyboard_map,location_map = setmetatable({{},{},{}},{__index=function()
    return {}
end}),{}


for idx,char in keyboard:gmatch"()(.)" do
    local x,y = (idx-1)%row_length+1,math.ceil(idx/row_length)
    keyboard_map[y][x] = char
    location_map[char] = {x,y}
end


local rand_1_sector = {0,1,0}
local rand_2_sector = {0,0,1}

local function create_typo(key)
    local selected,low = "",key:lower()
    local pressed_loc  = location_map[low]

    while not selected or not selected:match"%w" do
        local sector = math.random(1,3)
        local e1,e2  = rand_1_sector[sector],rand_2_sector[sector]

        selected = keyboard_map[
            pressed_loc[2]+math.random(-1*e2,1*e2)
        ][
            pressed_loc[1]+math.random(-1*e1,1*e1)
        ]
    end

    if selected == "j" then sleep(2) end

    return (key == low) and selected or selected:upper()
end

function os.pullEventRaw(...)
    local ev_data = table.pack(coroutine.yield(...))
    local char_in = ev_data[2]
    if ev_data[1] == "char" and math.random(1,10) == 1 and char_in ~= " " and location_map[char_in:lower()] then
        ev_data[2] = create_typo(char_in)
    end
    return table.unpack(ev_data,1,ev_data.n)
end