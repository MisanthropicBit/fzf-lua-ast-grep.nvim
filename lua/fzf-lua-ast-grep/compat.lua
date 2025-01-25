local compat = {}

---@param value string
---@return boolean
function compat.has(value)
    return vim.fn.has(value) == 1
end

if compat.has("nvim-0.10") then
    compat.islist = vim.islist
else
    ---@diagnostic disable-next-line: deprecated
    compat.islist = vim.tbl_islist
end

return compat
