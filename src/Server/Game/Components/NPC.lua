local Knit = require(game:GetService("ReplicatedStorage").Knit)
local Maid = require(Knit.Util.Maid)

local Component = require(Knit.Util.Component);

local NPC = {}
NPC.__index = NPC

NPC.Tag = "NPC"


function NPC.new(instance)
    local self = setmetatable({
        RespawnTime = 5;
        InitialPosition = CFrame.new();
    }, NPC)
    self._maid = Maid.new()
    return self
end

function NPC:Update()
    --// Respawning

    if (not self.Instance) then return end;

    local Humanoid = self.Instance:FindFirstChild('Humanoid')
    if (not Humanoid) then return end;


    if (Humanoid.Health <= 0) then --// Respawning.
        if (not self.DiedAt) then
            --// NPC dead!
            self.DiedAt = tick();
            return;
        end

        if (tick() - self.DiedAt < self.RespawnTime) then return end;
        
        --// Respawn NPC.

        local NewModel = self.Instance:Clone();
        NewModel.Humanoid.Health = 100;
        NewModel:MakeJoints()
        NewModel.Parent = self.Instance.Parent;
        self.Instance:Destroy()
        NewModel:SetPrimaryPartCFrame(self.InitialPosition);
        self.Instance = NewModel;
    end

end

function NPC:Init()
    self.Instance:SetAttribute('UID', game:GetService("HttpService"):GenerateGUID())
    self.Instance:SetAttribute('NPC', true)

    Knit.Modules.HitboxManager.ApplyHitboxToCharacter(self.Instance)

    repeat task.wait() until self.Instance:IsDescendantOf(workspace);
    task.wait(.5)
    self.InitialPosition = self.Instance:GetPrimaryPartCFrame()

    self._maid:GiveTask(game:GetService("RunService").Heartbeat:Connect(function()
        self:Update()
    end))
end


function NPC:Deinit()
end


function NPC:Destroy()
    self._maid:Destroy()
end


return NPC