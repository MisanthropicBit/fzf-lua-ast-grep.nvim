local utils = {}

---@param query string
---@return string
---@return string[]?
function utils.parse_additional_args(query)
    if not query or not query:find("%s%-%-") then
        return query, nil
    end

    if query:match("%s%-%-?$") then
        local sub, _ = query:gsub("%s%-%-?$", "")
        return sub, nil
    end

    local iter = vim.gsplit(query, "%s%-%-%s")
    local args, extra_args = iter(), iter()

    if not extra_args then
        return query, nil
    elseif #extra_args == 0 then
        ---@cast args -nil
        return args, nil
    end

    local parsed_extra_flags = {}

    for flag in vim.gsplit(extra_args, "%s+") do
        if flag:match("%-%-?[A-Za-z0-9-]+") then
            table.insert(parsed_extra_flags, flag)
        end
    end

    ---@cast args -nil
    return args, parsed_extra_flags
end

return utils
