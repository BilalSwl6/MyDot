return {
    -- Python class snippet
    s("pyclass", fmt([[
    class {}:
        def __init__(self{}):
            {}

        def {}(self{}):
            {}
    ]], {
        i(1, "ClassName"),
        i(2),
        i(3, "pass"),
        i(4, "method"),
        i(5),
        i(6, "pass")
    })),

    -- Django model snippet
    s("djmodel", fmt([[
    from django.db import models

    class {}(models.Model):
        {} = models.{}Field({})

        def __str__(self):
            return {}
    ]], {
        i(1, "ModelName"),
        i(2, "field_name"),
        i(3, "Char"),
        i(4, "max_length=100"),
        f(function(args) return "self." .. args[2][1] end, {2})
    })),

    -- Quick print with formatting
    s("pf", fmt("print(f'{}')", {
        i(1)
    }))
}
