-- 显式加载 process 模块
local process = require("ngx.process")
-- 获取当前进程类型
local str = process.type()
local version = process.version
ngx.say(version)
ngx.say(str)


-- 操作 worker 进程
local pid = ngx.worker.pid()
local count = ngx.worker.count()
local id = ngx.worker.id()

ngx.say(("pid: %s - id: %s - count: %s"):format(pid, id, count))
