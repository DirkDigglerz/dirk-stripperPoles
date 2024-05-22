local occupying = false
local makingItRain = false

local makeItRain = function()

  makingItRain = true
  RequestNamedPtfxAsset("core")
  cash = CreateObject(GetHashKey("prop_cash_pile_01"), 0, 0, 0, true, true, true) 
  AttachEntityToEntity(cash, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 18905), 0.12, 0.028, 0.001, 300.00, 180.0, 20.0, true, true, false, true, 1, true)
  local lib, anim = 'anim@mp_player_intcelebrationfemale@raining_cash', 'raining_cash' 
  Wait(900)
  while not HasAnimDictLoaded(lib) do RequestAnimDict(lib) Wait(0) end
  TaskPlayAnim(cache.ped, lib, anim, 8.0 , -1 , -1 , 0 , 0 , false , false , false);
  Wait(1000)
  local netID = NetworkGetNetworkIdFromEntity(cache.ped)
  local pos   = GetEntityCoords(cache.ped)
  TriggerServerEvent("dirk-stripperPoles:syncMoneyEffects", pos, netID)
  UseParticleFxAssetNextCall("core")
  local fx = StartParticleFxNonLoopedOnEntity("ent_brk_banknotes", cache.ped, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0, false, false, false)  
  Wait(2000)
  DetachEntity(cash, 1, 1)
  DeleteEntity(cash)
  makingItRain = false
end

local leanAnimation = function(pos, setPos)
  if not occupying then return false; end
  if setPos then 
    TaskGoStraightToCoord(cache.ped, pos.x, pos.y, pos.z, 1.0, 1000, 0.0, 0.0)
    while not IsEntityAtCoord(cache.ped, pos.x, pos.y, pos.z, 0.5, 0.5, 0.5, false, true, 0) do Wait(0); end
    Wait(1000)
    SetEntityHeading(cache.ped, pos.w)
    FreezeEntityPosition(cache.ped, true)
  end


  local lib, anim = Config.leanAnim.lib, Config.leanAnim.anim
  while not HasAnimDictLoaded(lib) do RequestAnimDict(lib) Wait(0) end
  TaskPlayAnim(cache.ped, lib, anim, 8.0 , -1 , -1 , 0 , 0 , false , false , false);
end

local leaveLean = function()


  TriggerServerEvent("dirk-stripperPoles:leanspot:sync", occupying, {
    occupied = false
  })
  ClearPedTasks(cache.ped)
  FreezeEntityPosition(cache.ped, false)
  occupying = false
end

RegisterNetEvent('dirk-stripperPoles:syncMoneyEffects', function(netID)
  local ply = NetworkGetEntityFromNetworkId(netID)
  if not DoesEntityExist(ply) then return false; end
  -- Play Particle Effects from 
  UseParticleFxAssetNextCall("core")
  local fx = StartParticleFxNonLoopedOnEntity("ent_brk_banknotes", ply, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0, false, false, false)
  Wait(4000)
  StopParticleFxLooped(fx, 0)
end)


newLeanSpot = function(id,data)

  local self = {}
  self.id       = id
  self.occupied = false
  self.pos      = data.pos 
  self.limit    = data.limit or 10000
  self.spent    = 0 
  self.lastThorw = false


  self.draw = function()
    DrawMarker(1, self.pos.x, self.pos.y, self.pos.z - 0.9, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 255, 255, 255, 255, 0, 0, 0, 0)
  end

  self.throwMoney = function()

    local now = GetGameTimer()
    if not self.lastThrow or now - self.lastThrow > Config.spamControl * 1000 then 
      self.lastThrow = now
    else
      return false, Core.UI.Notify(string.format('Please wait %s seconds to throw again ', math.floor(Config.spamControl - ((now - self.lastThrow) / 1000))))
    end

    Core.Callback("dirk-stripperPoles:throwMoney", function(hasMoney, errorMsg)
      if hasMoney then 
        makeItRain()
        leanAnimation(self.pos, false)
      else
        Core.UI.Notify(errorMsg)
      end
    end, self.id)

  end

  self.occupy = function()
    if self.occupied then return false end
    self.occupied = true
    --\\ Place in lean animation 

    
    leanAnimation(self.pos, true)
    occupying = self.id
    TriggerServerEvent("dirk-stripperPoles:leanspot:sync", self.id, {
      occupied = GetPlayerServerId(PlayerId())  
    })
    return true 
  end

  self.update = function(data)  
    for k,v in pairs(data) do 
      self[k] = v
    end
  end

  leanspots[id] = self
  return self
end


RegisterNetEvent("dirk-stripperPoles:leanspot:sync", function(id,data)
  local leanSpot = leanspots[id]
  if not leanSpot then return false; end 
  leanSpot.update(data)
end)



onReady(function()
  for name, pole in pairs(Config.stripperPoles) do 
    for id, spot in pairs(pole.leanSpots) do 
      newLeanSpot(id, {
        attachedPole = name,
        pos          = spot,
        limit        = pole.limit
      })
    end

    if Config.usingTarget then 
      for k,v in pairs(pole.leanSpots) do 
        Core.Target.AddBoxZone(string.format("leanSpot:%s:%s", name, k), {
          Length = 2.0,
          Width  = 2.0,
          Height  = 1.0,
          Position = v,
          Distance = 1.5,
          Options = {
            {
              label = "Lean",
              icon = "fas fa-money-bill-wave",
              canInteract = function()
                print('occupied = ', leanspots[k].occupied)
                return not leanspots[k].occupied
              end,

              action = function()
                leanspots[k].occupy()
              end
            }
          }
        })
      end 
    end
  end

  while true do 
    local wait_time = 1000 
    local mypos = GetEntityCoords(cache.ped)

    if not occupying then 
      if not Config.usingTarget then 
        for id, data in pairs(leanspots) do 
          if not data.occupied then 
            local dist = #(mypos - data.pos.xyz)
            if dist < 3.0 then 
              wait_time = 0 
              data.draw()
              if dist < 1.0 then 
                Core.UI.ShowHelpNotification("Press ~INPUT_CONTEXT~ to start leaning")
                if IsControlJustPressed(0, 38) then 
                  data.occupy()
                end
              end
            end
          end
        end
      end
    else
      wait_time = 0
      DisableAllControlActions(0)
      DisableAllControlActions(1)
      Core.UI.ShowHelpNotification("Press ~INPUT_CONTEXT~ to throw money\nPress ~INPUT_VEH_DUCK~ to stop leaning")
      if IsDisabledControlJustPressed(0, 38) then 
        local currentOccupyingData = leanspots[occupying]
        currentOccupyingData.throwMoney()
      elseif IsDisabledControlJustPressed(0, 120) then 
        leaveLean()
      end
      for _,exception in pairs(Config.allowedControls) do 
        EnableControlAction(0, exception, true)
        EnableControlAction(1, exception, true)
      end
      

      if not makingItRain then 
        local ply = cache.ped
        local lib, anim = Config.leanAnim.lib, Config.leanAnim.anim
        local playingAnim = IsEntityPlayingAnim(ply, lib,anim,3) 
        if not playingAnim then 
          leanAnimation()
        end
      end

    end

    Wait(wait_time)
  end
end)



RegisterCommand('testThrow', function()
  makeItRain()
end)


RegisterCommand('unfreeze', function()
  local ply  = cache.ped
  FreezeEntityPosition(ply, false)
end)