local keyboard,row_length =
    "qwertyuiop"
..  "asdfghjkl "
..  " yxcvbnm  ",10

local offsets = {0,0,1,0,0,1,-1,0,0,-1}

local typo_mappings = {}
for i=1,#keyboard do
    typo_mappings[keyboard:sub(i,i)] = i
end

local function create_typo(key)
    local selected    = ""
    local start_index = typo_mappings[key]

    local x_offset,y_offset,new_index
    while not selected:match("%w") or new_index < 1 or (start_index%row_length == 1 and x_offset < 0) or (start_index%row_length + x_offset) > 10 do
        local offset_idx = math.random(1,5)*2
        x_offset = offsets[offset_idx-1]
        y_offset = offsets[offset_idx  ]

        new_index = start_index + x_offset + y_offset * row_length

        selected = keyboard:sub(new_index,new_index)
    end

    return selected
end

local test_inp = read()
for i=1,10 do
    print(create_typo(test_inp))
end