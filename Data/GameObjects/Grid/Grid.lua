function Local.Init()
    Object.canvas = obe.Canvas.Canvas(obe.Screen.Width, obe.Screen.Height);
end

function Global.Editor.ColliderCreated(collider)
    print("Collider created : ", collider:getId());
    Object.canvas:
end