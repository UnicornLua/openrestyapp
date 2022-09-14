local ngx = ngx

local utils = {}


local function read_from_file(file_name)
  local f = assert(io.open(file_name, "r"))
  local content = f:read("*all");
  f:close()
  return content
end

function utils:get_body_data()
  local body_raw = ngx.req.get_body_data()
  if not body_raw then
    local body_file = ngx.req.get_body_file()
    if body_file then
      body_raw = read_from_file(body_file)
    end
  end
  return body_raw
end

return utils
