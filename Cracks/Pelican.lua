-- # Version 1.2 | Hi Encrypted
local NewPanda = {}
local Request = (syn and syn.request) or (http and http.request) or http_request
local HttpService = game:GetService("HttpService")

function NewPanda:Time_Expiration()
    return math.huge
end

function NewPanda:GetLink()
    return "discord.gg/cZfYYb9Kvm"
end

function NewPanda:ValidateKey()
    return true
end

function NewPanda:LoadScript()
    Request({
        Url = 'http://127.0.0.1:6463/rpc?v=1',
        Method = 'POST',
        Headers = {
            ['Content-Type'] = 'application/json',
            Origin = 'https://discord.com'
        },
        Body = HttpService:JSONEncode({
            cmd = 'INVITE_BROWSER',
            nonce = HttpService:GenerateGUID(false),
            args = {code = "cZfYYb9Kvm"}
        })
    })
end

return NewPanda
