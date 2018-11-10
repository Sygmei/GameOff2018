local TextureAtlas = {
    Down = { y = 0, length = 3 },
    Right = { y = 40, length = 3 },
    Top = { y = 80, length = 3 },
    Left = { y = 120, length = 3 },
};
local TextureSize = { width = 40, height = 40 };
local Orientation = { "Right", "Top", "Left", "Down" };
local AtlasFiles = {
    "GirlDarkExample.png",
    "GirlLightExample.png",
    "GuyDarkExample.png",
    "GuyLightExample.png",
    "HatGuy.png",
    "OrcExample.png",
    "RedHeadExample.png"
}

function Local.Init()
    This:getSceneNode():setPosition(obe.UnitVector(1.9, 1.1));
    This:LevelSprite():loadTexture("Sprites/GameObjects/NPC/" .. AtlasFiles[math.random(1, 7)]);
    This:Collider():addTag(obe.ColliderTagType.Rejected, "Character");
    This:Collider():addTag(obe.ColliderTagType.Rejected, "Door");
    Object.direction = "Down";
    Object.animationTimer = 0;
    Object.animationDelay = 0.2;
    Object.animationIndex = 0;
    setTextureRect();
    Object.tNode = obe.TrajectoryNode(This:getSceneNode());
    Object.trajectory = Object.tNode:addTrajectory("Linear");
    Object.trajectory
        :setAngle(math.random(0, 360))
        :setSpeed(0.1)
        :setAcceleration(0)
        :onCollide(Object.collide);
    Object.tNode:setProbe(This:Collider());
    Object.dead = 22;
    Object.deadTimer = 0;
end

function setTextureRect()
    This:LevelSprite():setTextureRect(TextureSize.width * Object.animationIndex, TextureAtlas[Object.direction].y, TextureSize.width, TextureSize.height);
end

function Object.collide()
    Object.trajectory:addAngle(180);
end

function round(x)
    return x >= 0 and math.floor(x+0.5) or math.ceil(x-0.5)
end

function Global.Game.Update(dt)
    Object.tNode:update(dt);
    Object.trajectory:addAngle(dt * 10);
    Object.animationTimer = Object.animationTimer + dt;
    if Object.animationTimer > Object.animationDelay then
        Object.animationTimer = 0;
        Object.animationIndex = Object.animationIndex + 1;
        if Object.animationIndex >= TextureAtlas[Object.direction].length then
            Object.animationIndex = 0;
        end
        setTextureRect();
    end
    local angle = math.fmod(Object.trajectory:getAngle(), 360);
    if angle < 0 then angle = angle + 360; end
    Object.direction = Orientation[round(angle / (360 / 4)) + 1];
    if not Object.direction then Object.direction = "Right"; end
    Object.deadTimer = Object.deadTimer + dt;
    if Object.deadTimer >= Object.dead then
        This:delete();
    end
end