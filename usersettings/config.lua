Config = {
  usingTarget          = true, 
  returnAccount   = "cash",
  spamControl     = 5, --## How many seconds between each throw
  allowedControls = {},
  leanAnim        = {lib = 'anim@amb@nightclub@lazlow@ig1_vip@', anim = 'clubvip_base_laz'},

  stripperPoles = {
    ['vanillaUnicorn-fiveDev'] = {
      danceZone = {
        vector3(99.28018951416,-1289.5327148438,27.346347808838),
        vector3(102.06481170654,-1288.26953125,27.260959625244),
        vector3(103.8480682373,-1288.65625,27.260959625244),
        vector3(104.71467590332,-1289.3911132812,27.321521759033),
        vector3(109.72971343994,-1286.4954833984,27.260959625244),
        vector3(109.591796875,-1285.6778564453,27.286987304688),
        vector3(112.25367736816,-1283.9031982422,27.343229293823),
        vector3(113.21440887451,-1283.9519042969,27.345188140869),
        vector3(115.66416168213,-1288.2615966797,27.307500839233),
        vector3(115.44802093506,-1288.8719482422,27.307065963745),
        vector3(113.39487457275,-1290.1434326172,27.260959625244),
        vector3(112.5267791748,-1290.5037841797,27.260959625244),
        vector3(111.64040374756,-1290.10546875,27.260959625244),
        vector3(106.89671325684,-1292.8767089844,27.260959625244),
        vector3(106.97664642334,-1294.7160644531,27.260959625244),
        vector3(105.85494995117,-1296.2866210938,27.260959625244),
        vector3(104.28559875488,-1297.265625,27.260959625244),   
      },

      denomination = 5000,       --## The denomination of the money that is thrown at a time e.g 20xCash
      currency     = {type = 'item', name = 'black_money'},--## The currency that is thrown --## This will not search for metadata just a non-unique item
      retCurrency  = {type = 'account', name = "cash"},  --## The currency returned to dancers and the player
      jobs         = {unemployed = 0}, --## The jobs that can use this pole
      limit        = 999999999,    --## How much can a player splash at this.
      toSociety    = "vu",     --## The society to pay the money to if you choose to do so 
      shares = {               --## The shares of the money that is thrown
        toPlayer   = 90,
        toStripper = 10, 
        toSociety  = 5, 
      },

      leanSpots = {           --## The spots where you can lean and throw that dollah      
        ["rightSide"]    = vector4(110.85, -1284.3, 28.26, 209.7),
        ['middle']       = vector4(114.91, -1286.08, 28.26, 114.6),
        ['leftSide']     = vector4(114.54, -1289.86, 28.26, 37.87),
      },
    },    
  },

  dances = {
    [1] = {
      label = "Dance 1",
      lib   = 'mini@strip_club@private_dance@part1',
      anim  = 'priv_dance_p1',
    },
    [2] = {
      label = "Dance 2",
      lib   = 'mini@strip_club@private_dance@part2',
      anim  = 'priv_dance_p2',
    },
    [3] = {
      label = "Dance 3",
      lib   = 'mini@strip_club@private_dance@part3',
      anim  = 'priv_dance_p3',
    }
  },
}

Core, Settings = exports['dirk-core']:getCore(); 
