require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#create' do
    before do
      @user = FactoryBot.build(:user)
    end

    it "nameとemail、passwordとpassword_confirmationが存在すれば登録できること" do
      expect(@user).to be_valid
      # ユーザー新規登録時にnameとemail、passwordとpassword_confirmationが存在している」
      # という条件を満たしていれば、データベースに正しく保存されるか確認
    end

    it "nameが空では登録できないこと" do
      @user.name = nil
      @user.valid?
      # モデルファイルで設定したバリデーション（もしuserのnameが空だったらDBに保存されない）が
      # 正常に起動するかを確認
      expect(@user.errors.full_messages).to include("Name can't be blank")
      # もしDBに保存されない場合のエラーメッセージは、「Name can't be blank（nameを入力してください）」となる
    end

    it "emailが空では登録できないこと" do
      @user.email = nil
      @user.valid?
      expect(@user.errors.full_messages).to include("Email can't be blank")
    end

    it "passwordが空では登録できないこと" do
      @user.password = nil
      @user.valid?
      expect(@user.errors.full_messages).to include("Password can't be blank")
    end
    it "passwordが存在してもpassword_confirmationが空では登録できないこと" do
      @user.password_confirmation = ""
      # password_confirmationの値が空と設定する時は「””」と記述。
      @user.valid?
      expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
    end

    it "passwordが6文字以上であれば登録できること" do
      @user.password = "123456"
      @user.password_confirmation = "123456"
      # 「DBに保存されるパスワードが６文字以上であるか」を確認
      expect(@user).to be_valid
      # データベースに保存されるかを確認
    end

    it "passwordが5文字以下であれば登録できないこと" do
      @user.password = "12345"
      @user.password_confirmation = "12345"
      @user.valid?
      expect(@user.errors.full_messages).to include("Password is too short (minimum is 6 characters)")
      # もしpasswordが5文字以下だった場合「Password is too short (minimum is 6 characters)」と、エラー文が表示
    end

    it "重複したemailが存在する場合登録できないこと" do
      @user.save
      # user情報をデータベースに保存する記述
      another_user = FactoryBot.build(:user, email: @user.email)
      # FactoryBotを用いて、user情報（name、email、password、password_confirmation）の中でも
      # 「email」だけを選択してインスタンスを生成し、生成したインスタンスを「another_user」に代入
      another_user.valid?
      expect(another_user.errors.full_messages).to include("Email has already been taken")
      # もし保存しようとしているemailが既にDBに存在している場合は
      #「Email has already been taken（そのEmailは既に使われています）」というエラー文が表示
    end
  end
end
