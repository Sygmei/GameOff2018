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
end

function Local.Delete()
    Object.spyMusic:stop();
end