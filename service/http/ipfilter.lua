-- [[
--
-- 基于 redis 和 lua 实现一个动态 ip 黑名单的功能
--
-- ]]
local ip_block_time = 300         -- ip 封禁时间(s)
local ip_timeout = 30             -- 指定 ip 访问频率时间段(s)
local ip_max_count = 40           -- 指定频率计数最大值 (次/ 30秒)
local BUSINESS = ngx.var.business -- nginx 的 location 中定义的的标识符, 可以不加，加了后方便区分

-- 连接 redis

local redis = require("resty.redis")
local conn = redis:new()

assert(conn ~= nil, "redis init err")

-- 连接的地址与端口
local ok, err = conn:connect("127.0.0.1", 6379)
-- 如果连接失败直接跳转到脚本结尾处
if not ok then
  ngx.log(ngx.ERR, err)
  ngx.exit(ngx.HTTP_FORBIDDEN)
  goto FLAG
end

-- 认证的用户名与密码
ok, err = conn:auth("redis", "foobared")
if not ok then
  ngx.log(ngx.ERR, err)
  ngx.exit(ngx.HTTP_FORBIDDEN)
  goto FLAG
end

-- 连接的超时时间2s
conn:set_timeout(2000)

-- 查询 ip 是否被禁止访问
local blockKey = BUSINESS .. "-BLOCK-" .. ngx.var.remote_addr
local countKey = BUSINESS .. "-COUNT-" .. ngx.var.remote_addr
local is_block, err = conn:get(blockKey)
if is_block == "1" then
  ngx.log(ngx.ERR, err)
  ngx.exit(ngx.HTTP_FORBIDDEN)
  goto FLAG
end

-- 查询redis 中保存的计数器
local ip_count, _ = conn.get(countKey)
if ip_count == ngx.null then -- 如果不存在则为第一次访问则开始记录
  conn.set(countKey, 1)
  conn.expire(countKey, ip_timeout)
else
  ip_count = ip_count + 1 -- 已经访问过的 ip 则开始计数

  -- 如果超过单位时间内的访问次数，则限制访问，显示访问时间为 ip_block_time
  if ip_count >= ip_max_count then
    conn:set(blockKey, 1)
    conn:expire(blockKey, ip_block_time)
  else
    conn:set(countKey, ip_count)
  end
end

::FLAG::

-- 关闭redis 连接
conn:close()
