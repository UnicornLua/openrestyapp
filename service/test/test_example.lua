local iresty_test = require("resty.iresty_test")
local tb = iresty_test.new({ unit_name = 'example' })

-- Init, 基础变量的初始化，
-- 公共代码的编写
function tb:init()
  self:log("init complete")
end

-- 测试用例
function tb:test01()
  self:log("this is a test example")
end

-- 测试用例
function tb:test02()
  error("invalid input")
end

-- 测试用例
function tb:test03()
  self:log("test 03")
end

tb:run()
