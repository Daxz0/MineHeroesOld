time_repeat:
    type: world
    debug: false
    events:
        on delta time secondly:
            - foreach <server.online_players> as:__player:
                - flag <player> mh.playtime:+:1
            - foreach <server.online_players_flagged[mh.dps].filter_tag[<[filter_value].flag[mh.dps].is_more_than_or_equal_to[1]>].filter_tag[<[filter_value].location.world.name.equals[mineheroes_defaultworld_<[filter_value].uuid>]>]> as:__player:
                - run dps_dealer
            - foreach <server.online_players_flagged[mh.upgrades.player.gold_magnet]> as:__player:
                - run gold_magnet_handler