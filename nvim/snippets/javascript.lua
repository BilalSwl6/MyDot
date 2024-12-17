return {
    -- Console log with variable name
    s("cl", fmt("console.log('{}:', {});", {
        f(function(args) 
            return args[1][1] 
        end, {1}),
        i(1)
    })),

    -- React functional component
    s("rfc", fmt([[
    import React from 'react';

    function {}({}) {{
        return (
            {}
        );
    }}

    export default {};
    ]], {
        i(1, "ComponentName"),
        i(2, ""),
        i(3, "<div></div>"),
        f(function(args) return args[1][1] end, {1})
    })),

    -- Quick async function
    s("async", fmt([[
    const {} = async ({}) => {{
        try {{
            {}
        }} catch (error) {{
            console.error(error);
        }}
    }};
    ]], {
        i(1, "functionName"),
        i(2, ""),
        i(3, "")
    }))
}
