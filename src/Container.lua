local TableUtil = require(script.Parent.Parent.TableUtil)
    local Merge = TableUtil.Map.Merge
    local Map = TableUtil.Map.Map
local React = require(script.Parent.Parent.React)
    local useEffect = React.useEffect
    local element = React.createElement
    local useRef = React.useRef
local Spr = require(script.Parent.spr)

export type Props = {
    LayoutOrder: number;
    PositionY: number;
    Height: number;
    Fade: number;

    Element: React.Element<any>?;
    Props: any?;

    PositionFrequency: number?;
    FadeFrequency: number?;

    children: {React.Element<any>?};
}

return function(Props: Props)
    local RootRef = useRef(nil)

    local PositionFrequency = Props.PositionFrequency or 2
    local FadeFrequency = Props.FadeFrequency or 2
    local PositionY = Props.PositionY
    local Fade = Props.Fade

    useEffect(function()
        local Root = RootRef.current

        if (not Root) then
            return
        end

        Root.GroupTransparency = 1
        Root.Position = UDim2.fromScale(0, Props.PositionY);
    end, { true })

    useEffect(function()
        local Root = RootRef.current

        if (not Root) then
            return
        end

        Spr.target(Root, 1, PositionFrequency or 2, {
            Position = UDim2.fromScale(0, Props.PositionY);
        })
    end, {PositionY })

    useEffect(function()
        local Root = RootRef.current

        if (not Root) then
            return
        end

        Spr.target(Root, 1, FadeFrequency or 2, {
            GroupTransparency = Fade;
        })
    end, { Fade })

    return element("CanvasGroup", {
        BackgroundTransparency = 0.5;
        Size = UDim2.new(1, 0, Props.Height, 0);

        ref = RootRef;
    }, {
        Main = element(Props.Element, Merge(Props, Props.Props or {}));
    })
end
