local ngx = ngx

-- 获取 json 解析库
local cjson = require("cjson.safe");
local utils = require("service.utils.read_body")

local path = "/opt/application/image"
local alias = "ocr/image"
local result = {}

-- 获取请求参数
ngx.req.read_body();

-- local args = ngx.req.get_body_data()
local args = utils:get_body_data()
if args == nil then
  result.code = '1'
  result.msg = "未获取到图片"
  ngx.say(cjson.encode(result));
  return
end
ngx.log(ngx.DEBUG, "-----------------------------------------")
--ngx.log(ngx.DEBUG, args)

local image_info = cjson.decode(args)
local img_str = image_info.img_str
if img_str == nil then
  result.code = '1'
  result.msg = "未获取到图片"
  ngx.say(cjson.encode(result));
  return
end

local md5 = ngx.md5(img_str)
local bytes = ngx.decode_base64(img_str)
-- ngx.log(ngx.DEBUG, bytes)
local s_level = string.sub(md5, 0, 5)
local filePath = path .. "/" .. s_level .. "/";
local filename = md5 .. '.jpg'
local proxyPath = string.format(
  "http://%s:%d/%s/%s/%s",
  ngx.var.host,
  ngx.var.server_port,
  alias,
  s_level,
  filename
)
-- "http://" .. ngx.var.host .. ":" .. ngx.var.server_port .. alias .. "/" .. s_level .. "/" .. filename

local file, err = io.open(filePath .. filename, "w+b")
-- 文件夹是否存在，不存在则创建
if file == nil then
  os.execute("mkdir -p " .. filePath)
  file = io.open(filePath .. filename, "w+b")
end
-- 文件为空则文件打开失败
if file == nil then
  ngx.log(ngx.ERR, err)
  result.code = '1'
  result.msg = "打开存储目录失败"
  ngx.say(cjson.encode(result))
  return
end
--io.output(file)
file:write(bytes)
file:close()

result.code = "0"
result.msg = proxyPath
-- 成功后返回成功保存的代理访问的 Url 信息
ngx.say(cjson.encode(result));
