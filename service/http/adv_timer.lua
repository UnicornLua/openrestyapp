local function onceTask(permuture, uri)
  ngx.log(ngx.INFO, "----------------------------------")
  ngx.log(ngx.INFO, uri)
  ngx.log(ngx.INFO, "----------------------------------")
  if permuture then
    ngx.log(ngx.WARN, ": Task")
  end
  -- http
  local http = require("resty.http")
  local httpc = http:new()
  local res, err = httpc:request_uri("http://127.0.0.1:8080", { path = "/hello" })
  if err then
    ngx.log(ngx.ERR, "err: ", err)
  else
    ngx.log(ngx.INFO, res.body)
  end
end

local ok, err = ngx.timer.at(1, onceTask, ngx.var.uri)
if not ok then
  ngx.log(ngx.ERR, "err: ", err)
end


-- 定时执行的任务
local function cycleTask(premuture, name)
  if premuture then
    return
  end
  ngx.log(ngx.INFO, "exec.......", name)
end

ok, err = ngx.timer.every(6, cycleTask, "alex")
if not ok then
  ngx.log(ngx.ERR, "cycleTask err, ", err)
end
