local astarpath = obe.Path("Data/GameObjects/Grid/a-star.lua"):find():gsub(".lua", "");
local astar = require(astarpath);

function Local.Init(colliderId)
    local collider = Scene:getCollider(colliderId);
    local bbox = collider:getBoundingBox();
    local bboxpx = bbox:getSize():to(obe.Units.ScenePixels);
    Object.grid = {};
    Object.foundPath = {};
    Object.canvas = obe.Canvas.Canvas(math.floor(bboxpx.x), math.floor(bboxpx.y));
    Object.canvas:setTarget(This:LevelSprite());
    This:LevelSprite():setPosition(bbox:getPosition());
    This:LevelSprite():setSize(bbox:getSize());
    --[[Object.canvas:Rectangle("background")({
        x = 0, y = 0, width = bboxpx.x, height = bboxpx.y,
        color = {
            r = 255,
            g = 0,
            b = 0,
            a = 50
        }
    });]]--
    Object.gridSize = 50;
    Object.cellWidth = obe.UnitVector(1 / Object.gridSize, 0, obe.Units.ViewPercentage).x;
    Object.cellHeight = obe.UnitVector(0, 1 / Object.gridSize).x;
    Object.endNode = {
        shape = Object.canvas:Rectangle("end")({
            x = 0, y = 0, width = 1 / Object.gridSize, height = 1 / Object.gridSize, unit = obe.Units.ViewPercentage,
            color = {
                r = 255,
                g = 0,
                b = 0,
                a = 255
            }, visible = false
        }),
        node = nil
    };
    for x = 0, Object.gridSize do
        for y = 0, Object.gridSize do
            table.insert(Object.grid, { x = x, y = y });
        end
    end
    for x = 0, Object.gridSize do
        Object.canvas:Line("column_" .. tostring(x))({
            p1 = { x = x / Object.gridSize, y = 0, color = "#FFFFFF", unit = obe.Units.ViewPercentage },
            p2 = { x = x / Object.gridSize, y = 1, color = "#FFFFFF", unit = obe.Units.ViewPercentage },
            thickness = 1,
            layer = 1
        });
    end
    for y = 0, Object.gridSize do
        Object.canvas:Line("row_" .. tostring(y))({
            p1 = { x = 0, y = y / Object.gridSize, color = "#FFFFFF", unit = obe.Units.ViewPercentage },
            p2 = { x = 1, y = y / Object.gridSize, color = "#FFFFFF", unit = obe.Units.ViewPercentage },
            thickness = 1,
            layer = 1
        });
    end
    Object.smode = 0;
    Object.cursor = Object.canvas:Rectangle("cursor")({
        x = 0, y = 0, width = 1 / Object.gridSize, height = 1 / Object.gridSize, unit = obe.Units.ViewPercentage,
        color = {
            r = 0,
            g = 255,
            b = 255,
            a = 255
        }
    });
    Object.path = false;
    This:LevelSprite():setVisible(false);
end

function getNode(x, y)
    for _, v in pairs(Object.grid) do
        if v.x == x and v.y == y then
            return v;
        end
    end
    return nil;
end

function Global.Cursor.Move(x, y)
    Object.cursor.x = math.floor((x / obe.Screen.Width) / (1 / Object.gridSize)) / Object.gridSize;
    Object.cursor.y = math.floor((y / obe.Screen.Height) / (1 / Object.gridSize)) / Object.gridSize;
end

function calculatePath()
    local pp = Scene:getGameObject(Scene:getGameObject("spy_manager").follow_id).collider:getCentroid():to(obe.Units.ViewPercentage);
    print(pp.x, pp.y);
    local gx = math.floor(pp.x / (1 / Object.gridSize));
    local gy = math.floor(pp.y / (1 / Object.gridSize));
    local start = getNode(gx, gy);
    --print("Path from", inspect(start), inspect(Object.endNode.node));
    --print(inspect(Object.grid))
    local path = astar.path(start, Object.endNode.node, Object.grid, function ( node, neighbor ) 
        return math.abs(node.x - neighbor.x) <= 1 and math.abs(node.y - neighbor.y) <= 1;
    end);
    if not path then
        print ("No valid path found");
    else
        for i = 1, #path - 1 do
            --print("Step " .. i .. " >> " .. path[i].x, path[i].y);
            table.insert(Object.foundPath, {
                x = path[i].x, y = path[i].y,
                line = Object.canvas:Line("path_" .. tostring(i))({
                    p1 = { 
                        x = path[i].x / Object.gridSize + (1 / (Object.gridSize * 2)), 
                        y = path[i].y / Object.gridSize + (1 / (Object.gridSize * 2)), 
                        color = "#FF00FF", unit = obe.Units.ViewPercentage 
                    },
                    p2 = { 
                        x = path[i + 1].x / Object.gridSize + (1 / (Object.gridSize * 2)), 
                        y = path[i + 1].y / Object.gridSize + (1 / (Object.gridSize * 2)), 
                        color = "#FF00FF", unit = obe.Units.ViewPercentage 
                    },
                    thickness = 1,
                    layer = 1
                });
            });
            --print(path[i].x / Object.gridSize, path[i].y / Object.gridSize);
        end
    end
    Object.path = {
        path = path,
        index = 1
    }
end

function Global.Actions.Click()
    if Scene:getGameObject("spy_manager").follow_id ~= "" then
        print("Click !");
        local x = Cursor:getX();
        local y = Cursor:getY();
        local gx = math.floor((x / obe.Screen.Width) / (1 / Object.gridSize));
        local gy = math.floor((y / obe.Screen.Height) / (1 / Object.gridSize));
        if Object.smode == 0 then
            Object.cursor.color = "#00FFFF";
            Object.smode = 1;
            Object.endNode.node = getNode(gx, gy);
            Object.endNode.shape.visible = true;
            Object.endNode.shape.x = gx / Object.gridSize;
            Object.endNode.shape.y = gy / Object.gridSize;
            Object.cursor.visible = false;
            calculatePath();
        elseif Object.smode == 1 then
            Object.smode = 0;
            Object.cursor.visible = true;
            Object.endNode.shape.visible = false;
            for _, v in pairs(Object.foundPath) do
                print("Removing", inspect(v));
                Object.canvas:remove(v.line.id);
            end
            Object.foundPath = {};
            Object.path = {};
        end
    end
end

function Global.Game.Render()
    Object.canvas:render();
end