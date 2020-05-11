module SupportModule

  def fill_in_update_profile_form(name, email, password = "", confirmation = "")
    fill_in "Name",         with: name
    fill_in "Email",        with: email
    fill_in "Password",     with: password
    fill_in "Confirmation", with: confirmation
  end

  def success_messages(msg)
    expect(page).to have_css("div.alert.alert-success", text: msg)
  end

  def error_messages(msg = "")
    if msg.empty?
      should have_css('div.alert.alert-danger')
    else
      should have_css('div.alert.alert-danger', text: msg)
    end
  end
end