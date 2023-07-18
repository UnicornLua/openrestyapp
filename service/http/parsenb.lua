local ngx = ngx
local cjson = require("cjson.safe")
-- 处理 get 请求
local function action_get()
  ngx.log(ngx.INFO, "enter get method==>>")
  -- 丢弃请求体中的数据
  -- ngx.req.discard_body()
  local args, err = ngx.req.get_uri_args()
  if err == "truncated" then
    local t = ngx.time()
    ngx.say(ngx.http_time(t))
  end

  for key, val in pairs(args) do
    if type(val) == "table" then
      ngx.log(ngx.INFO, key .. ":" .. table.concat(val, ", "))
    else
      ngx.log(ngx.INFO, key .. ":" .. val);
    end
    if key == 'msg' then
      ngx.say(val)
    end
  end
end

-- 处理 post 请求
local function action_post()
  -- 读取请求体中的数据
  ngx.req.read_body()
  local args = ngx.req.get_body_data()
  ngx.log(ngx.INFO, args)

  local tab = cjson.decode(args)
  local msg = cjson.decode(tab.msg)
  local dev_name = msg.dev_name
  local imei = msg.imei
  local pid = msg.pid
  local type = msg.type

  local signature = tab.signature
  local time = tab.time
  local id = tab.id
  local nonce = tab.nonce


  local frame = string.format("\n" ..
    "---------------------------------\n" ..
    "dev_name: %s\nimei: %s\npid: %s\nsignature: %s\ntime: %s\nid: %s\nnonce: %s\n" ..
    "---------------------------------\n",
    dev_name, imei, pid, signature, ngx.http_time(time), id, nonce
  )

  ngx.log(ngx.INFO, frame)

  -- if not num then
  --  ngx.log(ngx.ERR, "is not a valide date")
  --  ngx.exit(400)
  -- end
  -- ngx.say(ngx.http_time(num))
  ngx.say(args)
  ngx.header.status = ngx.HTTP_OK
  ngx.say("ok")
end

-- 构建处理方案的集合
local actions = { GET = action_get, POST = action_post }
local method = ngx.req.get_method()
-- 根据请求方法不同调用不同的处理方案
-- 因为我们前面已经经过了处理，只有 post 和 get 能进入到这里
actions[method]()
-- 可以不经过判断，直接可以函数调用
--
