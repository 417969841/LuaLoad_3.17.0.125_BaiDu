--
--WEBVIEW预加载profile
--

module(..., package.seeall)

local loadWebViewInfoTable = {}; --WebView信息

--获取WEBVIEW预加载的内容
function readCOMMONS_HTTPPROXY(dataTable)
	loadWebViewInfoTable = dataTable
	if dataTable and dataTable.Html and dataTable.Html ~= "" then --web有更新或是有数据
		Common.SaveTable(dataTable.Key, dataTable) --存入本地
		Common.log("sendCOMMONS_HTTPPROXY = 数据存入本地")
	end
	framework.emit(COMMONS_HTTPPROXY)
	Common.log("COMMONS_HTTPPROXY ------------- profile")
end

function getLoadWebViewInfoTable()
	return loadWebViewInfoTable
end

registerMessage(COMMONS_HTTPPROXY , readCOMMONS_HTTPPROXY);
