return function(request, next_middleware)
    local response = next_middleware()
    local prices = json.decode(response.body).prices
    local msg =""

    if(#prices >0) then
    msg = "```" .. "Prices for a distance of " .. prices[1].distance .. "km in " .. math.floor(prices[1].duration/60) .. " minutes"

    for i=1,#prices do
      msg = msg .. prices[i].display_name .." -> ".. prices[i].estimate .. " surge: ".. prices[1].surge_multiplier
    end
    msg = msg.. "```"
    else
    msg = "Uber does not seem to be available in this city"
    end
    local hookURL = "SLACK_INCOMING_HOOK_URL"
    local r = http.json.post(hookURL,'{"text": "'..msg..'","channel":"#'.. request.args.channel..'"}')
    console.log(r) -- dont comment it, it makes request synchronous
    return response
end
