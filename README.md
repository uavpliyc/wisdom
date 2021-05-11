# Wisdom
![pinterest_board_photo](https://user-images.githubusercontent.com/68683051/112710027-72e0b380-8f01-11eb-837b-e0821e2cb603.png)

## 概要
自己学習・自己成長を効率化するアプリです。インプットに偏りがちな学習内容を、具体的なアクションプランを明確した上でアウトプットし、学習・成長の効率化することを目的としています。

### サイトテーマ
「知識を知恵にするコミュニケーションの場」

### テーマを選んだ理由
【きっかけ】
社会人以降、読書を３００冊以上読み、資格を28個取得しました。
しかし、自分の脳内世界が変わり意識が高くなるものの、現実世界を変えることができていないことに気付きました。
問題点としては、「インプットしてもアウトプットしなければ、現実を変えることはできない」ということだと考えました。
そこで、インプットしたことをアウトプットする習慣をつけようと思いました。
【問題点】
しかし、いざアウトプットしようと思った時、「インプットで得た知識をどのようにアウトプットするべきなのかが分からない」という新たな問題が発生しました。
ここで、これは自分だけの問題ではなく、同じようにアウトプット方法がわからない人も多いのではないかと考えました。
一方で、インプットしたことを行動に移しアウトプットして、成功している人もいます。
もちろん、最適なアウトプット方法は人それぞれ異なると思いますが、そのような成功者や他人からの客観的視点には、自分だけの考えでは出てこないアウトプット方法のヒントがあるのではないか、と考えました。
そのためには、他人と繋がる必要があります。その手段として、現在数多く普及しているSNSを活用すれば、他人と繋がる機会ができると思いました。
しかし、既存のSNSは対象範囲が広すぎて、その人が求める情報とそうでない情報が混在してしまっています。その逆に、知識のアウトプットに焦点を絞ったSNSがあるべきだと考えました。
【解決案】
このような経験と考えから、これらの問題点を解決するために「アウトプット方法を共有できるコミュニケーションの場」が必要だと考え、制作に至りました。
知識のインプットにとどまらず、アウトプットすることで知恵にする、という意味で「Wisdom（知恵）」というアプリ名にしました。

### ターゲットユーザ
「自己学習・自己成長の効率化を求める人」
メインターゲット層：
- 20-40代
- SNSに慣れている
- ビジネスパーソン

### 主な利用シーン
- 個人発信の有益な情報を入手したい時
- 知識を言語化してアウトプットしたい時
- 具体的アクションプランのアドバイスが欲しい時
- 意識の高い人脈を広げたい時

### 利用方法
[登録は30秒]

![スクリーンショット 2021-04-29 0 21 13](https://user-images.githubusercontent.com/68683051/117786490-8319db80-b280-11eb-97f2-a015e8e93431.png)


[有益な知識ツイートに対して、アクションプランをコメント]

![スクリーンショット 2021-05-11 17 57 33](https://user-images.githubusercontent.com/68683051/117790622-81521700-b284-11eb-8e7a-6bdf3130e12c.png)

[マイアクションプランをtodoリストとして保存できる]

![スクリーンショット 2021-05-11 18 10 32](https://user-images.githubusercontent.com/68683051/117790393-44862000-b284-11eb-8830-b21a5dc18f55.png)


[通知を黄色ボタンでお知らせ]

![スクリーンショット 2021-04-28 23 46 52](https://user-images.githubusercontent.com/68683051/117787122-1eab4c00-b281-11eb-8826-352ddde8c990.png)



### 設計書


## 機能一覧
https://docs.google.com/spreadsheets/d/1UTzIwUKKz4slRCEYWaZUA19uY1rX6ojcG39kXVQOcqk/edit?usp=sharing

## 開発環境
- OS：Linux(CentOS)
- 言語：HTML,CSS,JavaScript,Ruby,SQL
- フレームワーク：Ruby on Rails
- JSライブラリ：jQuery
- IDE：Cloud9

## インフラ構成図
[Wisdom Diagram.pdf](https://github.com/uavpliyc/.github/files/6457789/Wisdom.Diagram.pdf)

### テスト
- Rspec:160以上

### その他使用技術
- HTTPS通信(Certbot)
- ドメイン取得(お名前.com(https://www.onamae.com/?utm_source=google&utm_medium=paidsearch&banner_id=102_kwt_domain_brand-2&waad=pMYIZsIp&flow=normal&gclid=CjwKCAjw1uiEBhBzEiwAO9B_HTL76TdP7DR-IDBEMH8NV9jhkIvsagoPLhUmFsBT1yVCdM0lX9ZLJBoCU9AQAvD_BwE))
- デプロイ自動化(GitHub Actions)

## 使用素材
- ロゴ作成：hatchful（https://hatchful.shopify.com/ja/）
- アイコン：FontAwesome（https://fontawesome.com/icons?d=gallery&p=2）
