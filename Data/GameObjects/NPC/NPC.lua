local TextureAtlas = {
    Down = { y = 0, length = 3 },
    Right = { y = 40, length = 3 },
    Top = { y = 80, length = 3 },
    Left = { y = 120, length = 3 },
};
local TextureSize = { width = 40, height = 40 };
local Orientation = { "Right", "Top", "Left", "Down" };
local AtlasFiles = {
    "a_recolor.png",
    "another_guy.png",
    "another_recolor.png",
    "girl_with_dress.png",
    "guy_with_hat.png",
    "lots_of_guys.png",
    "yet_another_guy.png",
}
Object.dialogues = {
	"Good day.",
    "Help enters in the back.",
    "…he isn’t even a member of the Harvard club!",
    "Yachts are so mundane by your third.",
    "Your suit looks store-bought.",
    "Pass the caviar, will you?",
    "Is there mustard on my tie?",
    "I can help double your yield.",
    "Did Linda just do a cartwheel?",
    "Clearly it’s a bull market and not a bear market.",
    "What are we fundraising for again? Children?",
    "And I said, ‘I don’t care whose donkey it is, just get it out of Johnson’s office!’",
    "The champagne tastes horrible this year.",
    "So much smaller this year."
}
Object.failDialogues = {
    "Um, okay?",
    "Huh.",
    "Had too much to drink?"
}
Object.successDialogues = {
    "Muahaha!",
    "Behold my Kremlin dance moves!",
    "The game has just begun, Agent!"
}

