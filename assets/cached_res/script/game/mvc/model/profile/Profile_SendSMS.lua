module(..., package.seeall)

local SendSMSTaskInfo = {}


function readMANAGERID_SEND_SMS_TASK(dataTable)
	SendSMSTaskInfo = dataTable
	--服务器推送发短信任务
	local dataTable = profile.SendSMS.getSendSMSTaskInfo()
	local javaClassName = "com.tongqu.client.utils.SMSUtils"
	local javaMethodName = "sendSms"
	local telePhone = SendSMSTaskInfo["Telephone"]
	local SMS = SendSMSTaskInfo["SMS"]

	if SendSMSTaskInfo.IsDataSms == 0 then
		--0文本短信
		Common.sendSMSMessage(telePhone, SMS)
	elseif PayResultTable["smsList"][1].IsDataSms == 1 then
		-- 1二进制短信
		Common.sendSMSDataMessage(telePhone, SendSMSTaskInfo.DestinationPort, SMS)
	end
end

registerMessage(MANAGERID_SEND_SMS_TASK, readMANAGERID_SEND_SMS_TASK)