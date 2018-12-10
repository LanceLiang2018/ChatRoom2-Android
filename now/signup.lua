require "import"
import "android.widget.*"
import "android.view.*"

import "config"
import "net"

activity.setTheme(android.R.style.Theme_Holo)
activity.setTitle("Sign up")

layout_signup = {
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
      text="Signup";
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
    orientation="horizontal";
    layout_width="fill";
    gravity="center";
    layout_marginLeft="20px";
    {
      TextView;
      layout_width="0";
      text="Nikelname: ";
      layout_weight="1";
    };
    {
      EditText;
      id="text_name";
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
      text="Email: ";
      layout_weight="1";
    };
    {
      EditText;
      id="text_email";
      layout_width="0";
      layout_marginRight="20px";
      layout_weight="4";
      text="LanceLiang2018@163.com";
    };
  };
  {
    LinearLayout;
    layout_width="fill";
    layout_margin="20";
    orientation="horizontal";
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
  
  activity.setContentView(layout_signup)
  btn_signup.onClick = function()
    username = text_username.getText()
    password = text_password.getText()
    name = text_name.getText()
    email = text_email.getText()
    res = string.lower(wpost(urls.signup, 
      {username, password, name, email}, 
      {'username', 'password', 'name', 'email'}))
    if res == '' then
      print("Network Error.")
      return
    end
    if string.find(res, 'error') ~= nil then
      print("Error in server. " .. res)
      return
    end
    activity.result{res}
  end
end