require "import"
import "android.widget.*"
import "android.view.*"
import "android.app.*"

import "config"

layout_settings = {
  LinearLayout;
  orientation="vertical";
  {
    ListView;
    layout_width="fill";
    layout_height="fill";
    id="list";
  };
};

layout_items = {
  LinearLayout;
  orientation="vertical";
  {
    ListView;
    layout_width="fill";
    layout_height="fill";
    id="list_item";
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

settings = {
  "host",
  "port",
  "theme",
}

themes = {
  Material = android.R.style.Theme_Material;
  Material_Light = android.R.style.Theme_Material_Light;
  Holo = android.R.style.Theme_Holo;
  Holo_Light = android.R.style.Theme_Holo_Light;
  Default = android.R.style.Theme;

  "Material",
  "Material_Light",
  "Holo",
  "Holo_Light",
  "Default",
}

function main()
  settings_load()
  activity.setTheme(config.theme)
  activity.setContentView(loadlayout(layout_settings))
  activity.setTitle("Settings")

  --settings_load()
  --text_host.setText(config.host)

  data = {}
  adp = LuaAdapter(activity, data, item)

  for i, v in ipairs(settings) do
    adp.add{text=v}
  end

  list.Adapter = adp

  list.onItemClick = function(l,v,p,i)
    local str = v.Tag.text.Text
    --print(str)
    if str == 'host' then
      edit = EditText(activity).setText(config.host)
      AlertDialog.Builder(activity)
      .setTitle("Host Address")
      .setMessage("Set host address here:")
      .setView(edit)
      .setNegativeButton("取消",nil)
      .setPositiveButton("确定", {onClick = function()
          config.host = tostring(edit.getText())
          settings_save()
        end})
      .show()
    end
    if str == 'port' then
      edit = EditText(activity).setText(config.port)
      AlertDialog.Builder(activity)
      .setTitle("Host Address")
      .setMessage("Set port here:")
      .setView(edit)
      .setNegativeButton("取消",nil)
      .setPositiveButton("确定", {onClick = function()
          config.port = tostring(edit.getText())
          settings_save()
        end})
      .show()
    end
    --[[
    if str == 'theme' then
      local layout = loadlayout(layout_items)
      local data2 = {}
      adp2 = LuaAdapter(activity, data2, item)
      for i, v in ipairs(themes) do
        adp2.add{text=v}
      end
      chosen = ''
      list_item.Adapter = adp2
      list_item.onItemClick = function(l,v,p,i)
        chosen = tostring(v.Tag.text.Text)
        print("You choose " .. chosen)
      end
      AlertDialog.Builder(activity)
      .setTitle("Select theme")
      .setView(layout)
      .setNegativeButton("取消",nil)
      .setPositiveButton("确定", {onClick = function()
          if themes == '' then return end
          config.theme = themes[chosen]
          settings_save()
          print("Restart to apply")
          --activity.result{}
        end})
      .show()
    end]]
    if str == 'theme' then
      AlertDialog.Builder(activity)
      .setTitle("Select theme")
      .setItems(themes, {onClick=function(l, v)
          config.theme = themes[themes[v+1]]
          settings_save()
          print("Restart to apply")
        end})
      .show()
    end
  end
end
