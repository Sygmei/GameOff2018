direction={"Left","Down","Right","Up"}

function Local.Init(pos)
    if pos == "Left" then Object.posX = 0.1
    elseif pos == "Right" then Object.posX = 0.6 
    end
    Object.posY = 0.1;
    This:getSceneNode():setPosition(obe.UnitVector(Object.posX, Object.posY, obe.Units.ViewPercentage));
    
    Object.arrowTargets = {};

    for k,v in pairs(direction) do
        Object.arrowTargets[v] = Scene:createGameObject("ArrowTarget")({board = {position=This:getSceneNode():getPosition():to(obe.Units.ViewPercentage), size=This:LevelSprite():getSize():to(obe.Units.ViewPercentage)}, type=v});
    end
    --[[
    Scene:createLevelSprite("life_bar");
    local life_bar = Scene:getLevelSprite("life_bar");
    life_bar:load("Sprites/LevelSprites/Dance/life_bar.png");
    life_bar:useTextureSize();
    local pixel_life_bar = life_bar:getSize():to(ViewPixels);
    local percent_life_bar = life_bar:getSize():to(ViewPercentage);
    local percent_2px = 2*percent_life_bar/pixel_life_bar
    life_bar:setPosition(Scene:getCamera():getPosition(Core.Transform.Referencial.TopLeft), Core.Transform.Referencial.TopLeft);

    Scene:createLevelSprite("life");
    Object.life = Scene:getLevelSprite("life");
    Object.life:load("Sprites/LevelSprites/Dance/life.png");
    Object.life:useTextureSize();
    local pSprite = fear_sprite:getPosition(Core.Transform.Referencial.TopLeft) + Core.Transform.UnitVector(2, 2, Core.Transform.Units.WorldPixels); 
    Object.life:setPosition(pSprite, Core.Transform.Referencial.TopLeft);
    Object.origin_life_size = Object.life:getSize();
    ]]
end

function Object:getSize()
    return This:LevelSprite():getSize():to(obe.Units.ViewPercentage)
end

function Object:getPosition()
    return This:getSceneNode():getPosition():to(obe.Units.ViewPercentage)
end