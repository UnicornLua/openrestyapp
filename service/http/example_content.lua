local ngx = ngx
local cjson = require("cjson.safe")
-- 处理 get 请求
local function action_get()
  -- 丢弃请求体中的数据
  ngx.req.discard_body()
  local t = ngx.time()
  ngx.say(ngx.http_time(t))
end

-- 处理 post 请求
local function action_post()
  -- 读取请求体中的数据
  ngx.req.read_body()
  local args = ngx.req.get_body_data()
  local tab = cjson.decode(args)
  local num = tonumber(tab.date)
  if not num then
    ngx.log(ngx.ERR, "is not a valide date")
    ngx.exit(400)
  end
  ngx.say(ngx.http_time(num))
end

-- 构建处理方案的集合
local actions = { GET = action_get, POST = action_post }
local method = ngx.req.get_method()
-- 根据请求方法不同调用不同的处理方案
-- 因为我们前面已经经过了处理，只有 post 和 get 能进入到这里
-- 可以不经过判断，直接可以函数调用
actions[method]()
