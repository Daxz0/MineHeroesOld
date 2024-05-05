spawn_monster:
    type: task
    debug: false
    definitions: zone
    script:
        - define data <script[monster_data].data_key[<[zone]>]>
        - define mob <[data].get[mobs].random>
        - define add_spawn <script[<[mob]>].data_key[flags].get[add_spawn].if_null[0]>
        - define loc <[data].get[spawn_location].parsed.above[<[add_spawn]>]>

        - spawn <[mob]> <[loc]> save:mob
        - wait 1t
        - define m <entry[mob].spawned_entity>
        - adjust <[m]> custom_name:<[m].custom_name>,<&sp>Lvl<&sp><player.flag[mh.level]>
        - if <[m].has_flag[custom_hitbox]>:
            - spawn hitbox_entity <[m].location.above[<[m].flag[custom_hitbox_readjust]>]> save:hitbox
            - define hit <entry[hitbox].spawned_entity>
            - flag <[hit]> hitbox_ent:<[m]>
            - adjust <[hit]> size:<[m].flag[custom_hitbox_size]>
            - adjust <[hit]> max_health:<proc[health_proc].context[<player.flag[mh.level]>]>
            - adjust <[hit]> health:<proc[health_proc].context[<player.flag[mh.level]>]>
            - adjust <[hit]> no_damage_duration:0t
            - adjust <[hit]> max_no_damage_duration:0t
        - define text <location[-216,64,61,<player.location.world>].find_entities[text_display].within[0.5]>
        - definemap progressbar:
            element: "❚"
            color: <red>
            barColor: <gray>
            size: 20
            currentValue: <proc[health_proc].context[<player.flag[mh.level]>]>
            maxValue: <proc[health_proc].context[<player.flag[mh.level]>]>
        - adjust <[text]> text:<&c><proc[health_proc].context[<player.flag[mh.level]>].proc[metric_number]><&c><&sp><&l>HP<n><[progressbar].proc[progressbar]>
hitbox_entity:
    type: entity
    entity_type: slime
    debug: false
    mechanisms:
        has_ai: false
        visible: false
        max_no_damage_duration: 0t
        no_damage_duration: 0t
    flags:
        no_split: true


dps_dealer:
    type: task
    debug: false
    script:
        - define dmg <player.flag[mh.dps].mul[<player.flag[mh.dps_multiplier].if_null[1]>]>
        - define loc <script[monster_data].data_key[<player.flag[mh.zone]>.spawn_location].parsed>
        - hurt <[dmg]> <[loc].find_entities[slime].within[5]> source:<player>

mob_spawner:
    type: world
    debug: false
    events:
        on player kills entity:
            - if <context.entity.has_flag[hitbox_ent]>:
                - remove <context.entity.flag[hitbox_ent]>
                - run spawn_monster def:<player.flag[mh.zone]>
                - run gold_splatter def:<context.entity.location>|<proc[gold_worth_proc].context[<context.entity.health_max>]>
                - remove <context.entity>

                - if <player.flag[mh.kill_req]> >= 9:
                    - flag <player> mh.kill_req:0
                    - flag <player> mh.level:+:1
                    - flag <player> mh.max_level:+:1
                - else:
                    - flag <player> mh.kill_req:+:1
                - run sidebar_update

        on player damages entity:
            - stop if:<context.entity.has_flag[hitbox_ent].not>
            - adjust <context.entity> max_no_damage_duration:0t
            - define point1 <context.entity.location.face[<player.location>].above[1].left[1]>
            - define point2 <context.entity.location.face[<player.location>].above[0.3].right[1]>
            - define beam <[point1].points_between[<[point2]>].distance[0.1]>
            - playeffect effect:redstone special_data:0.7|#ffffff at:<[beam]> offset:0
            - define dmg <player.flag[mh.click_dmg].add[<player.item_in_hand.flag[damage].if_null[0]>]>
            - determine passively <[dmg]>
        after player damages entity:
            - stop if:<context.entity.has_flag[hitbox_ent].not>
            - define text <location[-216,64,61,<player.location.world>].find_entities[text_display].within[0.5]>
            - definemap progressbar:
                element: "❚"
                color: <red>
                barColor: <gray>
                size: 20
                currentValue: <context.entity.health.round_up>
                maxValue: <context.entity.health_max.round_up>
            - adjust <[text]> text:<&c><proc[metric_number].context[<context.entity.health.round_up>]><&c><&sp><&l>HP<n><[progressbar].proc[progressbar]>
        on slime dies:
            - determine NO_XP
        on slime splits:
            - stop if:!<context.entity.has_flag[no_split]>
            - determine passively cancelled