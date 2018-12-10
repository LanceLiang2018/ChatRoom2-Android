require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"

--activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
--activity.setTheme(android.R.style.Theme_Holo)
--activity.setTheme(android.R.style.Theme_Holo_Light)
--activity.setTitle("Chat Room 2")

import "config"
import "net"
import "cjson"

layout_main = {
  LinearLayout;
  orientation="vertical";
  {
    ListView;
    layout_width="fill";
    layout_height="fill";
    id="list";
  };
};

item = {
  LinearLayout;
  layout_width="fill";
  layout_height="fill";
  gravity="center";
  {
    LinearLayout;
    layout_width="-1";
    orientation="horizontal";
    layout_height="180px";
    gravity="left";
    {
      TextView;
      layout_marginLeft="20px";
      text="标题内容";
      layout_gravity="center";
      textSize="80px";
      id="text";
      lines=1;
      ellipsize="end";
    };
  };
};

function main()
  --config.theme = android.R.style.Theme_Holo_Light
  --config.theme = android.R.style.Theme_Material
  --settings_save()
  settings_load()
  --print(config.host)

  activity.setTheme(config.theme)
  activity.setTitle("Chat Room 2")

  activity.setContentView(loadlayout(layout_main))
  if user.auth == '' then
    a = activity.newActivity('login')
  end

  --text.setText(user.auth)

  data = {}
  adp = LuaAdapter(activity, data, item)

  --[[
  for i = 1, 10 do
    adp.add{text='' .. i}
  end]]
  get_rooms()
  for i, v in ipairs(rooms) do
    adp.add{text=v.name}
  end


  list.Adapter = adp

  list.onItemClick=function(l,v,p,i)
    local str =v.Tag.text.Text
    --print(str)
    gid = room_data[str]
    activity.newActivity('room', {gid, str})
  end
end

function onResult(name, data)
  --name：返回的活动名称
  --...：返回的参数
  print("返回活动", name, data)
  if name == "login" then
    if data == "Failed" then
      --activity.newActivity("Login")
    else
      --print(data)
      user.auth = data
      settings_save()
      activity.recreate()
    end
  end
  if name == 'settings' then
    activity.recreate()
  end
end

function onCreateOptionsMenu(menu)
  menu.add("Login")
  menu.add("Sign up")
  menu.add("Settings")
  menu.add("New room")
  menu.add("join in room")
  menu.add("Clear All")
  menu.add("About")
end

function onOptionsItemSelected(item)
  title = item.Title
  if title == 'Login' then 
    activity.newActivity('login') end
  if title == 'Sign up' then
    activity.newActivity('signup') end
  if title == 'Settings' then
    activity.newActivity('settings') end
  if title == 'New room' then
    local edit = EditText()
    AlertDialog.Builder(activity)
    .setTitle("Set the room name:")
    .setView(edit)
    .setNegativeButton("Cancel", nil)
    .setPositiveButton("OK", function()
      name = edit.getText()
      res = wpost(urls.create_room, 
      {user.auth, name}, {"auth", "name"})
      print(res)
      activity.recreate()
    end)
    .show()
  end
  if title == 'About' then
    AlertDialog.Builder(activity)
    .setTitle("About")
    .setMessage([[About string.]])
    .setNegativeButton("OK", nil)
    .show()
  end
  if title == 'Clear All' then
    res = wpost(urls.clear_all, {}, {})
    print(res)
  end
  if title == "join in room" then
    local edit = EditText()
    AlertDialog.Builder(activity)
    .setTitle("Join in a room")
    .setMessage("The room id:")
    .setView(edit)
    .setNegativeButton("Cancel", nil)
    .setPositiveButton("OK", function()
      gid = edit.getText()
      res = wpost(urls.join_in, {user.auth, gid}, {"auth", "gid"})
      print(res)
    end)
    .show()
  end
end

参数=0
function onKeyDown(code,event) 
  if string.find(tostring(event),"KEYCODE_BACK") ~= nil then 
    if 参数+2 > tonumber(os.time()) then 
      activity.finish()
    else
      print("再按一次退出程序")
      参数=tonumber(os.time()) 
    end
    return true
  end
end

function get_rooms()
  res = wpost(urls.get_rooms, {user.auth, }, {"auth", })
  --print(res)
  room_data = {}
  rooms = cjson.decode(res)
  for i, v in ipairs(rooms) do
    room_data[v.name] = v.gid
  end
  return rooms
end
