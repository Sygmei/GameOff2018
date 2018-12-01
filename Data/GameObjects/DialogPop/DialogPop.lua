function Local.Init()
    Object.canvas = obe.Canvas.Canvas(obe.Screen.Width, obe.Screen.Height);
    Object.canvas:setTarget(This:LevelSprite());
    Object.texts = {};
    Object.index = 0;
    Object.duration = 6;
end

function Object:pop(x, y, text)
    print(x, y, text)
    Object.texts[self.index] = {
        text = self.canvas:Text(tostring(self.index))({
            x = x, y = y,
            align = {
                horizontal = "Center",
                vertical = "Center"
            },
            text = text, size = 22,
            font = "Data/Fonts/arial.ttf",
            layer = 0
        }),
        time = obe.TickSinceEpoch(),
        exists = true
    }
    self.index = self.index + 1;
    return self.texts[self.index - 1];
end

function Global.Game.Render()
    for k, v in pairs(Object.texts) do
        if v.text and obe.TickSinceEpoch() - v.time > Object.duration * 1000 then
            Object.canvas:remove(v.text.id);
            v.text = nil;
            v.exists = false;
        end
    end
    Object.canvas:render();
end