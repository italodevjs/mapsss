--!strict
--[[
    SERVER MANAGER (Script)
    Local: ServerScriptService
]]

local MarketplaceService = game:GetService("MarketplaceService")

MarketplaceService.ProcessReceipt = function(receiptInfo)
    print("Compra processada para: " .. receiptInfo.PlayerId .. " - Item: " .. receiptInfo.AssetId)
    return Enum.ProductPurchaseDecision.PurchaseGranted
end
