local actions = {}

function actions.ast_live_grep_grep(_, options)
    options.__ACT_TO({
        resume = true,
        __resume_key = options.__resume_key,
    })
end

function actions.description(options)
    return options.fn_reload and "Grep AST" or "Fuzzy Search"
end

return actions
