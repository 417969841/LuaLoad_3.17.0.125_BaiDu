module(..., package.seeall)


local TRICKYPARTY_RANK_LISTTable = {}


function readTRICKYPARTY_RANK_LIST(dataTable)
	TRICKYPARTY_RANK_LISTTable = dataTable
	framework.emit(TRICKYPARTY_RANK_LIST)
end


function getTRICKYPARTY_RANK_LIST()
	return TRICKYPARTY_RANK_LISTTable
end


registerMessage(TRICKYPARTY_RANK_LIST , readTRICKYPARTY_RANK_LIST);