require "import"
import "android.widget.*"
import "android.view.*"
import "android.app.*"
import "java.io.File"

import "config"
import "net"
import "cjson"
import "http"

layout_room = {
  LinearLayout;
  gravity="bottom";
  orientation="vertical";
  --layout_height="fill";
  {
    LinearLayout;
    layout_height="fill";
    layout_width="fill";
    gravity="top";

    {
      ListView;
      layout_marginTop="160px";
      id="list";
      --layout_height="fill";
      layout_width="fill";
      DividerHeight="0";
      --fastScrollEnabled="true";
    };
  };
  {
    LinearLayout;
    gravity="right";
    layout_height="160px";
    layout_width="fill";
    {
      LinearLayout;
      layout_height="fill";
      layout_width="-1";
      gravity="left";
      {
        EditText;
        layout_width="fill";
        id="text";
        lines="1";
        layout_weight="1";
      };
      {
        Button;
        text="Send";
        layout_width="-1";
        id="btn_send";
        layout_weight="2";
      };
      {
        Button;
        text="More";
        layout_width="-1";
        id="btn_more";
        layout_weight="2";
      };

    };
  };
};



item = {
  LinearLayout;
  layout_width="fill";
  gravity="center";
  layout_height="fill";
  {
    LinearLayout;
    layout_margin="20px";
    gravity="left";
    layout_width="fill";
    orientation="horizontal";
    {
      LinearLayout;
      orientation="vertical";
      gravity="left";
      {
        TextView;
        text="Name";
        textColor="#66ccff";
        id="text_name";
        layout_width="120px";
        lines="1";
        ellipsize="end";
      };
      {
        ImageView;
        scaleType="fitXY";
        layout_height="120px";
        id="head";
        src="icon.png";
        layout_width="120px";
      };
    };
    {
      LinearLayout;
      layout_margin="20px";
      layout_width="fill";
      {
        TextView;
        text="Text";
        id="message";
        --textIsSelectable="true";
      };
    };
  };
};

function get_head(url)
  os.execute("mkdir " .. activity.getLuaDir() .. '/head')
  --print("url:", url)
  filename = url:match("https://s.gravatar.com/avatar/(.+)?") .. '.png'
  if File(activity.getLuaDir() .. '/head/' .. filename).exists() then
    return activity.getLuaDir() .. '/head/' .. filename
  end
  http.download(url, activity.getLuaDir() .. '/head/' .. filename)
  return activity.getLuaDir() .. '/head/' .. filename
end

function load_message()
  data = {}
  adp = LuaAdapter(activity, data, item)
  for i, v in ipairs(messages) do
    head_file = get_head(v.head)
    --print(head_file)
    adp.add{text_name=v.username, head=head_file, message=v.text}
  end
  list.Adapter = adp
end

function send_message(gid, message)
  res = wpost(urls.send_message, {gid, user.auth, message}, 
  {"gid", "auth", "text"})
  return res
end

function main(_gid, _room_name)
  gid = _gid
  room_name = _room_name
  --activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
  settings_load()
  activity.setTheme(config.theme)
  --activity.setTheme(android.R.style.Theme)
  activity.setContentView(layout_room)
  activity.setTitle(room_name)

  data = wpost(urls.get_message, 
  {tostring(user.auth), tostring(gid)}, 
  {"auth", "gid"})
  --print(data)
  js = cjson.decode(data)
  messages = js

  load_message()

  btn_send.onClick = function()
    m = tostring(text.getText())
    res = send_message(gid, m)
    if res == "Success." then
      print("Send " .. res)
      text.setText("")
    else print(res)
    end
    activity.recreate()
  end
end

function onCreateOptionsMenu(menu)
  menu.add("Members")
  menu.add("History")
  menu.add("Images")
  menu.add("Files")
  menu.add("Infomation")
  menu.add("Exit")
end

function onOptionsItemSelected(it)
  title = it.Title
  if title == "Members" then
    res = wpost(urls.get_members, {user.auth, gid}, {"auth", "gid"})
    members = cjson.decode(res)
    usernames = {}
    for i, v in ipairs(members) do
      table.insert(usernames, v.username)
      print(usernames[i])
    end
    AlertDialog.Builder(activity)
    .setTitle("Members")
    .setItems(usernames, {onClick=nil})
    .show()
  end
  if title == "History" then

  end
  if title == "Images" then

  end
  if title == "Files" then

  end
  if title == "Infomation" then
    res = wpost(urls.get_room_info, {user.auth, gid}, {"auth", "gid"})
    info = cjson.decode(res)
    display = {
      "GID: " .. info.gid,
      "Name " .. info.name,
      "Created at: " .. info.create_time,
      "Number of members: " .. tostring(info.member_number),
      "Last active time: " .. info.last_post_time,
    }
    AlertDialog.Builder(activity)
    .setItems(display, {onClick=nil})
    .setNegativeButton("Set infomation", {onClick=function()
        edit = EditText(activity)
        AlertDialog.Builder(activity)
        .setTitle("Set infomation")
        .setMessage("Set name:")
        .setView(edit)
        .setPositiveButton("OK", {onClick=function()
            local name = edit.getText()
            res = wpost(urls.set_room_info, {user.auth, gid, name}, {"auth", "gid", "name"})
            print(res)
          end})
        .show()
      end})
    .setPositiveButton("OK", nil)
    .show()
  end
  if title == "Exit" then
    AlertDialog.Builder(activity)
    .setMessage(
    [[Do you want to Exit from this room,
and remove your name from here?]])
    .setNegativeButton("Cancel", nil)
    .setPositiveButton("OK", function()
      print("TODO: Exit.")
    end)
    .show()
  end
end
