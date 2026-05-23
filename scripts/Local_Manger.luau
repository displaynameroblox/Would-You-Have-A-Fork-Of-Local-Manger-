-- meow :3

local fold = {}
local localfold = nil
local deg = false

local manger = {} -- this is it
local config = {
    local_folder_path = "lib_fold_data_local",
    rlpx_folder_parent = game.Workspace,
    local_folder_cache_path = "lib_fold_data_local/cache",
    Session_cache_folder = nil, -- to be set
    session_write_folder_lock = false
}
manger.cache = {
    -- idk how i would do this but yeah
}

function manger:CheckFold ()
    if not fold then
        local folder = instance.new("folder")
        folder.Name = "lib_fold_data"
        folder.parent = manger.config.rlpx_folder_parent
        fold = folder
    elseif fold then
        warn("[manger lib WARN]: folder already exists, overwriting..")
        fold:Destroy()
        local folder = instance.new("folder")
        folder.Name = "lib_fold_data"
        folder.parent = manger.config.rlpx_folder_parent
        fold = folder
    else
        warn("[manger lib ERR]: unknown error, failed to create folder")
    end
end

function manger:CheckLocalFold ()
    if not isfolder("lib_fold_data_local") then
        local foldd = nil
        local s,r = pcall(function()
            makefolder("lib_fold_data_local")
        end)
        if not s then 
            warn("[manger lib ERR]: failed to create local folder, error: "..r)
        else
            localfold = isfolder
        end
    end
end

function manger.GetFold ()
    if not fold and fold.IsA("folder") then
        warn("[manger lib WARN]: folder does not exist, creating..")
        manger:CheckFold()
        return fold
    elseif fold and fold.IsA("folder") then
        return fold
    else
        warn("[manger lib ERR]: unknown error, failed to get folder")
    end
end

function manger:CheckCache()
    if not (isfolder(manger.config.local_folder_cache_path)) then
        local s,r = pcall(function()
            makefolder(manger.config.local_folder_cache_path)
        end)
        if not s then
            warn("[manger lib ERR]: failed to create cache folder, error: "..r)
        elseif s then
            print("[manger lib INFO]: cache folder created successfully")
        else
            warn("[manger lib ERR]: unknown error, failed to create cache folder")
        end
    elseif (isfolder(manger.config.local_folder_cache_path)) then
        print("[manger lib INFO]: cache folder already exists, skipping..")
    else
        warn("[manger lib ERR]: unknown error, failed to check cache folder") -- display here, the FUCK is this error :/, like how bad your executor can be???
    end
end

-- here where the REAL magic happens

function manger:Start()
    print("[manger lib INFO]: starting local manger..")
    if not isfolder(manger.config.local_folder_path) then
        if (deg == true) then -- debugging
            warn("[manger lib DEBUG]: local folder does not exist, creating..")
        end
        manger:CheckLocalFold()
    end
    if not (fold or not fold.IsA("folder")) then
        if (deg == true) then -- debugging
            warn("[manger lib DEBUG]: folder does not exist, creating..")
        end
        manger:CheckFold()
    end
    print("[manger lib INFO]: checking cache..")
    manger:CheckCache()
    -- here where i would load the cache data into the table but, not right now..
end
                                                                                                     -- this below is B.U.L.L.S.H.I.T TM*
function manger:CreateCacheFold(name : string) : (boolean, string?) -- make a cache folder for your script, later with your key to write to it
    if not name or type(name) ~= 'string' then
        warn("[manger lib ERR]: invalid name provided for cache folder")
        return false, "ERR_CFOLD:FALSE_NAME" -- CFOLD = cache folder, peak naming skills :3
    end
    if isfolder(manger.config.local_folder_cache_path .. "/" .. name) then
        warn("[manger lib WARN]: cache folder with name ".. name .. " already exists, skipping creation..")
        return true, "WARN_CFOLD:EXISTS" -- same here
    end
    local s,r = pcall(function()
        makefolder(manger.config.local_folder_cache_path .. "/" .. name)
    end)
    if not s then
        warn("[manger lib ERR]: failed to create cache folder with name ".. name .. ", error: " .. r)
        return false, "ERR_CFOLD:FAILED_CREATE" -- some wonder what dose this mean, alright the "ERR" before the underscore is js to say its an err or a warning, and after its where in the code is the error and after the ":" is the error itself. best dev ever :3
    end
    if s then
        print("[manger lib INFO]: cache folder with name ".. name.." created successfully")
        config.session_cache_folder = manger.config.local_folder_cache_path .. "/" .. name
        config.session_write_folder_lock = true -- so the script dont fuck the whole user executor folder
        return true -- no need to return an error code
    end
        -- this should never be reached but, you know, just in case
    warn("[manger lib ERR]: unknown error, failed to create cache folder with name ".. name)
    return false, "ERR_CFOLD:UNKNOWN_your executor is shit"
