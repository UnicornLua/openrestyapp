local redis = require("resty.redis")

local rds, err = redis:new()

if err then
  ngx.say("redis init error", err)
end
assert(rds ~= nil, "redis init err")
-- 设置超时时间，单位是秒
rds:set_timeout(2000)

-- 获取连接
local ok, e = rds:connect("121.36.204.214", 6379)
if not ok then
  ngx.say("failure to connect redis", e)
  rds:close()
  return
end

-- 服务器密码认证
local res, e = rds:auth("redis123!@#")
if not res then
  ngx.say("failure to authentication", e)
  rds:close()
  return
end

-- 存取redis 中数据
rds:set("name", "alex")
ngx.say(rds:get("name"))
