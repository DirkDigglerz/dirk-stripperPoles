myJob, myGang = {name = 'unemployed', rank = 0}, {name = 'none', rank = 0} 
poles, leanspots = {}, {}
onReady = function(func) 
  CreateThread(function() 
    while not Core do Wait(500); end 
    while not Core.Player.Ready() do Wait(500); end 
    func() 
  end) 
end 
 
onReady(function() 
  myJob = Core.Player.GetJob() 
  myGang = Core.Player.GetGang() 
end) 
 
RegisterNetEvent('Dirk-Core:JobChange', function(newJob) 
  myJob = newJob 
end) 
 
