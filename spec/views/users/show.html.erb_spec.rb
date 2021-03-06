require "rails_helper"

RSpec.describe "users/show.html.erb", type: :view do
  let(:work_space) { FactoryGirl.create :work_space}
  let(:user) { FactoryGirl.create :user, work_space_id: work_space.id }
  let(:topic){FactoryGirl.create :knowledge_topic}
  let!(:post) {FactoryGirl.create :post, user_id: user.id, topic_id: topic.id}
  let!(:answer) {FactoryGirl.create :answer, user_id: user.id, post_id: post.id}
  let!(:comment) {FactoryGirl.create :comment, user_id: user.id,
    commentable_id: post.id, commentable_type: Post.name}

  it "show user page" do
    assign :user, user

    render
    expect(subject).to render_template('users/_post')
    expect(subject).to render_template('users/_comment')
    expect(subject).to render_template('users/_answer')
  end
end
