function Local.Init()
    print("Hello, World!");
    local spr = Scene:createLevelSprite("playbtn");
    spr:loadTexture("Sprites/LevelSprites/play_btn.png");
    spr:setSize(obe.UnitVector(0.5, 0.25));
    spr:setPosition(obe.UnitVector(0.5, 0.85, obe.Units.ViewPercentage), obe.Referential.Center);
    local col = Scene:createCollider("playbtn");
    col:addPoint(spr:getPosition());
    col:addPoint(spr:getPosition() + obe.UnitVector(spr:getSize().x, 0));
    col:addPoint(spr:getPosition() + spr:getSize());
    col:addPoint(spr:getPosition() + obe.UnitVector(0, spr:getSize().y));
    Object.btn = {
        spr = spr,
        col = col
    }
end

function Global.Cursor.Press()
    local cursorCollider = obe.PolygonalCollider("cursor");
    local cpoint = obe.UnitVector(Cursor:getX(), Cursor:getY(), obe.Units.ScenePixels);
    cursorCollider:addPoint(cpoint);
    if cursorCollider:doesCollide(Object.btn.col, obe.UnitVector(0, 0)) then
        Scene:loadFromFile("spy.map.vili");
    end
end