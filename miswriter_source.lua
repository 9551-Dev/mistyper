local keyboard,math_random,term_ref,mistyped_string,seed_state,found_loc,char_lw,char_in,sector,x_offset,keyboard_x,new_index,old_blit,old_write =
"qwertyuiopasdfghjkl\0\0zxcvbnm\0\0",math.random,term
old_blit,old_write = term_ref.blit,term_ref.write

function term_ref.write(text,fg,bg)
    seed_state,mistyped_string = 0,{}

    for char_index,character in tostring(text):gmatch"()(.)" do
        char_lw = character:lower()

        seed_state                  = seed_state + character:byte()
        found_loc                   = keyboard:find(char_lw,1,1)
        mistyped_string[char_index] = character

        math.randomseed(seed_state)

        if 2>math_random(5) and found_loc then
            repeat
                sector = math_random(0,1)

                x_offset   = sector*(math_random(2)*2-3)
                new_index  = found_loc + x_offset + (math_random(2)*2-3)*10*(1-sector)
                keyboard_x = (found_loc-1)%10+1

                if new_index > 0 and keyboard_x+x_offset < 11 and keyboard_x+x_offset > 0 then
                    char_in = keyboard:sub(new_index,new_index)
                end
            until (char_in or""):match"%w"

            mistyped_string[char_index] = (character == char_lw) and char_in or char_in:upper()
        end
    end

    (fg and old_blit or old_write)(table.concat(mistyped_string),fg,bg)
end

term_ref.blit = term_ref.write