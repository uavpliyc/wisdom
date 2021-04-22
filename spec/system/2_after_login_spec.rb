require 'rails_helper'

describe '[STEP2] ユーザログイン後のテスト' do
  let(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:category) { create(:category) }
  let!(:tweet) { create(:tweet, user: user, category: category) }
  let!(:other_tweet) { create(:tweet, user: other_user) }
  # let!(:comment) { create(:content) }

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
      it '「マイページ編集」を押すと、マイページ編集画面に遷移する' do
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
      it '自分の投稿と他人の投稿のタイトルのリンク先がそれぞれ正しい' do
        expect(page).to have_link tweet.tweet, href: tweet_path(tweet)
        expect(page).to have_link other_tweet.tweet, href: tweet_path(other_tweet)
      end
      it '自分の投稿と他人のツイートが表示される' do
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
        click_on 'search'
      end
      it '入力されたワードで検索したページへ遷移する' do
        is_expected.to eq '/tweets/search'
      end
    end

    context 'ツイート投稿フォームのテスト' do
      it 'tweetフォームが表示される' do
        expect(page).to have_field 'tweet[tweet]'
      end
      it 'tweetフォームに値が入っていない' do
        expect(find_field('tweet[tweet]').text).to be_blank
      end
      it 'ツイート/下書きするボタンが表示される' do
        expect(page).to have_button 'ツイート/下書きする'
      end
    end

    context 'ツイート成功のテスト' do
      before do
        fill_in 'tweet[tweet]', with: Faker::Lorem.characters(number: 5)
        # fill_in 'tweet[category]', with: 1 「入力」ではなく「選択」なので以下を使う
        find("#tweet_category_id").find("option[value='1']").select_option
      end

      it '自分の新しい投稿が正しく保存される' do
        expect { click_button 'ツイート/下書きする' }.to change(user.tweets, :count).by(1)
      end
      it 'リダイレクト先が、保存できた投稿の詳細画面になっている' do
        click_button 'ツイート/下書きする'
        expect(current_path).to eq '/tweets'
      end
    end

    context 'カテゴリー選択のテスト' do
      before do
        click_on "tweets/category.id"
      end
      it '選択したカテゴリーの一覧ページが表示される' do
        expect(current_path).to eq tweet_category_path(category)
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
        expect(page).to have_field comment[content]
      end
      it 'コメントリンクが左から１番目に表示される' do
        comment_tweet_link = find_all('.level-item')[1]
        expect(page).to have_link comment_tweet_link, href: tweet_path(tweet)
      end
      it 'いいねが左から２番目に表示される' do
        favorite_tweet = find_all('.level-item')[2]
        expect(page).to have_content favorite_tweet
      end
      it 'ツイートの編集リンクが左から３番目に表示される' do
        edit_tweet_link = find_all('.level-item')[3]
        expect(page).to have_link edit_tweet_link, href: edit_tweet_path(tweet)
      end
      it 'ツイートの削除リンクが左から４番目に表示される' do
        destroy_tweet_link = find_all('.level-item')[4]
        expect(page).to have_link destroy_tweet_link, href: tweet_path(tweet)
      end
    end

    context '編集リンクのテスト' do
      it '編集画面に遷移する' do
        edit_tweet_link = find_all('.level-item')[3]
        click_link edit_tweet_link, match: :first
        expect(current_path).to eq '/tweets/' + tweet.id.to_s + '/edit'
      end
    end

    context '削除リンクのテスト' do
      before do
        destroy_tweet_link = find_all('.level-item')[4]
        click_link destroy_tweet_link, match: :first
      end
      it '正しく削除される' do
        expect(Tweet.where(id: tweet.id).count).to eq 0
      end
      it 'リダイレクト先が、ツイート一覧画面になっている' do
        expect(current_path).to eq '/tweets'
      end
    end
  end

#   describe '自分の投稿編集画面のテスト' do
#     before do
#       visit edit_book_path(book)
#     end

#     context '表示の確認' do
#       it 'URLが正しい' do
#         expect(current_path).to eq '/books/' + book.id.to_s + '/edit'
#       end
#       it '「Editing Book」と表示される' do
#         expect(page).to have_content 'Editing Book'
#       end
#       it 'title編集フォームが表示される' do
#         expect(page).to have_field 'book[title]', with: book.title
#       end
#       it 'opinion編集フォームが表示される' do
#         expect(page).to have_field 'book[body]', with: book.body
#       end
#       it 'Update Bookボタンが表示される' do
#         expect(page).to have_button 'Update Book'
#       end
#       it 'Showリンクが表示される' do
#         expect(page).to have_link 'Show', href: book_path(book)
#       end
#       it 'Backリンクが表示される' do
#         expect(page).to have_link 'Back', href: books_path
#       end
#     end

#     context '編集成功のテスト' do
#       before do
#         @book_old_title = book.title
#         @book_old_body = book.body
#         fill_in 'book[title]', with: Faker::Lorem.characters(number: 4)
#         fill_in 'book[body]', with: Faker::Lorem.characters(number: 19)
#         click_button 'Update Book'
#       end

#       it 'titleが正しく更新される' do
#         expect(book.reload.title).not_to eq @book_old_title
#       end
#       it 'bodyが正しく更新される' do
#         expect(book.reload.body).not_to eq @book_old_body
#       end
#       it 'リダイレクト先が、更新した投稿の詳細画面になっている' do
#         expect(current_path).to eq '/books/' + book.id.to_s
#         expect(page).to have_content 'Book detail'
#       end
#     end
#   end

