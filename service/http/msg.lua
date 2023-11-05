local ngx = ngx
local cjson = require("cjson.safe")


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
  end
  ngx.say([[
   {
      "code": 0,
      "msg": "你来干啥，要数据没有",
      "data": {
        "total": 100,
        "page": 3,
        "rows": [
          {"deviceName":"包河区xx机房", "deviceId": 353535},
          {"deviceName":"包河区xx机房", "deviceId": 353535},
          {"deviceName":"包河区xx机房", "deviceId": 353535},
          {"deviceName":"包河区xx机房", "deviceId": 353535},
          {"deviceName":"包河区xx机房", "deviceId": 353535}
        ]
      }
    }
  ]])
end


-- 构建处理方案的集合
local actions = { GET = action_get }
local method = ngx.req.get_method()
-- 根据请求方法不同调用不同的处理方案
-- 因为我们前面已经经过了处理，只有 post 和 get 能进入到这里
actions[method]()
-- 可以不经过判断，直接可以函数调用
--
