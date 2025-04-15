local keyboard,math_random,unique =
"qwertyuiopasdfghjkl\0\0zxcvbnm\0\0",
math.random,{}

function os.pullEventRaw(...)
    local ev_data   = table.pack(coroutine.yield(...))
    local char_in,_ = ev_data[2]
    if ev_data[1] == "char" and math_random(1,50) < 2 and keyboard:find(char_in:lower(),_,1) and ev_data[3] ~= unique then
        local char_lw,char_in = char_in:lower()
        while not char_in or not char_in:match"%w" do
            local sector,symbol_id = math_random(0,1),keyboard:find(char_lw,_,true_val)

            local x_offset,keyboard_x =
                (math_random(1,2)*2-3)*sector,
                (symbol_id-1)%10+1

            local new_index = symbol_id + x_offset + (math_random(1,2)*2-3)*(1-sector)*10
            if new_index > 0 and keyboard_x+x_offset <= 10 and keyboard_x+x_offset > 0 then
                char_in = keyboard:sub(new_index,new_index)
            end
        end

        ev_data[2],ev_data[3],ev_data.n = (ev_data[2] == char_lw) and char_in or char_in:upper(),unique,3
    end
    return table.unpack(ev_data,1,ev_data.n)
end