end

function manger:WriteToCacheFold(data : any, name : string, type_over_write : string) : (boolean, string?)
    if not data or data == nil then
        warn("[manger lib ERR]: given no data to write ")
        return false, "ERR_CWRITE:NO DATA"
    end
    if not name or typeof(name) ~= "string" then
        warn("[manger lib ERR]: given no name to write")
        return false, "ERR_CWRITE: NO NAME"
    end
    -- for now, we are not using the "type_over_write" var, we gonna use the file type given by the name
    if type_over_write then
        warn("[manger lib WARN]: type over write dose not exists for now!!, ignoring..")
        return false, "WARN_CWRITE: NO_TYPE_OVER_WRITE_SUPPORT"
    end
    if not config.session_write_folder_lock and not config.session_cache_folder then
        warn("[manger lib WARN]: no cache folder set for this session, creating one")
        local s,r = pcall(function()
            local random_folder_name = "cache_".. name .. "_" .. tostring(math.random(100000,999999))
            manger:CreateCacheFold(random_folder_name)
        end)
        if not s then
            warn("[manger lib ERR]: failed to create cache folder for this session, error: " .. r)
            return false, "ERR_CWRITE:FAILED_CREATE_SESSION_CACHE_FOLDER"
        end
        if s then
            print("[manger lib INFO]: cache folder for this session created successfully")
            -- wait
        end
    elseif config.seession_cache_folder and config.session_write_folder_lock then
        print("[manger lib INFO]: using existing cache folder for this session: " .. config.Session_cache_folder.."to write file ".. name .."..")
        local s,r = pcall(function()
            writefile(config.session_cache_folder .. "/" .. name, data)
        end)
        if not s then
            warn("[manger lib ERR]: failed to cache file ".. name .." due to error: " .. r"")
            return false, "ERR_CWRITE:FAILED_WRITE_FILE"
        end
        if s then
            print("[manger lib INFO]: file ".. name .." cached successfully in session cache folder")
            return true
        end
    else
        warn("[manger lib ERR]: unknown error, failed to write file ".. name .." to cache folder")
        return false, "ERR_CWRITE:UNKNOWN_ERROR you have bullshit executor, sorry g"
    end
end

function manger:ReadAllCacheFoldFiles()
    if not config.Session_cache_folder or not config.session_write_folder_lock then
        warn("[manger lib WARN]: no session cache folder found!, cannot read files. Did you forget to set one?")
        return false, "WARN_CREAD:NO_SESSION_CACHE_FOLDER"
    end
    for _, file in pairs(listfiles(config.session_cache_folder)) do
        local s,r = pcall(function()
           if deg == true then
            print("[manger lib DEBUG]: read file ".. file .." from session cache folder, data:")
           end
           if table.find(manger.cache, file) then
            warn("[manger lib WARN]: file ".. file .." already exists in cache, skipping read..")
            return true, "WARN_CREAD:FILE_ALREADY_IN_CACHE"
           else
               manger.cache[file] = file -- for now, bc if add the other data w/ data it will use a L O T of memory, at least what i think
           end
        end)
        if not s then
            warn("[manger lib ERR]: failed to read file ".. file .." from session cache folder, error: " .. r)
        end
    end
end

