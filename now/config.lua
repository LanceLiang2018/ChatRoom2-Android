require "import"
import "android.widget.*"
import "android.view.*"

import "cjson"

urls = {
  about = '/about';
  login = '/login';
  signup = '/signup';
  create_user = '/create_user';
  create_room = '/create_room';
  join_in = '/join_in';
  get_rooms = '/get_room_all';
  get_members = '/get_room_members';
  set_room_info = '/set_room_info';
  get_room_info = '/get_room_info';
  set_user = '/set_user';
  send_message = '/send_message';
  get_message = '/get_message';
  clear_all = '/clear_all';
};

user = {
  username = '';
  name = '';
  auth = '';
};

config = {
  host = "0.0.0.0";
  port = "8080";
  --host = "lanceliang2018.xyz:8088";
  --host = "107.173.80.101:8080";
  theme = android.R.style.Theme_Holo
};

function settings_load()
  --print(io.open(activity.getLuaDir()..'/config.json', 'w'))
  --dir = activity.getLuaDir()
  --print(io.open(dir .. '/config.json'):read("*a"))
  data = io.open(activity.getLuaDir()..'/config.json'):read('*a')
  config = cjson.decode(data)
  data = io.open(activity.getLuaDir()..'/user.json'):read('*a')
  user = cjson.decode(data)

end

function settings_save()
  data = cjson.encode(config)
  --print(data)
  io.open(activity.getLuaDir()..'/config.json', "w"):write(data):close()
  data = cjson.encode(user)
  io.open(activity.getLuaDir()..'/user.json', "w"):write(data):close()

end
