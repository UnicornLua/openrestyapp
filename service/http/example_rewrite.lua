local ngx = ngx

local method = ngx.req.get_method()

-- this predicate is allowed GET and POST method
if method ~= "GET" and method ~= "POST" then
  -- tell client only get or post allow
  ngx.header.Allow = "get. post"
  -- exit
  ngx.exit(405)
end


-- this predicate is only HTTP 1.1 / 2
local version = ngx.req.http_version()
if version < 1.1 then
  ngx.exit(400)
end

-- restore a variable about need_encode in args
ngx.ctx.encode = ngx.var.arg_need_encode
ngx.header['Content-Length'] = nil
