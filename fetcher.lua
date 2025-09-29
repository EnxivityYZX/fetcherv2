-- fetcher.lua (host raw on GitHub, DO NOT obfuscate)
local HttpService = game:GetService("HttpService")
local ANON = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ3cGFkaGJpZWF3em5teXRienJmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTkwMTMxNDcsImV4cCI6MjA3NDU4OTE0N30.mi7ZYhOoj5gesuhHhk9Y8gvbtXEpiUKKD8stSk4SW5A"
local URL = "https://bwpadhbieawznmytbzrf.supabase.co/rest/v1/keys?select=key_value&expires_at=gt.now()"

local function doRequest(url, headers)
    local opts = { Url = url, Method = "GET", Headers = headers or {} }
    if syn and syn.request then return syn.request(opts) end
    if request then return request(opts) end
    if http_request then return http_request(opts) end
    local ok, body = pcall(function() return game:HttpGet(url, true) end)
    return { Success = ok, StatusCode = ok and 200 or 500, Body = body or "" }
end

local headers = {
    ["apikey"] = ANON,
    ["Authorization"] = "Bearer " .. ANON,
    ["Accept"] = "application/json"
}
local res = doRequest(URL, headers)
if not res then return {} end
local body = res.Body or res.body or ""
local success, parsed = pcall(function() return HttpService:JSONDecode(body) end)
if not success or type(parsed) ~= "table" then return {} end

local keys = {}
for i=1,#parsed do
    if parsed[i] and parsed[i].key_value then
        table.insert(keys, tostring(parsed[i].key_value))
    end
end
return keys
