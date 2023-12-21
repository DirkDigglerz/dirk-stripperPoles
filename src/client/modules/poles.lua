newPole = function(id,data)
  local self = {}
  self.id = id  
  self.danceZone = data.danceZone or {}
  self.insideZone = false
  self.jobs = data.jobs or false

  self.onEnter = function()
    if self.jobs and not self.jobs[myJob.name] or self.jobs[myJob.name] > myJob.rank then return false; end
    if self.insideZone then return false; end
    self.insideZone = true
    TriggerServerEvent("dirk-stripperPoles:poles:occupy", self.id)
  end

  self.onExit = function()
    if not self.insideZone then return false; end
    self.insideZone = false
    TriggerServerEvent("dirk-stripperPoles:poles:leave", self.id)
  end

  Core.Zones.Register(self.id, {
    Type = "poly",
    Zone = self.danceZone,
    
    onLeave = function()
      self.onExit()
    end,

    onStay = function()
      self.onEnter()
    end,

    onEnter = function()
      self.onEnter()
    end,
  })



  poles[self.id] = self
  return self
end

local playDanceAnimation = function(anim)
  local ply = PlayerPedId()
  local lib = anim.lib
  local anim = anim.anim
  local flag = anim.flag or 1
  local duration = anim.duration or -1
  local playbackRate = anim.playbackRate or 1.0

  RequestAnimDict(lib)

  while not HasAnimDictLoaded(lib) do RequestAnimDict(lib); Wait(0); end 
  TaskPlayAnim(ply, lib, anim, 8.0 , -1 , -1 , flag , playbackRate , false , false , false);
end

local stopDanceAnimation = function()
  ClearPedTasksImmediately(PlayerPedId())
end



onReady(function()
  for name, pole in pairs(Config.stripperPoles) do 
    newPole(name, {
      danceZone = pole.danceZone,
      jobs = pole.jobs,
    })
  end
  local currentDance = 1

  while true do 
    local wait_time = 1000 
    for id,data in pairs(poles) do 
      if data.insideZone then 
        wait_time = 0
        local danceLabel = Config.dances[currentDance].label
        Core.UI.ShowHelpNotification(string.format('%s\nPress ~INPUT_CONTEXT~ to dance\nPress ~INPUT_CELLPHONE_RIGHT~ to cycle dances\nPress ~INPUT_VEH_DUCK~ to stop dancing', danceLabel))
        if IsControlJustPressed(0, 38) then 
          playDanceAnimation(Config.dances[currentDance])
        elseif IsControlJustPressed(0, 175) then 
          currentDance = currentDance + 1
          if currentDance > #Config.dances then currentDance = 1; end
        elseif IsControlJustPressed(0, 36) then
          stopDanceAnimation()
        end
      end
    end
    Wait(wait_time)
  end
end)