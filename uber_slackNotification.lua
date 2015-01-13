return function(request, next_middleware)
  local response = next_middleware()

  local prices = json.decode(response.body).prices
  local msg =""
  if(#prices >0) then
    emoji = {}
    emoji["uberX"]="\xF0\x9F\x9A\x97"
    emoji["uberXL"]= "\xF0\x9F\x9A\x99"
    emoji["UberBLACK"]= "\xF0\x9F\x9A\x93"
    emoji["UberSUV"]= "\xF0\x9F\x9A\x90"
    emoji["uberTAXI"]= "\xF0\x9F\x9A\x95"
   pretext = "Prices for a distance of " .. prices[1].distance .. "km in " .. math.floor(prices[1].duration/60) .. " minutes"
  	msg =""
    for i=1,#prices do
      msg = msg .. emoji[prices[i].display_name].." "..prices[i].display_name .." -> ".. prices[i].estimate .. " surge: ".. prices[1].surge_multiplier .."\\n"
    end
  else
    msg = "Uber does not seem to be available in this city"
  end
  local hookURL = "SLACK_INCOMING_URL"
  console.log(msg,pretext)
  local r = http.json.post(hookURL,'{"channel":"#'.. request.args.channel..'","attachments":[{"fallback":"'..pretext..'","pretext":"'..pretext..'","color":"#1fbad6","fields":[{"title":"Prices","value":"'..msg..'","short":false}]}]}')

  console.log(r)
  return response
end
