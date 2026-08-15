-- Compact relative-date formatter, e.g. "11h", "1d", "4w", "3mo", "1y".
local function relative_date(epoch)
  epoch = tonumber(epoch)
  if not epoch then
    return "?"
  end

  local diff = os.time() - epoch
  if diff < 0 then
    diff = 0
  end

  local minutes = math.floor(diff / 60)
  if minutes < 1 then
    return diff .. "s"
  end

  local hours = math.floor(minutes / 60)
  if hours < 1 then
    return minutes .. "m"
  end

  local days = math.floor(hours / 24)
  if days < 1 then
    return hours .. "h"
  end

  local weeks = math.floor(days / 7)
  if weeks < 1 then
    return days .. "d"
  end

  local months = math.floor(days / 30)
  if months < 1 then
    return weeks .. "w"
  end

  local years = math.floor(days / 365)
  if years < 1 then
    return months .. "mo"
  end

  return years .. "y"
end

return relative_date
