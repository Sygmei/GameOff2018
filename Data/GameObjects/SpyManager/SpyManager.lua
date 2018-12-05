function Local.Init()
    Object.amountOfNPC = 40;
    math.randomseed(os.time());
    local spyIndex = math.random(0, Object.amountOfNPC);
    print("Spy Index", spyIndex)
    for i = 0, Object.amountOfNPC do
        Scene:createGameObject("NPC")({ spy = i == spyIndex });
    end
    Object.follow_id = "";
    Object.spyMusic = obe.Music("Sounds/spy.ogg");
    Object.spyMusic:play();
    Object.spy_found = false;
    Object.chron_trig = false;
    Object.timer = obe.Chronometer();
    Object.timer:setLimit(6000);
    Object.didtry = false;
    Object.fails = 0;
end

function Global.Game.Update(dt)
    if Object.fails < 3 then
        if Object.spy_found and not Object.chron_trig then
            Object.timer:start();
            Object.chron_trig = true;
        end
        if Object.timer:limitExceeded() then
            Scene:loadFromFile("dance.map.vili");
        end
        Object.didtry = false;
    else
        local end_sprite = Scene:createLevelSprite("end_sprite");
        end_sprite:loadTexture("Sprites/LevelSprites/Dance/defeat.png");
        end_sprite:useTextureSize();
        end_sprite:setPosition(Scene:getCamera():getPosition(obe.Referential.Center), obe.Referential.Center);
    end
end

function Local.Delete()
    Object.spyMusic:stop();
end