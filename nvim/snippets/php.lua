return {
    -- Laravel controller method
    s("laracontroller", fmt([[
    public function {}({})
    {{
        {}
    }}
    ]], {
        i(1, "methodName"),
        i(2, "Request $request"),
        i(3, "// TODO: Implement method logic")
    })),

    -- PHP class with constructor
    s("phpclass", fmt([[
    class {}
    {{
        public function __construct({})
        {{
            {}
        }}

        {}
    }}
    ]], {
        i(1, "ClassName"),
        i(2),
        i(3, "// Constructor logic"),
        i(4, "// Additional methods")
    }))
}
