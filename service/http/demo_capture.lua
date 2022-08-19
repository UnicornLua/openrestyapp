local capture = ngx.location.capture

local res = capture("/springhello", {})

if res.status == ngx.HTTP_OK then
  ngx.say(res.body)
end
