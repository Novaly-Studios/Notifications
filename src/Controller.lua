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
    local Additions = Props.Additions

    useEffect(function()
        for _, Addition in Additions do
            -- Initiate remove sequence.
            local function Remove()
                return Async.Spawn(function()
                    local FinishDuration = Addition.Duration or Props.DefaultDuration or DEFAULT_DURATION

                    Async.Delay(math.max(0, FinishDuration - FADE_TIME), function()
                        for Index, Value in Queue do
                            if (Value.ID == Addition.ID) then
                                Value.Props = Merge(Value.Props, {
                                    Fade = 1;
                                })
                                SetQueue(table.clone(Queue))
                            end
                        end
                    end)

                    Async.Delay(FinishDuration, function()
                        local Found: number

                        for Index, Value in Queue do
                            if (Value.ID == Addition.ID) then
                                Found = Index
                                break
                            end
                        end
        
                        table.remove(Queue, Found)
                        SetQueue(table.clone(Queue))
                    end)
                end)
            end

            -- Update existing element.
            for _, Value in Queue do
                if (Value.ID == Addition.ID) then
                    if (Value.Duration ~= Addition.Duration) then
                        -- Cancel last removal if duration is updated.
                        local Thread = Value.Thread

                        if (Thread) then
                            pcall(Async.Cancel, Thread)
                        end

                        Value.Thread = Remove()
                    end

                    Value.Props = Merge(Value.Props, Addition.Props or {})
                    break
                end
            end

            -- Add new element.
            Addition = Merge(Addition, {
                Thread = Remove();
                Props = Merge(Addition.Props or {}, {
                    Fade = 0;
                });
            })
            table.insert(Queue, Addition)
        end

        SetQueue(table.clone(Queue))
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