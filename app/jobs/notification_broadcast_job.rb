class NotificationBroadcastJob < ApplicationJob
  queue_as :notification

  require "action_view"
  require "action_view/helpers"
  include ActionView::Helpers::DateHelper

  def perform notification
    if notification.activity.trackable.class.name == Relationship.name
      ActionCable.server.broadcast "notification_channel_#{notification.user_id}",
        mess: "#{notification.load_message.first}",
        url: ("/users/" + notification.load_message.last.to_s + "?noti_id=#{notification.id}"),
        img: notification.activity.owner.avatar.present? ? notification.activity.owner.avatar.url : "/assets/no_avatar.png",
        name: notification.activity.owner.name, time: time_ago_in_words(notification.created_at)
    elsif notification.activity.trackable.class.name == AVersion.name
      ActionCable.server.broadcast "notification_channel_#{notification.user_id}",
        mess: "#{notification.load_message.first}",
        url: ("/a_versions?post_id=#{notification.activity.trackable.a_versionable.id}&noti_id=#{notification.id}"),
        img: notification.activity.owner.avatar.present? ? notification.activity.owner.avatar.url : "/assets/no_avatar.png",
        name: notification.activity.owner.name, time: time_ago_in_words(notification.created_at)
    elsif notification.activity.trackable.class.name == Comment.name || notification.activity.trackable.class.name == Answer.name
      ActionCable.server.broadcast "notification_channel_#{notification.user_id}",
        mess: "#{notification.load_message.first}",
        url: ("/posts/" + notification.load_message.last.to_s + "?noti_id=#{notification.id}" + "#"+ "#{notification.activity.trackable_type.downcase}-" + notification.activity.trackable_id.to_s),
        img: notification.activity.owner.avatar.present? ? notification.activity.owner.avatar.url : "/assets/no_avatar.png",
        name: notification.activity.owner.name, time: time_ago_in_words(notification.created_at)
    elsif notification.activity.trackable.try(:topic_id) == Settings.topic.feedback_number && notification.activity.trackable.waiting?
      ActionCable.server.broadcast "notification_channel_#{notification.user_id}",
        mess: "#{notification.load_message.first}",
        url: "/dashboard/feedbacks?noti_id=#{notification.id}",
        img: notification.activity.owner.avatar.present? ? notification.activity.owner.avatar.url : "/assets/no_avatar.png",
        name: notification.activity.owner.name, time: time_ago_in_words(notification.created_at)
    else
      ActionCable.server.broadcast "notification_channel_#{notification.user_id}",
        mess: "#{notification.load_message.first}",
        url: ("/posts/" + notification.load_message.last.to_s + "?noti_id=#{notification.id}"),
        img: notification.activity.owner.avatar.present? ? notification.activity.owner.avatar.url : "/assets/no_avatar.png",
        name: notification.activity.owner.name, time: time_ago_in_words(notification.created_at)
    end
  end
end
