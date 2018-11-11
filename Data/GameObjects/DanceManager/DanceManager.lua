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

    Object.test = 0;
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
    if Object.test == 0 then
        local r = math.random(1,4);
        for k,v in pairs(Object.boards) do
            table.insert(Object.arrows[k][direction[r]], Scene:createGameObject("Arrow")({board = v, type=direction[r]}));
        end
        
    end

    Object.test = (Object.test + 1)%80;
end

function check(pos, type)
    local tolerance = 0.05
    --for k,v in pairs() do
        local targetPos = Object.boards[pos].arrowTargets[type].getPosition()
        if #Object.arrows[pos][type] > 0 then
            local arrowPos = Object.arrows[pos][type][1].getPosition()
            if targetPos.y - tolerance <= arrowPos.y and arrowPos.y <= targetPos.y + tolerance  then
                print("yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyVICTORY",arrowPos.y,pos,type,targetPos.y);
                Object.boards[pos].success();
                Object.arrows[pos][type][1].delete();
                table.remove(Object.arrows[pos][type], 1);
            else
                Object.boards[pos].fail();
                print("yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyLOSER",arrowPos.y,pos,type,targetPos.y);
            end
        else
            Object.boards[pos].fail();
            print("yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyLOSER");
        end
    --end
end

function LUpPressed()
    check("Left", "Up");
end

function LRightPressed()
    check("Left", "Right");
end

function LDownPressed()
    check("Left", "Down");
end

function LLeftPressed()
    check("Left", "Left");
end

function RUpPressed()
    check("Right", "Up");
end

function RRightPressed()
    check("Right", "Right");
end

function RDownPressed()
    check("Right", "Down");
end

function RLeftPressed()
    check("Right", "Left");
end