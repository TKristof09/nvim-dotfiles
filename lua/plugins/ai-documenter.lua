return {
    {
        dir = "~/ai-documenter",
        opts = {
            api_key = require("secrets").gemini_api_key
        },
        config = true,
        lazy = true,
        event = "VeryLazy"
    }
}
