-- 加载限流库
local limit_req = require("resty.limit.req")

-- 使用共享内存来实现
-- 这里设置 rate=2/s 漏桶的流量是 0, 就是说来多少水就流多少水
local limit, err = limit_req.new("my_limit_req_store", 15, 0)
if not limit then
  ngx.log(ngx.ERR, "failed to resty_limit_req_object", err)
  return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end

local key = ngx.var.binary_remote_addr
local delay, err = limit:incoming(key, true)
if not delay then
  if err == "rejected" then
    ngx.exit(ngx.HTTP_FORBIDDEN)
  end
  ngx.log(ngx.ERR, "failed to limit req", err)
  return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end

-- 当前的请求，和前面的请求至少需要 delay秒后才会被处理
-- 此处忽略桶中所需要请求延时处理
if delay >= 0.001 then
  local excedd = err
  ngx.sleep(delay)
end
