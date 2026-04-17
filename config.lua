Config = {}
Config.DriverLicense = {
    ['car'] = 'driver', -- car is the vehicle type, while driver is the player metadata
}

local vehicles = {
            {
                model = 'bmx',
                money = 50,
                img = 'nui://rep-rental/web/build/assets/bmx.png',
            },
            {
                model = 'cruiser',
                money = 50,
                img = 'nui://rep-rental/web/build/assets/cruiser.png',
            },
            {
                model = 'scorcher',
                money = 75,
                img = 'nui://rep-rental/web/build/assets/scorcher.png',
            },
            {
                model = 'faggio',
                money = 150,
                img = 'nui://rep-rental/web/build/assets/faggio.png',
            },
            {
                model = 'faggio2',
                money = 150,
                img = 'nui://rep-rental/web/build/assets/faggio2.png',
            },
            {
                model = 'faggio3',
                money = 175,
                img = 'nui://rep-rental/web/build/assets/faggio3.png',
            },
            {
                model = 'panto',
                money = 300,
                type = 'car',
                img = 'nui://rep-rental/web/build/assets/panto.png',
            },
            {
                model = 'asea',
                money = 500,
                type = 'car',
                img = 'nui://rep-rental/web/build/assets/asea.png',
            },
            {
                model = 'primo',
                money = 600,
                type = 'car',
                img = 'nui://rep-rental/web/build/assets/primo.png',
            },
            {
                model = 'felon',
                money = 600,
                type = 'car',
                img = 'nui://rep-rental/web/build/assets/felon.png',
            }
        }

Config.Locations = {
    {
        ped = {
            hash = 'u_f_m_miranda_02',
            name = 'Carmella Rentheart',
            position = "Escalera Employee",
            color = "#fd4747",
            startMSG = 'Hey, how may I help you today?',
        },
        coords = vector4(-311.8154, -926.1224, 30.08, 258.08785),
        spawnpoint = vector4(-317.8297, -931.9272, 30.6569, 250.0985),
        type = 'vehicle',
        blip = {
            label = "Rental",
            colour = 50,
            sprite = 56,
        },
        vehicles = vehicles,
    },
    {
        ped = {
            hash = 'u_f_m_miranda_02',
            name = 'Carmella Rentheart',
            position = "Escalera Employee",
            color = "#fd4747",
            startMSG = 'Hey, how may I help you today?',
        },
        coords = vector4(109.2877, -1088.5396, 28.3, 352.5399),
        spawnpoint = vector4(105.8077, -1063.0851, 28.7839, 245.3517),
        type = 'vehicle',
        blip = {
            label = "Rental",
            colour = 50,
            sprite = 56,
        },
        vehicles = vehicles,
    },
}

Config.Lang = {
    ['en'] = {
        error = {
            obstacle = {
                label = "There is a vehicle blocking the road",
                type = "error",
                time = 5000
            },
            already = {
                label = "Please return the car before renting again",
                type = "error",
                time = 5000
            },
            license = {
                label = "You need a driver license",
                type = "error",
                time = 5000
            },
            cash = {
                label = "You don't have enough cash",
                type = "error",
                time = 5000
            },
            bank = {
                label = "You don't have enough money in your card",
                type = "error",
                time = 5000
            },
        },
        npc = {
            button1 = {
                label = "I need a vehicle",
            },
            button2 = {
                label = "I'm just passing by here",
            },
            button3 = {
                label = "I'm want return vehicle",
            },
        },
        ui = {
            per_hour = "/ per hour",
            rent = "Rent",
            choose_color = "Choose a color:",
            rental_dur = "Rental duration:",
            rental_dur_placeholder = "Rent hours",
            one_hour = "1 hour",
            two_hours = "2 hours",
            three_hours = "3 hours",
            four_hours = "4 hours",
            total = "Total amount:",
            cash = "Cash",
            card = "Card"
        }

    }
}

local _lang = GetConvar('repscripts:locale', 'en')
Lang = Config.Lang[_lang]

Framework = {}

function Framework.ESX()
    return GetResourceState("es_extended") ~= "missing"
end

function Framework.QBCore()
    return GetResourceState("qb-core") ~= "missing"
end

function Framework.QBox()
    return GetResourceState("qbx_core") ~= "missing"
end