Config = {
  returnAccount   = "cash",
  spamControl     = 5, --## How many seconds between each throw
  allowedControls = {},
  leanAnim        = {lib = 'anim@amb@nightclub@lazlow@ig1_vip@', anim = 'clubvip_base_laz'},

  stripperPoles = {
    ['vanillaUnicorn-fiveDev'] = {
      danceZone = {
        vector3(108.63925170898,-1296.3497314453,28.406003952026),
        vector3(109.68885040283,-1295.4644775391,28.4196434021),
        vector3(110.66255950928,-1293.8630371094,28.300262451172),
        vector3(112.62454986572,-1294.0456542969,28.300268173218),
        vector3(114.93127441406,-1292.7944335938,28.300273895264),
        vector3(115.46892547607,-1290.9020996094,28.274715423584),
        vector3(117.73882293701,-1291.0866699219,28.300298690796),
        vector3(119.86264801025,-1289.83984375,28.300298690796),
        vector3(120.41892242432,-1288.0799560547,28.288501739502),
        vector3(121.43914794922,-1287.7395019531,28.300298690796),
        vector3(123.44960021973,-1288.515625,28.300298690796),
        vector3(123.51182556152,-1290.5047607422,28.300298690796),
        vector3(122.09657287598,-1291.4202880859,28.300298690796),
        vector3(120.87956237793,-1291.0543212891,28.297218322754),
        vector3(118.81465911865,-1292.1025390625,28.416463851929),
        vector3(118.08997344971,-1293.5617675781,28.300298690796),
        vector3(117.40944671631,-1294.3802490234,28.300298690796),
        vector3(115.41554260254,-1294.2053222656,28.181755065918),
        vector3(113.52877044678,-1295.4104003906,28.223384857178),
        vector3(113.14813232422,-1296.6990966797,28.225387573242),
        vector3(112.02349853516,-1297.4631347656,28.294078826904),
        vector3(110.37642669678,-1297.1168212891,28.299425125122),
        vector3(109.55384063721,-1297.5549316406,28.299430847168),   
      },

      denomination = 5000,       --## The denomination of the money that is thrown at a time e.g 20xCash
      currency     = {type = 'item',    name = 'markedbills'},--## The currency that is thrown --## This will not search for metadata just a non-unique item
      retCurrency  = {type = 'account', name = "cash"},  --## The currency returned to dancers and the player
      jobs         = {vu = 0}, --## The jobs that can use this pole
      limit        = 999999999,    --## How much can a player splash at this.
      toSociety    = "vu",     --## The society to pay the money to if you choose to do so 
      shares = {               --## The shares of the money that is thrown
        toPlayer   = 90,
        toStripper = 10, 
        toSociety  = 5, 
      },

      leanSpots = {           --## The spots where you can lean and throw that dollah
        ["rightSide"]    = vector4(123.01, -1291.52, 28.44, 31.68),
        ['middle']       = vector4(120.66, -1287.43, 28.44, 201.28),
        ['leftSide']     = vector4(115.53, -1290.34, 28.44, 195.14),
        ['farRight']     = vector4(117.97, -1294.47, 28.44, 33.35), 
        ['furtherRight'] = vector4(112.52, -1297.55, 28.44, 19.87), 
        ['nextOne']      = vector4(110.29, -1293.54, 28.44, 212.04),
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
