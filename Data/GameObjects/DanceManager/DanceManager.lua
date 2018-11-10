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
    --print("test");
    -- Delete Arrows out of bounds
    --print(inspect(Object.arrows))
    for k,v in pairs(Object.arrows) do
        for k2,v2 in pairs(v) do
            for k3, v3 in pairs (v2) do
                --print("test6");
                if v3.checkOOB() then
                    --print("test5");
                    v3.delete();
                    table.remove(v2, k3);
                end
            end
        end
    end
    --print("test2");
    --print(inspect(Object.arrows))
    if Object.test == 0 then
        --print("test3");
        for k,v in pairs(Object.boards) do
            --print("test4");
            local r = math.random(1,4);
            table.insert(Object.arrows[k][direction[r]], Scene:createGameObject("Arrow")({board = {position=v.getPosition(), size=v.getSize()}, type=direction[r]}));
        end
        
    end
    --print("test7");

    Object.test = (Object.test + 1)%50;
    --print("test8");
    --print(__ENV_ID);
    --print("test9");
end

function check(pos, type)
    local perfect = 0.1;
    local good = 0.15;
    local ok = 0.2;
    for k,v in pairs(Object.arrows[pos][type]) do
        if v.getPosition().y <= Object.boards[pos].arrowTargets[type].getPosition().y  then
            --v.delete();
            print("yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyVICTORY",v.getPosition().y,pos,type,Object.boards[pos].arrowTargets[type].getPosition().y);
        else
            print("yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyLOSER",v.getPosition().y,pos,type,Object.boards[pos].arrowTargets[type].getPosition().y);
        end
    end
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