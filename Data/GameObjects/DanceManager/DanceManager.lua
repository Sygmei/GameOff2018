

position={"Left","Right"}
direction={"Left","Down","Right","Up"}

function Local.Init()
    Object.arrows = {};
    Object.boards = {};
    for k,v in pairs(position) do
        Object.boards[v] = Scene:createGameObject("Board")({pos = v});
        Object.arrows[v] = {};
        for k2, v2 in pairs(direction) do
            Object.arrows[v][v2] = {};
        end
    end

    Global.Actions.LUpPressed = LUpPressed;
    Global.Actions.LRightPressed = LRightPressed;
    Global.Actions.LDownPressed = LDownPressed;
    Global.Actions.LLeftPressed = LLeftPressed;

    Global.Actions.RUpPressed = RUpPressed;
    Global.Actions.RRightPressed = RRightPressed;
    Global.Actions.RDownPressed = RDownPressed;
    Global.Actions.RLeftPressed = RLeftPressed;

    Global.Actions.LUpReleased = LUpReleased;
    Global.Actions.LRightReleased = LRightReleased;
    Global.Actions.LDownReleased = LDownReleased;
    Global.Actions.LLeftReleased = LLeftReleased;

    Global.Actions.RUpReleased = RUpReleased;
    Global.Actions.RRightReleased = RRightReleased;
    Global.Actions.RDownReleased = RDownReleased;
    Global.Actions.RLeftReleased = RLeftReleased;

    Object.music = obe.Music("Sounds/I_Spot_a_Spy_With_My_Little_Eye.ogg");
    Object.previousFrameTime = 0;
    Object.lastReportedPlayheadPosition = 0;
    Object.bpm = 90
    Object.timer = obe.TimeCheck(math.floor((60/Object.bpm)*1000),true);
    Object.music:play();
    Object.music:setVolume(60);
    
end

function Global.Game.Update(dt)
    -- Delete Arrows out of bounds
    
    for k,v in pairs(Object.arrows) do
        for k2,v2 in pairs(v) do
            for k3, v3 in pairs (v2) do
                if v3.checkOOB() then
                    Object.boards[k].fail();
                    v3.delete();
                    table.remove(v2, k3);
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
    
end

function check(pos, type)
    local tolerance = 0.08
    local targetPos = Object.boards[pos].arrowTargets[type].getPosition()
    if #Object.arrows[pos][type] > 0 then
        local arrowPos = Object.arrows[pos][type][1].getPosition()
        if targetPos.y - tolerance <= arrowPos.y and arrowPos.y <= targetPos.y + tolerance  then
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
    Object.boards["Left"].arrowTargets["Up"].grow();
    check("Left", "Up");
end

function LRightPressed()
    Object.boards["Left"].arrowTargets["Right"].grow();
    check("Left", "Right");
end

function LDownPressed()
    Object.boards["Left"].arrowTargets["Down"].grow();
    check("Left", "Down");
end

function LLeftPressed()
    Object.boards["Left"].arrowTargets["Left"].grow();
    check("Left", "Left");
end

function RUpPressed()
    Object.boards["Right"].arrowTargets["Up"].grow();
    check("Right", "Up");
end

function RRightPressed()
    Object.boards["Right"].arrowTargets["Right"].grow();
    check("Right", "Right");
end

function RDownPressed()
    Object.boards["Right"].arrowTargets["Down"].grow();
    check("Right", "Down");
end

function RLeftPressed()
    Object.boards["Right"].arrowTargets["Left"].grow();
    check("Right", "Left");
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