local React = require(script.Parent.Parent.React)
    local element = React.createElement

local RichTextModule = require(script.Module)

export type Props = {
    TextConfig: {[string]: any}?;
    Text: string;
}

return function(Props: Props)
    local RichTextObject, SetRichTextObject = React.useState(nil)
    local RootRef = React.useRef(nil)

    React.useEffect(function()
        local Root = RootRef.current

        if (not Root) then
            return
        end

        -- Refresh & create new object if modified.
        if (RichTextObject) then
            RichTextObject:Hide()
            RootRef:ClearAllChildren()
        end

        local Object = RichTextModule:New(Root, Props.Text, Props.TextConfig)
        Object:Animate(false)
        SetRichTextObject(Object)
    end, { Props.Text })

    return element("Frame", {
        BackgroundTransparency = 1;
        Size = UDim2.fromScale(1, 1);

        ref = RootRef;
    })
end
