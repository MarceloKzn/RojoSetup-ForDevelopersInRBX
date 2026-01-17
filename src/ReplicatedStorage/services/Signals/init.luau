--!strict
local Signal = require(script.Parent) :: any

return {
	OnEconomyUpdated = Signal.new(),
}
