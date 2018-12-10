require "import"
import "android.widget.*"
import "android.view.*"
import "http"

import "config"

function translate(data, list)
  --[[for i, v in ipairs(data) do
    print(data[i]) end
  for i, v in ipairs(list) do
    print(list[i]) end]]
  res = ''
  start = true
  for i, v in ipairs(data) do
    if start ~= true then
      res = res .. '&'
    end
    res = res .. list[i] .. '=' .. tostring(data[i])
    start = false
  end
  return res
end

function wpost(target, data, list)
  settings_load()
  --[[
  if translate(data, list) == '' then
    body, cookie, code, headers = http.post(
    'http://' .. config.host .. ':' .. tostring(config.port) .. target)
  end
  ]]
  body, cookie, code, headers = http.post(
  'https://' .. config.host .. ':' .. tostring(config.port) .. target, translate(data, list))
  --print("NET::", 'http://' .. config.host .. ':' .. config.port .. target .. '?' .. translate(data, list))
  
  return body
end
