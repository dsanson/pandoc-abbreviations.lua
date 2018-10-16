local yaml_key = "abbreviations"
local defaults_slug = "abbreviations.yml"
local default_files = { defaults_slug, os.getenv("HOME") .. "/.pandoc/" .. defaults_slug }

local abbreviations = {}

local function deepcopy(o, seen)
  seen = seen or {}
  if o == nil then return nil end
  if seen[o] then return seen[o] end
  local no
  if type(o) == 'table' then
    no = {}
    seen[o] = no
    for k, v in next, o, nil do
      no[deepcopy(k, seen)] = deepcopy(v, seen)
    end
    setmetatable(no, deepcopy(getmetatable(o), seen))
  else -- number, string, boolean, etc
    no = o
  end
  return no
end

local function read_file(path)
    local file = io.open(path, "rb") -- r read mode and b binary mode
    if not file then return nil end
    local content = file:read "*a" -- *a or *all reads the whole file
    file:close()
    return content
end

local function read_meta(m)
    for k,v in pairs(m[yaml_key]) do
        if v.t == "MetaInlines" then
            abbreviations[k] = v
        end
    end
end

local function read_meta_file(path)
    local mf = read_file(path)
    if mf then
        local mf_meta = pandoc.read(mf, "markdown").meta
        read_meta(mf_meta)
    end
end

-- Specify abbreviations in yaml metadata:
--
-- abbreviations:
--    ex: 'First example'
--    ex2: 'Second **example**'

function get_vars (meta)
    read_meta(meta)
    -- now process default meta
    for _, f in pairs(default_files) do
        read_meta_file(f)
    end
end

function replace (elem)
  for k, v in pairs(abbreviations) do
      if elem.text == k then
        return v
      elseif string.find(elem.text, "^[%[%(]?" .. k .. "[%]%)]?%p?$") then
        local _, _, p1, p2 = string.find(elem.text, "^([%[%(]*)" .. k .. "([%]%)%p]*)$")
        local r = deepcopy(v)
        if p1  then
            table.insert(r,1,pandoc.Str(p1))
        end
        if p2  then
            table.insert(r,pandoc.Str(p2))
        end
        return r
      end
  end
end

return {{Meta = get_vars}, {Str = replace}}

