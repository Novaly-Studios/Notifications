local TableUtil = require(script.Parent.Parent.TableUtil)
    local Merge = TableUtil.Map.Merge
    local Map = TableUtil.Map.Map
local React = require(script.Parent.Parent.React)
    local useEffect = React.useEffect
    local element = React.createElement
    local useRef = React.useRef
local Spr = require(script.Parent.spr)

export type Props = {
    PositionFrequency: number?;
    FadeFrequency: number?;
    PositionY: number;
    FadeType: ("Canvas" | "Manual")?;
    Height: number;
    Width: number?;
    Fade: boolean;

    Element: React.Element<any>?;
    Props: any?;
}

return function(Props: Props)
    local RootRef = useRef(nil)

    local PositionFrequency = Props.PositionFrequency or 2
    local FadeFrequency = Props.FadeFrequency or 2
    local PositionY = Props.PositionY
    local FadeType = Props.FadeType or "Canvas"
    local Fade = Props.Fade

    useEffect(function()
        local Root = RootRef.current

        if (not Root) then
            return
        end

        if (FadeType == "Canvas") then
            Root.GroupTransparency = 1
        else
            for _, Item in Root:GetDescendants() do
                if (Item:IsA("ImageLabel")) then
                    Item:SetAttribute("OriginalImageTransparency", Item.ImageTransparency)
                    Item.ImageTransparency = 1
                end

                if (Item:IsA("TextLabel")) then
                    Item:SetAttribute("OriginalTextTransparency", Item.TextTransparency)
                    Item.TextTransparency = 1
                    Item:SetAttribute("OriginalTextStrokeTransparency", Item.TextStrokeTransparency)
                    Item.TextStrokeTransparency = 1
                end
            end
        end

        Root.Position = UDim2.fromScale(0.5, Props.PositionY);
    end, { true })

    useEffect(function()
        local Root = RootRef.current

        if (not Root) then
            return
        end

        Spr.target(Root, 1, PositionFrequency or 2, {
            Position = UDim2.fromScale(0.5, Props.PositionY);
        })
    end, { PositionY })

    useEffect(function()
        local Root = RootRef.current

        if (not Root) then
            return
        end

        if (FadeType == "Canvas") then
            Spr.target(Root, 1, FadeFrequency, {
                GroupTransparency = Fade and 1 or 0;
            })

            return
        end

        for _, Item in Root:GetDescendants() do
            if (Item:IsA("ImageLabel")) then
                Spr.target(Item, 1, FadeFrequency, {
                    ImageTransparency = Fade and 1 or Item:GetAttribute("OriginalImageTransparency");
                })

                continue
            end

            if (Item:IsA("TextLabel")) then
                Spr.target(Item, 1, FadeFrequency, {
                    TextTransparency = Fade and 1 or Item:GetAttribute("OriginalTextTransparency");
                })
                Spr.target(Item, 1, FadeFrequency * (Fade and 1.5 or 0.5), {
                    TextStrokeTransparency = Fade and 1 or Item:GetAttribute("OriginalTextStrokeTransparency");
                })

                continue
            end
        end
    end, { Fade })

    return element(FadeType == "Canvas" and "CanvasGroup" or "Frame", {
        BackgroundTransparency = 1;
        AnchorPoint = Vector2.new(0.5, 0);
        Size = UDim2.new(Props.Width or 1, 0, Props.Height, 0);

        ref = RootRef;
    }, {
        Main = element(Props.Element, Merge(Props, Props.Props or {}));
    })
end
