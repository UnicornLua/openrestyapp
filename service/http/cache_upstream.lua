-- [[
--  根据商品的 ID 来实现请求的定向分发，
--
-- ]]

-- 获取参数
local uri_args = ngx.req.get_uri_args()

-- 获取商品的 id 参数
local productId = uri_args["productId"]

if not productId then
  ngx.log(ngx.ERR, "参数缺失")
  return
end


-- 设置分发地址，
-- 也可以使用 redis 动态获取
local hosts = { "192.168.0.137:8080", "192.168.0.138:8080", "192.168.0.139:8080" }


-- 获取 Id 的 hash 值
local hash, err = ngx.crc32_long(productId)

if not hash then
  ngx.log(ngx.ERR, "Hash failure", err)
  return
end

-- 获取到服务器
local index = (hash % #hosts) + 1

local backend = "http://" .. hosts[index] .. ngx.var.request_uri
ngx.log(ngx.INFO, backend)
-- 加载 http 库并初始化
local http = require("resty.http")
local httpc = http:new()

-- 发送请求
local resp, err = httpc:request_uri(backend, { method = "GET", keepalive_timeout = 60 })

if not resp then
  ngx.say(ngx.ERR .. err)
  return
end

ngx.status = resp.status
ngx.say(resp.body)
