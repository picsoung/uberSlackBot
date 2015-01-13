local start_latlng
local end_latlng

function getLatLng(start_point,end_point)
    local google_key = "GOOGLE_API_KEY"
    local google_url ="APITOOLS_GOOGLE_SERVICEURL/geocode/json?address="

    start_point = string.gsub(start_point," ","+")
    end_point = string.gsub(end_point," ","+")

    local request_url = google_url .. start_point .. "&key="..google_key
    local resp_geocoding = http.get(request_url)
    start_latlng = json.decode(resp_geocoding.body).results[1].geometry.location

    request_url = google_url .. end_point .. "&key="..google_key
    resp_geocoding = http.get(request_url)
    end_latlng = json.decode(resp_geocoding.body).results[1].geometry.location
end

return function(request, next_middleware)
    local start_point = request.args.start_point
    local end_point = request.args.end_point

    getLatLng(start_point,end_point)

    request.args.start_latitude = start_latlng.lat
    request.args.start_longitude = start_latlng.lng
    request.args.end_latitude = end_latlng.lat
    request.args.end_longitude = end_latlng.lng
    local uber_token = "UBER_TOKEN"
    request.args.server_token = uber_token

    local response = next_middleware()
    return response
end
