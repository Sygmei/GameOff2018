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
    Object.lifeCounter = 0

    Scene:createLevelSprite("life_sprite_"..pos);
    Object.life_sprite = Scene:getLevelSprite("life_sprite_"..pos);
    Object.life_sprite:loadTexture("Sprites/LevelSprites/Dance/life_bar.png");
    Object.life_sprite_max_size = obe.UnitVector(This:LevelSprite():getSize():to(obe.Units.ViewPercentage).x, 0.05 , obe.Units.ViewPercentage);
    Object.life_sprite:setSize(obe.UnitVector(Object.life_sprite_max_size.x*(Object.life/Object.maxLife), Object.life_sprite_max_size.y, obe.Units.ViewPercentage));
    Object.life_sprite:setPosition(obe.UnitVector(Object.posX, Object.posY-0.05, obe.Units.ViewPercentage));
    Object.life_sprite:setZDepth(2);

    Scene:createLevelSprite("canvas_sprite_"..pos);
    Object.canvas_sprite = Scene:getLevelSprite("canvas_sprite_"..pos); 
    Object.canvas_sprite:setSize(obe.UnitVector(obe.Screen.Width, obe.Screen.Height, obe.Units.ViewPixels));
    Object.canvas = obe.Canvas.Canvas(obe.Screen.Width, obe.Screen.Height);
    Object.canvas:setTarget(Object.canvas_sprite);

    Object.lifeCounterText = Object.canvas:Text("lifeCounterText")({
        x = Object.posX, y = Object.posY-0.05,
        unit = obe.Units.ViewPercentage,
        text = Object.lifeCounter, size = 60,
        font = "Data/Fonts/arial.ttf",
        layer = 0, align = { horizontal = "Left", vertical = "Bottom" }
    });

    Object.timer = obe.TimeCheck(200,true);

end

function Global.Game.Update()
    if Object.timer:resetIfOver() then
        if Object.life == Object.minLife then
            Object.lifeCounter = Object.lifeCounter - 1;
            Object.lifeCounterText.text = Object.lifeCounter;
            Object.canvas:render();
        elseif Object.life == Object.maxLife then
            Object.lifeCounter = Object.lifeCounter + 1;
            Object.lifeCounterText.text = Object.lifeCounter;
            Object.canvas:render();
        end
    end
end

function Global.Game.Render()
    Object.canvas:render();
end

function Object:getLife()
    return Object.life;
end

function Object:getCounter()
    return Object.lifeCounter;
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