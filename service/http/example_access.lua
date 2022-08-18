local ngx = ngx
local white_list = { "0.0.0.0", "127.0.0.1", "117.88.109.126" }

local function inlist(item)
  for _, v in ipairs(white_list) do
    if item == v then
      return true
    end
  end
  return false;
end

local ip = ngx.var.remote_addr

if not inlist(ip) then
  ngx.log(ngx.ERR, ip, " is blocked")
  ngx.exit(ngx.HTTP_FORBIDDEN)
end
