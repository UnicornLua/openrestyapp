-- 加载 lua-resty-http 模块
local http = require("resty.http")

-- 创建 http 连接对象
local httpc = http:new()
-- 设置超时时间
httpc:set_timeout(1000)

-- 发送请求
local res, err = httpc:request_uri("http://127.0.0.1:8080", { path = "/hello" })

if not res then
  ngx.say("failed to request: ", err)
end

ngx.say(res.body)
