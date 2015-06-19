# require 'spec_helper'

# describe Micropost do

#   let(:user) { FactoryGirl.create(:user) }
#   before { @micropost = user.microposts.build(content: "Lorem ipsum") }
#   subject { @micropost }

#   it { should respond_to(:content) }
#   it { should respond_to(:user_id) }
#   it { should respond_to(:user) }
#   its(:user) { should eq user }

#   it { should be_valid }

#   describe "when user_id is not present" do
#     before { @micropost.user_id = nil }
#     it { should_not be_valid }
#   end

#   describe "when user_id is not present" do
#     before { @micropost.user_id = nil }
#     it { should_not be_valid }
#   end

#   describe "with blank content" do
#     before { @micropost.content = " " }
#     it { should_not be_valid }
#   end

#   describe "with content that is too long" do
#     before { @micropost.content = "a" * 141 }
#     it { should_not be_valid }
#   end
# end

class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('created_at DESC') }
  validates :content, presence: true, length: { maximum: 2000 }
  validates :user_id, presence: true
  mount_uploader :image, ImageUploader

  # 与えられたユーザーがフォローしているユーザー達のマイクロポストを返す。
  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          user_id: user.id)
  end
end