local addToSociety = function(society, amount)
  if not Settings.Framework then 
    Core,Settings = exports['dirk-core']:getCore();
  end

  if Settings.Framework == 'qb-core' then 
    -- exports['qb-management']:AddMoney(society, amount)
  elseif Settings.Framework == 'es_extended' then 

  end  
end

newPole = function(id,data)

  local self = {}
  self.id    = id
  self.limit = data.limit or 1
  self.shares  = data.shares or {
    toPlayer   = 75,
    toStripper = 10, 
    toSociety  = 15, 
  }
  self.earned = 0
  self.danceZone = data.danceZone or {}
  self.denomination = data.denomination or 1
  self.toSociety = data.toSociety or false
  self.currency = data.currency
  self.retCurrency = data.retCurrency
  self.occupants = {}

  self.shareEarningsEqually = function(ply, amount)
    local playerShare = math.floor(amount * (self.shares.toPlayer / 100))
    if playerShare > 0 then 
      Core.UI.Notify(tonumber(ply), string.format('You have washed $%s', playerShare))
      if self.retCurrency.type == "item" then 
        Core.Player.AddItem(tonumber(ply), self.retCurrency.name, playerShare)
      elseif self.retCurrency.type == "account" then 
        Core.Player.AddMoney(tonumber(ply), self.retCurrency.name, playerShare)
      end
    end


    local societyShare = math.floor(amount * (self.shares.toSociety / 100))
    if self.toSociety and societyShare > 0 then 
      addToSociety(self.toSociety, societyShare)
    end

    local stripperShare = math.floor(amount * (self.shares.toStripper / 100))
    if stripperShare == 0 then return false; end
    local stripperCount = self.occupantCount()
    if stripperCount == 0 then return false; end
    local stripperSharePer = math.floor(stripperShare / stripperCount)

    for playerId, active in pairs(self.occupants) do 
      if active then 
        Core.UI.Notify(tonumber(playerId), string.format("You have just earned £%s", stripperSharePer))
        if self.retCurrency.type == "item" then 
          Core.Player.AddItem(tonumber(playerId), self.retCurrency.name, stripperSharePer)
        elseif self.retCurrency.type == "account" then 
          Core.Player.AddMoney(tonumber(playerId), self.retCurrency.name, stripperSharePer)
        end
      end
    end

    return true
  end

  self.occupantCount = function()
    local count = 0
    for k,v in pairs(self.occupants) do 
      count = count + 1
    end
    return count
  end

  self.addOccupant = function(ply)
    self.occupants[ply] = true
  end

  self.removeOccupant = function(ply)
    self.occupants[ply] = nil
  end

  self.throwMoney = function(ply)
    local amount = self.denomination
    if self.earned + amount > self.limit then return false, 'This pole has reached its monetary limit for today come back again later'; end
    --\\ Check player for money 
    if self.currency.type == 'account' then 
      local hasMoney = Core.Player.HasMoneyInAccount(ply, self.currency.name, amount)
      if not hasMoney then return false, 'You dont have any money'; end
      Core.Player.RemoveMoney(ply, self.currency.name, amount)
    elseif self.currency.type == 'item' then 
      local hasMoney = Core.Player.HasItem(ply, self.currency.name, amount)
      if not hasMoney then return false, 'You dont have any money'; end
      Core.Player.RemoveItem(ply, self.currency.name, amount)
    end 

    self.earned = self.earned + amount

    self.shareEarningsEqually(ply, amount)
    return true 
  end

  poles[self.id] = self
end

RegisterNetEvent('dirk-stripperPoles:poles:occupy', function(poleId)
  local src = source
  local pole = getPoleById(poleId)
  if not pole then return false; end
  pole.addOccupant(src)
end)

RegisterNetEvent('dirk-stripperPoles:poles:leave', function(poleId)
  local src = source
  local pole = getPoleById(poleId)
  if not pole then return false; end
  pole.removeOccupant(src)
end)


onReady(function()
  for name, pole in pairs(Config.stripperPoles) do 
    newPole(name, {
      danceZone = pole.danceZone,
      limit     = pole.limit,
      currency  = pole.currency,
      denomination = pole.denomination,
      toSociety = pole.toSociety,
      shares    = pole.shares,

      retCurrency = pole.retCurrency,
    })
  end
end)