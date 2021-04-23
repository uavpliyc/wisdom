require 'rails_helper'

describe '[STEP3] 仕上げのテスト' do
  let(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:category) { create(:category) }
  let!(:comment) { create(:comment) }
  let!(:tweet) { create(:tweet, user: user, category: category) }
  let!(:other_tweet) { create(:tweet, user: other_user) }

  describe 'サクセスメッセージのテスト' do
    subject { page }

    it 'ユーザ新規登録成功時' do
      visit new_user_registration_path
      fill_in 'user[name]', with: Faker::Lorem.characters(number: 9)
      fill_in 'user[username]', with: Faker::Lorem.characters(number: 9)
      fill_in 'user[email]', with: 'a' + user.email # 確実にuser, other_userと違う文字列にするため
      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'password'
      click_button 'Sign up'
      is_expected.to have_content 'アカウント登録が完了しました'
    end
    it 'ユーザログイン成功時' do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'Log in'
      is_expected.to have_content 'ログインしました'
    end
    it 'ユーザログアウト成功時' do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'Log in'
      logout_link = find_all('a')[6].native.inner_text
      logout_link = logout_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
      click_link logout_link
      is_expected.to have_content 'ログアウトしました'
    end
    it 'ユーザのプロフィール情報更新成功時' do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'Log in'
      visit edit_user_registration_path
      fill_in 'user[current_password]', with: user.password
      click_button '更新する'
      is_expected.to have_content 'アカウント情報を変更しました'
    end
    it 'ツイートの新規投稿成功時' do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'Log in'
      visit tweets_path
      fill_in 'tweet[tweet]', with: Faker::Lorem.characters(number: 20)
      find("#tweet_category_id").find("option[value='1']").select_option
      click_button 'ツイート/下書きする'
      is_expected.to have_content 'ツイートをしました'
    end
    it 'ツイートの更新成功時' do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'Log in'
      visit edit_tweet_path(tweet)
      click_button 'ツイート/下書きする'
      is_expected.to have_content 'ツイートを更新しました'
    end
  end

  describe '処理失敗時のテスト' do
    context 'ユーザ新規登録失敗: nameを1文字にする' do
      before do
        visit new_user_registration_path
        @name = Faker::Lorem.characters(number: 1)
        @username = Faker::Lorem.characters(number: 5)
        @email = 'a' + user.email # 確実にuser, other_userと違う文字列にするため
        fill_in 'user[name]', with: @name
        fill_in 'user[username]', with: @username
        fill_in 'user[email]', with: @email
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
      end

      it '新規登録されない' do
        expect { click_button 'Sign up' }.not_to change(User.all, :count)
      end
      it '新規登録画面を表示しており、フォームの内容が正しい' do
        click_button 'Sign up'
        expect(page).to have_content 'Sign up'
        expect(page).to have_field 'user[name]', with: @name
        expect(page).to have_field 'user[username]', with: @username
        expect(page).to have_field 'user[email]', with: @email
      end
      it 'バリデーションエラーが表示される' do
        click_button 'Sign up'
        expect(page).to have_content "名前は2文字以上で入力してください"
      end
    end

    context 'ユーザのプロフィール情報編集失敗: nameを1文字にする' do
      before do
        @user_old_name = user.name
        @name = Faker::Lorem.characters(number: 1)
        visit new_user_session_path
        fill_in 'user[name]', with: @user_old_name
        fill_in 'user[username]', with: user.username
        fill_in 'user[password]', with: user.password
        click_button 'Log in'
        visit edit_user_registration_path
        fill_in 'user[name]', with: @name
        click_button '更新する'
      end

      it '更新されない' do
        expect(user.reload.name).to eq @user_old_name
      end
      it 'ユーザ編集画面を表示しており、フォームの内容が正しい' do
        expect(page).to have_field 'user[name]', with: @name
      end
      it 'バリデーションエラーが表示される' do
        expect(page).to have_content "名前は2文字以上で入力してください"
      end
    end

    context 'ツイートの新規投稿失敗: ツイートを空にする' do
      before do
        visit new_user_session_path
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'Log in'
        visit tweets_path
        find("#tweet_category_id").find("option[value='1']").select_option
      end

      it 'ツイートが保存されない' do
        expect { click_button 'ツイート/下書きする' }.not_to change(Tweet.all, :count)
      end
      it 'ツイート一覧画面を表示している' do
        click_button 'ツイート/下書きする'
        expect(current_path).to eq '/tweets'
        expect(page).to have_content tweet.tweet
        expect(page).to have_content other_tweet.tweet
      end
      it '新規ツイートフォームの内容が正しい' do
        expect(find_field('tweet[tweet]').text).to be_blank
      end
      it 'バリデーションエラーが表示される' do
        click_button 'ツイート/下書きする'
        expect(page).to have_content "ツイートを入力してください"
      end
    end

    context 'ツイートの更新失敗: ツイートを空にする' do
      before do
        visit new_user_session_path
        fill_in 'user[name]', with: user.name
        fill_in 'user[username]', with: user.username
        fill_in 'user[password]', with: user.password
        click_button 'Log in'
        visit edit_tweet_path(tweet)
        @tweet_old_tweet = tweet.tweet
        fill_in 'tweet[tweet]', with: ''
        click_button 'ツイート/下書きする'
      end

      it 'ツイートが更新されない' do
        expect(tweet.reload.tweet).to eq @tweet_old_tweet
      end
      it 'ツイート編集画面を表示しており、フォームの内容が正しい' do
        expect(current_path).to eq '/tweets/' + tweet.id.to_s
        expect(find_field('tweet[tweet]').text).to be_blank
        expect(page).to have_field 'tweet[tweet]', with: tweet.tweet
      end
      it 'エラーメッセージが表示される' do
        expect(page).to have_content 'error'
      end
    end
  end

  # describe 'ログインしていない場合のアクセス制限のテスト: アクセスできず、ログイン画面に遷移する' do
  #   subject { current_path }

  #   it 'ユーザ一覧画面' do
  #     visit users_path
  #     is_expected.to eq '/users/sign_in'
  #   end
  #   it 'ユーザ詳細画面' do
  #     visit user_path(user)
  #     is_expected.to eq '/users/sign_in'
  #   end
  #   it 'ユーザ情報編集画面' do
  #     visit edit_user_path(user)
  #     is_expected.to eq '/users/sign_in'
  #   end
  #   it '投稿一覧画面' do
  #     visit books_path
  #     is_expected.to eq '/users/sign_in'
  #   end
  #   it '投稿詳細画面' do
  #     visit book_path(book)
  #     is_expected.to eq '/users/sign_in'
  #   end
  #   it '投稿編集画面' do
  #     visit edit_book_path(book)
  #     is_expected.to eq '/users/sign_in'
  #   end
  # end

  # describe '他人の画面のテスト' do
  #   before do
  #     visit new_user_session_path
  #     fill_in 'user[name]', with: user.name
  #     fill_in 'user[password]', with: user.password
  #     click_button 'Log in'
  #   end

  #   describe '他人の投稿詳細画面のテスト' do
  #     before do
  #       visit book_path(other_book)
  #     end

  #     context '表示内容の確認' do
  #       it 'URLが正しい' do
  #         expect(current_path).to eq '/books/' + other_book.id.to_s
  #       end
  #       it '「Book detail」と表示される' do
  #         expect(page).to have_content 'Book detail'
  #       end
  #       it 'ユーザ画像・名前のリンク先が正しい' do
  #         expect(page).to have_link other_book.user.name, href: user_path(other_book.user)
  #       end
  #       it '投稿のtitleが表示される' do
  #         expect(page).to have_content other_book.title
  #       end
  #       it '投稿のopinionが表示される' do
  #         expect(page).to have_content other_book.body
  #       end
  #       it '投稿の編集リンクが表示されない' do
  #         expect(page).not_to have_link 'Edit'
  #       end
  #       it '投稿の削除リンクが表示されない' do
  #         expect(page).not_to have_link 'Destroy'
  #       end
  #     end

  #     context 'サイドバーの確認' do
  #       it '他人の名前と紹介文が表示される' do
  #         expect(page).to have_content other_user.name
  #         expect(page).to have_content other_user.introduction
  #       end
  #       it '他人のユーザ編集画面へのリンクが存在する' do
  #         expect(page).to have_link '', href: edit_user_path(other_user)
  #       end
  #       it '自分の名前と紹介文は表示されない' do
  #         expect(page).not_to have_content user.name
  #         expect(page).not_to have_content user.introduction
  #       end
  #       it '自分のユーザ編集画面へのリンクは存在しない' do
  #         expect(page).not_to have_link '', href: edit_user_path(user)
  #       end
  #     end
  #   end

  #   context '他人の投稿編集画面' do
  #     it '遷移できず、投稿一覧画面にリダイレクトされる' do
  #       visit edit_book_path(other_book)
  #       expect(current_path).to eq '/books'
  #     end
  #   end

  #   describe '他人のユーザ詳細画面のテスト' do
  #     before do
  #       visit user_path(other_user)
  #     end

  #     context '表示の確認' do
  #       it 'URLが正しい' do
  #         expect(current_path).to eq '/users/' + other_user.id.to_s
  #       end
  #       it '投稿一覧のユーザ画像のリンク先が正しい' do
  #         expect(page).to have_link '', href: user_path(other_user)
  #       end
  #       it '投稿一覧に他人の投稿のtitleが表示され、リンクが正しい' do
  #         expect(page).to have_link other_book.title, href: book_path(other_book)
  #       end
  #       it '投稿一覧に他人の投稿のopinionが表示される' do
  #         expect(page).to have_content other_book.body
  #       end
  #       it '自分の投稿は表示されない' do
  #         expect(page).not_to have_content book.title
  #         expect(page).not_to have_content book.body
  #       end
  #     end

  #     context 'サイドバーの確認' do
  #       it '他人の名前と紹介文が表示される' do
  #         expect(page).to have_content other_user.name
  #         expect(page).to have_content other_user.introduction
  #       end
  #       it '他人のユーザ編集画面へのリンクが存在する' do
  #         expect(page).to have_link '', href: edit_user_path(other_user)
  #       end
  #       it '自分の名前と紹介文は表示されない' do
  #         expect(page).not_to have_content user.name
  #         expect(page).not_to have_content user.introduction
  #       end
  #       it '自分のユーザ編集画面へのリンクは存在しない' do
  #         expect(page).not_to have_link '', href: edit_user_path(user)
  #       end
  #     end
  #   end

  #   context '他人のユーザ情報編集画面' do
  #     it '遷移できず、自分のユーザ詳細画面にリダイレクトされる' do
  #       visit edit_user_path(other_user)
  #       expect(current_path).to eq '/users/' + user.id.to_s
  #     end
  #   end
  # end

  # describe 'グリッドシステムのテスト: container, row, col-md-〇を正しく使えている' do
  #   subject { page }

  #   before do
  #     visit new_user_session_path
  #     fill_in 'user[name]', with: user.name
  #     fill_in 'user[password]', with: user.password
  #     click_button 'Log in'
  #   end

  #   it 'ユーザ一覧画面' do
  #     visit users_path
  #     is_expected.to have_selector '.container .row .col-md-3'
  #     is_expected.to have_selector '.container .row .col-md-8.offset-md-1'
  #   end
  #   it 'ユーザ詳細画面' do
  #     visit user_path(user)
  #     is_expected.to have_selector '.container .row .col-md-3'
  #     is_expected.to have_selector '.container .row .col-md-8.offset-md-1'
  #   end
  #   it '投稿一覧画面' do
  #     visit books_path
  #     is_expected.to have_selector '.container .row .col-md-3'
  #     is_expected.to have_selector '.container .row .col-md-8.offset-md-1'
  #   end
  #   it '投稿詳細画面' do
  #     visit book_path(book)
  #     is_expected.to have_selector '.container .row .col-md-3'
  #     is_expected.to have_selector '.container .row .col-md-8.offset-md-1'
  #   end
  # end

  # describe 'アイコンのテスト' do
  #   context 'トップ画面' do
  #     subject { page }

  #     before do
  #       visit root_path
  #     end

  #     it '本のアイコンが表示される' do
  #       is_expected.to have_selector '.fas.fa-book'
  #     end
  #   end

  #   context 'アバウト画面' do
  #     subject { page }

  #     before do
  #       visit '/home/about'
  #     end

  #     it '本のアイコンが表示される' do
  #       is_expected.to have_selector '.fas.fa-book'
  #     end
  #   end

  #   context 'ヘッダー: ログインしていない場合' do
  #     subject { page }

  #     before do
  #       visit root_path
  #     end

  #     it 'Homeリンクのアイコンが表示される' do
  #       is_expected.to have_selector '.fas.fa-home'
  #     end
  #     it 'Aboutリンクのアイコンが表示される' do
  #       is_expected.to have_selector '.fas.fa-link'
  #     end
  #     it 'sign upリンクのアイコンが表示される' do
  #       is_expected.to have_selector '.fas.fa-user-plus'
  #     end
  #     it 'loginリンクのアイコンが表示される' do
  #       is_expected.to have_selector '.fas.fa-sign-in-alt'
  #     end
  #   end

  #   context 'ヘッダー: ログインしている場合' do
  #     subject { page }

  #     before do
  #       visit new_user_session_path
  #       fill_in 'user[name]', with: user.name
  #       fill_in 'user[password]', with: user.password
  #       click_button 'Log in'
  #     end

  #     it 'Homeリンクのアイコンが表示される' do
  #       is_expected.to have_selector '.fas.fa-home'
  #     end
  #     it 'Usersリンクのアイコンが表示される' do
  #       is_expected.to have_selector '.fas.fa-users'
  #     end
  #     it 'Booksリンクのアイコンが表示される' do
  #       is_expected.to have_selector '.fas.fa-book-open'
  #     end
  #     it 'log outリンクのアイコンが表示される' do
  #       is_expected.to have_selector '.fas.fa-sign-out-alt'
  #     end
  #   end

  #   context 'サイドバー' do
  #     subject { page }

  #     before do
  #       visit new_user_session_path
  #       fill_in 'user[name]', with: user.name
  #       fill_in 'user[password]', with: user.password
  #       click_button 'Log in'
  #     end

  #     it 'ユーザ一覧画面でレンチアイコンが表示される' do
  #       visit users_path
  #       is_expected.to have_selector '.fas.fa-user-cog'
  #     end
  #     it 'ユーザ詳細画面でレンチアイコンが表示される' do
  #       visit user_path(user)
  #       is_expected.to have_selector '.fas.fa-user-cog'
  #     end
  #     it '投稿一覧画面でレンチアイコンが表示される' do
  #       visit books_path
  #       is_expected.to have_selector '.fas.fa-user-cog'
  #     end
  #     it '投稿詳細画面でレンチアイコンが表示される' do
  #       visit book_path(book)
  #       is_expected.to have_selector '.fas.fa-user-cog'
  #     end
  #   end
  # end
end
