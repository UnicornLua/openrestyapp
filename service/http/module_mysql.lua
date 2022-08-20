local mysql = require("resty.mysql")
-- 创建实例
local db, err = mysql:new()

if err then
  ngx.say("init mysql instance")
  return
end
assert(db ~= nil, "database connect init failure")
db:set_timeout(1000)

local opts = {
  host = "124.71.169.210",
  port = 3306,
  database = "ai-asset-dev",
  user = "root",
  password = "Test123!",
  characterEncoding = "utf8",
  useUnicode = true,
}

local ok, e = db:connect(opts)

-- 真正建立连接
if not ok then
  ngx.say("connect mysql failure...", e)
  db:close()
  return
end

local res, _e = db:query("select * from his_tag")

if _e then
  ngx.say("query failure", _e)
  db:close()
  return
end

for _, rows in ipairs(res) do
  for k, v in pairs(rows) do
    ngx.say(("%s - %s"):format(k, v))
  end
end
