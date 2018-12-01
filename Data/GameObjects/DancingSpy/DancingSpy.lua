function Local.Init()
    This:Animator():setKey("DANCE");
    This:LevelSprite():setPosition(obe.UnitVector(0.67, 0.77));
    Object.tNode = obe.TrajectoryNode(This:getSceneNode());
    Object.trajectory = Object.tNode:addTrajectory("Linear");
    Object.trajectory
        :setAngle(0)
        :setSpeed(0)
        :setAcceleration(0);
end

function Global.Game.Update(dt)
    if Scene:getGameObject("danceManager").flagEnd then
        if Scene:getGameObject("danceManager").win then
            This:Animator():setKey("DEAD");
            Object.trajectory:setAngle(90);
        end
        Object.trajectory:setSpeed(1);
    end
    Object.tNode:update(dt);
end