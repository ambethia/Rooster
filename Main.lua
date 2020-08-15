local ADDON, NS = ...

local QUEST_ID = 44877
local QUEST_NPC = 115802

Rooster = CreateFrame("Frame", ADDON .. "Frame")

Rooster:SetScript(
  "OnEvent",
  function(self, event, ...)
    if event == "QUEST_LOG_UPDATE" then
      if C_QuestLog.IsOnQuest(QUEST_ID) then
        local objectives = C_QuestLog.GetQuestObjectives(QUEST_ID)
        for _, objective in ipairs(objectives) do
          if objective.numFulfilled >= objective.numRequired / 2 then
            for i = 1, GetNumQuestLogEntries() do
              local questId = select(8, GetQuestLogTitle(i))
              if questId == QUEST_ID then
                SelectQuestLogEntry(i)
                SetAbandonQuest()
                AbandonQuest()
              end
            end
          end
        end
      end
    elseif event == "PLAYER_TARGET_CHANGED" then
      if not C_QuestLog.IsOnQuest(QUEST_ID) then
        local unitGUID = UnitGUID("target")
        if unitGUID then
          local unitId = tonumber(select(3, string.find(unitGUID, "%d+-%d+-%d+-%d+-(%d+)")) or "")
          if unitId == QUEST_NPC then
            AcceptQuest()
          end
        end
      end
    elseif event == "QUEST_ACCEPTED" then
      if select(2, ...) == QUEST_ID then
        C_Timer.After(0.5, CloseQuest)
      end
    end
  end
)
Rooster:RegisterEvent("QUEST_LOG_UPDATE")
Rooster:RegisterEvent("QUEST_ACCEPTED")
Rooster:RegisterEvent("PLAYER_TARGET_CHANGED")
