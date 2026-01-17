-- Save and Load Progress here

--!strict
-- local DataStoreService = game:GetService("DataStoreService")

local playerData = {}

function playerData.setupConfig(player)
	local character = player.character or nil

	if not character then
		return nil
	end

	return
end
