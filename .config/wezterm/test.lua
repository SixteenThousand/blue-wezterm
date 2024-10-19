local M = {}


M.LOG_FILE = os.getenv("HOME").."/temp/wezterm.log"


function M.write_log(opts)
    local fp = io.open(M.LOG_FILE,"a")
    if opts.multiline then fp:write("=>> multiline log START\n") end
    fp:write(string.format(
        "%s: %s | >>%s<<\n",
        os.date(),
        opts.msg,
        opts.var
    ))
    if opts.multiline then fp:write("<<= multiline log END\n") end
    fp:close()
end

-- just stringifies a table.
--     @param t: table = the table to be stringified
--     @param depth: int = the recursion depth of the print, i.e., the maximum 
--     level of nesting that will be shown. Defaults to infinity
function M.stringify(t, depth)
    if type(t) ~= "table" then
        return tostring(t)
    end
    if depth ~= nil then
        depth = depth - 1
    end
    local s = "{"
    for k,v in pairs(t) do
        s = s..string.format("\n%s = %s,",k,M.stringify(v,depth))
    end
    if #s > 1 then
        s = s.."\n"
    end
    s = s.."}"
    return s
end


return M
