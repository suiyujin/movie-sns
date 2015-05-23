require 'csv'

CSV.foreach('db/csv_data/categories.csv') do |row|
  Category.create(name:row[1])
end

CSV.foreach('db/csv_data/youtube_categories.csv') do |row|
  YoutubeCategory.create(name:row[1],
                         category_id: row[2],
                         youtube_category_id: row[3])
end

CSV.foreach('db/csv_data/nicovideo_categories.csv') do |row|
  NicovideoCategory.create(name:row[1],
                           category_id: row[2])
end

User.create(email: 'test@test.com',
           password: 'password',
           password_confirmation: 'password')
User.create(email: 'takeda@takeda.com',
           password: 'takedatakeda',
           password_confirmation: 'takedatakeda')
User.create(email: 'higashi@higashi.com',
           password: 'higashihigashi',
           password_confirmation: 'higashihigashi')
User.create(email: 'masaki@masaki.com',
           password: 'masakimasaki',
           password_confirmation: 'masakimasaki')

CSV.foreach('db/csv_data/movies.csv') do |row|
  Movie.create(movie_id: row[0],
           title: row[1],
           description: row[2],
           url: row[3],
           thumbnail_url: row[4],
           category_id: row[5],
           user_id: row[6])
end

CSV.foreach('db/csv_data/relations.csv') do |row|
  Relation.create(movie1_id: row[0],
               movie2_id: row[1],
               user_id: row[2])
end

Movie.create(movie_id: 'gBVCa8rZmGg',
           title: "【ラブライブ！】Printemps「Pure girls project」試聴動画",
           description: "『ラブライブ！』ユニットシングル 2nd session Pure girls project Printemps〜高坂穂乃果(新田恵海)、南ことり(内田 彩)、小泉花陽(久保ユリカ) from μ's〜 LACM-14103 2013年8月21日発売 定価：¥1,200(税抜価格：¥1,143) ＜INDEX＞ 01. Pure girls project 作詞：畑 亜貴　作曲・編曲：倉内達矢 歌：Printemps～高坂穂乃果(新田恵海)、南ことり(内田 彩)、小泉花陽(久保ユリカ) from μ's～ 02. UNBALANCED LOVE 作詞：畑 亜貴　作曲・編曲：佐伯高志 歌：Printemps～高坂穂乃果(新田恵海)、南ことり(内田 彩)、小泉花陽(久保ユリカ) from μ's～ 03. Pure girls project(Off Vocal) 04. UNBALANCED LOVE(Off Vocal) 05. プールでオンステージ！（ミニドラマ） 出演：μ's(高坂穂乃果(CV.新田恵海)、絢瀬絵里(CV.南條愛乃)、南ことり(CV.内田彩)、園田海未(CV.三森すずこ)、星空 凛(CV.飯田里穂)、西木野真姫(CV.Pile)、東條 希(CV.楠田亜衣奈)、小泉花陽(CV.久保ユリカ)、矢澤にこ(CV.徳井青空))　　 脚本：子安秀明 【初回生産限定封入】 μ'sのユニット活動！私たちのユニットの強みは...？カード （C）2013 プロジェクトラブライブ！",
           url: 'https://www.youtube.com/watch?v=gBVCa8rZmGg',
           thumbnail_url: 'https://i.ytimg.com/vi/gBVCa8rZmGg/mqdefault.jpg',
           category_id: 2,
           user_id: 1)

Movie.create(movie_id: 'jZG4SYdvbNE',
           title: "Love live !OP",
           description: "Love live Opening music ！　Anime of Japan . It started in January, 2013.",
           url: 'https://www.youtube.com/watch?v=jZG4SYdvbNE',
           thumbnail_url: 'https://i.ytimg.com/vi/jZG4SYdvbNE/mqdefault.jpg',
           category_id: 8,
           user_id: 1)

Relation.create(movie1_id: 1,
               movie2_id: 2,
               user_id: 1)

CSV.foreach('db/csv_data/comments.csv') do |row|
  Comment.create(title: row[0],
                comment: row[1],
                commentable_id: row[2],
                commentable_type: row[3],
                user_id: row[4],
                role: row[5])
end

Comment.create(title: "ラブライブ最高！",
              comment: "ラブライブ大好き！
              ラブライブ大好き！",
              commentable_id: 1,
              commentable_type: 'Relation',
              user_id: 1,
              role: 'comments')
