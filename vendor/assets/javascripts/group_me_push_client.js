(function() {
  var GroupmePushClient;

  GroupmePushClient = (function() {

    function GroupmePushClient(apiToken) {
      this.apiToken = apiToken;
      this.baseUri = GroupmePushClient.baseUri || "";
      this.subscriptions = {};
    }

    GroupmePushClient.prototype.publish = function(channel, data) {
      this.debug("publishing to " + channel + "...");
      return this.client().publish(channel, data);
    };

    GroupmePushClient.prototype.subscribe = function(channel, options) {
      var subscription;
      var _this = this;
      this.debug("subscribing to " + channel + "...");
      subscription = this.client().subscribe(channel, options.message);
      subscription.callback(function() {
        var subscribeInit;
        _this.debug("subscription success: " + channel);
        if (options.success) options.success(channel);
        subscribeInit = function() {
          return _this.publish(channel, {
            type: "subscribe"
          });
        };
        return setTimeout(subscribeInit, 500);
      });
      subscription.errback(function(error) {
        _this.debug("subscription error: " + error);
        delete _this.subscriptions[channel];
        if (options.error) return options.error(error);
      });
      return this.subscriptions[channel] = subscription;
    };

    GroupmePushClient.prototype.unsubscribe = function(channel) {
      this.debug("unsubscribing from " + channel);
      this.subscriptions[channel].cancel();
      return delete this.subscriptions[channel];
    };

    GroupmePushClient.prototype.bindTyping = function(element, channel, userId) {
      var _this = this;
      return element.bind('keydown', function(event) {
        var target;
        target = event.target;
        if (!target.typingSince || Date.now() - target.typingSince > 5000) {
          _this.publish(channel, {
            type: 'typing',
            user_id: String(userId),
            started: Date.now()
          });
          return event.target.typingSince = Date.now();
        }
      });
    };

    GroupmePushClient.prototype.removeTyping = function(element) {
      element.unbind('keydown');
      return delete element.typingSince;
    };

    GroupmePushClient.prototype.client = function() {
      return this._client || (this._client = this.initClient());
    };

    GroupmePushClient.prototype.debug = function(message) {
      if (this.logLevel === "debug" || GroupmePushClient.logLevel === "debug") {
        return typeof console !== "undefined" && console !== null ? console.log(message) : void 0;
      }
    };

    GroupmePushClient.prototype.initClient = function() {
      var client;
      client = new Faye.Client("" + this.baseUri + "/faye", {
        timeout: 30,
        retry: 5
      });
      client.addExtension(this);
      return client;
    };

    GroupmePushClient.prototype.outgoing = function(message, callback) {
      if (!message.channel.match(/\/meta\/(?!subscribe)/)) {
        message.ext = {
          access_token: this.apiToken
        };
      }
      this.debug("sending message: " + (JSON.stringify(message)));
      return callback(message);
    };

    GroupmePushClient.prototype.incoming = function(message, callback) {
      this.debug("received message: " + (JSON.stringify(message)));
      return callback(message);
    };

    return GroupmePushClient;

  })();

  window.GroupmePushClient = GroupmePushClient;

}).call(this);
