-- meow :3

local fold = {}
local localfold = nil
local deg = false

local manger = {} -- this is it
local manger.config = {
    local_folder_path = "lib_fold_data_local",
    rlpx_folder_parent = game.Workspace,

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

