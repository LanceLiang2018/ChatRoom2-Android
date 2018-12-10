require "import"
import "android.widget.*"
import "android.view.*"
import "android.app.*"

import "config"
import "net"

--activity.setTheme(android.R.style.Theme_Holo_Light)
activity.setTheme(android.R.style.Theme_Holo)
activity.setTitle("Login")

layout_login = {
  LinearLayout;
  orientation="vertical";
  {
    LinearLayout;
    layout_width="fill";
    layout_margin="20px";
    gravity="center";
    {
      TextView;
      textSize="200px";
      text="Login";
    };
  };
  {
    LinearLayout;
    orientation="horizontal";
    layout_width="fill";
    gravity="center";
    layout_marginLeft="20px";
    {
      TextView;
      layout_width="0";
      text="Username: ";
      layout_weight="1";
    };
    {
      EditText;
      id="text_username";
      layout_width="0";
      layout_marginRight="20px";
      layout_weight="4";
      text="Lance";
    };
  };
  {
    LinearLayout;
    orientation="horizontal";
    layout_width="fill";
    gravity="center";
    layout_marginLeft="20px";
    {
      TextView;
      layout_width="0";
      text="Password: ";
      layout_weight="1";
    };
    {
      EditText;
      inputType="textPassword";
      layout_weight="4";
      layout_width="0";
      id="text_password";
      layout_marginRight="20px";
      text="1352040930lxr"
    };
  };
  {
    LinearLayout;
    layout_width="fill";
    layout_margin="20";
    orientation="horizontal";
    {
      Button;
      id="btn_login";
      layout_width="0";
      text="Login";
      layout_weight="1";
    };
    {
      Button;
      id="btn_signup";
      layout_width="0";
      text="Sign up";
      layout_weight="1";
    };
  };
};

function main(...)
  settings_load()
  activity.setTheme(config.theme)
  activity.setContentView(layout_login)
  btn_login.onClick = function()
    username = text_username.getText()
    password = text_password.getText()
    --dialog = ProgressDialog.show(this, "提示", "正在登陆中")
    --dialog.show()
    res = string.lower(wpost(urls.login, 
    {username, password}, {'username', 'password'}))
    --dialog.hide()
    if res == '' then
      print("Network Error.")
      return
    end
    if string.find(res, 'error') ~= nil then
      print("Error in usermane or password.")
      return
    end
    user.auth = res
    settings_save()
    activity.result{res}
  end
  btn_signup.onClick = function()
    activity.newActivity("signup")
  end
end

function onResult(name, ...)
  print(name, ...)
  --activity.result{name, ...}
end

function onKeyDown(code,event) 
  if string.find(tostring(event),"KEYCODE_BACK") ~= nil then 
    activity.result{"Failed"}
  end
end