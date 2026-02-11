return table.freeze({
	-- datastore keys
	OwnedDataKey = "OwnedItems",
	EquippedDataKey = "EquippedItem",

	-- item 
	DefaultEquipped = "StarterItem",

	Items = {
		["StarterItem"] = {
			Name = "Starter Item",
			Price = 0,
			Currency = "Free",
            -- [field] 
			-- Multiplier = 1,
			-- Speed = 1,
            -- etc.
		},

		--[[ in game item ]]
		-- ["Sword"] = {
		-- 	Name = "Sword",
		-- 	Price = 500,
		-- 	Currency = "Coins",
		-- },

		--[[ robux item ]]
		-- ["PremiumItem"] = {
		-- 	Name = "Premium Item",
		-- 	Price = 200,
		-- 	Currency = "Robux",
		-- 	ProductId = 123456789,
		-- },
	},
})
