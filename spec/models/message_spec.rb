require 'rails_helper'

RSpec.describe Message, type: :model do
  describe '#create' do
    before do
      @message = FactoryBot.build(:message)
    end

    it 'contentとimageが存在していれば保存できること' do
      expect(@message).to be_valid
      # contentとimageの両方が存在していれば、DBに正しく保存されるかを確認
    end

    it 'contentが空でも保存できること' do
      @message.content = nil
      expect(@message).to be_valid
      # contentが空でも（imageが存在していれば）、DBに正しく保存されるかを確認
    end

    it 'imageが空でも保存できること' do
      @message.image = nil
      expect(@message).to be_valid
      # imageが空でも（contentが存在していれば）、DBに正しく保存されるかを確認
    end

    it 'contentとimageが空では保存できないこと' do
      @message.content = nil
      @message.image = nil
      @message.valid?
      # モデルファイルで設定したバリデーション（もしcontentとimageが空だったらDBに保存されない）が正常に起動するかを確認
      expect(@message.errors.full_messages).to include("Content can't be blank")
      # もしDBに保存されない場合のエラーメッセージは「Content can't be blank（Contentを入力してください）」となる
    end

    it 'roomが紐付いていないと保存できないこと' do
      @message.room = nil
      @message.valid?
      expect(@message.errors.full_messages).to include("Room must exist")
      # アソシエーションによって@messageに紐づいているroomを空にした上で、バリデーションを確認
      # エラーメッセージはRoom must exist
    end

    it 'userが紐付いていないと保存できないこと' do
      @message.user = nil
      @message.valid?
      expect(@message.errors.full_messages).to include("User must exist")
      # アソシエーションによって@messageに紐づいているuserを空にした上で、バリデーションを確認
      # エラーメッセージはUser must exist
    end
  end
end
