class Notifications
  constructor: ->    
    @notifications = $("[data-behavior='notifications']")
    @setup() if @notifications.length > 0


  setup: ->
    $("[data-behavior='notifications-link']").on "click", @handleClick
    $.ajax(
      url: "/notifications.json"
      dataType: "JSON"
      method: "GET"
      success: @handleSuccess
    )

  handleClick: (e) =>
    $.ajax(
      url: "/notifications/mark_as_read"
      method: "POST"
      dataType: "JSON"
      success: ->
        $("[data-behavior='unread-count']").text(0)
        $bell = $('a[data-behavior="notifications-link"] .fi-web')
        $bell.css 'color', 'rgb(102, 102, 102)'
    )

  handleSuccess: (data) =>    
    items = $.map data, (notification) ->
      "<li data-read-at='#{notification.read_at}'><a href='#{notification.url}' class='notification-link'><div class='row expanded'><div class='columns small-3 large-2'><img src=#{notification.actor_photo_url} class=''> </div><div class='columns small-9 large-10'><span style='white-space: pre-line'>#{notification.actor}さん#{notification.notifiable.type}#{notification.action}しました。</span><br><time class='timeago' datetime='#{notification.created_at}'>#{notification.created_at}</time></div></div></a></li>"
    $("[data-behavior='notification-items']").append(items)
    unread_count = $('*[data-read-at="null"]').length / 2
    $("[data-behavior='unread-count']").text(unread_count)
    $("time.timeago").timeago()    
    if unread_count != 0
      $bell = $('a[data-behavior="notifications-link"] .fi-web')
      $bell.css 'color', '#ec6952'

$ ->
  new Notifications  
