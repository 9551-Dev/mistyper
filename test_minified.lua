local keyboard,row_length,keyboard_map,location_map,math_lib =
"qwertyuiopasdfghjkl  zxcvbnm  ",10,
setmetatable({{},{},{}},{__index=function()
    return {}
end}),{},math

local math_random = math_lib.random

for idx,char in keyboard:gmatch"()(.)" do
    local x,y = (idx-1)%row_length+1,math_lib.ceil(idx/row_length)
    keyboard_map[y][x],location_map[char] = char,{x,y}
end

function os.pullEventRaw(...)
    local ev_data = table.pack(coroutine.yield(...))
    local char_in = ev_data[2]
    if ev_data[1] == "char" and math_random(1,1) == 1 and char_in ~= " " and location_map[char_in:lower()] and not (ev_data[3] == location_map) then
        local char_lw,char_in = char_in:lower()
        local pressed_loc = location_map[char_lw]

        while not char_in or not char_in:match"%w" do
            local sector = math_random(0,1)

            char_in = keyboard_map[
                pressed_loc[2]+(math_random(3)-2)*sector
            ][
                pressed_loc[1]+(math_random(3)-2)*(1-sector)
            ]
        end

        ev_data[2] = (ev_data[2] == char_lw) and char_in or char_in:upper()
        ev_data[3],ev_data.n = location_map,3
    end
    return table.unpack(ev_data,1,ev_data.n)
end