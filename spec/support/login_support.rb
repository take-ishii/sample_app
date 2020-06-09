module LoginSupport
  def valid_login(user)
    visit root_path
    click_link "Log in"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"
  end
  
  def valid_remember_login(user)
    visit root_path
    click_link "Log in"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    check "Remember me on this computer"
    click_button "Log in"
  end  
end
