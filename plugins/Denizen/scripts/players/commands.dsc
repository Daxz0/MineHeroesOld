c_world_transfer:
    type: command
    description: Teleports you to another world
    name: world_transfer
    permissons: mh.world_transfer
    usage: /world_transfer [world]
    tab completions:
        1: <server.worlds>

    script:
        - define world <context.args.first>
        - define world_list <server.worlds>
        - if <[world_list].contains[<[world]>]>:
            - createworld <[world]>
            - teleport <player> <world[<[world]>].spawn_location>

c_playtime:
    type: command
    description: Checks your playtime
    debug: false
    name: playtime
    usage: /playtime
    script:
        - narrate "<&a>Your playtime is <duration[<player.flag[mh.playtime]>].formatted>."


c_leaderboard:
    type: command
    description: Gets top 10 players with most gold
    name: leaderboard
    usage: /leaderboard
    debug: false
    tab completions:
        1: gold|level|click_dmg|playtime
    script:
        - define arg <context.args.first>
        - choose <[arg]>:
            - case gold:
                - narrate "<&2><&l>GOLD LEADERBOARD"
                - narrate <empty>
                - define top <server.players_flagged[mh.gold].sort_by_number[flag[mh.gold]].reverse.get[1].to[10]>
                - foreach <[top]> as:t:
                    - narrate "<&a>[<[loop_index]>] <&e><[t].name>: <&6><[t].flag[mh.gold].proc[metric_number]>"
                - narrate "<&7>Your position: <[top].get[<[top].find[<player>]>]>"
            - case level:
                - narrate "<&2><&l>LEVELS LEADERBOARD"
                - narrate <empty>
                - define top <server.players_flagged[mh.level].sort_by_number[flag[mh.level]].reverse.get[1].to[10]>
                - foreach <[top]> as:t:
                    - narrate "<&a>[<[loop_index]>] <&e><[t].name>: <&6><[t].flag[mh.level].proc[metric_number]>"
                - narrate "<&7>Your position: <[top].get[<[top].find[<player>]>]>"
            - case click_dmg:
                - narrate "<&2><&l>CLICK DAMAGE LEADERBOARD"
                - narrate <empty>
                - define top <server.players_flagged[mh.click_dmg].sort_by_number[flag[mh.click_dmg]].reverse.get[1].to[10]>
                - foreach <[top]> as:t:
                    - narrate "<&a>[<[loop_index]>] <&e><[t].name>: <&6><[t].flag[mh.click_dmg].proc[metric_number]>"
                - narrate "<&7>Your position: <[top].get[<[top].find[<player>]>]>"
            - case playtime:
                - narrate "<&2><&l>PLAYTIME LEADERBOARD"
                - narrate <empty>
                - define top <server.players_flagged[mh.playtime].sort_by_number[flag[mh.playtime]].reverse.get[1].to[10]>
                - foreach <[top]> as:t:
                    - narrate "<&a>[<[loop_index]>] <&e><[t].name>: <&6><duration[<[t].flag[mh.playtime]>].formatted>"
                - narrate "<&7>Your position: <[top].get[<[top].find[<player>]>]>"
            - default:
                - narrate "<&c>Not a valid leaderboard type!"