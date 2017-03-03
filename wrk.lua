local path = nil
local count = 0

request = function()
    if not path then
        wrk.method = "POST"
        wrk.body   = '{"text":"Hello YAPC::Kansai!"}' 
        wrk.headers["Content-Type"] = "application/json"
        return wrk.format(nil, '/')
    elseif count > 0 then
        wrk.method = "GET"
        return wrk.format(nil, path)
    else
        wrk.method = "DELETE"
        return wrk.format(nil, path)
    end
end

response = function(status, headers, body)
    if not path then
        path = headers["Location"]
        count = 5
    elseif count > 0 then
        count = count - 1
    else
        path = nil
    end
    print(body)
end
