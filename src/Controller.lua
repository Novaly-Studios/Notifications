local TableUtil = require(script.Parent.Parent.TableUtil)
    local Merge = TableUtil.Map.Merge
local React = require(script.Parent.Parent.React)
    local useEffect = React.useEffect
    local useState = React.useState
    local element = React.createElement
local Async = require(script.Parent.Parent.Async)

export type Props = {
    PositionDirection: ("Up" | "Down")?;
    DefaultDuration: number?;
    Additions: {{
        Duration: number?;
        Element: React.Element<any>;
        Props: {[string]: any};
        ID: string;
    }};
}

local DEFAULT_DURATION = 5
local DEFAULT_HEIGHT = 0.1
local FADE_TIME = 0.5

return function(Props: Props)
    local Queue, SetQueue = useState({})
    local StateRef = React.useRef(nil)
    local Additions = Props.Additions
    StateRef.current = Queue

    useEffect(function()
        for _, Addition in Additions do
            -- Initiate remove sequence.
            local function Remove()
                return Async.Spawn(function()
                    local FinishDuration = Addition.Duration or Props.DefaultDuration or DEFAULT_DURATION

                    Async.Delay(math.max(0, FinishDuration - FADE_TIME), function()
                        local Modified = false

                        for Index, Value in StateRef.current do
                            if (Value.ID == Addition.ID) then
                                Value.Props = Merge(Value.Props, {
                                    Fade = true;
                                })

                                Modified = true
                                break
                            end
                        end

                        if (Modified) then
                            StateRef.current = table.clone(StateRef.current)
                            SetQueue(StateRef.current)
                        end
                    end)

                    Async.Delay(FinishDuration, function()
                        local Found: number

                        for Index, Value in StateRef.current do
                            if (Value.ID == Addition.ID) then
                                Found = Index
                                break
                            end
                        end

                        table.remove(StateRef.current, Found)
                        StateRef.current = table.clone(StateRef.current)
                        SetQueue(StateRef.current)
                    end)
                end)
            end

            -- Update existing element.
            local Found = false

            for _, Value in StateRef.current do
                if (Value.ID == Addition.ID) then
                    if (Addition.Duration) then
                        -- Cancel last removal if duration is updated.
                        local Thread = Value.Thread

                        if (Thread) then
                            pcall(Async.Cancel, Thread)
                        end

                        Value.Thread = Remove()
                    end

                    Value.Props = Merge(Value.Props, Addition.Props or {})
                    Found = true
                    break
                end
            end

            if (Found) then
                continue
            end

            -- Add new element.
            Addition = Merge(Addition, {
                Thread = Remove();
                Props = Merge(Addition.Props or {}, {
                    Fade = false;
                });
            })
            table.insert(StateRef.current, Addition)
        end

        StateRef.current = table.clone(StateRef.current)
        SetQueue(StateRef.current)
    end, { Additions })

    local ActualizedElements = {}
    local PositionDirection = Props.PositionDirection or "Down"
    local YAccumulation = 0

    for Index, Data in Queue do
        local Height = Data.Props.Height or DEFAULT_HEIGHT

        ActualizedElements[Data.ID] = element(
            Data.Element,
            Merge(Data.Props, {
                LayoutOrder = Index;
                PositionY = (PositionDirection == "Up" and 1 - YAccumulation - Height or YAccumulation);
                Height = Height;
            })
        )

        YAccumulation += Height
    end

    return ActualizedElements
end