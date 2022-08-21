-- 获取之前定义的共享内存对象
local shmem = ngx.shared.shmem;
local ok, err, f -- 预先定义一些变量，方便使用

-----------------------------------------------
-- set
-----------------------------------------------
-- key
-- value
-- exptime
ok, err = shmem:set("name", "alex", 0.05)

-----------------------------------------------
-- get
-----------------------------------------------
ngx.say(shmem:get("name"))



-----------------------------------------------
-- get_stale
-----------------------------------------------

-- 一段时间之后再去取值
-- 获取到空值
ngx.sleep(1)
-- 此时获取就是 nil
-- ngx.say(shmem:get("name"))
-- 这里如果没有使用 get 获取过，是可以得到的
-- 如果之前已经使用 get 获取过，这里获取不到了
local value, flag, stale = shmem:get_stale("name")
-- 返回了三个值，
ngx.say(("value:%s - flag:%s - stale: %s"):format(value, flag, stale))

-----------------------------------------------
-- add
-----------------------------------------------

-- add 新增数据，如果之前有这个值，将会添加失败
shmem:add("name", "maria")

-- 已经存在的不能再次被覆盖
ok, err = shmem:add("name", "scott")

-- 输出添加是否成功
if not ok then
  ngx.say("add status: ", ok, " cause: ", err)
end

-----------------------------------------------
-- replace
-----------------------------------------------

ok, err = shmem:replace("gender", "cat")

-- 输出替换是否成功的消息
if not ok then
  ngx.say("replace status: ", ok, "  cause:", err)
end

-- 获取数据
ngx.say(shmem:get("name") .. "")


----------------------------------------------
-- delete
----------------------------------------------
-- 不管存在与否，删除都会执行，不会报错
ok, err = shmem:delete("name")

if not ok then
  ngx.say(("delete status: %s cause:%s"):format(ok, err))
end

ngx.say("delete name ", ok)



----------------------------------------------
-- incr
----------------------------------------------
-- 计数操作, 多进程安全，可以实现多进程安全的计数器
-- 可以操作 整数，可以操作浮点数
-- key   : 计数器名称
-- value : 每次添加的值
-- init  : 初始值
-- init_ttl :

shmem:incr("count", 1, 0)
ngx.say(shmem:get("count") .. "")

----------------------------------------------
-- 队列的操作
----------------------------------------------

shmem:lpush("msg", "hello")
shmem:lpush("msg", "world")
ngx.say("" .. shmem:llen("msg"))
f, err = shmem:rpop("msg")
ngx.say(f .. "")


----------------------------------------------
-- 查看超时时间，重新设置超时时间
----------------------------------------------

shmem:ttl("name")
shmem:expire("msg", 10)
