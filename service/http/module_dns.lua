local resolver = require("resty.dns.resolver")

local r, e = resolver:new({
  nameservers = { "223.5.5.5", { "223.6.6.6", 53 } },
  timeout = 5,
  retrans = 3,
})
-- 初始化异常处理
if e then
  ngx.say("failure to init resolver", e)
end

assert(r ~= nil, "init resolver failure")
local answers, err = r:query("www.openresty.org")

-- 服务解析异常处理
if not answers then
  ngx.say("failure to query", err)
end

-- 结果输出
for _, rec in ipairs(answers) do
  ngx.say(rec.name, " ", rec.address, " ", rec.ttl)
end