#   describe 'ユーザ一覧画面のテスト' do
#     before do
#       visit users_path
#     end

#     context '表示内容の確認' do
#       it 'URLが正しい' do
#         expect(current_path).to eq '/users'
#       end
#       it '自分と他人の画像が表示される: fallbackの画像がサイドバーの1つ＋一覧(2人)の2つの計3つ存在する' do
#         expect(all('img').size).to eq(3)
#       end
#       it '自分と他人の名前がそれぞれ表示される' do
#         expect(page).to have_content user.name
#         expect(page).to have_content other_user.name
#       end
#       it '自分と他人のshowリンクがそれぞれ表示される' do
#         expect(page).to have_link 'Show', href: user_path(user)
#         expect(page).to have_link 'Show', href: user_path(other_user)
#       end
#     end

#     context 'サイドバーの確認' do
#       it '自分の名前と紹介文が表示される' do
#         expect(page).to have_content user.name
#         expect(page).to have_content user.introduction
#       end
#       it '自分のユーザ編集画面へのリンクが存在する' do
#         expect(page).to have_link '', href: edit_user_path(user)
#       end
#       it '「New book」と表示される' do
#         expect(page).to have_content 'New book'
#       end
#       it 'titleフォームが表示される' do
#         expect(page).to have_field 'book[title]'
#       end
#       it 'titleフォームに値が入っていない' do
#         expect(find_field('book[title]').text).to be_blank
#       end
#       it 'opinionフォームが表示される' do
#         expect(page).to have_field 'book[body]'
#       end
#       it 'opinionフォームに値が入っていない' do
#         expect(find_field('book[body]').text).to be_blank
#       end
#       it 'Create Bookボタンが表示される' do
#         expect(page).to have_button 'Create Book'
#       end
#     end
#   end

#   describe '自分のユーザ詳細画面のテスト' do
#     before do
#       visit user_path(user)
#     end

#     context '表示の確認' do
#       it 'URLが正しい' do
#         expect(current_path).to eq '/users/' + user.id.to_s
#       end
#       it '投稿一覧のユーザ画像のリンク先が正しい' do
#         expect(page).to have_link '', href: user_path(user)
#       end
#       it '投稿一覧に自分の投稿のtitleが表示され、リンクが正しい' do
#         expect(page).to have_link book.title, href: book_path(book)
#       end
#       it '投稿一覧に自分の投稿のopinionが表示される' do
#         expect(page).to have_content book.body
#       end
#       it '他人の投稿は表示されない' do
#         expect(page).not_to have_link '', href: user_path(other_user)
#         expect(page).not_to have_content other_book.title
#         expect(page).not_to have_content other_book.body
#       end
#     end

#     context 'サイドバーの確認' do
#       it '自分の名前と紹介文が表示される' do
#         expect(page).to have_content user.name
#         expect(page).to have_content user.introduction
#       end
#       it '自分のユーザ編集画面へのリンクが存在する' do
#         expect(page).to have_link '', href: edit_user_path(user)
#       end
#       it '「New book」と表示される' do
#         expect(page).to have_content 'New book'
#       end
#       it 'titleフォームが表示される' do
#         expect(page).to have_field 'book[title]'
#       end
#       it 'titleフォームに値が入っていない' do
#         expect(find_field('book[title]').text).to be_blank
#       end
#       it 'opinionフォームが表示される' do
#         expect(page).to have_field 'book[body]'
#       end
#       it 'opinionフォームに値が入っていない' do
#         expect(find_field('book[body]').text).to be_blank
#       end
#       it 'Create Bookボタンが表示される' do
#         expect(page).to have_button 'Create Book'
#       end
#     end
#   end

#   describe '自分のユーザ情報編集画面のテスト' do
#     before do
#       visit edit_user_path(user)
#     end

#     context '表示の確認' do
#       it 'URLが正しい' do
#         expect(current_path).to eq '/users/' + user.id.to_s + '/edit'
#       end
#       it '名前編集フォームに自分の名前が表示される' do
#         expect(page).to have_field 'user[name]', with: user.name
#       end
#       it '画像編集フォームが表示される' do
#         expect(page).to have_field 'user[profile_image]'
#       end
#       it '自己紹介編集フォームに自分の自己紹介文が表示される' do
#         expect(page).to have_field 'user[introduction]', with: user.introduction
#       end
#       it 'Update Userボタンが表示される' do
#         expect(page).to have_button 'Update User'
#       end
#     end

#     context '更新成功のテスト' do
#       before do
#         @user_old_name = user.name
#         @user_old_intrpduction = user.introduction
#         fill_in 'user[name]', with: Faker::Lorem.characters(number: 9)
#         fill_in 'user[introduction]', with: Faker::Lorem.characters(number: 19)
#         click_button 'Update User'
#       end

#       it 'nameが正しく更新される' do
#         expect(user.reload.name).not_to eq @user_old_name
#       end
#       it 'introductionが正しく更新される' do
#         expect(user.reload.introduction).not_to eq @user_old_intrpduction
#       end
#       it 'リダイレクト先が、自分のユーザ詳細画面になっている' do
#         expect(current_path).to eq '/users/' + user.id.to_s
#       end
#     end
#   end
end
