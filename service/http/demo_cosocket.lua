-- 开启一个 tcp 实例
local sock = ngx.socket.tcp()

-- 设置超时事件
sock:settimeout(1000)

-- 建立连接
local ok, err = sock:connect("127.0.0.1", 8888)

if not ok then
  ngx.say("failure to connect", err)
  return
end

-- 接收数据
local data, e = sock:receive()

if e then
  ngx.say("failure to receive")
  return
end
ngx.say("response: ", data)


-- byte 是已经发送的字节数
local byte, er = sock:send("hello cosocket")

if er then
  ngx.say("failure to send")
  return
end
ngx.say("send data byte: ", byte)
