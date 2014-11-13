# require 'jpush'

class Push
    
  # def self.jpush(target)
  #   master_secret = '8446cd26befa8742a8ceed36'
  #   app_key = '3b3a37bc0cb93a2d8a84db0e'
  #   client = JPush::JPushClient.new(app_key, master_secret)
  #   logger = Logger.new(STDOUT)
  #
  #   device_tag = "#{target.class.to_s.downcase}target.id"
  #
  #   # Get user profile
  #   user_profile = client.getDeviceTagAlias(device_tag)
  #   logger.debug("Got result " + user_profile.toJSON)
  #   # Update Device Tag Alias
  #   add = ['tag1', 'tag2'];
  #   remove = ['tag3', 'tag4'];
  #   tag_alias = JPush::TagAlias.build(:add=> add, :remove=> remove, :alias=> 'alias1')
  #   result = client.updateDeviceTagAlias(device_tag, tag_alias)
  #   logger.debug("Got result " + result.code.to_s)
  # end
    
  # https://github.com/fahchen/baidu_push
  # http://developer.baidu.com/wiki/index.php?title=docs/cplat/push/scene
  # http://developer.baidu.com/wiki/index.php?title=docs/cplat/push/api/list
  def self.baidu_push(user, content)
    # ID：
    # 4531181
    # API Key：
    # P3PaK4AeUtAlx2yX1yVkYuyo
    # Secret Key：
    # AvCo1ZuZ7cQKVKCUw68lMSH1tvglcS4s
    api_key = 'P3PaK4AeUtAlx2yX1yVkYuyo'
    secret_key = 'AvCo1ZuZ7cQKVKCUw68lMSH1tvglcS4s'
    # Create a client
    client = BaiduPush::Client.new(api_key, secret_key)

    ## Set resource of client
    # client.resource = 'your_channel_id'
    ## Query bindlist
    # client.query_bindlist

    ### Push messages
    ## 推送类型，取值范围为：1～3
    # 1：单个人，必须指定user_id 和 channel_id （指定用户的指定设备）或者user_id（指定用户的所有设备）
    # 2：一群人，必须指定 tag
    # 3：所有人，无需指定tag、user_id、channel_id
    #
    #
    ## 指定消息内容，单个消息为单独字符串。如果有二进制的消息内容，请先做 BASE64 的编码。
    # 当message_type为1 （通知类型），请按以下格式指定消息内容。
    # 通知消息格式及默认值：
    #
    # {
    #     //android必选，ios可选
    # "title" : "hello" ,
    #     “description: "hello world"
    #
    # //android特有字段，可选
    # "notification_builder_id": 0,
    #     "notification_basic_style": 7,
    #     "open_type":0,
    #     "net_support" : 1,
    #     "user_confirm": 0,
    #     "url": "http://developer.baidu.com",
    #     "pkg_content":"",
    #     "pkg_name" : "com.baidu.bccsclient",
    #     "pkg_version":"0.1",
    #
    #     //android自定义字段
    # "custom_content": {
    #     "key1":"value1",
    #     "key2":"value2"
    # },
    #
    #     //ios特有字段，可选
    # "aps": {
    #     "alert":"Message From Baidu Push",
    #     "sound":"",
    #     "badge":0
    # },
    #
    #     //ios的自定义字段
    # "key1":"value1",
    #     "key2":"value2"
    # }
    #
    # 注意：
    #
    # 当description与alert同时存在时，ios推送以alert内容作为通知内容
    # 当custom_content与 ios的自定义字段"key" ："value"同时存在时，ios推送的自定义字段内容会将以上两个内容合并，但推送内容整体长度不能大于256B，否则有被截断的风险。
    # 此格式兼容Android和ios原生通知格式的推送。
    # 如果通过Server SDK推送成功，Android端却收不到通知，解决方案请参考该：http://developer.baidu.com/wiki/index.php?title=docs/cplat/push/faq#.E4.B8.BA.E4.BD.95.E9.80.9A.E8.BF.87Server_SDK.E6.8E.A8.E9.80.81.E6.88.90.E5.8A.9F.EF.BC.8CAndroid.E7.AB.AF.E5.8D.B4.E6.94.B6.E4.B8.8D.E5.88.B0.E9.80.9A.E7.9F.A5.EF.BC.9F
    #
    #
    ## 消息类型
    # 0：消息（透传给应用的消息体）
    # 1：通知（对应设备上的消息通知）
    # 默认值为0。
    # 消息标识。
    # 指定消息标识，必须和messages一一对应。相同消息标识的消息会自动覆盖。特别提醒：该功能只支持android、browser、pc三种设备类型。
    message = { title: '拍立行新通知', description: content }
    if user.baidu_devices.present? && (uid = user.baidu_devices.last.baidu_user_id)
      client.push_msg(3, message, "#{user.class.name}-#{user.id}-#{Time.now.to_i}", message_type: 1, user_id: uid)
    end
  end
  
end