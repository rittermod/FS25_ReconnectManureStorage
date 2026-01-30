--
-- ReconnectManureStorage
-- Fixes base game bug where manure heaps lose connection to animal pens on reload.
--
-- After all placeables are loaded (onStartMission), re-scan each manure heap
-- for nearby extendable unloading/loading stations and reconnect any missing links.
--

local modName = g_currentModName or "FS25_ReconnectManureStorage"
local LOG_PREFIX = "[" .. modName .. "]"

local function reconnectManureStorages()
    if g_server == nil then
        return
    end

    local storageSystem = g_currentMission.storageSystem
    if storageSystem == nil then
        return
    end

    local placeableSystem = g_currentMission.placeableSystem
    if placeableSystem == nil or placeableSystem.placeables == nil then
        return
    end

    local reconnected = 0
    local heapCount = 0

    for _, placeable in ipairs(placeableSystem.placeables) do
        local spec = placeable.spec_manureHeap
        if spec ~= nil and spec.manureHeap ~= nil then
            heapCount = heapCount + 1
            local heap = spec.manureHeap
            local farmId = placeable:getOwnerFarmId()

            local unloadingStations = storageSystem:getExtendableUnloadingStationsInRange(heap, farmId)
            for _, station in ipairs(unloadingStations) do
                if heap.unloadingStations[station] == nil then
                    storageSystem:addStorageToUnloadingStation(heap, station)
                    reconnected = reconnected + 1
                end
            end

            local loadingStations = storageSystem:getExtendableLoadingStationsInRange(heap, farmId)
            for _, station in ipairs(loadingStations) do
                if heap.loadingStations[station] == nil then
                    storageSystem:addStorageToLoadingStation(heap, station)
                    reconnected = reconnected + 1
                end
            end
        end
    end

    if reconnected > 0 then
        Logging.info("%s Reconnected %d manure storage connection(s) across %d heap(s)", LOG_PREFIX, reconnected,
            heapCount)
    end
end

Mission00.onStartMission = Utils.appendedFunction(Mission00.onStartMission, reconnectManureStorages)
