local line_added = false
local font_color = "|cffffffff"
local dungeon_reward_string = "Награда за подземелье: "
local dungeon_crest_reward_string = "Награда за гребни: "
local vault_reward_string = "Награда в Великом Хранилище: "
local dungeon_item_level_table = { 684, 684, 688, 691, 694, 694, 697, 697, 701, 701, 701 }
local dungeon_upgrade_track_table = { "Защитник 2", "Защитник 2", "Защитник 3", "Защитник 4", "Герой 1", "Герой 1", "Герой 2", "Герой 2", "Герой 3", "Герой 3", "Герой 3" }
local dungeon_crest_table = { "10 Рунических гребней", "12 Рунических гребней", "14 Рунических гребней", "16 Рунических гребней", "18 Рунических гребней", "10 Позолоченных гребней", "12 Позолоченных гребней", "14 Позолоченных гребней", "16 Позолоченных гребней", "18 Позолоченных гребней", "20 Позолоченных гребней" }
local vault_item_reward_table = { 694, 694, 697, 697, 701, 704, 704, 704, 707, 707, 707 }
local vault_upgrade_track_table = { "Герой 1", "Герой 1", "Герой 2", "Герой 2", "Герой 3", "Герой 4", "Герой 4", "Герой 4", "Легенда 1", "Легенда 1", "Легенда 1" }


SLASH_KEYSTONETOOLTIP1 = "/kt"

SlashCmdList["KEYSTONETOOLTIP"] = function(msg)
    print(dungeon_reward_string .. GetDungeonReward(tonumber(msg)) .. ", " .. GetDungeonRewardTrack(tonumber(msg)))
    print(dungeon_crest_reward_string .. GetDungeonCrestReward(tonumber(msg)))
    print(vault_reward_string .. GetVaultReward(tonumber(msg)) .. ", " .. GetVaultRewardTrack(tonumber(msg)))
end


local frame = CreateFrame("Frame");
frame:RegisterEvent("ADDON_LOADED");
frame:SetScript("OnEvent", function(self, event, ...)
    if (event == "ADDON_LOADED") then
        local addon = ...
    end
end)


local function GetItemString(parent_string)
    return string.match(parent_string, "keystone[%-?%d:]+")
end


local function GetKeyLevel(parent_string)
    return tonumber(string.sub(select(4, strsplit(":", parent_string)), 1, 2))
end


local function OnTooltipSetItem(tooltip, ...)
    name, link = GameTooltip:GetItem()

    if (link == nil) then return end

    for item_link in link:gmatch("|%x+|Hkeystone:.-|h.-|h|r") do
        local item_string = GetItemString(item_link)
        local key_level = GetKeyLevel(item_string)

        if not line_added then
            tooltip:AddLine(font_color .. dungeon_reward_string .. GetDungeonReward(key_level) .. ", " .. GetDungeonRewardTrack(key_level) .. "|r")
            tooltip:AddLine(font_color .. dungeon_crest_reward_string .. GetDungeonCrestReward(key_level) .. "|r")
            tooltip:AddLine(font_color .. vault_reward_string .. GetVaultReward(key_level) .. ", " .. GetVaultRewardTrack(key_level) .. "|r")
            line_added = true
        end
    end
end


local function OnTooltipCleared(tooltip, ...) line_added = false end


local function SetHyperlink_Hook(self, hyperlink, text, button)
    local item_string = GetItemString(hyperlink)
    if item_string == nil or item_string == "" then return end
    if strsplit(":", item_string) == "keystone" then
        local key_level = GetKeyLevel(hyperlink)
        ItemRefTooltip:AddLine(font_color .. dungeon_reward_string .. GetDungeonReward(key_level) .. ", " .. GetDungeonRewardTrack(key_level) .. "|r", 1, 1, 1, true)
        ItemRefTooltip:AddLine(font_color .. dungeon_crest_reward_string .. GetDungeonCrestReward(key_level) .. "|r", 1, 1, 1, true)
        ItemRefTooltip:AddLine(font_color .. vault_reward_string .. GetVaultReward(key_level) .. ", " .. GetVaultRewardTrack(key_level) .. "|r", 1, 1, 1, true)
        ItemRefTooltip:Show()
    end
end


function GetDungeonReward(key_level)
    if key_level == nil or key_level < 2 then
        -- Key value outside of normal range, return err
        return "Unknown Key Level"
    else
        if key_level > 11 then
            -- return the last element in the table
            return tostring(dungeon_item_level_table[#dungeon_item_level_table])
        else
            -- return the element at the index of key_level-1
            return tostring(dungeon_item_level_table[key_level-1])
        end
    end
end


function GetDungeonRewardTrack(key_level)
    if key_level == nil or key_level < 2 then
        -- Key value outside of normal range, return err
        return "Unknown Key Level"
    else
        if key_level > 11 then
            -- return the last element in the table
            return dungeon_upgrade_track_table[#dungeon_upgrade_track_table]
        else
            -- return the element at the index of key_level-1
            return dungeon_upgrade_track_table[key_level-1]
        end
    end
end


function GetDungeonCrestReward(key_level)
    if key_level == nil or key_level < 2 then
        return "Unknown Key Level"
    else
        if key_level > 11 then
            return dungeon_crest_table[#dungeon_crest_table]
        else
            return dungeon_crest_table[key_level-1]
        end
    end
end


function GetVaultReward(key_level)
    if key_level == nil or key_level < 2 then
        -- Key value outside of normal range, return err
        return "Unknown Key Level"
    else
        if key_level > 11 then
            -- return the last element in the table
            return tostring(vault_item_reward_table[#vault_item_reward_table])
        else
            -- return the element at the index of key_level-1
            return tostring(vault_item_reward_table[key_level-1])
        end
    end
end


function GetVaultRewardTrack(key_level)
    if key_level == nil or key_level < 2 then
        -- Key value outside of normal range, return err
        return "Unknown Key Level"
    else
        if key_level > 11 then
            -- return the last element in the table
            return vault_upgrade_track_table[#vault_upgrade_track_table]
        else
            -- return the element at the index of key_level-1
            return vault_upgrade_track_table[key_level-1]
        end
    end
end


GameTooltip:HookScript("OnTooltipCleared", OnTooltipCleared)
hooksecurefunc("ChatFrame_OnHyperlinkShow", SetHyperlink_Hook)
TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, OnTooltipSetItem)
