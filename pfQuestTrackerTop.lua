local function AnchorTrackerTop()
  local f = pfQuestMapTracker
  if not f then return end
  local r, t = f:GetRight(), f:GetTop()
  if r and t then
    f:ClearAllPoints()
    f:SetPoint("TOPRIGHT", UIParent, "BOTTOMLEFT", r, t)
  end
end

local hooked = false
local function HookTracker()
  if hooked or not pfQuestMapTracker then return end
  hooked = true

  local origDragStop = pfQuestMapTracker:GetScript("OnDragStop")
  pfQuestMapTracker:SetScript("OnDragStop", function()
    if origDragStop then origDragStop() end
    AnchorTrackerTop()
  end)

  local origMouseUp = pfQuestMapTracker:GetScript("OnMouseUp")
  pfQuestMapTracker:SetScript("OnMouseUp", function()
    if origMouseUp then origMouseUp() end
    AnchorTrackerTop()
  end)
end

local loader = CreateFrame("Frame")
loader:RegisterEvent("PLAYER_ENTERING_WORLD")
loader:SetScript("OnEvent", function()
  -- Wait one frame so pfQuest finishes restoring its saved position first
  this:SetScript("OnUpdate", function()
    this:SetScript("OnUpdate", nil)
    HookTracker()
    AnchorTrackerTop()
  end)
end)
