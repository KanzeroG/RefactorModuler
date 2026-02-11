--|| Game Services ||--
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--|| Packages ||--
local Knit = require(ReplicatedStorage.Packages.Knit)
local MonetizationModule = require(ReplicatedStorage.Packages.MonetizationModule)

-- local DataHandler

--|| Handler ||--
local MonetizationHandler = Knit.CreateService({
	Name = "MonetizationHandler",
	Configuration = {},
	Client = {
		onPurchaseVIP = Knit.CreateSignal(),
        onPurchaseMagnet = Knit.CreateSignal(),
        onPurchasePopup = Knit.CreateSignal(),
	},
})

--|| Functions ||--
function MonetizationHandler:OnPurchaseVIP(player)
	self.Client.onPurchaseVIP:Fire(player)
end

--|| Knit Lifecycle ||--
function MonetizationHandler:KnitStart()
	-- DataHandler = Knit.GetService("DataHandler")
    local notificationService = Knit.GetService("NotificationService")

    self.Configuration = require(ReplicatedStorage.Shared.Configs["MonetizationModule.config"])
    -- print(self.Configuration)

	MonetizationModule.OnPurchaseSucceeded:Connect(function(player: Player, item: number)
		-- print("ON PURCHASE SUCCEEDED MONET SERVICE")
		-- print(player) print(item) print (item.Name)
		local id = MonetizationModule:FindIdFromName(item.Name)
        if notificationService then
            notificationService:Notify(player, "Successfully bought " .. tostring(item.Name), "success")
        end
        self.Client.onPurchasePopup:Fire(player, tostring(item.Name))
		-- print(id)
		if item.Type == "GamePass" then
			-- local playerData = DataHandler:Get(player)
			-- local gamepasses = table.clone(playerData.Gamepasses)

			-- gamepasses[id] = true

			-- DataHandler:Update(player, "Gamepasses", gamepasses)
		end
		if item.Name == "VIP" then
			self:OnPurchaseVIP(player)
		end
		if item.Name == "Magnet" then
            --CALL REDUCER
            self.Client.onPurchaseMagnet:Fire(player)
			-- print("GIVE MAGNET TO PLAYER")
		end
        if item.Name == "Bundle Starter Pack" then
            self.Client.onPurchaseMagnet:Fire(player)
		end

		if self.Configuration[id].Name == "x2 Rocks" then
            -- print("GIVE X2 ROCKS")
         end

        if self.Configuration[id].Name == "x2 Wins" then
            -- print("GIVE X2 WINS")
         end
        -- if self.Configuration[id].Name == "+10K Win" then
        --     DataHandler:Update(player, "Wins", 10000)
        --  end
        -- if self.Configuration[id].Name == "+100K Win" then
        --      DataHandler:Update(player, "Wins", 100000)
        --  end
        -- if self.Configuration[id].Name == "+500K Win" then
        --    DataHandler:Update(player, "Wins", 500000)
        --  end
        -- if self.Configuration[id].Name == "+2M Win" then
        --     DataHandler:Update(player, "Wins", 2000000)
        --  end
        -- if self.Configuration[id].Name == "+10M Win" then
        --     DataHandler:Update(player, "Wins", 10000000)
        -- end



   		if self.Configuration[id].Name == "+2 Pet Equip" then
            -- print("GIVE +2 PET EQUIP")
        end 
        if self.Configuration[id].Name == "+5 Pet Equip" then
            -- print("GIVE +5 PET EQUIP")
        end 
		if self.Configuration[id].Name == "Rebirth - Skip 1" then
            --   print("skip 1 rebirth")
        end 
		if self.Configuration[id].Name == "Rebirth - Skip 5" then
            --   print("skip 5 rebirth")
        end 
		if self.Configuration[id].Name == "Pet Pack 1" then
            --   print("Pet Pack 1	")
        end 
		if self.Configuration[id].Name == "Pet Pack 2" then
            --  print("Pet Pack 2")
        end 
		if self.Configuration[id].Name == "Pet Pack 3" then
            --  print("Pet pack 3")
        end 
	end)
end

return MonetizationHandler
