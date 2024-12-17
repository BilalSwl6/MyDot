local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

return {
    -- Basic HTML5 boilerplate
    s("html5", fmt([[
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>{}</title>
        <link rel="stylesheet" href="{}">
    </head>
    <body>
        {}
        <script src="{}"></script>
    </body>
    </html>
    ]], {
        i(1, "Page Title"),
        i(2, "styles.css"),
        i(3, ""),
        i(4, "script.js")
    })),

    -- Tailwind container
    s("twcontainer", fmt([[
    <div class="container mx-auto px-4 {}">
        {}
    </div>
    ]], {
        i(1, ""),
        i(2, "")
    })),

    -- Quick div with Tailwind classes
    s("twdiv", fmt([[
    <div class="{}">{}</div>
    ]], {
        i(1, ""),
        i(2, "")
    }))
}
