module LoginModule
    def login(user)
        visit login_path
        fill_in 'Email', with: user.email
        fill_in 'Password', with: 'example'
        click_button 'Login'
    end

    def logout(user)
        visit root_path
        click_on 'Logout'
    end
end