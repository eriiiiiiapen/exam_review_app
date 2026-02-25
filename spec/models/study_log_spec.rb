require 'rails_helper'

RSpec.describe StudyLog, type: :model do
    describe 'バリデーションテスト' do
        let(:user) { create(:user) }
        let(:topic) { create(:topic) }

        it '全ての属性が揃っていれば有効であること' do
            study_log = StudyLog.new(
                user: user,
                topic: topic,
                understanding_level: :understood,
                note: "合格したい"
            )
            expect(study_log).to be_valid
        end

        it 'understanding_levelがない場合は無効であること' do
            study_log = StudyLog.new(understanding_level: nil)
            expect(study_log).not_to be_valid
            expect(study_log.errors[:understanding_level]).to include("を入力してください")
        end
    end

    describe 'enumの挙動確認' do
        it '数値で値を指定しても正しくシンボルとして扱われること' do
            study_log = build(:study_log, understanding_level: 2) # understood
            expect(study_log.understood?).to be true
        end
    end

    describe 'カスタムメソッド .next_level_for のテスト' do
        it '階層が正しく循環すること' do
            expect(StudyLog.next_level_for(:not_understood)).to eq 'vaguely_understood'
            expect(StudyLog.next_level_for(:mastered)).to eq 'not_understood'
        end
    end
end