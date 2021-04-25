require 'rails_helper'

describe '[STEP2] ユーザログイン後のテスト' do
  let(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:category) { create(:category) }
  let!(:comment) { create(:comment) }
  let!(:tweet) { create(:tweet, user: user, category: category) }
  let!(:other_tweet) { create(:tweet, user: other_user) }

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'Log in'
  end

  describe 'ヘッダーのテスト: ログインしている場合' do
    context 'リンクの内容を確認: ※logoutは『1_before_login』でテスト済み。' do
      subject { current_path }

      it '「新しい知識を提供する」を押すと、ツイート一覧画面に遷移する' do
        new_link = find_all('a')[1].native.inner_text
        new_link = new_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link new_link
        is_expected.to eq '/tweets'
      end
      it '「下書き一覧」を押すと、下書き一覧画面に遷移する' do
        confirm_link = find_all('a')[2].native.inner_text
        confirm_link = confirm_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link confirm_link
        is_expected.to eq '/tweets/confirm'
      end
      it '「ユーザー一覧」を押すと、ユーザ一覧画面に遷移する' do
        users_link = find_all('a')[3].native.inner_text
        users_link = users_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link users_link
        is_expected.to eq '/users'
      end
      it '「通知一覧」を押すと、通知一覧画面に遷移する' do
        notifications_link = find_all('a')[4].native.inner_text
        notifications_link = notifications_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link notifications_link
        is_expected.to eq '/notifications'
      end
      it '「プロフィール編集」を押すと、プロフィール編集画面に遷移する' do
        mypage_link = find_all('a')[5].native.inner_text
        mypage_link = mypage_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link mypage_link
        is_expected.to eq '/users/edit'
      end
    end
  end

  describe 'ツイート一覧画面のテスト' do
    before do
      visit tweets_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/tweets'
      end
      it '自分と他人の画像のリンク先が正しい' do
        expect(page).to have_link '', href: user_path(tweet.user)
        expect(page).to have_link '', href: user_path(other_tweet.user)
      end
      it '自分のツイートと他人のツイートのリンク先がそれぞれ正しい' do
        expect(page).to have_link tweet.tweet, href: tweet_path(tweet)
        expect(page).to have_link other_tweet.tweet, href: tweet_path(other_tweet)
      end
      it '自分のツイートと他人のツイートが表示される' do
        expect(page).to have_content tweet.tweet
        expect(page).to have_content other_tweet.tweet
      end
    end

    context 'サイドバーの確認' do
      it '「プロフィール」と表示される' do
        expect(page).to have_content 'プロフィール'
      end
      it '自分の名前とユーザーネームが表示される' do
        expect(page).to have_content user.name
        expect(page).to have_content user.username
      end
      it '自分の詳細画面へのリンクが存在する' do
        expect(page).to have_link '', href: user_path(user)
      end
      it '自分のフォロー一覧画面へのリンクが存在する' do
        expect(page).to have_link '', href: following_user_path(user)
      end
      it '自分のフォロワー一覧画面へのリンクが存在する' do
        expect(page).to have_link '', href: followers_user_path(user)
      end
      it '「ツイートを検索する」と表示される' do
        expect(page).to have_content 'ツイートを検索する'
      end
      it 'searchフォームが表示される' do
        expect(page).to have_field 'search'
      end
      it 'searchフォームに値が入っていない' do
        expect(find_field('search').text).to be_blank
      end
      it '「カテゴリー一覧」と表示される' do
        expect(page).to have_content 'カテゴリー一覧'
      end
    end

    context 'ツイートを検索するテスト' do
      before do
        fill_in 'search', with: 'a'
        click_button 'search'
      end
      it '入力されたワードで検索したページへ遷移する' do
        expect(current_path).to eq '/tweets/search'
      end
    end

    context 'ツイートフォームのテスト' do
      it 'ツイートフォームが表示される' do
        expect(page).to have_field 'tweet[tweet]'
      end
      it 'ツイートフォームに値が入っていない' do
        expect(find_field('tweet[tweet]').text).to be_blank
      end
      it 'ツイート/下書きするボタンが表示される' do
        expect(page).to have_button 'ツイート/下書きする'
      end
    end

    context 'ツイート成功のテスト' do
      before do
        fill_in 'tweet[tweet]', with: Faker::Lorem.characters(number: 5)
        # fill_in 'tweet[category]', with: 1 「入力」ではなく「選択」なので、これではなく以下を使う
        find("#tweet_category_id").find("option[value='1']").select_option
      end

      it '自分の新しいツイートが正しく保存される' do
        expect { click_button 'ツイート/下書きする' }.to change(user.tweets, :count).by(1)
      end
      it 'リダイレクト先が、ツイートの一覧画面になっている' do
        click_button 'ツイート/下書きする'
        expect(current_path).to eq '/tweets'
      end
    end

    context 'カテゴリー選択のテスト' do
      before do
        first('.category-btn').click
      end
      it '選択したカテゴリーの一覧ページが表示される' do
        expect(current_path).to eq tweet_category_path(category)
      end
    end

    context '下書き成功のテスト' do
      before do
        fill_in 'tweet[tweet]', with: Faker::Lorem.characters(number: 5)
        find("#tweet_category_id").find("option[value='1']").select_option
        find("#tweet_status").find("option[value='draft']").select_option
      end
      it '自分の新しいツイートが正しく下書き保存される' do
        expect { click_button 'ツイート/下書きする' }.to change(user.tweets.draft, :count).by(1)
      end
      it 'リダイレクト先が、ツイートの一覧画面になっている' do
        click_button 'ツイート/下書きする'
        expect(current_path).to eq '/tweets'
      end
    end

  end

  describe '自分のツイート詳細画面のテスト' do
    before do
      visit tweet_path(tweet)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/tweets/' + tweet.id.to_s
      end
      it 'ユーザ画像のリンク先が正しい' do
        expect(page).to have_link href: user_path(tweet.user)
      end
      it 'ツイートの内容が表示される' do
        expect(page).to have_content tweet.tweet
      end
      it 'コメントのフォームが表示される' do
        expect(page).to have_field comment[comment]
      end
      it 'コメントリンクが表示される' do
        expect(page).to have_link, href: tweet_path(tweet)
      end
      it 'いいねリンクが表示される' do
        expect(page).to have_link, href: tweet_favorites_path(tweet)
      end
      it 'ツイートの編集リンクが表示される' do
        expect(page).to have_link, href: edit_tweet_path(tweet)
      end
      it 'ツイートの削除リンクが表示される' do
        expect(page).to have_link, href: tweet_path(tweet)
      end
    end

    context '編集リンクのテスト' do
      it '編集画面に遷移する' do
        find('.edit-btn').click
        expect(current_path).to eq '/tweets/' + tweet.id.to_s + '/edit'
      end
    end

    context '削除リンクのテスト' do
      before do
        find('.destroy-btn').click
      end
      it '正しく削除される' do
        expect(Tweet.where(id: tweet.id).count).to eq 0
      end
      it 'リダイレクト先が、ツイート一覧画面になっている' do
        expect(current_path).to eq '/tweets'
      end
    end
  end

  describe '自分のツイート編集画面のテスト' do
    before do
      visit edit_tweet_path(tweet)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/tweets/' + tweet.id.to_s + '/edit'
      end
      it '「ツイートを編集する」と表示される' do
        expect(page).to have_content 'ツイートを編集する'
      end
      it 'ツイート編集フォームが表示される' do
        expect(page).to have_field 'tweet[tweet]', with: tweet.tweet
      end
      it 'カテゴリーセレクトボタンが表示される' do
        expect(page).to have_field 'tweet[category_id]'
      end
      # it '画像添付用ファイルを選択が表示される' do
      #   expect(page).to have_content 'ファイルを選択'
      # end
      it 'ツイートする/下書きするセレクトボタンが表示される' do
        expect(page).to have_select 'tweet[status]'
      end
      it 'ツイート/下書きするボタンが表示される' do
        expect(page).to have_button 'ツイート/下書きする'
      end
      it 'Cancelボタンが表示される' do
        expect(page).to have_link 'Cancel'
      end
    end

    context '編集成功のテスト' do
      before do
        @tweet_old_tweet = tweet.tweet
        @tweet_old_category = tweet.category
        fill_in 'tweet[tweet]', with: Faker::Lorem.characters(number: 15)
        find("#tweet_category_id").find("option[value='2']").select_option
        click_button 'ツイート/下書きする'
      end

      it 'ツイートが正しく更新される' do
        expect(tweet.reload.tweet).not_to eq @tweet_old_tweet
      end
      it 'カテゴリーが正しく更新される' do
        expect(tweet.reload.category).not_to eq @tweet_old_category
      end
      it 'リダイレクト先が、更新したツイートの詳細画面になっている' do
        expect(current_path).to eq '/tweets/' + tweet.id.to_s
      end
    end
  end

  describe 'ユーザ一覧画面のテスト' do
    before do
      visit users_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users'
      end
      it '自分と他人の名前がそれぞれ表示される' do
        expect(page).to have_content user.name
        expect(page).to have_content other_user.name
      end
      it '自分と他人のshowリンクがそれぞれ表示される' do
        expect(page).to have_link href: user_path(user)
        expect(page).to have_link href: user_path(other_user)
      end
      # it 'フォローする/フォロー外すボタンが表示される' do
      #   expect(page).to include 'フォローする' or 'フォロー外す'
      # end
    end

  end

  describe '自分のユーザ詳細画面のテスト' do
    before do
      visit user_path(user)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
      it 'ツイート一覧のユーザ画像のリンク先が正しい' do
        expect(page).to have_link '', href: user_path(user)
      end
      it 'ツイート一覧に自分のツイートが表示され、リンクが正しい' do
        expect(page).to have_link tweet.tweet, href: tweet_path(tweet)
      end
      it 'ツイート一覧に自分のツイートのカテゴリーが表示される' do
        expect(page).to have_content tweet.category_id
      end
      it '他人のツイートは表示されない' do
        expect(page).not_to have_link '', href: user_path(other_user)
        expect(page).not_to have_content other_tweet.tweet
        expect(page).not_to have_content other_tweet.category
      end
    end

  end

  describe '自分のユーザ情報編集画面のテスト' do
    before do
      visit edit_user_registration_path
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/edit'
      end
      it '名前編集フォームに自分の名前が表示される' do
        expect(page).to have_field 'user[name]', with: user.name
      end
      it '画像編集フォームが表示される' do
        expect(page).to have_field 'user[profile_image]'
      end
      it '自己紹介編集フォームに自分の自己紹介文が表示される' do
        expect(page).to have_field 'user[profile]', with: user.profile
      end
      it '更新するボタンが表示される' do
        expect(page).to have_button '更新する'
      end
    end

    context '更新成功のテスト' do
      before do
        @user_old_name = user.name
        @user_old_profile = user.profile
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 8)
        fill_in 'user[profile]', with: Faker::Lorem.characters(number: 15)
        fill_in 'user[current_password]', with: user.password
        click_button '更新する'
      end

      it 'nameが正しく更新される' do
        expect(user.reload.name).not_to eq @user_old_name
      end
      it 'profileが正しく更新される' do
        expect(user.reload.profile).not_to eq @user_old_profile
      end
      it 'リダイレクト先が、自分のユーザ詳細画面になっている' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
    end
  end
end
