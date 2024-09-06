class Memo
  def initialize(memo_name)
    @memo_name = memo_name
  end

  def new_entry
    puts "メモしたい内容を入力してください"
    puts "完了したら改行して[Ctrl + D]をおします"
    #ファイルを新しく書き出す
    memo_value = readlines(chomp: true)
    CSV.open("#{@memo_name}.csv","w") do |csv|
      csv << memo_value
    end
    puts "【保存が完了しました】"
  end

  def edit
    puts "メモに追記できます"
    puts "完了したら改行して[Ctrl + D]をおします"
    #ファイルに追記する
    CSV.open("#{@memo_name}.csv","rt+") do |csv|
      csv.each do |row|
        puts row
      end
      memo_value = readlines(chomp: true)
      csv << memo_value
    end
    puts "【保存が完了しました】"
  end
end

# ファイル名入力メソッド
def input_memo_name
  puts "拡張子を除いたファイル名を入力してください"
  $memo_name = gets.chomp
end

# 実行開始
require "csv" 

puts "1 → 新規でメモを作成する / 2 → 既存のメモに追記する"

memo_type = gets.to_i

# 新規作成
if memo_type == 1
  puts "【新規でメモを作成する】"
  input_memo_name

  # 同名のファイルがフォルダに存在するとき確認
  while File.exist?("#{$memo_name}.csv") do
    puts "【!】同名のファイルが存在します"
    puts "上書きしてよろしいですか？ 1 → はい / 2 → いいえ"
    puts "(プログラムを終了したいときは 3 を入力してください)"
    answer = gets.to_i
    if answer == 1
      # はい
      break
    elsif answer == 2
      #いいえ
      input_memo_name
    elsif answer == 3
      # 強制終了
      puts "プログラムを終了します"
      exit
    else
      # 不正感知
      puts "不正な値です。1か2を入力してください"
    end
  end
  # 同名のファイルがフォルダが存在しないなら実行
    memo = Memo.new($memo_name)
    memo.new_entry()

# 追記
elsif memo_type == 2
  puts "【既存のメモに追記する】"
  input_memo_name
  # フォルダにファイルが存在しないとき確認
  until File.exist?("#{$memo_name}.csv") do
    puts "【!】フォルダに存在しないファイル名です"
    puts "(プログラムを終了したいときは未記入のままエンターを押してください)"
    input_memo_name
    if $memo_name == ""
      # 強制終了
      puts "プログラムを終了します"
      exit
    end
  end
  # フォルダにファイルが存在するなら実行
  memo = Memo.new($memo_name)
  memo.edit()

else
  # 不正感知
  puts "不正な値です。1か2を入力してください"
end