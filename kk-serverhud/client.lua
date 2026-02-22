local hudVisible = false

local function SendVisible(state)
  hudVisible = state
  SendNUIMessage({ type = "hud:setVisible", state = hudVisible })
end

local function ToggleHud()
  SendVisible(not hudVisible)
end

RegisterCommand(Config.Command, function()
  ToggleHud()
end, false)

RegisterCommand("toggleServerHud", function()
  ToggleHud()
end, false)

RegisterKeyMapping("toggleServerHud", "Server Info HUD", "keyboard", Config.DefaultKeybind)

if Config.EnableKeyFallback then
  CreateThread(function()
    while true do
      Wait(0)
      for _, control in ipairs(Config.FallbackControls) do
        if IsControlJustReleased(0, control) then
          ToggleHud()
          Wait(200)
          break
        end
      end
    end
  end)
end

CreateThread(function()
  Wait(500)
  SendVisible(false)

  while true do
    Wait(1000)

    if hudVisible then
      local playersOnline = #GetActivePlayers()
      local playerId = GetPlayerServerId(PlayerId())
      local playersMax = GetConvarInt("sv_maxclients", 9)

      SendNUIMessage({
        type = "hud:update",
        playersOnline = playersOnline,
        playersMax = playersMax,
        playerId = playerId,
      })
    end
  end
end)