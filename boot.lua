function Editor.Start()
    obe.PolygonalCollider.SetTagColor("Door", obe.Color.Red);
    obe.PolygonalCollider.SetTagColor("Character", obe.Color.Green);
end

function Game.Start()
    Scene:loadFromFile("menu.map.vili");
end