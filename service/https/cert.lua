-- 加载证书管理模块
local ssl = require("ngx.ssl")


-- 清理证书
local ok, err = ssl.clear_certs()

if not ok then
  ngx.log(ngx.ERR, "failure to clear existing", err)
  return ngx.exit(ngx.ERR)
end

-- 记载文件的方法，
local function get_pem(file)
  local f = io.open(file, "r")
  if not f then
    return
  end
  local str = f:read("*a")
  -- ngx.log(ngx.INFO, str)
  f:close()
  return str
end

-- 加载证书
local prefix = ngx.config.prefix()
local cert, err = ssl.parse_pem_cert(get_pem(prefix .. "/cert/server.crt"))

if not cert then
  ngx.log(ngx.ERR, "fail parse pem err: ")
end

-- 设置证书
local ok, err = ssl.set_cert(cert)
if not ok then
  ngx.log(ngx.ERR, "set cert err: ", err)
  return
end

-- 加载私钥
local key, err = ssl.parse_pem_priv_key(get_pem(prefix .. "/cert/server.key"))

if not key then
  ngx.log(ngx.ERR, "load key err: ", err)
  return
end

-- 设置私钥
ok, err = ssl.set_priv_key(key)
if not ok then
  ngx.log(ngx.ERR, "set key err", err)
  return
end