function helper_loadrblx(type, data)
    if type == "settings" then
        local s,r = pcall(function()
            return game.HttpService:JSONDecode(data)
        end)
        if not s then
            warn("[manger lib ERR]: failed to decode JSON data, error: " .. r)
            return false, "ERR_LOADRBLX:FAILED_DECODE_JSON"
        else
            local table = s
            return true, table
        end
    end
    if type == "imgs" then
        local s,r = pcall(function()
            local img : ImageLabel = instance.new("ImageLabel") -- i do hate the LSP extension for VS code, it used to work before but now, its shit
            img.ImageContent = getcustomasset(data)
            img.Parent = localfold
            img.Name = "cached_img:".. math.random(199999999999,999999999999)
        end)
        if not s then
            warn("[manger lib ERR]: failed to load image, error:" .. r ", you MAY have been kicked, and if so i feel sorry for you :(")
            return false, "ERR_LOADRBLX:FAILED_LOAD_IMAGE"
        else
            print("[manger lib INFO]: image loaded successfully from cache")
            return true, r
        end
    end
    if type == "sounds" then
        local s,r = pcall(function()
            local sound : Sound = instance.new("Sound")
            sound.SoundId = getcustomasset(data)
            sound.Parent = localfold
            sound.Name = "cached_sound:".. math.random(199999999999,999999999999)
        end)
        if not s then
            warn("[manger lib ERR]: failed to load sound, error:" .. r ", you MAY have been kicked, and if so i feel sorry for you :(")
            return false, "ERR_LOADRBLX:FAILED_LOAD_SOUND"
        else
            print("[manger lib INFO]: sound loaded successfully from cache")
            return true, r
        end
    end
    if type == "video" then
        warn("[manger lib WARN]: video file type is unstable in roblox, soo it might work or crash your whole game, and might get you banned")
        local s,r = pcall(function()
            local video : VideoFrame = instance.new("VideoFrame")
            video.VideoContent = getcustomasset(data)
            video.Parent = localfold
            video.Name = "cached_video:".. math.random(199999999999,999999999999)
        end)
        if not s then
            warn("[manger lib ERR]: failed to load video, error:" .. r ", you MAY have been kicked, and if so i feel sorry for you :(")
            return false, "ERR_LOADRBLX:FAILED_LOAD_VIDEO"
        else
            print("[manger lib INFO]: video loaded successfully from cache, wait HOW THE FUCK DID THIS WORK???")
            return true, r
        end
    end
end

function manger:LoadCacheToRblx()
    -- now, we see which type of file it is,
    local outsidetables = loadstring("https://github.com/displaynameroblox/Would-You-Have-A-Fork-Of-Local-Manger-/blob/main/scripts/outside_tables.luau") -- idk if VS code will pick up the tables in this file but its dosen't matter bc i do remember, or do i?
    for i,file in pairs(manger.cache) do
        -- to be added...
    end
end

function manger:Download(Url : string) -- very very VERY baisc download func
    if not Url or typeof(Url) ~= "string" then
        warn("[manger lib ERR]: given no Url to download")
        return false, "ERR_DOWNLOAD:NO_URL"
    end
    local serverexist = nil
    local pinged, r = pcall(function()
        game:HttpPost(Url)
    end)
    if not pinged then
        warn("[manger lib ERR]: could not find server! did you put the worng Url?")
        return false, "ERR_DOWNLOAD:SERVER_NOT_FOUND"
    end
    if pinged then
        print("[manger lib INFO]: server found, downloading data..")
        local s,r = pcall(function()
            return game:HttpGet(Url)
        end)
        if not s then
            warn("[manger lib ERR]: failed to download data from server, error: " .. r)
            return false, "ERR_DOWNLOAD:FAILED_DOWNLOAD"
        else
            print("[manger lib INFO]: saving..")
            local s2,r2 = pcall(function()
                local ran = math.random(100000,999999)
                writefile(manger.config.session_write_folder_lock .. "/downloaded_data_" .. tostring(ran) .. ".bin", r) --.bin bc i dont know what kind of bullshit data the user want, thats why its a 'basic' downloader
                return manger.config.session_cache_folder .. "downloaded_data_".. tostring(ran) .. ".bin"
            end)
            if not s2 then
                warn("[manger lib ERR]: failed to save downloaded file!.. ".. r2 .." ")
                r = nil
                return false, "ERR_DOWNLOAD:FAIL_SAVE_FILE"
            else
                print("[manger lib INFO]: saved file")
                return true, r2 -- 'path (i hope)' said display
            end
        end
    end
end

return manger