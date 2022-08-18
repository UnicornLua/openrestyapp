local ngx = ngx

-- 请求非正常返回的时候，不对数据进行加工
if ngx.status ~= ngx.HTTP_OK then
  return
end

-- 对响应的内容进行加工处理
if ngx.ctx.encode then
  -- 如果请求端要求进行 base64 编码，则编码
  ngx.arg[1] = ngx.encode_base64(ngx.arg[1])
end
