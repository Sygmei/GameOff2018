

position={"Left","Right"}
direction={"Left","Down","Right","Up"}

function Local.Init(two_player, music_path, bpm)
    Object.arrows = {};
    Object.boards = {};
    Object.two_player = two_player;
    for k,v in pairs(position) do
        Object.boards[v] = Scene:createGameObject("Board")({pos = v});
        Object.arrows[v] = {};
        for k2, v2 in pairs(direction) do
            Object.arrows[v][v2] = {};
        end
    end

    if Object.two_player then
        Global.Actions.LUpPressed = LUpPressed;
        Global.Actions.LRightPressed = LRightPressed;
        Global.Actions.LDownPressed = LDownPressed;
        Global.Actions.LLeftPressed = LLeftPressed;

        Global.Actions.LUpReleased = LUpReleased;
        Global.Actions.LRightReleased = LRightReleased;
        Global.Actions.LDownReleased = LDownReleased;
        Global.Actions.LLeftReleased = LLeftReleased;
    end

    Global.Actions.RUpPressed = RUpPressed;
    Global.Actions.RRightPressed = RRightPressed;
    Global.Actions.RDownPressed = RDownPressed;
    Global.Actions.RLeftPressed = RLeftPressed;        

    Global.Actions.RUpReleased = RUpReleased;
    Global.Actions.RRightReleased = RRightReleased;
    Global.Actions.RDownReleased = RDownReleased;
    Global.Actions.RLeftReleased = RLeftReleased;

    Object.arrowPressedBot = "";
    Object.flagEnd = false;
    Object.chronoReleaseBot = obe.Chronometer();
    Object.chronoReleaseBot:setLimit(math.floor(200));
    Object.tolerance = 0.07;
    Object.music = obe.Music(music_path);
    Object.bpm = bpm
    Object.timer = obe.TimeCheck(math.floor((60/Object.bpm)*1000),true);
    Object.music:play();
    Object.music:setVolume(60);
    Object.win = false
end

function Local.Delete()
    Object.music:stop();
end

function Global.Game.Update(dt)
    -- Delete Arrows out of bounds
    if Object.chronoReleaseBot:limitExceeded() then
        Object.chronoReleaseBot:stop();
        Object.boards["Left"].arrowTargets[Object.arrowPressedBot].shrink();
        Object.arrowPressedBot = "";
    end
    if Object.music:getStatus() == "Playing" and Object.music:getPlayingOffset():asSeconds() + 4*(60/Object.bpm) < Object.music:getDuration():asSeconds() then
        for k,v in pairs(Object.arrows) do
            for k2,v2 in pairs(v) do
                for k3, v3 in pairs (v2) do
                    if v3.checkOOB() then
                        Object.boards[k].fail();
                        v3.delete();
                        table.remove(v2, k3);
                    end
                    if not Object.two_player and k == "Left" then
                        local arrowType = k2;
                        local targetPos = Object.boards[k].arrowTargets[arrowType].getPosition();
                        local arrowPos = v3.getPosition();
                        if targetPos.y - 0.005 <= arrowPos.y and arrowPos.y <= targetPos.y + 0.005 then
                            local r = math.random(0,2);
                            if r ~= 0 then
                                Object.boards["Left"].arrowTargets[arrowType].grow();
                                check("Left", arrowType);
                                Object.arrowPressedBot = arrowType
                                Object.chronoReleaseBot:start();
                            end
                        end
                    end
                end
            end
        end
        if Object.timer:resetIfOver() then
            local r = math.random(1,4);
            for k,v in pairs(Object.boards) do
                table.insert(Object.arrows[k][direction[r]], Scene:createGameObject("Arrow")({board = v, type=direction[r], bpm=Object.bpm}));
            end
            
        end
    elseif not Object.flagEnd and Object.music:getStatus() == "Stopped" then
        Object.flagEnd = true;
        Scene:createLevelSprite("end_sprite");
        local end_sprite = Scene:getLevelSprite("end_sprite"); 
        local leftCount = Object.boards["Left"].getCounter();
        local rightCount = Object.boards["Right"].getCounter();
        local leftLife = Object.boards["Left"].getLife();
        local rightLife = Object.boards["Right"].getLife();       
        if ( leftCount ==  rightCount and leftLife < rightLife ) or ( leftCount < rightCount ) then
            end_sprite:loadTexture("Sprites/LevelSprites/Dance/victory.png");
            Object.win = true;
        else
            end_sprite:loadTexture("Sprites/LevelSprites/Dance/defeat.png");
        end
        end_sprite:useTextureSize();
        end_sprite:setPosition(Scene:getCamera():getPosition(obe.Referential.Center), obe.Referential.Center);
    end
end

function check(pos, type)
    local targetPos = Object.boards[pos].arrowTargets[type].getPosition();
    if #Object.arrows[pos][type] > 0 then
        local arrowPos = Object.arrows[pos][type][1].getPosition();
        if targetPos.y - Object.tolerance <= arrowPos.y and arrowPos.y <= targetPos.y + Object.tolerance  then
            Object.boards[pos].success();
            Object.arrows[pos][type][1].delete();
            table.remove(Object.arrows[pos][type], 1);
        else
            Object.boards[pos].fail();
        end
    else
        Object.boards[pos].fail();
    end
end

function LUpPressed()
    if not Object.flagEnd then
        Object.boards["Left"].arrowTargets["Up"].grow();
        check("Left", "Up");
    end
end

function LRightPressed()
    if not Object.flagEnd then
        Object.boards["Left"].arrowTargets["Right"].grow();
        check("Left", "Right");
    end
end

function LDownPressed()
    if not Object.flagEnd then
        Object.boards["Left"].arrowTargets["Down"].grow();
        check("Left", "Down");
    end
end

function LLeftPressed()
    if not Object.flagEnd then
        Object.boards["Left"].arrowTargets["Left"].grow();
        check("Left", "Left");
    end
end

function RUpPressed()
    if not Object.flagEnd then
        Object.boards["Right"].arrowTargets["Up"].grow();
        check("Right", "Up");
    end
end

function RRightPressed()
    if not Object.flagEnd then
        Object.boards["Right"].arrowTargets["Right"].grow();
        check("Right", "Right");
    end
end

function RDownPressed()
    if not Object.flagEnd then
        Object.boards["Right"].arrowTargets["Down"].grow();
        check("Right", "Down");
    end
end

function RLeftPressed()
    if not Object.flagEnd then
        Object.boards["Right"].arrowTargets["Left"].grow();
        check("Right", "Left");
    end
end



function LUpReleased()
    Object.boards["Left"].arrowTargets["Up"].shrink();
end

function LRightReleased()
    Object.boards["Left"].arrowTargets["Right"].shrink();
end

function LDownReleased()
    Object.boards["Left"].arrowTargets["Down"].shrink();
end

function LLeftReleased()
    Object.boards["Left"].arrowTargets["Left"].shrink();
end

function RUpReleased()
    Object.boards["Right"].arrowTargets["Up"].shrink();
end

function RRightReleased()
    Object.boards["Right"].arrowTargets["Right"].shrink();
end

function RDownReleased()
    Object.boards["Right"].arrowTargets["Down"].shrink();
end

function RLeftReleased()
    Object.boards["Right"].arrowTargets["Left"].shrink();
end