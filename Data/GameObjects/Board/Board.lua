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

    Object.life = 100
    Object.minLife = 0
    Object.maxLife = 200
    --[[
    Scene:createLevelSprite("life_bar");
    local life_bar = Scene:getLevelSprite("life_bar");
    life_bar:load("Sprites/LevelSprites/Dance/life_bar.png");
    life_bar:useTextureSize();
    local pixel_life_bar = life_bar:getSize():to(ViewPixels);
    local percent_life_bar = life_bar:getSize():to(ViewPercentage);
    local percent_2px = 2*percent_life_bar/pixel_life_bar
    life_bar:setPosition(Scene:getCamera():getPosition(Core.Transform.Referencial.TopLeft), Core.Transform.Referencial.TopLeft);
    ]]
    Scene:createLevelSprite("life_sprite_"..pos);
    Object.life_sprite = Scene:getLevelSprite("life_sprite_"..pos);
    Object.life_sprite:loadTexture("Sprites/LevelSprites/Dance/life_bar.png");
    Object.life_sprite_max_size = obe.UnitVector(This:LevelSprite():getSize():to(obe.Units.ViewPercentage).x, 0.05 , obe.Units.ViewPercentage);
    Object.life_sprite:setSize(obe.UnitVector(Object.life_sprite_max_size.x*(Object.life/Object.maxLife), Object.life_sprite_max_size.y, obe.Units.ViewPercentage));
    --local pSprite = fear_sprite:getPosition(Core.Transform.Referencial.TopLeft);-- + Core.Transform.UnitVector(2, 2, Core.Transform.Units.WorldPixels); 
    Object.life_sprite:setPosition(obe.UnitVector(Object.posX, Object.posY-0.05, obe.Units.ViewPercentage));
    
end

function Object:getSize()
    return This:LevelSprite():getSize():to(obe.Units.ViewPercentage)
end

function Object:getPosition()
    return This:getSceneNode():getPosition():to(obe.Units.ViewPercentage)
end

function Object:fail()
    Object.life = Object.life - 5;
    if Object.life < Object.minLife then
        Object.life = Object.minLife;
    end
    Object.life_sprite:setSize(obe.UnitVector(Object.life_sprite_max_size.x*(Object.life/Object.maxLife), Object.life_sprite_max_size.y, obe.Units.ViewPercentage));
end

function Object:success()
    Object.life = Object.life + 5;
    if Object.life > Object.maxLife then
        Object.life = Object.maxLife;
    end
    Object.life_sprite:setSize(obe.UnitVector(Object.life_sprite_max_size.x*(Object.life/Object.maxLife), Object.life_sprite_max_size.y, obe.Units.ViewPercentage));
end