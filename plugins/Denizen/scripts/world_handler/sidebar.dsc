sidebar_update:
    type: task
    debug: false
    script:
        - sidebar set "title:<&6>--- <&l>MineHeroes<&6> ---" values:<&6><&l>Coins:<&e><&sp><proc[metric_number].context[<player.flag[mh.gold]>]>|<empty>|<&2><&l>Level:<&sp><&a><player.flag[mh.level]>|<&3><&l>Required<&sp>Kills:<&sp><&b><player.flag[mh.kill_req]><&l>/10|<empty>|<player.has_flag[mh.dps_multiplier].if_true[<&gradient[from=#f785ff;to=#6026ff]><&l>].if_false[<&f>]><player.flag[mh.dps].mul[<player.flag[mh.dps_multiplier].if_null[1]>].proc[metric_number]><&sp>DPS|<&f><player.flag[mh.click_dmg].proc[metric_number]><&sp>Click<&sp>Damage players:<player>

sidebar_updater:
    type: world
    debug: false
    events:
        on delta time secondly:
            - foreach <server.online_players_flagged[mh]> as:__player:
                - run sidebar_update