leanspots = {}

newLeanSpot = function(id,data)
  local self = {}
  self.id       = id
  self.attachedPole = data.attachedPole
  self.occupied = false
  self.pos      = data.pos 

  local shouldSync = {
    occupied = true
  }

  self.update = function(data)  
    local toSync = {}
    for k,v in pairs(data) do 
      self[k] = v
      if shouldSync[k] then 
        toSync[k] = v
      end
    end
    if next(toSync) then 
      TriggerClientEvent("dirk-stripperPoles:leanspot:sync", -1, self.id, toSync)
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
  end

  Core.Callback("dirk-stripperPoles:throwMoney", function(src,cb,id)
    local thisSpot = leanspots[id]
    if not thisSpot then return cb(false); end
    local pole = getPoleById(thisSpot.attachedPole)
    if not pole then print(string.format("We cannot find a pole with ID:%s", thisSpot.attachedPole)) return cb(false); end
    if pole.occupantCount() == 0 then return cb(false, 'There is noone to throw your money at'); end
    local throwMoney, errorMsg = pole.throwMoney(src)
    if not throwMoney then return cb(false, errorMsg); end
    cb(true)
  end)
end)


















RegisterNetEvent("dirk-stripperPoles:syncMoneyEffects", function(pos,NetId)
  local src = source
  local nearbyIds = {}
  for k,v in pairs(GetPlayers()) do
    local plyPos = GetEntityCoords(GetPlayerPed(v))
    if #(plyPos - pos) < 10.0 then 
      table.insert(nearbyIds, v)
    end
  end
  for k,v in pairs(nearbyIds) do 
    if tonumber(v) ~= tonumber(src) then 
      TriggerClientEvent("dirk-stripperPoles:syncMoneyEffects", tonumber(v), NetId)
    end
  end
end)