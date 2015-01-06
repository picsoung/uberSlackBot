-- fct to split a string by a delimeter
local function split(s, delimiter)
    local result = {}
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end

local hex_to_char = function(x)
    return string.char(tonumber(x, 16))
end

local unescape = function(url)
    return url:gsub("%%(%x%x)", hex_to_char)
end

return function(request, next_middleware)
    local response = next_middleware()
    local hookURL = "SLACK_INCOMING_HOOK_URL"

    if(request.uri == '/hook') then
        local params = split(request.body,'&')
        local decoded_params = {}
        -- turn urlencoded string into an object
        for i=1,#params do
            local p = split(params[i],'=')
            decoded_params[p[1]] = p[2]
        end

        local query = decoded_params['text']
        query = unescape(query) -- decode special chars
        query = string.gsub(query,"+"," ") -- turn + into spaces

        if(string.match(query,"^uber price start=[a-zA-Z0-9_, ]* end=[a-zA-Z0-9_, ]*")) then
            console.log("MATCH")
            local start_point = string.sub(query,string.find(query, "start=")+6,string.find(query, "end=")-2)
            local end_point = string.sub(query,string.find(query, "end=")+4)

            start_point = string.gsub(start_point," ","%%20")
            end_point = string.gsub(end_point," ","%%20")

            local url = "APITOOLS_UBER_SERVICE_URL/estimates/price?start_point="..start_point.."&end_point="..end_point.."&channel="..decoded_params.channel_name
            console.log(url)
            local r = http.get(url)
            console.log(r)
        else
          console.log("DONT MATCH")
          msg = 'Malformated request. Format is: `uber price start=START_ADDRESS end=END_ADDRESS`'
          local r = http.json.post(hookURL,'{"text": "'..msg..'","channel":"#'.. decoded_params.channel_name..'"}')
          console.log(r)
        end
    end
    return response
end