function Local.Init(spy)
    Object.spy = spy;
    local foundPos = false;
    This:Collider():addTag(obe.ColliderTagType.Rejected, "Character");
    This:Collider():addTag(obe.ColliderTagType.Rejected, "Door");
    This:Collider():addTag(obe.ColliderTagType.Rejected, "Scene");
    This:LevelSprite():move((This:LevelSprite():getSize() / 2) * -1);
    This:Collider():move((This:Collider():getBoundingBox():getSize() / 2) * -1);
    while not foundPos do
        local randx = (math.random() * 0.8) + 0.1;
        local randy = (math.random() * 0.8) + 0.1;
        This:getSceneNode():setPosition(obe.UnitVector(randx, randy, obe.Units.ViewPercentage));
        print("Trying", This:Collider():getCentroid().x, This:Collider():getCentroid().y);
        if not This:Collider():doesCollide(obe.UnitVector(0, 0)) then
            foundPos = true;
            print("NO COLLISION, OKAY")
        end
    end
    This:Collider():removeTag(obe.ColliderTagType.Rejected, "Scene");
    This:LevelSprite():loadTexture("Sprites/GameObjects/NPC/" .. AtlasFiles[math.random(1, #AtlasFiles)]);
    
    
    Object.collider = This:Collider();
    Object.direction = "Down";
    Object.animationTimer = 0;
    Object.animationDelay = 0.2;
    Object.animationIndex = 0;
    setTextureRect();
    Object.tNode = obe.TrajectoryNode(This:getSceneNode());
    Object.trajectory = Object.tNode:addTrajectory("Linear");
    Object.speed = 0.1;
    if spy then Object.speed = 0.15; end
    Object.trajectory
        :setAngle(math.random(0, 360))
        :setSpeed(Object.speed)
        :setAcceleration(0)
        :onCollide(Object.collide);
    Object.tNode:setProbe(This:Collider());
    Object.target = obe.UnitVector(This:getSceneNode():getPosition());
    Object.pop = {};
    Object.failed = false;
    Object.sound = nil;
    Object.angleInc = math.random() * 20;
end

function setTextureRect()
    This:LevelSprite():setTextureRect(TextureSize.width * Object.animationIndex, TextureAtlas[Object.direction].y, TextureSize.width, TextureSize.height);
end

function Object.collide()
    Object.trajectory:addAngle(180);
end

function Object:moveTo(pos)
    self.target = pos;
end

function round(x)
    return x >= 0 and math.floor(x+0.5) or math.ceil(x-0.5)
end

function UpdateAnimation(dt)
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
end

function Global.Game.Update(dt)
    Object.trajectory:addAngle(Object.angleInc * dt);
    if Scene:getGameObject("spy_manager").fails >= 3 and Object.spy then
        Object.trajectory:setSpeed(1);
        This:Collider():addTag(obe.ColliderTagType.Rejected, "Scene");
    end
    if Scene:getGameObject("spy_manager").follow_id ~= This:getId() then
        Object.tNode:update(dt);
    elseif Scene:getGameObject("grid").path then
        local path = Scene:getGameObject("grid").path;
        if path.index <= #path.path then
            local target = path.path[path.index];
            local cpos = Object.collider:getCentroid():to(obe.Units.ViewPercentage);
            local gx = math.floor(cpos.x / (1 / Scene:getGameObject("grid").gridSize));
            local gy = math.floor(cpos.y / (1 / Scene:getGameObject("grid").gridSize));
            local sensibility = 0.001;
            if math.abs(gx - target.x) < sensibility and math.abs(gy - target.y) < sensibility then
                path.index = path.index + 1;
                target = path.path[path.index];
            end
            local angle = obe.Math.atan2(gy - target.y, target.x - gx) * 180.0 / obe.Math.pi;
            Object.trajectory:setAngle(angle);
            Object.tNode:update(dt);
        end
    end
    local poppos = (This:LevelSprite():getPosition(obe.Referential.Top) - obe.UnitVector(0, 0.01)):to(obe.Units.ScenePixels);
    if math.random(1, math.floor(1000000 * dt)) == 1 and not Object.pop.text then
        Object.pop = Scene:getGameObject("dialog_pop"):pop(poppos.x, poppos.y, Object.dialogues[math.random(1, #Object.dialogues)]);
    end
    if Object.pop.text then
        Object.pop.text.x = poppos.x;
        Object.pop.text.y = poppos.y;
    end
    UpdateAnimation(dt);
end

function Global.Actions.Click()
    if not Scene:getGameObject("spy_manager").didtry then
        local poppos = (This:LevelSprite():getPosition(obe.Referential.Top) - obe.UnitVector(0, 0.01)):to(obe.Units.ScenePixels);
        if IsInCursor() and Object.spy then
            Scene:getGameObject("spy_manager").spy_found = true;
            if Object.pop.text then
                Object.pop.text.text = Object.successDialogues[math.random(1, #Object.successDialogues)];
            else
                Object.pop = Scene:getGameObject("dialog_pop"):pop(poppos.x, poppos.y, Object.successDialogues[math.random(1, #Object.successDialogues)]);
            end
            --[[Object.pop.text.color = {
                r = 0, g = 255, b = 0, a = 255
            }]]--
            This:LevelSprite():setColor(SFML.Color.Green);
            Scene:getGameObject("spy_manager").didtry = true;
            Object.sound = obe.Sound("Sounds/accusation.ogg");
            Object.sound:play();
        elseif IsInCursor() then
            if Object.pop.text then
                Object.pop.text.text = Object.failDialogues[math.random(1, #Object.failDialogues)];
            else
                Object.pop = Scene:getGameObject("dialog_pop"):pop(poppos.x, poppos.y, Object.failDialogues[math.random(1, #Object.failDialogues)]);
            end
            Object.failed = true;
            Object.sound = obe.Sound("Sounds/wrong_guess.ogg");
            Object.sound:play();
            Scene:getGameObject("spy_manager").didtry = true;
            Scene:getGameObject("spy_manager").fails = Scene:getGameObject("spy_manager").fails + 1;
        end
    end
end

function Follow()
    local cursorCollider = obe.PolygonalCollider("cursor");
    local cam = Scene:getCamera():getPosition(obe.Referential.TopLeft):to(obe.Units.ScenePixels);
    local cpoint = obe.UnitVector(Cursor:getX(), Cursor:getY(), obe.Units.ScenePixels);
    local col = This:Collider():getPosition():to(obe.Units.ScenePixels);
    --print(This:getId());
    --print("  Cursor", cpoint.x, cpoint.y);
    --print("  Camera", cam.x, cam.y);
    --print("  Collider", col.x, col.y);
    cursorCollider:addPoint(cpoint + cam);
    if Scene:getGameObject("spy_manager").ok and cursorCollider:doesCollide(This:Collider(), obe.UnitVector(0, 0)) then
        print("It's me", This:getId());
        Scene:getGameObject("spy_manager").follow_id = This:getId();
        Scene:getGameObject("spy_manager").ok = false;
    end
    collectgarbage()
    collectgarbage()
end

function IsInCursor()
    local pxbbox = This:Collider():getBoundingBox():getPosition():to(obe.Units.ScenePixels);
    local sxbbox = This:Collider():getBoundingBox():getSize():to(obe.Units.ScenePixels);
    pxbbox.x = pxbbox.x + (sxbbox.x / 4); 
    sxbbox.x = sxbbox.x - (sxbbox.x / 2); 
    pxbbox.y = pxbbox.y + (sxbbox.y / 4); 
    sxbbox.y = sxbbox.y - (sxbbox.y / 2); 
    return (Cursor:getX() > pxbbox.x and Cursor:getX() < pxbbox.x + sxbbox.x and Cursor:getY() > pxbbox.y and Cursor:getY() < pxbbox.y + sxbbox.y);
end

function Global.Game.Render()
    if not Scene:getGameObject("spy_manager").spy_found then
        if IsInCursor() or Object.failed then
            This:LevelSprite():setColor(SFML.Color.Red);
        else
            This:LevelSprite():setColor(SFML.Color.White);
        end
    end
    if Scene:getGameObject("spy_manager").follow_id == This:getId() then
        --Scene:getCamera():setPosition(This:LevelSprite():getPosition(obe.Referential.Center), obe.Referential.Center);
    end
end

function Local.Delete()
    if Scene:getGameObject("spy_manager").follow_id == This:getId() then
        Scene:getGameObject("spy_manager").follow_id = "";
    end
end