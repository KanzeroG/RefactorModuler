local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ShopConfig = require(ReplicatedStorage.Shared.Configs["Shop.config"])

local DataService

local ShopService = Knit.CreateService({
	Name = "ShopService",
	Client = {
		OnItemPurchased = Knit.CreateSignal(),
		OnItemEquipped = Knit.CreateSignal(),
	},
})

--|| Client Functions ||--
function ShopService.Client:Buy(player, itemId)
	return self.Server:Buy(player, itemId)
end

function ShopService.Client:Equip(player, itemId)
	return self.Server:Equip(player, itemId)
end

function ShopService.Client:GetInitialData(player)
	return self.Server:GetInitialData(player)
end

function ShopService.Client:GetShopItems(_player)
	return ShopConfig.Items
end

--|| Server Functions ||--
function ShopService:Buy(player, itemId: string)
	local item = ShopConfig.Items[itemId]
	if not item then return false end

	if item.Currency == "Robux" then return false end

	local data = DataService:GetData(player)
	if not data then return false end

	local owned = data[ShopConfig.OwnedDataKey] or {}
	if owned[itemId] then return false end

	if item.Currency ~= "Free" then
		local balance = data[item.Currency]
		if not balance or balance < item.Price then return false end
		DataService:SetValue(player, item.Currency, balance - item.Price)
	end

	owned[itemId] = true
	DataService:SetValue(player, ShopConfig.OwnedDataKey, owned)
	self.Client.OnItemPurchased:Fire(player, itemId)

	return true
end

function ShopService:GrantItem(player, itemId: string)
	local data = DataService:GetData(player)
	if not data then return false end

	local owned = data[ShopConfig.OwnedDataKey] or {}
	owned[itemId] = true
	DataService:SetValue(player, ShopConfig.OwnedDataKey, owned)
	self.Client.OnItemPurchased:Fire(player, itemId)

	return true
end

function ShopService:Equip(player, itemId: string)
	local item = ShopConfig.Items[itemId]
	if not item then return false end

	local data = DataService:GetData(player)
	if not data then return false end

	local owned = data[ShopConfig.OwnedDataKey] or {}
	if not (owned[itemId] or item.Currency == "Free") then return false end

	DataService:SetValue(player, ShopConfig.EquippedDataKey, itemId)
	self.Client.OnItemEquipped:Fire(player, itemId)

	if self._onEquipCallback then
		self._onEquipCallback(player, itemId, item)
	end

	return true
end

function ShopService:GetInitialData(player)
	local data = DataService:GetData(player)
	if not data then return nil end

	return {
		OwnedItems = data[ShopConfig.OwnedDataKey] or {},
		EquippedItem = data[ShopConfig.EquippedDataKey] or ShopConfig.DefaultEquipped,
	}
end

function ShopService:OnEquip(callback)
	self._onEquipCallback = callback
end

-- KNIT START
function ShopService:KnitStart()
	DataService = Knit.GetService("DataService")
end

return ShopService
