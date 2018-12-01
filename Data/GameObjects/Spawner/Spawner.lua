function Local.Init()
    print("Hello, World!");
    Object.delay = 4;
    Object.timer = 0;
    Object.follow_id = "";
    for i = 0, 40 do
        Scene:createGameObject("NPC");
    end
end

function Global.Game.Update(dt)
    --[[Object.timer = Object.timer + dt;
    if Object.timer >= Object.delay then
        Object.timer = 0;
        Scene:createGameObject("NPC");
    end]]--
end

function Global.Actions.Click()
    Scene:getGameObject("npc_spawner").ok = true;
end