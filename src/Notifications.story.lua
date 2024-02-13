local ReplicatedFirst = game:GetService("ReplicatedFirst")
    local ReactRoblox = require(ReplicatedFirst:WaitForChild("ReactRoblox"))
    local TableUtil = require(ReplicatedFirst:WaitForChild("TableUtil"))
        local Merge = TableUtil.Map.Merge
    local React = require(ReplicatedFirst:WaitForChild("React"))
        local element = React.createElement

local Notifications = require(script.Parent.Controller)
local Container = require(script.Parent.Container)

local Text = require(script.Parent.RichText)

local function Test(Props)
    return element(Container, Merge({
        Element = Text;
    }, Props));
end

local Config = {
    ContainerHorizontalAlignment = "Center";
    ContainerVerticalAlignment = "Center";
    TextStrokeTransparency = 0.5;
    TextPlaybackSpeed = 0.1;
    TextColor3 = "White";
    TextScale = 1;
    Font = Enum.Font.FredokaOne;
}

local function Story(Target: Instance)
    local Element = element("Frame", {
        BackgroundTransparency = 1;
        Size = UDim2.fromScale(1, 1);
    }, {
        List = element(Notifications, {
            Additions = {
                [1] = {
                    Duration = Random.new():NextNumber() * 7;
                    Element = Test;
                    Props = {
                        BackgroundTransparency = 0.5;
                        TextConfig = Config;
                        Text = "11111";
                        Height = Random.new():NextNumber(0.05, 0.1);
                    };
                    ID = "Test1";
                };
                [2] = {
                    Duration = Random.new():NextNumber() * 7;
                    Element = Test;
                    Props = {
                        BackgroundTransparency = 0.5;
                        TextConfig = Config;
                        Text = "22222";
                        Height = Random.new():NextNumber(0.05, 0.1);
                    };
                    ID = "Test2";
                };
                [3] = {
                    Duration = Random.new():NextNumber() * 7;
                    Element = Test;
                    Props = {
                        BackgroundTransparency = 0.5;
                        TextConfig = Config;
                        Text = "33333";
                        Height = Random.new():NextNumber(0.05, 0.1);
                    };
                    ID = "Test3";
                };
                [4] = {
                    Duration = Random.new():NextNumber() * 7;
                    Element = Test;
                    Props = {
                        BackgroundTransparency = 0.5;
                        TextConfig = Config;
                        Text = "44444";
                        Height = Random.new():NextNumber(0.05, 0.1);
                    };
                    ID = "Test4";
                };
                [5] = {
                    Duration = Random.new():NextNumber() * 7;
                    Element = Test;
                    Props = {
                        BackgroundTransparency = 0.5;
                        TextConfig = Config;
                        Text = "55555";
                        Height = Random.new():NextNumber(0.05, 0.1);
                    };
                    ID = "Test5";
                };
                [6] = {
                    Duration = Random.new():NextNumber() * 7;
                    Element = Test;
                    Props = {
                        BackgroundTransparency = 0.5;
                        TextConfig = Config;
                        Text = "66666666";
                        Height = Random.new():NextNumber(0.05, 0.1);
                    };
                    ID = "Test6";
                };
            };
        })
    }); --

    local ReactRoot = ReactRoblox.createRoot(Target)
    ReactRoot:render(Element)

    return function()
        ReactRoot:unmount()
    end
end

return Story