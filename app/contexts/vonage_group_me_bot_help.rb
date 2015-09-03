module VonageGroupMeBotHelp
    def help_messages
        [
            "When addressing the bot, use an exclamation point ('!') at " +
                "the beginning of your message. Each command consists of at least a date " +
                "range and a grouping",

            "====== Date Range ======\r\n" +
                "If you don't specify a range, the bot will assume you want to see " +
                "today only. If you want to see a different date range, the following " +
                "options are available to you:",

            "* 'yesterday'\r\n" +
                "* 'last week' or 'this week' (Monday-Sunday)\r\n" +
                "* 'last month' or 'this month'\r\n" +
                "* 'mtd' (month to date, same as 'this month')\r\n" +
                "* 'last weekend', or 'this weekend' (Friday-Sunday)\r\n" +
                "* 'tomorrow' (just kidding! ;)",

            "====== Grouping ======\r\n" +
                "The bot will output territories by default if you don't specify that " +
                "you'd rather see information grouped by the following:",

            "* 'rep'\r\n" +
                "* 'territory' (this is the default)\r\n" +
                "* 'region' (Red/Blue)\r\n",

            "Some examples to try:\r\n" +
                "* '!mtd activations and no upgrades'\r\n" +
                "* '!last week by brand'\r\n" +
                "* '!last month upgrades'\r\n" +
                "* '!this week philadelphia by rep with activations and no upgrades'"
        ]
    end
end