function Local.Init()
    print("Hello, World!");
    Object.delay = 0.5;
    Object.timer = 0;
end

function Global.Game.Update(dt)
    Object.timer = Object.timer + dt;
    if Object.timer >= Object.delay then
        Object.timer = 0;
        Scene:createGameObject("NPC");
    end
end