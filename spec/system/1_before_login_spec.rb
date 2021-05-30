require 'rails_helper'

describe '[STEP1] ユーザログイン前のテスト' do
  describe 'トップ画面のテスト' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/'
      end
      it 'Guest Log inリンクが表示される: 左上から1番目のリンクが「ゲストログイン」である' do
        log_in_link = find_all('a')[1].native.inner_text
        expect(log_in_link).to match(/ゲストログイン/)
      end
      it 'Guest Log inリンクの内容が正しい' do
        expect(page).to have_link 'ゲストログイン', href: homes_guest_sign_in_path
      end
      it 'Log inリンクが表示される: 左上から2番目のリンクが「ログイン」である' do
        log_in_link = find_all('a')[2].native.inner_text
        expect(log_in_link).to match(/ログイン/)
      end
      it 'Log inリンクの内容が正しい' do
        expect(page).to have_link 'ログイン', href: new_user_session_path
      end
      it 'Sign Upリンクが表示される: 左上から2番目のリンクが「新規登録」である' do
        sign_up_link = find_all('a')[3].native.inner_text
        expect(sign_up_link).to match(/新規登録/i)
      end
      it 'Sign Upリンクの内容が正しい' do
        expect(page).to have_link '新規登録', href: new_user_registration_path
      end
      it 'お問い合わせリンクの内容が正しい' do
        expect(page).to have_link 'お問い合わせ', href: contact_path
      end
    end
  end

  describe 'ヘッダーのテスト: ログインしていない場合' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it 'タイトルが表示される' do
        expect(page).to have_content 'Wisdom'
      end
      it 'guest_loginリンクが表示される: 左上から1番目のリンクが「ゲストログイン」である' do
        guest_login_link = find_all('a')[1].native.inner_text
        expect(guest_login_link).to match(/ゲストログイン/i)
      end
      it 'loginリンクが表示される: 左上から2番目のリンクが「ログイン」である' do
        signup_link = find_all('a')[2].native.inner_text
        expect(signup_link).to match(/ログイン/i)
      end
      it 'sign up: 左上から3番目のリンクが「新規登録」である' do
        login_link = find_all('a')[3].native.inner_text
        expect(login_link).to match(/新規登録/i)
      end
    end

    context 'リンクの内容を確認' do
      subject { current_path }
      it 'ゲストログインを押すと、ゲストログイン画面に遷移する' do
        guest_login_link = find_all('a')[1].native.inner_text
        guest_login_link = guest_login_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link guest_login_link
        is_expected.to eq '/tweets'
      end
      it 'ログインを押すと、ログイン画面に遷移する' do
        login_link = find_all('a')[2].native.inner_text
        login_link = login_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link login_link
        is_expected.to eq '/users/sign_in'
      end
      it '新規登録を押すと、新規登録画面に遷移する' do
        signup_link = find_all('a')[3].native.inner_text
        signup_link = signup_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link signup_link
        is_expected.to eq '/users/sign_up'
      end
    end
  end

  describe 'ユーザ新規登録のテスト' do
    before do
      visit new_user_registration_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_up'
      end
      it '「新規登録」と表示される' do
        expect(page).to have_content '新規登録'
      end
      it 'nameフォームが表示される' do
        expect(page).to have_field 'user[name]'
      end
      it 'usernameフォームが表示される' do
        expect(page).to have_field 'user[username]'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'password_confirmationフォームが表示される' do
        expect(page).to have_field 'user[password_confirmation]'
      end
      it '新規登録ボタンが表示される' do
        expect(page).to have_button '新規登録'
      end
    end

    context '新規登録成功のテスト' do
      before do
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[username]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[email]', with: Faker::Internet.email
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
      end

      it '正しく新規登録される' do
        expect { click_button '新規登録' }.to change(User.all, :count).by(1)
      end
      it '新規登録後のリダイレクト先が、ツイート一覧画面になっている' do
        click_button '新規登録'
        expect(current_path).to eq '/tweets'
      end
    end
  end

  describe 'ユーザログイン' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_in'
      end
      it '「ログイン」と表示される' do
        expect(page).to have_content 'ログイン'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'ログインボタンが表示される' do
        expect(page).to have_button 'ログイン'
      end
    end

    context 'ログイン成功のテスト' do
      before do
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
      end

      it 'ログイン後のリダイレクト先が、ツイート一覧画面になっている' do
        expect(current_path).to eq '/tweets'
      end
    end

    context 'ログイン失敗のテスト' do
      before do
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        click_button 'ログイン'
      end

      it 'ログインに失敗し、ログイン画面にリダイレクトされる' do
        expect(current_path).to eq '/users/sign_in'
      end
    end
  end

  describe 'ヘッダーのテスト: ログインしている場合' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
      fill_in 'user[email]', with: Faker::Internet.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
    end

  end

  describe 'ユーザログアウトのテスト' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
      logout_link = find_all('a')[6].native.inner_text
      logout_link = logout_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
      click_link logout_link
    end

    context 'ログアウト機能のテスト' do
      it 'ログアウト後のリダイレクト先が、トップになっている' do
        expect(current_path).to eq '/'
      end
    end
  end
end
