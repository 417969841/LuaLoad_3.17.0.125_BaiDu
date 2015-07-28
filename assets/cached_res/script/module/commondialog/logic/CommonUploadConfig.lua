CommUploadConfig = {}

CommUploadConfig.iosExceptionFileName = "iosExceptionFile"-- ios异常信息储存路径

local lookTimer = nil --定时器

--[[--
	上传上一次退出前保存下来的错误信息
	如果没有错误信息,则不传
	如果有错误信息,每条之间间隔1秒发送
	不需要服务器应答
--]]
function CommUploadConfig.sendException()
	local iosExceptionTable = Common.LoadShareTable(CommUploadConfig.iosExceptionFileName)
	if iosExceptionTable ~= nil and #iosExceptionTable ~= 0 then
		--如果本地存有错误信息
		local function send()
			--发送错误信息方法
			local dataTable = {}
			dataTable["userId"] = profile.User.getSelfUserID()
			Common.log("CommUploadConfig userId is " .. profile.User.getSelfUserID())
			dataTable["exceptionInfo"] = iosExceptionTable[1]
			sendSTATID_COMMIT_EXCEPTION_INFO(dataTable)
			table.remove(iosExceptionTable, 1)
			if #iosExceptionTable == 0 then
				--如果已经全部传完,将本地错误数据清空,并且将定时器停止
				Common.SaveShareTable(CommUploadConfig.iosExceptionFileName, iosExceptionTable)
				if (lookTimer) then
					CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(lookTimer)
				end
			end
		end
		--设置定时器,每1秒钟发送一次上传错误信息请求
		lookTimer = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(send, 1 ,false)
	end
end

return CommUploadConfig