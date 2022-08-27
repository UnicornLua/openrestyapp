-- [[
--
-- 我们会请求的参数中携带对应的版本号，在入口中获取到这个参数，之后会根据这个参数对请求
-- 进行拦截，分发到不同的应用中，然后就可以进行分离，部分客户端进行灰度测试。
--
-- ]]

ngx.header.content_type = "text/plain"

-- 获取请求的参数
ngx.req.read_body()

local post_args_tab, err = ngx.req.get_post_args()

if not post_args_tab then
  ngx.say("invalied parameter error", err)
  return
end

local request_data = {}

for k, v in pairs(post_args_tab) do
  request_data[k] = v
end

if not request_data["ver"] then
  ngx.say("ver is null")
  return
end


-- 进行传参的版本号校验，根据不同的版本号分发到不同的应用中
local ver = math.floor(2.0)

-- ver=1.0 --> app01
-- ver=2.0 --> app02
if math.floor(request_data["ver"]) == ver then
  -- 内部重定向
  ngx.req.set_method(ngx.HTTP_GET)
  ngx.exec("@app02")
  return
end

-- 由于我们这里是模仿的请求，当使用 POST 请求获取 nginx 静态资源
-- 被认为是一个错误的请求 (--> 405)，因此我们需要转换一下请求方式

-- 默认访问
ngx.req.set_method(ngx.HTTP_GET)
ngx.exec("@app01")
