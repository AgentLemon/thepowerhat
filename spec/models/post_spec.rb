require "spec_helper"

describe Post do

  include GeneralHelper

  before :each do
    @post = build :post
  end

  describe "callbacks" do

    it "creates tags for ordinary post" do
      @post.message = "OHAI! It's my post #ordinary #post"
      @post.save!

      expect(@post.tags.map(&:name)).to eq(%w(ordinary post))
    end

    it "creates tags for post only with tags" do
      @post.message = "#only #tags"
      @post.save!

      expect(@post.tags.map(&:name)).to eq(%w(only tags))
    end

    it "creates tags from last line" do
      @post.message = %Q{ Message
        Lalala! Lalala! Pew pew pew.
        these are    tags}
      @post.save!

      expect(@post.tags.map(&:name)).to eq(%w(these are tags))
    end

    it "doesn't create tags from last line if there is real tag" do
      @post.message = %Q{ Message
        Lalala! Lalala! Pew pew pew.
        these are    tags #tagtoo}
      @post.save!

      expect(@post.tags.map(&:name)).to eq(%w(tagtoo))
    end

    it "changes message text when sets autotags" do
      @post.message = %Q{ Message
        Lalala! Lalala! Pew pew pew.
        these are    tags}
      @post.save!

      expect(@post.message.match("#these #are #tags")).not_to eq(nil)
    end

  end

end
